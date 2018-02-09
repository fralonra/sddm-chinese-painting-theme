import QtQuick 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Item {
  id: frame
  property int sessionIndex: sessionModel.lastIndex
  property string userName: userModel.lastUser
  property bool isProcessing: glowAnimation.running
  property alias input: passwdInput
  property alias button: loginButton

  Connections {
    target: sddm
    onLoginSucceeded: {
      animate(false)
      Qt.quit()
    }
    onLoginFailed: {
      passwdInput.echoMode = TextInput.Normal
      passwdInput.text = textConstants.loginFailed
      passwdInput.focus = false
      passwdInput.color = '#e7b222'
      animate(false)
    }
  }

  Item {
    id: loginItem
    width: parent.width
    height: parent.height

    Item {
      id: topRec
      anchors {
        top: parent.top
        left: parent.left
      }
      width: parent.width
      height: config.iconLarge * Screen.width * 0.0005

      Text {
        id: userNameText
        anchors {
          bottom: parent.bottom
          bottomMargin: 10
          right: userAvater.left
          rightMargin: 20
        }
        text: userName
        color: config.colorText
        font.pixelSize: config.fontMedium * Screen.width * 0.0006
      }

      UserAvatar {
        id: userAvater
        anchors {
          bottom: parent.bottom
          right: parent.right
          rightMargin: 40
        }
        width: config.iconLarge * Screen.width * 0.0005
        height: config.iconLarge * Screen.width * 0.0005
        source: userFrame.currentIconPath
        onClicked: {
          mainPanel.state = 'user'
        }
      }

      Glow {
        id: avatarGlow
        anchors.fill: userAvater
        radius: 5
        samples: 10
        spread: 0.4
        color: '#f5b041'
        source: userAvater

        SequentialAnimation on radius {
          id: glowAnimation
          running: false
          alwaysRunToEnd: true
          loops: Animation.Infinite
          PropertyAnimation { to: 20 ; duration: 1000}
          PropertyAnimation { to: 0 ; duration: 1000}
        }
      }
    }

    Item {
      id: bottomRec
      anchors {
        top: topRec.bottom
        topMargin: 10
        left: parent.left
      }
      width: parent.width
      height: parent.height / 3

      Rectangle {
        id: passwdInputRec
        visible: !isProcessing
        anchors {
          top: parent.top
          topMargin: 10
          horizontalCenter: parent.horizontalCenter
        }
        width: 300
        height: 25
        radius: 3
        color: config.colorBackgroundDark

        TextInput {
          id: passwdInput
          anchors.fill: parent
          clip: true
          focus: true
          color: config.colorText
          font.pixelSize: 10
          selectByMouse: true
          selectionColor: '#a8d6ec'
          echoMode: TextInput.Password
          verticalAlignment: TextInput.AlignVCenter
          onFocusChanged: {
            if (focus) {
              color = config.colorText
              echoMode = TextInput.Password
              text = ''
            }
          }
          onAccepted: {
            animate(true)
            sddm.login(userNameText.text, passwdInput.text, sessionIndex)
          }
          KeyNavigation.backtab: {
            if (sessionButton.visible) {
              return sessionButton
            }
            else if (userButton.visible) {
              return userButton
            }
            else {
              return shutdownButton
            }
          }
          KeyNavigation.tab: loginButton
          Timer {
            interval: 200
            running: true
            onTriggered: passwdInput.forceActiveFocus()
          }
        }

        ImgButton {
          id: loginButton
          anchors {
            left: passwdInput.right
            leftMargin: 5
            verticalCenter: parent.verticalCenter
          }
          width: config.iconLarge * Screen.width * 0.0005
          height: config.iconLarge * Screen.width * 0.0005
          opacity: 0.8

          SequentialAnimation {
            id: rotateAnimation
            running: false
            alwaysRunToEnd: true
            loops: Animation.Infinite
            RotationAnimation { target: loginButton; duration: 500; direction: RotationAnimation.Counterclockwise }
          }

          states: State {
            name: 'rotate'
            PropertyChanges { target: loginButton; rotation: 360 }
          }

          transitions: Transition {
            RotationAnimation { duration: 500; direction: RotationAnimation.Counterclockwise }
          }

          normalImg: 'icons/login_normal.png'
          hoverImg: 'icons/login_hover.png'
          pressImg: 'icons/login_press.png'
          onClicked: {
            //loginButton.state = 'rotate'
            animate(true)
            sddm.login(userNameText.text, passwdInput.text, sessionIndex)
          }
          KeyNavigation.tab: shutdownButton
          KeyNavigation.backtab: passwdInput
        }
      }
    }
  }

  function animate(bool) {
    glowAnimation.running = bool
    rotateAnimation.running = bool
  }
}
