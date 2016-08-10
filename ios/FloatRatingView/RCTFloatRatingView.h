//
//  FloatRatingView.h
//  FloatRatingView
//
//  Created by ymmuse on 7/14/16.
//  Copyright © 2016 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTView.h"
#import "RCTEventDispatcher.h"
#import "UIView+React.h"
#import "RCTImageSource.h"


@class RCTFloatRatingView;

@protocol UIFloatRatingViewDelegate <NSObject>

@optional

/**
 Returns the rating value when touch events end
 */
-(void)floatRatingView: (RCTFloatRatingView*)view didUpdate:(CGFloat)rating;

/**
 Returns the rating value as the user pans
 */
-(void)floatRatingView: (RCTFloatRatingView*)view isUpdating:(CGFloat)rating;

@end

@interface RCTFloatRatingView : RCTView <UIFloatRatingViewDelegate>

@property (nonatomic, strong) UIImage *emptyImage;
@property (nonatomic, strong) UIImage *fullImage;

@property (nonatomic, copy) RCTDirectEventBlock onDidRatingUpdate;
@property (nonatomic, copy) RCTDirectEventBlock onIsRatingUpdating;

@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL halfRatings;
@property (nonatomic, assign) BOOL floatRatings;

@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, assign) int maxRating;
@property (nonatomic, assign) int minRating;

-(void)updateRating:(CGFloat)val;
@end
