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
#import "BlockView.h"

@interface ViewController () <UICollisionBehaviorDelegate>
{
    IBOutlet BallView *ballView;
    IBOutlet PaddleView *paddleView;
    IBOutlet BlockView *blockView;
    UIDynamicAnimator* dynamicAnimator;
    UIPushBehavior* pushBehavior;
    UICollisionBehavior* collisionBehavior;
    UIDynamicItemBehavior* ballDynamicItemBehavior;
    UIDynamicItemBehavior* paddleDynamicItemBehavior;
    UIDynamicItemBehavior* blockDynamicItemBehavior;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView, paddleView, blockView]];
    ballDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    paddleDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    blockDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[blockView]];
    
    paddleDynamicItemBehavior.allowsRotation = NO;
    paddleDynamicItemBehavior.density = 10000000000000;
    [dynamicAnimator addBehavior: paddleDynamicItemBehavior];
    
    blockDynamicItemBehavior.allowsRotation = NO;
    blockDynamicItemBehavior.density = 10000000000000;
    [dynamicAnimator addBehavior: blockDynamicItemBehavior];
    
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


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    CGFloat x = ([ballDynamicItemBehavior linearVelocityForItem:item].x * -1) + 0.5;
    CGFloat y = ([ballDynamicItemBehavior linearVelocityForItem:item].y * -1) + 1.0;
    if (p.y > paddleView.frame.origin.y) {
        [ballDynamicItemBehavior addAngularVelocity:([ballDynamicItemBehavior angularVelocityForItem:item] * -1) forItem:item];
        ballView.center = self.view.center;
        pushBehavior.pushDirection = CGVectorMake(x, y);
        pushBehavior.active = YES;
        pushBehavior.magnitude = 0.02;
        ballView.backgroundColor = [UIColor redColor];
        [UIView animateWithDuration:1.0 animations:^{
            ballView.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            pushBehavior.pushDirection = CGVectorMake(x, y);
            pushBehavior.active = YES;
            pushBehavior.magnitude = 0.02;
        }];
    }
    [dynamicAnimator updateItemUsingCurrentState:ballView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
