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

#define NUMBER_ROWS 6
#define BLOCK_WIDTH_EASY 30
#define BLOCK_HEIGHT_EASY 20

@interface ViewController () <UICollisionBehaviorDelegate>
{
    IBOutlet BallView *ballView;
    IBOutlet PaddleView *paddleView;
    UIDynamicAnimator* dynamicAnimator;
    UIPushBehavior* pushBehavior;
    UICollisionBehavior* collisionBehavior;
    UIDynamicItemBehavior* ballDynamicItemBehavior;
    UIDynamicItemBehavior* paddleDynamicItemBehavior;
    UIDynamicItemBehavior* blockDynamicItemBehavior;
    UIDynamicItemBehavior* blockDynamicBehavior;
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
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView, paddleView]];
    ballDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    paddleDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:blocks];
    
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

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p{
    BlockView* block = (BlockView*)item2;
    
    if ([item2 isKindOfClass:[BlockView class]]) {
        [collisionBehavior removeItem:item2];
        [(BlockView*)item2 removeFromSuperview];
        [dynamicAnimator updateItemUsingCurrentState:item2];
    }
}

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)sender{
    
    paddleView.center = CGPointMake([sender locationInView:self.view].x, paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    CGFloat x = ([ballDynamicItemBehavior linearVelocityForItem:item].x * -1);
    CGFloat y = ([ballDynamicItemBehavior linearVelocityForItem:item].y * -1);
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
}

-(void) addBlocks{
    float x = 0.0;
    float y = 0.00;
    for (int numberOfColumns=0; numberOfColumns < NUMBER_ROWS; numberOfColumns++){
        for (int i=0; i < self.view.frame.size.width/BLOCK_WIDTH_EASY; i++){
            BlockView *block = [BlockView new];
            block.frame = CGRectMake(x, y, BLOCK_WIDTH_EASY, BLOCK_HEIGHT_EASY);
            block.backgroundColor = [UIColor whiteColor];
            
            blockDynamicBehavior.density = 10000000000000000;
            blockDynamicBehavior.allowsRotation = NO;
            [dynamicAnimator addBehavior:blockDynamicBehavior];
            block.layer.contents = (__bridge id)[UIImage imageNamed:@"Image-3"].CGImage;
            
            [self.view addSubview:block];
            [blocks addObject:block];
            [collisionBehavior addItem:block];
            x += BLOCK_WIDTH_EASY + 2;
            NSLog(@"block frame x:%f y:%f",block.frame.origin.x,block.frame.origin.y);
            
        }
        
        x =0.0;
        y += BLOCK_HEIGHT_EASY + 2;
        
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self addBlocks];

}
@end
