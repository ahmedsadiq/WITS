//
//  HistorySelectedCC.m
//  Wits
//
//  Created by Mr on 10/11/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "HistorySelectedCC.h"

@implementation HistorySelectedCC
@synthesize topicLbl,messageLbl,opponentImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
