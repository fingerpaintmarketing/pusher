
'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  View,
} = ReactNative;

import NotificationHandler from './src/NotificationHandler.js';


class Pusher extends React.Component {
  render() {
    return (
      <View style={styles.container}>
        <NotificationHandler/>
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
  btn: {
    flex: 1,
    marginTop: 100
  },
  input: {
    backgroundColor: '#FFFFFF',
    borderWidth: 1,
    borderColor: '#000000',
    height: 50,
    // flex: 0.5,
    // flexDirection: 'row',
    marginBottom: 10
  }
});

AppRegistry.registerComponent('Pusher', () => Pusher);
