//
//  FloatRatingView.m
//  FloatRatingView
//
//  Created by ymmuse on 7/14/16.
//  Copyright © 2016 None. All rights reserved.
//

#import "RCTFloatRatingView.h"
#import "RCTUtils.h"
#import "UIView+React.h"
#import "RCTBridge.h"
#import "RCTImageLoader.h"

@implementation RCTFloatRatingView
{
    NSMutableArray<UIImageView*> *emptyImageViews;
    NSMutableArray<UIImageView*> *fullImageViews;
    
    UIViewContentMode imageContentMode;
    CGSize minImageSize;
}

-(void) updateRating:(CGFloat)val {
    [self refresh];
}

-(void) setRating:(CGFloat)rating {
    _rating = rating;
    [self refresh];
}

-(void) initImageViews {
    if (emptyImageViews.count > 0) {
        return;
    }
    
    [self removeImageViews];
    
    for (int i = 0; i < _maxRating; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = imageContentMode;
        imageView.image = _emptyImage;
        [emptyImageViews addObject:imageView];
        [self addSubview:imageView];
        
        imageView = [UIImageView new];
        imageView.contentMode = imageContentMode;
        imageView.image = _fullImage;
        [fullImageViews addObject:imageView];
        [self addSubview:imageView];
    }
}

-(void) refresh {
    for (int i = 0; i < fullImageViews.count; i++) {
        UIImageView *imageView = fullImageViews[i];
        if (_rating >= (CGFloat)i+1) {
            imageView.layer.mask = nil;
            imageView.hidden  = FALSE;
        } else if (_rating > (CGFloat)i && _rating < (CGFloat)i+1) {
            CALayer * masklayer = [CALayer new];
            masklayer.frame = CGRectMake(0, 0, (_rating -(CGFloat)i)*imageView.frame.size.width, imageView.frame.size.height);
            masklayer.backgroundColor = [UIColor blackColor].CGColor;
            imageView.layer.mask = masklayer;
            imageView.hidden = FALSE;
        } else {
            imageView.layer.mask = nil;
            imageView.hidden = TRUE;
        }
    }
}

-(CGSize) sizeForImage:(UIImage*)img size:(CGSize)size {
    CGFloat imageRatio = img.size.width / img.size.height;
    CGFloat viewRatio = size.width / size.height;
    if (imageRatio < viewRatio) {
        CGFloat scale = size.height / img.size.height;
        CGFloat width = scale * img.size.width;
        return CGSizeMake(width, size.height);
    } else {
        CGFloat scale = size.width / img.size.width;
        CGFloat height = scale * img.size.height;
        return CGSizeMake(size.width, height);
    }
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    [self initImageViews];
    
    if (_emptyImage) {
        CGFloat desiredImageWidth = self.frame.size.width / (CGFloat)emptyImageViews.count;
        CGFloat maxImageWidth = fmax(minImageSize.width, desiredImageWidth);
        CGFloat maxImageHeight = fmax(minImageSize.height, self.frame.size.height);
        CGSize imageViewSize = [self sizeForImage:_emptyImage size:CGSizeMake(maxImageWidth, maxImageHeight)];
        CGFloat imageXOffset = (self.frame.size.width - (imageViewSize.width * (CGFloat)emptyImageViews.count))/(CGFloat)(emptyImageViews.count-1);
        for (int i = 0; i < _maxRating; i++) {
            CGRect imageFrame = CGRectMake(i==0?0:(CGFloat)i*(imageXOffset+imageViewSize.width), 0, imageViewSize.width*1.0, imageViewSize.height*1.0);
            UIImageView *imageView = emptyImageViews[i];
            imageView.frame = imageFrame;
            
            imageView = fullImageViews[i];
            imageView.frame = imageFrame;
        }
        [self refresh];
    }
}

-(void) removeImageViews {
    for (int i = 0; i < emptyImageViews.count; i++) {
        UIImageView *imageView = emptyImageViews[i];
        [imageView removeFromSuperview];
        imageView = fullImageViews[i];
        [imageView removeFromSuperview];
    }
    
    [emptyImageViews removeAllObjects];
    [fullImageViews removeAllObjects];
}


-(void) handleTouchAtLocation:(CGPoint)touchLocation {
    if (!_editable) {
        return;
    }
    
    CGFloat newRating = 0;
    for (int i = _maxRating - 1; i >= 0; --i) {
        UIImageView *imageView = emptyImageViews[i];
        if (touchLocation.x > imageView.frame.origin.x) {
            CGPoint newLocation = [imageView convertPoint:touchLocation toView:self];
            
            if ([imageView pointInside:newLocation withEvent:nil] && (_floatRatings || _halfRatings)) {
                CGFloat decimalNum = newLocation.x / imageView.frame.size.width;
                newRating = (CGFloat)i + decimalNum;
                if (_halfRatings) {
                    newRating = (CGFloat)i + (decimalNum > 0.75 ? 1 : (decimalNum > 0.25 ? 0.5 : 0));
                }
            } else {
                newRating = (CGFloat)i + 1.f;
            }
            break;
        }
    }
    
    [self setRating:newRating < (CGFloat)_minRating ?  (CGFloat)_minRating : newRating];
    
    [self floatRatingView:self isUpdating:_rating];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch =  [touches anyObject];
    if (touch) {
        [self handleTouchAtLocation: [touch locationInView:self]];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch =  [touches anyObject];
    if (touch) {
        [self handleTouchAtLocation: [touch locationInView:self]];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self floatRatingView:self didUpdate:_rating];
}

/**
 Returns the rating value when touch events end
 */
-(void)floatRatingView: (RCTFloatRatingView*)view didUpdate:(CGFloat)rating {
    if (_onDidRatingUpdate) {
        _onDidRatingUpdate(@{@"rating":@(rating)});
    }
}

/**
 Returns the rating value as the user pans
 */
-(void)floatRatingView: (RCTFloatRatingView*)view isUpdating:(CGFloat)rating {
    if (_onIsRatingUpdating) {
        _onIsRatingUpdating(@{@"rating":@(rating)});
    }
}


RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)aDecoder)

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        imageContentMode = UIViewContentModeScaleAspectFit;
        emptyImageViews = [NSMutableArray array];
        fullImageViews = [NSMutableArray array];
        
        self.contentMode = UIViewContentModeScaleToFill;
        
        _rating = 0.f;
        minImageSize = CGSizeMake(5.0, 5.0);
        _maxRating = 1;
        _minRating = 1;
        
        _editable = FALSE;
        _floatRatings = TRUE;
        _halfRatings = TRUE;
    }
    return self;
}

@end
