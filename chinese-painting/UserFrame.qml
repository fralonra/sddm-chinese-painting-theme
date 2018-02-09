import QtQuick 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Item {
  id: frame
  signal selected(var userName)
  signal needClose()

  property string currentIconPath: usersList.currentItem.iconPath
  property string currentUserName: usersList.currentItem.userName
  property bool shouldShowBG: false
  property alias currentItem: usersList.currentItem

  function isMultipleUsers() {
    return usersList.count > 1
  }

  onOpacityChanged: {
    shouldShowBG = false
  }

  onFocusChanged: {
    // Active by mouse click
    if (focus) {
      usersList.currentItem.focus = false
    }
  }

  ImgButton {
    id: prevUser
    visible: usersList.childrenRect.width > frame.width
    anchors {
      right: parent.left
      verticalCenter: parent.verticalCenter
      margins: 10
    }
    normalImg: 'icons/arrow_left.png'
    onClicked: {
      usersList.decrementCurrentIndex()
      shouldShowBG = true
    }
  }

  ListView {
    id: usersList
    anchors.centerIn: parent
    width: childrenRect.width > frame.width ? frame.width : childrenRect.width
    height: 100
    model: userModel
    clip: true
    spacing: config.buttonSpacing
    orientation: ListView.Horizontal

    delegate: Rectangle {
      id: item
      property string iconPath: icon
      property string userName: nameText.text
      property bool activeBG: usersList.currentIndex === index && shouldShowBG

      border.width: 2
      border.color: activeBG || focus ? '#33ffffff' : 'transparent'
      radius: 8
      color: activeBG || focus? config.colorBackgroundDark : 'transparent'

      width: 80
      height: parent.height

      function select() {
        selected(name)
        usersList.currentIndex = index
        currentIconPath = icon
        currentUserName = name
      }

      UserAvatar {
        id: iconButton
        anchors {
          top: parent.top
          topMargin: 10
          horizontalCenter: parent.horizontalCenter
        }
        width: config.iconLarge * Screen.width * 0.0005
        height: config.iconLarge * Screen.width * 0.0005
        source: icon
        onClicked: item.select()
      }

      Text {
        id: nameText
        text: name
        anchors {
          top: iconButton.bottom
          topMargin: 5
          horizontalCenter: parent.horizontalCenter
        }
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: config.fontMedium * Screen.width * 0.0006
        color: 'white'
        wrapMode: Text.WordWrap
      }

      Keys.onLeftPressed: {
        usersList.decrementCurrentIndex()
        usersList.currentItem.forceActiveFocus()
      }
      Keys.onRightPressed: {
        usersList.incrementCurrentIndex()
        usersList.currentItem.forceActiveFocus()
      }
      Keys.onEscapePressed: needClose()
      Keys.onEnterPressed: item.select()
      Keys.onReturnPressed: item.select()

      Component.onCompleted: {
        if (name === userModel.lastUser) {
          item.select()
        }
      }
    }
  }

  ImgButton {
    id: nextUser
    visible: usersList.childrenRect.width > frame.width
    anchors {
      left: parent.right
      verticalCenter: parent.verticalCenter
      margins: 10
    }
    normalImg: 'icons/arrow_right.png'
    onClicked: {
      usersList.incrementCurrentIndex()
      shouldShowBG = true
    }
  }

  MouseArea {
    z: -1
    anchors.fill: parent
    onClicked: needClose()
  }

  Keys.onEscapePressed: needClose()
}
