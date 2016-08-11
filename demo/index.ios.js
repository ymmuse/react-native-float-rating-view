/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';

import FloatRatingView from 'react-native-float-rating-view'

class demo extends Component {
  render() {
    return (
      <View style={styles.container}>
        <FloatRatingView
          style={styles.ratingview}
          emptyImage={require('./StarEmpty.png') }
          fullImage={require('./StarFull.png') }
          maxRating={5}
          minRating={1}
          editable={true}
          rating={3.4} />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  ratingview: {
    width: 400,
    height: 100,
  }
});

AppRegistry.registerComponent('demo', () => demo);
