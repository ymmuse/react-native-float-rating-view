//
//  FloatRatingViewManager.m
//  FloatRatingView
//
//  Created by ymmuse on 7/15/16.
//  Copyright © 2016 None. All rights reserved.
//

#import "RCTFloatRatingViewManager.h"
#import "RCTFloatRatingView.h"
#import "RCTBridge.h"
#import "RCTConvert.h"
#import "RCTUIManager.h"

@implementation RCTFloatRatingViewManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    return [RCTFloatRatingView new];
}

RCT_EXPORT_VIEW_PROPERTY(emptyImage, UIImage)
RCT_EXPORT_VIEW_PROPERTY(fullImage, UIImage)
RCT_EXPORT_VIEW_PROPERTY(onDidRatingUpdate, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onIsRatingUpdating, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(editable, BOOL)
RCT_EXPORT_VIEW_PROPERTY(halfRatings, BOOL)
RCT_EXPORT_VIEW_PROPERTY(floatRatings, BOOL)
RCT_EXPORT_VIEW_PROPERTY(rating, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(maxRating, int)
RCT_EXPORT_VIEW_PROPERTY(minRating, int)

RCT_EXPORT_METHOD(updateRating:(nonnull NSNumber *)reactTag rating:(CGFloat)rating) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RCTFloatRatingView *> *viewRegistry) {
        RCTFloatRatingView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RCTFloatRatingView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting RCTRichText, got: %@", view);
        } else {
            [view updateRating:rating];
        }
    }];
}
@end