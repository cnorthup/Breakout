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

#define NUMBER_ROWS 3
#define BLOCK_WIDTH_EASY 40
#define BLOCK_HEIGHT_EASY 40

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
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView, paddleView, blockView]];
    ballDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    paddleDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    blockDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[blockView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:blocks];
    
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
    // Dispose of any resources that can be recreated.
}

-(void) addBlocks{
    float fudgeFactor = 0.0005;
    float width = 0.0;
    float height = 0.00;
    for (int numberOfColumns=0; numberOfColumns < NUMBER_ROWS; numberOfColumns++){
        for (int i=0; i < self.view.frame.size.width/BLOCK_WIDTH_EASY; i++){
            BlockView *block = [BlockView new];
            block.frame = CGRectMake(width, height, BLOCK_WIDTH_EASY, BLOCK_HEIGHT_EASY);
            block.backgroundColor = [UIColor whiteColor];
            
            //block.backgroundColor = [self chooseARandomColorForBlock];
            blockDynamicBehavior.density = 10000000000000000;
            blockDynamicBehavior.allowsRotation = NO;
            blockDynamicBehavior.elasticity = 1.0;
            blockDynamicBehavior.friction = 0.0;
            blockDynamicBehavior.resistance =0.0;
            [dynamicAnimator addBehavior:blockDynamicBehavior];
            block.layer.contents = (__bridge id)[UIImage imageNamed:@"Image-3"].CGImage;
            
            [self.view addSubview:block];
            [blocks addObject:block];
            [collisionBehavior addItem:block];
            width += BLOCK_WIDTH_EASY;
            NSLog(@"block frame x:%f y:%f",block.frame.origin.x,block.frame.origin.y);
            
        }
        
        width =0.0;
        
        height += numberOfColumns + BLOCK_HEIGHT_EASY +fudgeFactor;
        
    }
    
}
//    float factor = .0005;
//    float width = 0.0;
//    float height = 0.00;
//    
//    for (int numberColumns=0; numberColumns < Number_Rows; numberColumns++) {
//        for (int i = 0; self.view.frame.size.width/BLOCK_WIDTH_EASY; i++)
//        {
//            BlockView *block = [BlockView new];
//            block.frame = CGRectMake(width, height, BLOCK_WIDTH_EASY, BLOCK_HEIGHT_EASY);
//            blockDynamicBehavior.density = 1000000000000;
//            blockDynamicBehavior.allowsRotation = NO;
//            blockDynamicBehavior.elasticity = 1.0;
//            blockDynamicBehavior.friction = 0.0;
//            blockDynamicBehavior.resistance =0.0;
//            [dynamicAnimator addBehavior:blockDynamicBehavior];
//            [self.view addSubview:block];
//            [collisionBehavior addItem:block];
//            width += BLOCK_WIDTH_EASY;
//            NSLog(@"fdsf");
//        }
//        width =0.0;
//        
//        height += numberColumns + BLOCK_HEIGHT_EASY +factor;
//    }
//    blocks = [NSMutableArray new];
//    failed = [NSMutableArray new];
//    [blocks addObject:blockView];
//    while (blocks.count < 50) {
//        rectX = arc4random() % 290;
//        rectY = arc4random() % 200;
//        BlockView* block1 = [[BlockView alloc] initWithFrame:CGRectMake(rectX, rectY, blockView.frame.size.width, blockView.frame.size.height)];
//        block1.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:block1];
//        for (BlockView* createdBlock in blocks) {
    
            //            while ((CGRectIntersectsRect(block1.frame, createdBlock.frame))) {
            //                rectX = arc4random() % 290;
            //                rectY = arc4random() % 200;
            //                NSLog(@"try");
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
            //            }
//        [blocks addObject:block1];
        //NSLog(@"block added");

- (void) viewDidAppear:(BOOL)animated
{
    [self addBlocks];

}
@end
