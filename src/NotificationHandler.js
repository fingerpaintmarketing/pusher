'use strict';

import React, {
  Component
} from 'react';
import {
  PushNotificationIOS,
  StyleSheet,
  Text,
  TextInput,
  View
} from 'react-native';

import Button from './Button.js';
var PushNotification = require('react-native-push-notification');

export default class NotificationHandler extends Component {
  constructor(props) {
    super(props);
    this._scheduleNotification = this._scheduleNotification.bind(this);
    this.state = {
      buttonText: 'Send Notification',
      pushToken: ''
    };
  }

  componentDidMount() {
    PushNotification.configure({

      onRegister: (token) => {
          this.setState({
            pushToken: token.token
          });
      },

      onNotification: (notification) => {
        console.log( 'NOTIFICATION:', notification );
        this.setState({
          buttonText: 'Notification Received',
          pushToken: notification.message
        });
      },

      // ANDROID ONLY: GCM Sender ID (optional - not required for local notifications, but is need to receive remote push notifications)
      senderID: "YOUR GCM SENDER ID",

      permissions: {
          alert: true,
          badge: true,
          sound: true
      },

      popInitialNotification: true,
      requestPermissions: true
    });
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

  render() {
    return <View>
      <Text>This worked?</Text>
      <Button style={styles.btn}
        onPress={this._scheduleNotification}
        label={this.state.buttonText}
      />
      <TextInput
        multiline={true}
        style={styles.input}
        value={this.state.pushToken}
      />
    </View>;
  }
}

const styles = StyleSheet.create({
});
