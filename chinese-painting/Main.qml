/***********************************************************************/

import QtQuick 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Item {
  id: root

  readonly property int rootPadding: 40

  TextConstants { id: textConstants }

  transitions: Transition {
    PropertyAnimation { duration: 100; properties: 'opacity';  }
    PropertyAnimation { duration: 300; properties: 'radius'; }
  }

  Repeater {
    model: screenModel
    Background {
      id: background
      anchors.fill: parent
      source: config.background
      fillMode: Image.PreserveAspectCrop
      onStatusChanged: {
        if (status == Image.Error && source != config.defaultBackground) {
          source = config.defaultBackground
        }
      }
    }
  }

  Item {
    id: main
    property variant geometry: screenModel.geometry(screenModel.primary)
    x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height

    FastBlur {
      id: bgBlur
      anchors.fill: background
      source: background
      radius: 0
    }

    Item {
      id: mainPanel
      state: 'login'
      anchors {
        bottom: parent.bottom
        bottomMargin: rootPadding + 80
        right: parent.right
        rightMargin: rootPadding + 80
      }
      width: 300
      height: 100

      UserFrame {
        id: userFrame
        anchors.fill: parent
        visible: mainPanel.state == 'user'
        onSelected: {
          console.log('Select user:', userName)
          mainPanel.state = 'login'
          loginFrame.userName = userName
          loginFrame.input.forceActiveFocus()
        }
        onNeedClose: {
          mainPanel.state = 'login'
          loginFrame.input.forceActiveFocus()
        }
      }

      LoginFrame {
        id: loginFrame
        anchors.fill: parent
        visible: mainPanel.state == 'login'
        transformOrigin: Item.Top
      }
    }

    Item {
      id: timePanel
      visible: ! loginFrame.isProcessing
      anchors {
        top: parent.top
        topMargin: rootPadding
        right: parent.right
        rightMargin: rootPadding
      }
      width: 200
      height: 100
      opacity: 0.75

      Text {
        id: timeText
        anchors {
          top: parent.top
          right: parent.right
        }
        font.pixelSize: config.fontBig * Screen.width * 0.0006
        font.letterSpacing: 3
        color: config.colorText

        function updateTime() {
          text = new Date().toLocaleString(Qt.locale(), config.timeFormat)
        }
      }

      Text {
        id: dateText
        anchors {
          top: timeText.bottom
          topMargin: 10
          right: parent.right
        }

        font.pixelSize: config.fontMedium * Screen.width * 0.0006
        color: config.colorText

        function updateDate() {
          text = new Date().toLocaleString(Qt.locale(), config.dateFormat)
        }
      }

      Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
          timeText.updateTime()
          dateText.updateDate()
        }
      }

      Component.onCompleted: {
        timeText.updateTime()
        dateText.updateDate()
      }
    }

    Item {
      id: actionPanel
      state: 'none'
      visible: ! loginFrame.isProcessing
      anchors {
        left: parent.left
        leftMargin: rootPadding - 20
        bottom: parent.bottom
        bottomMargin: rootPadding
      }
      height: buttonRow.height + frameWrapper.height + 20

      Row {
        id: buttonRow
        spacing: 10
        anchors {
          left: parent.left
          leftMargin: 20
          bottom: parent.bottom
        }
        height: config.iconSmall * Screen.width * 0.0005
        opacity: 0.6

        ImgButton {
          id: sessionButton
          width: config.iconSmall * Screen.width * 0.0005
          height: config.iconSmall * Screen.width * 0.0005
          visible: sessionFrame.isMultipleSessions()
          normalImg: 'icons/session_menu.png'
          onClicked: {
            switchState('session')
          }
          onEnterPressed: sessionFrame.currentItem.forceActiveFocus()

          KeyNavigation.tab: loginFrame.input
          KeyNavigation.backtab: {
            return shutdownButton
          }
        }

        ImgButton {
          id: shutdownButton
          width: config.iconSmall * Screen.width * 0.0005
          height: config.iconSmall * Screen.width * 0.0005
          visible: true

          normalImg: 'icons/power_menu.png'
          onClicked: {
            switchState('power')
          }
          onEnterPressed: powerFrame.shutdown.focus = true
          KeyNavigation.backtab: loginFrame.button
          KeyNavigation.tab: {
            if (sessionButton.visible) {
              return sessionButton
            }
            else {
              return loginFrame.input
            }
          }
        }
      }

      Item {
        id: frameWrapper
        visible: actionPanel.state != 'none'
        anchors {
          top: parent.top
          left: parent.left
        }
        height: config.frameHeight
        opacity: 0.75

        PowerFrame {
          id: powerFrame
          anchors {
            top: parent.top
            left: parent.left
            margins: 10
          }
          visible: actionPanel.state == 'power'
          onNeedClose: {
            actionPanel.state = 'none'
            loginFrame.input.forceActiveFocus()
          }
          onNeedShutdown: sddm.powerOff()
          onNeedReboot: sddm.reboot()
          onNeedSuspend: sddm.suspend()
          onNeedHibernate: sddm.hibernate()
        }

        SessionFrame {
          id: sessionFrame
          anchors {
            top: parent.top
            left: parent.left
            margins: 10
          }
          visible: actionPanel.state == 'session'
          onSelected: {
            console.log('Selected session:', index)
            actionPanel.state = 'none'
            loginFrame.sessionIndex = index
            loginFrame.input.forceActiveFocus()
          }
          onNeedClose: {
            actionPanel.state = 'none'
            loginFrame.input.forceActiveFocus()
          }
        }
      }
    }

    MouseArea {
      z: -1
      anchors.fill: parent
      onClicked: {
        actionPanel.state = 'none'
        loginFrame.input.forceActiveFocus()
      }
    }
  }

  function switchState(state) {
    actionPanel.state = actionPanel.state == state ? 'none' : state
  }
}
