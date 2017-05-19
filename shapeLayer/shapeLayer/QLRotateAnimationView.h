//
//  QLRotateAnimationView.h
//  shapeLayer
//
//  Created by QiLu on 2017/5/19.
//  Copyright © 2017年 QiLu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QLRotateType) {
    QLRotateTypeUnknown = 0,
    QLRotateTypeClockWise = 1,
    QLRotateTypeAnticlockwise = 2
};

@interface QLRotateAnimationView : UIView

@property (nonatomic, assign) QLRotateType rotateType;
- (void)beginAnimationClockwise:(BOOL)clockwise;
- (void)stopAnimation;
+ (instancetype)viewWithEdgeLength:(CGFloat)edgeLength radius:(CGFloat)radius;
@end
