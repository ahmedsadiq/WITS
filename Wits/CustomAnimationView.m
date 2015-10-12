//
//  CustomAnimationView.m
//  ActivityAnimation
//
//  Created by tcs on 13/02/14.
//  Copyright (c) 2014 iPhone. All rights reserved.
//

#import "CustomAnimationView.h"

@implementation CustomAnimationView

static CustomAnimationView* _sharedCustomActivity = nil;


+(CustomAnimationView*)sharedCustomActivity
{
     @synchronized([CustomAnimationView class])
     {
          if (!_sharedCustomActivity)
               _sharedCustomActivity = [[self alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
          
          return _sharedCustomActivity;
     }
     
     return nil;
}

- (id)initWithFrame:(CGRect)frame
{
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     CGFloat screenWidth = screenRect.size.width;
     CGFloat screenHeight = screenRect.size.height;
     
     if (self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)])
     {
          [self doInit];
     }
     
     return self;
}

- (void)doInit
{
// Change here Done by obaid in heoght width previous values were 240 , 200
     imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  200 , 160)];
     
     [imageView setImage:[UIImage imageNamed:@"Loader1.png"]];
     
     images = [[NSArray alloc] initWithObjects:
               [UIImage imageNamed:@"Loader2.png"],
               [UIImage imageNamed:@"Loader3.png"],
               [UIImage imageNamed:@"Loader4.png"],
               [UIImage imageNamed:@"Loader5.png"],
               [UIImage imageNamed:@"Loader6.png"],
               nil];
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     CGFloat screenWidth = screenRect.size.width;
     CGFloat screenHeight = screenRect.size.height;
     
     UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
     [overlay setBackgroundColor:[UIColor blackColor]];
     overlay.alpha = 0.5;
     [self addSubview:overlay];
     
     
     screenHeight = screenHeight/2;
     screenWidth = screenWidth/2;
     [imageView setCenter:CGPointMake(screenWidth, screenHeight-20)];
     [self addSubview:imageView];
     
     isAnimating = NO;
}

-(void) showCustomActivity {
     UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
     [mainWindow addSubview: self];
     [self startAnimating];
}
-(void) removeCustomActivity {
     [self stopAnimating];
     [self removeFromSuperview];
}

- (void)startAnimating
{
     if (isAnimating)
          return;
     
     isAnimating = YES;
     status = 0;
     
     [self setHidden:NO];
     [imageView setImage:[UIImage imageNamed:@"Loader1.png"]];
     
     [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAnimation) userInfo:nil repeats:NO];
}

- (void)updateAnimation
{
     switch (status)
     {
          case 0:
               status = 1;
               [imageView setImage:[UIImage imageNamed:@"Loader2.png"]];
               [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAnimation) userInfo:nil repeats:NO];
               break;
          case 1:
               status = 2;
               [imageView setImage:[UIImage imageNamed:@"Loader3.png"]];
               [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAnimation) userInfo:nil repeats:NO];
               break;
          case 2:
               status = 3;
               [imageView setImage:[UIImage imageNamed:@"Loader4.png"]];
               [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAnimation) userInfo:nil repeats:NO];
               break;
          case 3:
               status = 4;
               [imageView setImage:[UIImage imageNamed:@"Loader5.png"]];
               [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAnimation) userInfo:nil repeats:NO];
          case 4:
               status = 5;
               [imageView setImage:[UIImage imageNamed:@"Loader6.png"]];
               [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAnimation) userInfo:nil repeats:NO];
          case 5:
               [imageView setAnimationImages:images];
               [imageView setAnimationDuration:1];
               [imageView startAnimating];
               break;
          default:
               break;
     }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
     [self setHidden:YES];
     return NO;
}

- (void)stopAnimating
{
     isAnimating = NO;
     
     [imageView stopAnimating];
     [imageView setAnimationImages:nil];
}

- (BOOL)isAnimating
{
     return isAnimating;
}

@end
