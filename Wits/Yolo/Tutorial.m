//
//  Tutorial.m
//  Wits
//
//  Created by Mr on 07/05/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import "Tutorial.h"
#import "Utils.h"
#import "NavigationHandler.h"

@interface Tutorial ()

@end

@implementation Tutorial


-(id)init
{
     if (IS_IPAD) {
          
          self = [super initWithNibName:@"Tutorial" bundle:Nil];
     }
     
     else{
          self = [super initWithNibName:@"Tutorial" bundle:Nil];
     }
     return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     _moviePlayer = [[MPMoviePlayerController alloc] init];
    [self playMovie];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)playMovie
{
     
     NSBundle *bundle = [NSBundle mainBundle];
     NSString *moviePath = [bundle pathForResource:@"wits_animation" ofType:@"mp4"];
     NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
     
     _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
   //  _moviePlayer.view.frame =  CGRectMake(0, 0, 375, 667);
     
     // Rotate the view for landscape playback
     if (IS_IPHONE_4) {
          [[_moviePlayer view] setBounds:CGRectMake(-240, 155, 480, 330)];
     }else if (IS_IPAD){
           [[_moviePlayer view] setBounds:CGRectMake(-512, 380, 1024, 760)];
     }else{
          [[_moviePlayer view] setBounds:CGRectMake(-280, 155, 680, 330)];
     }
     [[_moviePlayer view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
     

     
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(moviePlayBackDidFinish:)
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:_moviePlayer];
     
     _moviePlayer.shouldAutoplay = YES;
     _moviePlayer.fullscreen = TRUE;
     _moviePlayer.controlStyle = MPMovieControlStyleNone;
     [self.view addSubview:_moviePlayer.view];
     [_moviePlayer play];
    

}
- (void)configureSubViews
{
     if (self.moviePlayer.view.subviews.count > 0)
     {
          UIView *view = self.moviePlayer.view.subviews[0];
          if (view.subviews.count > 0)
          {
               UIView *sView = view.subviews[0];
               self.moviePlayer = [sView viewWithTag:1002];
               
          }
     }
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
     
     MPMoviePlayerController *player = [notification object];
     
     [[NSNotificationCenter defaultCenter] removeObserver:self
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:player];
     
     if ([player
          respondsToSelector:@selector(setFullscreen:animated:)])
     {
          player.fullscreen = NO;
          [[NavigationHandler getInstance]NavigateToSignUpScreen];
          [player.view removeFromSuperview];
     }
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//     return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
//- (BOOL)shouldAutorotate
//{
//     return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//     return UIInterfaceOrientationLandscapeRight;
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//     // Return YES for supported orientations
//      if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//          
//          [_moviePlayer.view setFrame:CGRectMake(0, 0, 667, 375)];
//     }
//     return YES;
//}



@end
