import QtQuick 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Item {
  signal needClose()
  signal needShutdown()
  signal needReboot()
  signal needSuspend()
  signal needHibernate()

  height: config.frameHeight

  Rectangle {
    width: buttonRow.width + 50
    height: parent.height
    radius: 5
    color: config.colorBackgroundDark

    Row {
      id: buttonRow
      spacing: config.buttonSpacing
      anchors {
        top: parent.top
        topMargin: 5
        horizontalCenter: parent.horizontalCenter
      }
      height: parent.height

      Item {
        width: config.iconLarge * Screen.width * 0.0005
        height: parent.height

        ImgButton {
          id: shutdownButton
          anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
          }
          width: config.iconLarge * Screen.width * 0.0005
          height: config.iconLarge * Screen.width * 0.0005
          normalImg: 'icons/powerframe/shutdown_normal.png'
          hoverImg: 'icons/powerframe/shutdown_hover.png'
          pressImg: 'icons/powerframe/shutdown_press.png'
          onClicked: needShutdown()
          KeyNavigation.right: rebootButton
          KeyNavigation.left: hibernateButton
          Keys.onEscapePressed: needClose()
        }

        Text {
          text: qsTr('shutdown')
          anchors {
            bottom: parent.bottom
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
          }
          font.pixelSize: config.fontMedium * Screen.width * 0.0006
          color: 'white'
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      Item {
        width: config.iconLarge * Screen.width * 0.0005
        height: parent.height

        ImgButton {
          id: rebootButton
          anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
          }
          width: config.iconLarge * Screen.width * 0.0005
          height: config.iconLarge * Screen.width * 0.0005
          normalImg: 'icons/powerframe/reboot_normal.png'
          hoverImg: 'icons/powerframe/reboot_hover.png'
          pressImg: 'icons/powerframe/reboot_press.png'
          onClicked: needReboot()
          KeyNavigation.right: suspendButton
          KeyNavigation.left: shutdownButton
          Keys.onEscapePressed: needClose()
        }

        Text {
          text: qsTr('reboot')
          anchors {
            bottom: parent.bottom
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
          }
          font.pixelSize: config.fontMedium * Screen.width * 0.0006
          color: 'white'
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      Item {
        visible: sddm.canSuspend
        width: config.iconLarge * Screen.width * 0.0005
        height: parent.height

        ImgButton {
          id: suspendButton
          anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
          }
          width: config.iconLarge * Screen.width * 0.0005
          height: config.iconLarge * Screen.width * 0.0005
          normalImg: 'icons/powerframe/suspend_normal.png'
          hoverImg: 'icons/powerframe/suspend_hover.png'
          pressImg: 'icons/powerframe/suspend_press.png'
          onClicked: needSuspend()
          KeyNavigation.right: hibernateButton
          KeyNavigation.left: rebootButton
          Keys.onEscapePressed: needClose()
        }

        Text {
          text: qsTr('suspend')
          anchors {
            bottom: parent.bottom
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
          }
          font.pixelSize: config.fontMedium * Screen.width * 0.0006
          color: 'white'
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      Item {
        visible: sddm.canHibernate
        width: config.iconLarge * Screen.width * 0.0005
        height: parent.height

        ImgButton {
          id: hibernateButton
          anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
          }
          width: config.iconLarge * Screen.width * 0.0005
          height: config.iconLarge * Screen.width * 0.0005
          normalImg: 'icons/powerframe/hibernate_normal.png'
          hoverImg: 'icons/powerframe/hibernate_hover.png'
          pressImg: 'icons/powerframe/hibernate_press.png'
          onClicked: needSuspend()
          KeyNavigation.right: shutdownButton
          KeyNavigation.left: suspendButton
          Keys.onEscapePressed: needClose()
        }

        Text {
          text: qsTr('hibernate')
          anchors {
            bottom: parent.bottom
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
          }
          font.pixelSize: config.fontMedium * Screen.width * 0.0006
          color: 'white'
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    }
  }

  MouseArea {
    z: -1
    anchors.fill: parent
    onClicked: needClose()
  }

  Keys.onEscapePressed: needClose()
}
