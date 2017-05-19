//
//  QLRotateAnimationView.m
//  shapeLayer
//
//  Created by QiLu on 2017/5/19.
//  Copyright © 2017年 QiLu. All rights reserved.
//

#import "QLRotateAnimationView.h"
#define k_whole_round_time (2.0)

@interface QLRotateAnimationView () <CAAnimationDelegate>

@property (nonatomic, strong) UIBezierPath *path1;
@property (nonatomic, strong) UIBezierPath *path2;
@property (nonatomic, strong) CAShapeLayer *shapeLayer1;
@property (nonatomic, strong) CAShapeLayer *shapeLayer2;

@end

static CGFloat k_width_height;
static CGFloat circle_radius;

@implementation QLRotateAnimationView
#pragma mark - lifeCircle
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

+ (instancetype)viewWithEdgeLength:(CGFloat)edgeLength radius:(CGFloat)radius {
    QLRotateAnimationView *view = [[QLRotateAnimationView alloc] init];
    view.bounds = CGRectMake(0, 0, edgeLength, edgeLength);
    k_width_height = edgeLength;
    circle_radius = radius;
    return view;
}

- (void)enterForeground {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.toValue = @(M_PI * 2);
    rotateAnimation.duration = k_whole_round_time;
    rotateAnimation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotateAnimation forKey:@"rotate"];
}

- (void)beginAnimationClockwise:(BOOL)clockwise {
    
    //要求顺时针旋转
    if (clockwise == YES) {
        
        if (self.rotateType == QLRotateTypeClockWise) {
            NSLog(@"已经在顺时针旋转");
            return;
        }
        
        if (self.rotateType == QLRotateTypeAnticlockwise) {
            [self stopAnimation];
        }
    }
    
    //要求逆时针旋转
    if (clockwise == NO) {
        
        if (self.rotateType == QLRotateTypeAnticlockwise) {
            NSLog(@"已经在逆时针旋转");
            return;
        }
        
        if (self.rotateType == QLRotateTypeClockWise) {
            [self stopAnimation];
        }
    }
    
    CGPoint center = CGPointMake(k_width_height * 0.5, k_width_height * 0.5);
    
    CGFloat path1_start_angle = -M_PI;
    CGFloat path2_start_angle = 0;
    CGFloat rotate_angle = clockwise ? M_PI * 2 : -M_PI * 2;
    
    self.path1 = [UIBezierPath bezierPathWithArcCenter:center radius:circle_radius startAngle:path1_start_angle endAngle:(rotate_angle + path1_start_angle) clockwise:clockwise];
    self.path2 = [UIBezierPath bezierPathWithArcCenter:center radius:circle_radius startAngle:path2_start_angle endAngle:(rotate_angle + path2_start_angle) clockwise:clockwise];
    
    //shapeLayer1
    self.shapeLayer1 = [CAShapeLayer layer];
    self.shapeLayer1.strokeColor = [[UIColor whiteColor] CGColor];
    self.shapeLayer1.fillColor = nil;
    self.shapeLayer1.lineWidth = 4.0f;
    self.shapeLayer1.lineCap = kCALineCapRound;
    self.shapeLayer1.path = self.path1.CGPath;
    [self.layer addSublayer:self.shapeLayer1];
    
    //shapeLayer2
    self.shapeLayer2 = [CAShapeLayer layer];
    self.shapeLayer2.strokeColor = [[UIColor whiteColor] CGColor];
    self.shapeLayer2.fillColor = nil;
    self.shapeLayer2.lineWidth = 4.0f;
    self.shapeLayer2.lineCap = kCALineCapRound;
    self.shapeLayer2.path = self.path2.CGPath;
    [self.layer addSublayer:self.shapeLayer2];
    
    //rotateAnimation
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.toValue = clockwise ? @(M_PI * 2) : @(-M_PI * 2);
    rotateAnimation.duration = k_whole_round_time;
    rotateAnimation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotateAnimation forKey:@"rotate"];
    
    //animation1
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation1.duration = k_whole_round_time;
    animation1.values = @[@0.001,@1.0];
    
    //animation2
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation2.beginTime = k_whole_round_time * 0.25;
    animation2.duration = k_whole_round_time;
    animation2.values = @[@0,@0.999];
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    //group
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = animation1.duration + animation2.duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = MAXFLOAT;
    group.animations = @[animation1,animation2];
    
    [self.shapeLayer1 addAnimation:group forKey:@"groupAnimation"];
    [self.shapeLayer2 addAnimation:group forKey:@"groupAnimation"];
    
    if (clockwise == YES) {
        self.rotateType = QLRotateTypeClockWise;
    }
    
    if (clockwise == NO) {
        self.rotateType = QLRotateTypeAnticlockwise;
    }
}

- (void)stopAnimation {
    
    self.rotateType = QLRotateTypeUnknown;
    [self.layer removeAllAnimations];
    [self.shapeLayer1 removeFromSuperlayer];
    [self.shapeLayer2 removeFromSuperlayer];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
@end
