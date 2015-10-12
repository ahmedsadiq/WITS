//
//  UITableViewCell+HelperFunctions.m
//  Wits
//
//  Created by Obaid ur Rehman on 17/09/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import "HelperFunctions.h"
#import "Utils.h"

@implementation HelperFunctions


+ (void)setBackgroundColor:(UIView *)myView
{
     UIColor * black = [UIColor blackColor];
     myView.backgroundColor = [black colorWithAlphaComponent:ALPHA_OVERLAY_VALUE];
}


@end
