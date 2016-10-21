/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

/**
 * Copyright (c) 2013-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * The examples provided by Facebook are for non-commercial testing and
 * evaluation purposes only.
 *
 * Facebook reserves all rights not expressly granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL
 * FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * @flow
 */
'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
  AlertIOS,
  AppRegistry,
  PushNotificationIOS,
  StyleSheet,
  Text,
  TouchableHighlight,
  View,
} = ReactNative;

var PushNotification = require('react-native-push-notification');


class Button extends React.Component {
  render() {
    return (
      <TouchableHighlight
        underlayColor={'white'}
        style={styles.button}
        onPress={this.props.onPress}>
        <Text style={styles.buttonLabel}>
          {this.props.label}
        </Text>
      </TouchableHighlight>
    );
  }
}

class Pusher extends React.Component {
  constructor(props){
      super(props);
      this.state = {buttonText: 'Send Notification'};
      this._scheduleNotification = this._scheduleNotification.bind(this);
  }

  _scheduleNotification() {
    PushNotification.localNotificationSchedule({
      message: "Pusher Local Notification",
      date: new Date(Date.now() + (5 * 1000)).getTime(),
      bigText: "My big text that will be shown when notification is expanded", // (optional) default: "message" prop
      subText: "This is a subText", // (optional) default: none
      playSound: true, // (optional) default: true
      soundName: 'default', // (optional) Sound to play when the notification is shown. Value of 'default' plays the default sound. It can be set to a custom sound such as 'android.resource://com.xyz/raw/my_sound'. It will look for the 'my_sound' audio file in 'res/raw' directory and play it. default: 'default' (default sound is played)
    autoCancel: true, // (optional) default: true
    vibrate: true, // (optional) default: true
    vibration: 300, // vibration length in milliseconds, ignored if vibrate=false, default: 1000
    });
    this.setState({
      buttonText: 'Notification Sent'
    });
  }

  _requestPermissions() {
    PushNotification.requestPermissions();
  }

componentDidMount() {

  PushNotification.configure({

    // (optional) Called when Token is generated (iOS and Android)
    onRegister: (token) => {
        console.log( 'TOKEN:', token );
        AlertIOS('TOKEN', token);
    },

    // (required) Called when a remote or local notification is opened or received
    onNotification: (notification) => {
      console.log( 'NOTIFICATION:', notification );
      this.setState({
        buttonText: 'Notification Received'
      });
    },

    // ANDROID ONLY: GCM Sender ID (optional - not required for local notifications, but is need to receive remote push notifications)
    senderID: "YOUR GCM SENDER ID",

    // IOS ONLY (optional): default: all - Permissions to register.
    permissions: {
        alert: true,
        badge: true,
        sound: true
    },

    // Should the initial notification be popped automatically
    // default: true
    popInitialNotification: true,

    /**
      * (optional) default: true
      * - Specified if permissions (ios) and token (android and ios) will requested or not,
      * - if not, you must call PushNotificationsHandler.requestPermissions() later
      */
    requestPermissions: false,
});
}

  render() {
    return (
      <View style={styles.container}>
        <Button
          onPress={this._requestPermissions}
          label="Request Permissions"
        />
        <Button
          onPress={this._scheduleNotification}
          label={this.state.buttonText}
        />

      </View>
    );
  }
}

const styles = StyleSheet.create({
  bryan: {
    marginTop: 200
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('Pusher', () => Pusher);
