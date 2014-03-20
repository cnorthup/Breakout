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
    UIDynamicItemBehavior* ballDynamicItemBehavior;
    UIDynamicItemBehavior* paddleDynamicItemBehavior;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView, paddleView]];
    ballDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    paddleDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    
    paddleDynamicItemBehavior.allowsRotation = NO;
    paddleDynamicItemBehavior.density = 10000000000000;
    [dynamicAnimator addBehavior: paddleDynamicItemBehavior];
    
    ballDynamicItemBehavior.allowsRotation = NO;
    ballDynamicItemBehavior.elasticity = 1.0;
    ballDynamicItemBehavior.friction = 0.0;
    ballDynamicItemBehavior.resistance = 0.0;
    [dynamicAnimator addBehavior:ballDynamicItemBehavior];
    
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

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    if (p.y > paddleView.frame.origin.y) {
        [ballDynamicItemBehavior addAngularVelocity:([ballDynamicItemBehavior angularVelocityForItem:item] * -1) forItem:item];
        ballView.center = self.view.center;
        CGFloat x = ([ballDynamicItemBehavior linearVelocityForItem:item].x * -1) + 0.5;
        CGFloat y = ([ballDynamicItemBehavior linearVelocityForItem:item].y * -1) + 1.0;
        pushBehavior.pushDirection = CGVectorMake(x, y);
        pushBehavior.active = YES;
        pushBehavior.magnitude = 0.04;
    }
    [dynamicAnimator updateItemUsingCurrentState:ballView];
    //pushBehavior.pushDirection =
//    if (p.y > paddleView.frame.origin.y) {
//        ballDynamicItemBehavior.elasticity = 0.0;
//        ballDynamicItemBehavior.friction = 100000000000000000;
//        ballDynamicItemBehavior.resistance = 100000000000000000;
//        ballView.center = self.view.center;
//        [dynamicAnimator updateItemUsingCurrentState:ballView];
//    }
    //CGFloat velocity = [ballDynamicItemBehavior angularVelocityForItem:item];
    //NSLog(@"%f", velocity);
    //pushBehavior.pushDirection = CGVectorMake(ballDynamicItemBehavior, <#CGFloat dy#>)
    
    
    
    
//    [UIView animateWithDuration:2 animations:^{
//        ballDynamicItemBehavior.allowsRotation = NO;
//        ballDynamicItemBehavior.elasticity = 1.0;
//        ballDynamicItemBehavior.friction = 0.0;
//        ballDynamicItemBehavior.resistance = 0.0;
//        pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
//        pushBehavior.active = YES;
//        pushBehavior.magnitude = 0.02;
//        [dynamicAnimator updateItemUsingCurrentState:ballView];
//    } completion:^(BOOL finished) {
//        pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
//        pushBehavior.active = YES;
//        pushBehavior.magnitude = 0.02;
//        [dynamicAnimator updateItemUsingCurrentState:ballView];
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
