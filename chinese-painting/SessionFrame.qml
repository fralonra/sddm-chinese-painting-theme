import QtQuick 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Item {
  id: frame
  signal selected(var index)
  signal needClose()

  property bool shouldShowBG: false
  property var sessionTypeList: ['awesome', 'cinnamon', 'deepin', 'enlightenment', 'fluxbox', 'gnome', 'i3', 'kde', 'mate', 'lxde', 'lxqt', 'ubuntu', 'xfce']
  property alias currentItem: sessionList.currentItem
  readonly property int maxWidth: main.width / 2 + 20

  height: config.frameHeight

  function getIconName(sessionName) {
    for (var item in sessionTypeList) {
      var str = sessionTypeList[item]
      var index = sessionName.toLowerCase().indexOf(str)
      if (index >= 0) {
        return str
      }
    }

    return 'unknown'
  }

  function getCurrentSessionIcon() {
    return sessionList.currentItem.icon;
  }

  function isMultipleSessions() {
    return sessionList.count > 1
  }

  onOpacityChanged: {
    shouldShowBG = false
  }

  onFocusChanged: {
    // Active by mouse click
    if (focus) {
      sessionList.currentItem.focus = false
    }
  }

  Rectangle {
    width: sessionList.width + 50
    height: parent.height
    radius: 5
    color: config.colorBackgroundDark

    ImgButton {
      id: prevSession
      visible: sessionList.childrenRect.width > parent.width
      anchors {
        right: parent.left
        rightMargin: 5
        verticalCenter: parent.verticalCenter
      }
      normalImg: "icons/arrow_left.png"
      onClicked: {
        sessionList.decrementCurrentIndex()
        shouldShowBG = true
      }
    }

    ListView {
      id: sessionList
      anchors {
        top: parent.top
        topMargin: 5
        horizontalCenter: parent.horizontalCenter
      }
      width: childrenRect.width < maxWidth ? childrenRect.width : maxWidth
      height: parent.height
      clip: true
      model: sessionModel
      currentIndex: sessionModel.lastIndex
      orientation: ListView.Horizontal
      spacing: config.buttonSpacing

      delegate: Item {
        property string icon: iconButton.normalImg
        property bool activeBG: sessionList.currentIndex === index && shouldShowBG
        width: config.iconLarge * Screen.width * 0.0005
        height: parent.height

        Rectangle {
          id: iconWrapper
          width: config.iconLarge * Screen.width * 0.0005
          height: config.iconLarge * Screen.width * 0.0005
          border.width: 3
          border.color: parent.activeBG || parent.focus ? '#33ffffff' : 'transparent'
          radius: 8
          color: parent.activeBG || parent.focus ? config.colorBackgroundDark : 'transparent'

          ImgButton {
            id: iconButton
            anchors {
              horizontalCenter: parent.horizontalCenter
              verticalCenter: parent.verticalCenter
            }
            width: config.iconLarge * Screen.width * 0.0005
            height: config.iconLarge * Screen.width * 0.0005
            normalImg: ('%1normal.png').arg(prefix)
            hoverImg: ('%1hover.png').arg(prefix)
            pressImg: ('%1press.png').arg(prefix)

            property var prefix: ('icons/sessionicon/%1_').arg(getIconName(name));

            onClicked: {
              selected(index)
              sessionList.currentIndex = index
            }
          }
        }

        Item {
          anchors {
            top: iconWrapper.bottom
            topMargin: 5
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
          }
          width: parent.width + Number(config.buttonSpacing)

          Text {
            text: name
            anchors {
              top: parent.top
            }
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: config.fontMedium * Screen.width * 0.0006
            color: 'white'
            wrapMode: Text.Wrap
            lineHeight: 0.75
          }
        }

        Keys.onLeftPressed: {
          sessionList.decrementCurrentIndex()
          sessionList.currentItem.forceActiveFocus()
        }
        Keys.onRightPressed: {
          sessionList.incrementCurrentIndex()
          sessionList.currentItem.forceActiveFocus()
        }
        Keys.onEscapePressed: needClose()
        Keys.onEnterPressed: {
          selected(index)
          sessionList.currentIndex = index
        }
        Keys.onReturnPressed: {
          selected(index)
          sessionList.currentIndex = index
        }
      }
    }

    ImgButton {
      id: nextSession
      visible: sessionList.childrenRect.width > parent.width
      anchors {
        left: parent.right
        leftMargin: 5
        verticalCenter: parent.verticalCenter
      }
      normalImg: "icons/arrow_right.png"
      onClicked: {
        sessionList.incrementCurrentIndex()
        shouldShowBG = true
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
