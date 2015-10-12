//
//  Article.h
//  Libas
//
//  Created by Salman Khalid on 13/02/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Page.h"

@interface Article : NSObject{
    
    NSString *articleID;
    NSString *articleName;
    NSMutableArray *PagesArray;
    
    NSString *video_link;
    NSString *website_link;
    NSString *facebook_link;
    NSString *twitter_link;
    NSString *instagram_link;
    NSString *other_link;
    NSArray *keywords;
    
    
    BOOL _isDownloaded;
    BOOL _isAdvertisement;
    BOOL _isContactForm;
}

@property (nonatomic, retain) NSString *articleID;
@property (nonatomic, retain) NSString *articleName;
@property(nonatomic,retain) NSMutableArray *PagesArray;
@property(nonatomic,retain) NSString *video_link;
@property(nonatomic,retain) NSString *website_link;
@property(nonatomic,retain) NSString *facebook_link;
@property(nonatomic,retain) NSString *twitter_link;
@property(nonatomic,retain) NSString *instagram_link;
@property(nonatomic,retain) NSString *other_link;
@property(nonatomic,retain) NSArray *keywords;



@property BOOL _isDownloaded;
@property BOOL _isAdvertisement;
@property BOOL _isContactForm;

@end
