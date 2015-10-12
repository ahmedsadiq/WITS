//
//  Rank.h
//  Yolo
//
//  Created by Jawad Mahmood  on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rank : NSObject{
    
    NSString *displayName;
    NSString *gender;
    NSString *cityName;
    NSString *countryName;
    NSString *countryCode;
    NSString *scorePoints;
    NSString *profileImage_url;
    NSString *profileImage_path;
    NSString *countryImage_url;
    NSString *countryImage_path;
    
    BOOL isProfileDownloaded;
    
}

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *scorePoints;
@property (nonatomic, strong) NSString *profileImage_url;
@property (nonatomic, strong) NSString *profileImage_path;
@property (nonatomic, strong) NSString *countryImage_url;
@property (nonatomic, strong) NSString *countryImage_path;

@property BOOL isProfileDownloaded;

@end
