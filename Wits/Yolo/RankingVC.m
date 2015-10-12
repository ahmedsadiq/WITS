//
//  RankingVC.m
//  Yolo
//
//  Created by Jawad Mahmood  on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "RankingVC.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "SharedManager.h"
#import "RightBarVC.h"
#import "Rank.h"
#import "RankingCC.h"
#import "UIImageView+RoundImage.h"
@interface RankingVC ()

@end

@implementation RankingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    loadView = [[LoadingView alloc] init];
    allTimeBtn.selected = YES;
    rankingArray = [[NSArray alloc] init];
     [SharedManager getInstance].rankingArray = nil;
     [SharedManager getInstance].rankingArray = [[NSMutableArray alloc] init];
    [self fetchRankingDetail];
}

-(void)fetchRankingDetail{
    
    [loadView showInView:self.view withTitle:@"Loading ..."];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:@"rankingByScore" forKey:@"method"];
    [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
    [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
    
    MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
    
    [op onCompletion:^(MKNetworkOperation *compOperation){
        
        [loadView hide];
        NSDictionary *mainDict = [compOperation responseJSON];
        NSLog(@"%@",mainDict);
        NSString *messageStr = [mainDict objectForKey:@"message"];
        rankingArray = [mainDict objectForKey:@"ranking"];
        if ([rankingArray count]>0) {
            [self FetchCountryFlagImage];
        }
        
        else{
             
             
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to fetch" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }onError:^(NSError *error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavalible" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [alert show];
    }];
    
    [engine enqueueOperation:op];
}

-(void)FetchCountryFlagImage{
     
    for (int i=0; i<[rankingArray count]; i++) {
        
        NSDictionary *tempDict = [rankingArray objectAtIndex:i];
        
        Rank *_rankObj = [[Rank alloc] init];
        _rankObj.displayName = [tempDict objectForKey:@"display_name"];
        
        if ([[SharedManager getInstance] isDownloaded:_rankObj])
            continue;
    
        _rankObj.gender = [tempDict objectForKey:@"gender"];
        _rankObj.cityName = [tempDict objectForKey:@"city_name"];
        _rankObj.countryName = [tempDict objectForKey:@"country_name"];
        _rankObj.countryCode = [tempDict objectForKey:@"country_code"];
        _rankObj.scorePoints = [tempDict objectForKey:@"score_points"];
        _rankObj.profileImage_url = [tempDict objectForKey:@"profile_image"];
        _rankObj.countryImage_url = [tempDict objectForKey:@"country_image"];
        
        _rankObj.isProfileDownloaded = false;
        
        [[SharedManager getInstance].rankingArray addObject:_rankObj];
         
    }
    [rankTblView reloadData];
    [[SharedManager getInstance] saveModel];
    //[loadView showInView:self.view withTitle:@"Loading ..."];
    //[self DownloadFlag:0];
}




-(void)DownloadFlag:(int)_counter{
    
    Rank *tempRank = [[SharedManager getInstance].rankingArray objectAtIndex:_counter];
    
    if(!tempRank.isProfileDownloaded)
    {
        NSString *newDirPath = [docs stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",tempRank.displayName]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:newDirPath])
            NSLog(@"Already Exists");
        
        
        else{
            [fileManager createDirectoryAtPath:newDirPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            NSLog(@"Folder Created");
        }
        
        
        //NSString *profileImagePath = [newDirPath stringByAppendingPathComponent:@"profile.jpg"];
        NSString *countryImagePath = [newDirPath stringByAppendingPathComponent:@"flag.jpg"];
        
        
        MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
        MKNetworkOperation *op = [engine operationWithURLString:tempRank.countryImage_url params:nil httpMethod:@"GET"];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            UIImage *image = [completedOperation responseImage];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.0);
            [imageData writeToFile:countryImagePath atomically:NO];
            
            tempRank.countryImage_path = countryImagePath;
            tempRank.isProfileDownloaded = true;
            
            rankCounter++;
            if (rankCounter<[[SharedManager getInstance].rankingArray count])
                [self DownloadFlag:rankCounter];
            
            if (rankCounter == [[SharedManager getInstance].rankingArray count]) {
                
                [loadView hide];
                [[SharedManager getInstance] saveModel];
                [rankTblView reloadData];
            }
        } onError:^(NSError* error) {
            
            [loadView hide];
             
             
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to download check your network connection" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [alert show];
            
        }];
        
        [engine enqueueOperation:op];
        
    }
    
    else{
        
        rankCounter++;
        if (rankCounter<[[SharedManager getInstance].rankingArray count])
            [self DownloadFlag:rankCounter];
        
        if (rankCounter == [[SharedManager getInstance].rankingArray count]) {
            
            [loadView hide];
            [rankTblView reloadData];
        }
        
    }
}




- (IBAction)bckPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)ShowRightMenu:(id)sender{
    
    [[RightBarVC getInstance] AddInView:self.view];
    [[RightBarVC getInstance] ShowInView];
}



-(void)UnSelectOtherButtons{
    
    allTimeBtn.selected = NO;
    thisWeekBtn.selected = NO;
}

#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float returnValue;
    if ([[UIScreen mainScreen] bounds].size.height == iPad)
        returnValue = 88.0f;
    else
        returnValue = 58.0f;
    
    return returnValue;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[SharedManager getInstance].rankingArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RankingCC *cell ;
    
    if ([[UIScreen mainScreen] bounds].size.height == iPad) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RankingCC_iPad" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    else{
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RankingCC" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Rank *_rank = [[SharedManager getInstance].rankingArray objectAtIndex:indexPath.row];
    cell.nameLbl.text = _rank.displayName;
    cell.levelLbl.text = [NSString stringWithFormat:@"Level-%@",_rank.scorePoints];
    cell.scoreLbl.text = _rank.scorePoints;
    cell.rankingIndex.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
     if(_rank.countryName.length > 1) {
          
          NSString *flag = [_rank.countryName substringToIndex:2];
          flag = [flag uppercaseString];
          if( [_rank.countryName caseInsensitiveCompare:@"Pakistan"] == NSOrderedSame ) {
               flag = @"PK";
          }
          else if( [_rank.countryName caseInsensitiveCompare:@"Lebanon"] == NSOrderedSame ) {
               flag = @"LB";
          }
          cell.flagImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",flag]];
     }
    
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     MKNetworkOperation *op = [engine operationWithURLString:_rank.profileImage_url params:nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [cell.profileImgView setImage:[completedOperation responseImage]];
          [cell.profileImgView roundImageCorner];
          
     } onError:^(NSError* error) {
     }];
     
     [engine enqueueOperation:op];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.userInteractionEnabled = true;
    return cell;
}



#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
