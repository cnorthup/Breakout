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
    NSMutableArray *blocks;
    CGFloat rectX;
    CGFloat rectY;
    NSMutableArray *failed;
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
    blocks = [NSMutableArray new];
    failed = [NSMutableArray new];
    [blocks addObject:blockView];
    while (blocks.count < 50) {
        rectX = arc4random() % 290;
        rectY = arc4random() % 200;
        BlockView* block1 = [[BlockView alloc] initWithFrame:CGRectMake(rectX, rectY, blockView.frame.size.width, blockView.frame.size.height)];
        block1.backgroundColor = [UIColor whiteColor];

        for (BlockView* createdBlock in blocks) {
            while ((CGRectIntersectsRect(block1.frame, createdBlock.frame))) {
//                CGPoint p = CGPointMake(block1.frame.origin.x, block1.frame.origin.y);
//               // [failed addObject:];
//            }
//            if ((CGRectIntersectsRect(block1.frame, createdBlock.frame))) {
//                [failed addObject:<#(id)#>]
//            }
            
//            BOOL inter = (CGRectIntersectsRect(block1.frame, createdBlock.frame));
//            NSLog(@"%hhd", inter);
            //CGRect inter = CGRectIntersection(createdBlock.frame, block1.frame);
//            while(inter){
//                rectX = arc4random() % 290;
//                rectY = arc4random() % 215;
//                [block1 setCenter:CGPointMake(rectX, rectY)];
//                if (!(CGRectIntersectsRect(block1.frame, createdBlock.frame))) {
//                    inter = NO;
//                    break;
//                }
//                //NSLog(@"try");
//            }
            }
        }
        [self.view addSubview:block1];
        [blocks addObject:block1];
        //NSLog(@"block added");
    }
    
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

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p{
    if ([item2 isEqual:blockView] || [item1 isEqual:blockView]) {
    [collisionBehavior removeItem:blockView];
    [blockView removeFromSuperview];
    }
    
    

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
