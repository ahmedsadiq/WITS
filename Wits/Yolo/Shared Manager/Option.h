//
//  Option.h
//  Yolo
//
//  Created by Salman Khalid on 07/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject{
 
    NSString *optionID;
    NSString *optionText;
    NSString *isCorrect; // correct one is 1
    //     NSAssert(x != y, @"x and y were equal, this shouldn't happen");
}

@property (nonatomic, retain)   NSString *optionID;
@property (nonatomic, retain)   NSString *optionText;
@property (nonatomic, retain)   NSString *isCorrect;

@end

/*
 
"options_id": [
               "33",
               "34",
               "35",
               "36"
               ],
"options": [
            "Anne Boleyn",
            "Anne of Cleves",
            "Catherine Howard",
            "Jane Seymou"
            ],
"is_correct": [
               "0",
               "1",
               "0",
               "0"
               ]
*/