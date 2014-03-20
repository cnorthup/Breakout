//
//  ViewController.m
//  Breakout
//
//  Created by Charles Northup on 3/20/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import "PaddleView.h"

@interface ViewController () <UICollisionBehaviorDelegate>
{
    IBOutlet BallView *ballView;
    IBOutlet PaddleView *paddleView;
    UIDynamicAnimator* dynamicAnimator;
    UIPushBehavior* pushBehavior;
    UICollisionBehavior* collisionBehavior;
    UIDynamicItemBehavior* ballDynamicBehavior;
    UIDynamicItemBehavior* paddleDynamicBehavior;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView, paddleView]];
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 10000000000000;
    [dynamicAnimator addBehavior: paddleDynamicBehavior];
    
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [dynamicAnimator addBehavior:collisionBehavior];
    
    pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
    pushBehavior.active = YES;
    pushBehavior.magnitude = 0.02;
    [dynamicAnimator addBehavior:pushBehavior];
    
}

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)sender{
    
    paddleView.center = CGPointMake([sender locationInView:self.view].x, paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
