'use strict';

import React, {
  Component
} from 'react';
import {
  StyleSheet,
  Text,
  TouchableHighlight
} from 'react-native';

export default class Button extends React.Component {
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

const styles = StyleSheet.create({
});
