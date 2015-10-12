//
//  Question.h
//  Yolo
//
//  Created by Salman Khalid on 07/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Option.h"

@interface Question : NSObject{
 
    NSString *questionID;
    NSString *questionText;
    NSString *questionImage;
    
    NSMutableArray *optionsArray;
}

@property (nonatomic,retain) NSString *questionID;
@property (nonatomic,retain) NSString *questionText;
@property (nonatomic,retain) NSString *questionImage;

@property (nonatomic,retain) NSMutableArray *optionsArray;

-(id)initWithDictionary:(NSDictionary *)_dictionary;
-(void)loadQuestion:(NSDictionary *)_dictionary;
-(Option *)getCorrectBotOption;

/*
 "question_id": "9",
 "question_text": "Hans Holbein the Younger was criticized by Henry VIII for painting a flattering portrait of whom?",
 "question_image": "",
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
@end
