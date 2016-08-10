/*
 * @flow
 * @providesModule react-native-float-rating-view
 */

'use strict';

import ReactNative, {View, requireNativeComponent}  from 'react-native'

var Image = require('Image')
var React = require('React')
var resolveAssetSource = require('resolveAssetSource')

var UIManager = require('UIManager')
var RCTFloatRatingView = requireNativeComponent('RCTFloatRatingView', null)

const PropTypes = require('react/lib/ReactPropTypes')

const propTypes = {
  /**
   * The image source (either a remote URL or a local file resource).
   */
  emptyImage: Image.propTypes.source,
  fullImage: Image.propTypes.source,
  onIsRatingUpdating: PropTypes.func,
  onDidRatingUpdate: PropTypes.func,
  editable: PropTypes.bool,
  halfRatings: PropTypes.bool,
  floatRatings: PropTypes.bool,
  rating: PropTypes.number,
  maxRating: PropTypes.number,
  minRating: PropTypes.number,
}

const REF = 'floatRatingView'

export default class FloatRatingView extends React.Component {

  updateRating(val) {
    UIManager.dispatchViewManagerCommand(
      ReactNative.findNodeHandle(this.refs[REF]),
      UIManager.RCTFloatRatingView.Commands.updateRating,
      [val]
    );
  }


  render() {
    return (
      <RCTFloatRatingView
        ref={REF}
        {...this.props}
        rating={this.props.rating}
        />
    )
  }
}

FloatRatingView.propTypes = propTypes