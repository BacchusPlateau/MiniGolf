//
//  MiniGolfViewController.h
//  MiniGolf
//
//  Created by Bret Williams on 12/18/17.
//  Copyright © 2017 Bret Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniGolfViewController : UIViewController

@property NSString *gameState;
@property UIImage *playerBall;
@property UIImageView *playerBallView;
@property CGRect ballRect;
@property CGRect cupRect;
@property (strong) NSTimer *updateTimer;

@property (strong, nonatomic) IBOutlet UILabel *StrokeCount;
- (IBAction)exitGame:(id)sender;

@end
