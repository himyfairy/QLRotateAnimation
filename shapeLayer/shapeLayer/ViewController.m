//
//  ViewController.m
//  shapeLayer
//
//  Created by QiLu on 2017/5/17.
//  Copyright © 2017年 Tp-Link. All rights reserved.
//

#import "ViewController.h"
#import "QLRotateAnimationView.h"
@interface ViewController ()
@property (nonatomic, strong) QLRotateAnimationView *rotateView;
@end

@implementation ViewController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:38/255.0 blue:47/255.0 alpha:1.0];
    
    QLRotateAnimationView *rotateView = [QLRotateAnimationView viewWithEdgeLength:300 radius:120];
    self.rotateView = rotateView;
    [self.view addSubview:rotateView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.rotateView.center = self.view.center;
}

- (IBAction)animate:(UIButton *)sender {
    [self.rotateView beginAnimationClockwise:YES];
}

- (IBAction)antiClockwise:(UIButton *)sender {
    [self.rotateView beginAnimationClockwise:NO];
}

- (IBAction)stop:(UIButton *)sender {
    [self.rotateView stopAnimation];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
