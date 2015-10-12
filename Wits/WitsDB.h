//
//  WitsDB.h
//  Wits
//
//  Created by Apple on 26/03/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WitsDB : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

-(void)copyDatabaseIntoDocumentsDirectory;

@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;
@property (nonatomic) int recordFound;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;
@end
