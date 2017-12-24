//
//  MiniGolfViewController.m
//  MiniGolf
//
//  Created by Bret Williams on 12/18/17.
//  Copyright © 2017 Bret Williams. All rights reserved.
//

#import "MiniGolfViewController.h"

@interface MiniGolfViewController ()
@end

@implementation MiniGolfViewController

CGRect courseBounds;
CGPoint ballDirection;
float ballVelocity;
int strokeCounter;
CGPoint touchStartPos;
CGPoint touchEndPos;

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if([self.gameState isEqual: @"Playing"])
        return;
    
    UITouch *touch = [touches anyObject];
    touchStartPos = [touch locationInView:touch.view];
    
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    touchEndPos = [touch locationInView:touch.view];
    
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if([self.gameState isEqual: @"Playing"])
        return;
    
    CGFloat distance = sqrt(pow((touchEndPos.x - touchStartPos.x), 2.0) + pow((touchEndPos.y - touchStartPos.y), 2.0));
    if(distance > 0)
    {
        self.gameState = @"Playing";
        strokeCounter++;
        self.StrokeCount.text = [NSString stringWithFormat:@"Stroke: %d", strokeCounter];
        ballVelocity = distance * 0.01;
        ballDirection = CGPointMake((touchEndPos.x - touchStartPos.x) * 0.01, (touchEndPos.y - touchStartPos.y) * 0.01);
    }
    
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    touchStartPos = CGPointMake(0, 0);
    touchEndPos = CGPointMake(0, 0);
    ballVelocity = 0;
    self.gameState = @"Waiting";
    
}

-(void) update {
    
    if(![self.gameState isEqual: @"Playing"])
        return;
    
    if(self.ballRect.origin.x <= courseBounds.origin.x) {
        ballDirection.x = fabs(ballDirection.x);
    } else if((self.ballRect.origin.x + self.ballRect.size.width) >= (courseBounds.origin.x + courseBounds.size.width)) {
        ballDirection.x = -fabs(ballDirection.x);
    }
    
    if(self.ballRect.origin.y <= courseBounds.origin.y) {
        ballDirection.y = fabs(ballDirection.y);
    } else if (self.ballRect.origin.y + self.ballRect.size.height >= (courseBounds.size.height + courseBounds.origin.y)) {
        ballDirection.y = -fabs(ballDirection.y);
    }
    
    self.ballRect = CGRectOffset(self.ballRect, ballDirection.x * ballVelocity, ballDirection.y * ballVelocity);
    CGRect newRect = self.ballRect;
    
    newRect.origin.x += ballDirection.x * ballVelocity;
    newRect.origin.y += ballDirection.y * ballVelocity;
    
    self.ballRect = newRect;
    
    if(ballVelocity <= 0) {
        self.gameState = @"Waiting";
        ballVelocity = 0;
    }
    
    if(CGRectIntersectsRect(self.ballRect, self.cupRect)) {
    
        self.gameState = @"Done";
        self.ballRect = CGRectMake(205, 55, 12, 12);
        ballVelocity = 0;
        
    }
    
    self.playerBallView.frame = self.ballRect;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameState = @"Loading";
    self.playerBall = [UIImage imageNamed:@"ball.png"];
    self.playerBallView = [[UIImageView alloc] initWithImage: self.playerBall];
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    self.ballRect = CGRectMake(160, screenheight - 100, 24,24);
    self.playerBallView.frame = self.ballRect;
    [self.view addSubview: self.playerBallView];
    
    self.cupRect = CGRectMake(207, 57, 10, 10);
    courseBounds = CGRectMake(136, 30, 145, 536);
    ballDirection = CGPointMake(0, 0);
    ballVelocity = 0;
    strokeCounter = 0;
    
    self.StrokeCount.text = [NSString stringWithFormat:@"Stroke: %d", strokeCounter];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval : .03
                                                         target: self
                                                       selector:@selector(update)
                                                       userInfo:nil repeats:YES];
    self.gameState = @"Waiting";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)exitGame:(id)sender {
}
@end
