//
//  UIImageView+RoundImage.m
//  Wits
//
//  Created by Nisar Ahmad on 19/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "UIImageView+RoundImage.h"

@implementation UIImageView (RoundImage)

-(void)roundImageCorner{
    
    [self setBackgroundColor:[UIColor clearColor]];
     self.layer.cornerRadius = self.frame.size.width / 2;
     self.layer.borderWidth = 4.0f;
      self.clipsToBounds = YES;
     //self.layer.masksToBounds = YES;
     self.layer.borderColor = [UIColor whiteColor].CGColor;
   
    
    //return self;
}


@end
