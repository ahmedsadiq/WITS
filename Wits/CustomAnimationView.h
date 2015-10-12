//
//  CustomAnimationView.h
//  ActivityAnimation
//
//  Created by tcs on 13/02/14.
//  Copyright (c) 2014 iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAnimationView : UIControl
{
	UIImageView *imageView;
	NSArray		*images;
	BOOL		isAnimating;
	int			status;
}
+(CustomAnimationView*)sharedCustomActivity;
-(void) showCustomActivity;
-(void) removeCustomActivity;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
- (void)doInit;
@end
