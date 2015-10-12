//
//  CategoryModel.h
//  Wits
//
//  Created by Mr on 01/01/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject {
     
}
@property (nonatomic, retain) NSString *category_id;
@property (nonatomic, retain) NSString *_description;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *is_recommended;
@property (nonatomic, retain) NSMutableArray *topicsArray;
@property BOOL isSelected;
@end
