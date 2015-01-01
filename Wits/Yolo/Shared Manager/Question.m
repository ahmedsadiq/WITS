//
//  Question.m
//  Yolo
//
//  Created by Salman Khalid on 07/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "Question.h"
#import "Option.h"

@implementation Question


@synthesize questionID,questionText,questionImage,optionsArray;


-(id)initWithDictionary:(NSDictionary *)_dictionary{
    
    self = [super init];
    if(self)
    {
        self.optionsArray = [[NSMutableArray alloc] init];
        [self loadQuestion:_dictionary];
    }
    return self;
}


-(void)loadQuestion:(NSDictionary *)_dictionary{
    
    self.questionText = [_dictionary objectForKey:@"questionText"];
    self.questionID = [_dictionary objectForKey:@"questionId"];
    self.questionImage = [_dictionary objectForKey:@"questionImage"];
    
    NSArray *r_optionsIDArray = [_dictionary objectForKey:@"optionsId"];
    NSArray *r_optionsArray = [_dictionary objectForKey:@"options"];
    NSArray *r_isCorrectArray = [_dictionary objectForKey:@"isCorrect"];
    
    NSAssert([r_optionsIDArray count] == [r_optionsArray count], @"Size of option Arrays are not equal");
    NSAssert([r_optionsArray count] == [r_isCorrectArray count], @"Size of option Arrays are not equal");
    
    
    for(int i=0; i<[r_optionsIDArray count]; i++)
    {
        Option *_option = [[Option alloc] init];
        _option.optionID = [r_optionsIDArray objectAtIndex:i];
        _option.optionText = [r_optionsArray objectAtIndex:i];
          _option.optionText = [_option.optionText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _option.isCorrect = [r_isCorrectArray objectAtIndex:i];
        [self.optionsArray addObject:_option];
        
    }
    
}


-(Option *)getCorrectBotOption{
    
    for (int x =0; x<[self.optionsArray count]; x++) {
        
        Option *tempOption = [self.optionsArray objectAtIndex:x];
        if ([tempOption.isCorrect intValue] == 1) {
            return tempOption;
        }
    }
    return nil;
}

@end
