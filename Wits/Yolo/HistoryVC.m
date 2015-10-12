//
//  HistoryVC.m
//  Yolo
//
//  Created by Salman Khalid on 25/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "HistoryVC.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "Utils.h"
#import "RightBarVC.h"
#import "History.h"
#import "HistoryCC.h"
#import "AlertMessage.h"
@interface HistoryVC ()

@end

@implementation HistoryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)ShowRightMenu:(id)sender{
    
    [[RightBarVC getInstance] AddInView:self.view];
    [[RightBarVC getInstance] ShowInView];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _loadingView = [[LoadingView alloc] init];

     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
    historyArray = [[NSMutableArray alloc] init];
    [self fetchHistory];

}


-(void)fetchHistory{
    
    [_loadingView showInView:self.view withTitle:@"Fetching History"];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:@"showHistory" forKey:@"method"];
    [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
    [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
    
    MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation){
        
        [_loadingView hide];
        NSDictionary *mainDict = [completedOperation responseJSON];
        NSLog(@"main dict %@",mainDict);
        
        NSString *msgStr = [mainDict objectForKey:@"message"];
        if ([msgStr isEqualToString:@"success"]) {
            
            NSArray *recivedArray = [mainDict objectForKey:@"data"];
           for(NSDictionary *tempdict in recivedArray)
           {
               History *temp_Obj = [[History alloc] init];
               temp_Obj.isSelected = false;
               
               temp_Obj.game_message = [tempdict objectForKey:@"game_message"];
               temp_Obj.sub_topic_title = [tempdict objectForKey:@"sub_topic_title"];
               temp_Obj.opponent_image = [tempdict objectForKey:@"opponent_image"];
               [historyArray addObject:temp_Obj];
           }
            [table_View reloadData];
            NSLog(@"History Count %i",[historyArray count]);
        }
        else{
            
             [AlertMessage showAlertWithMessage:@"Unable to fetch" andTitle:@"Error !"SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
            
             
           /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"Unable to fetch" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [alert show];*/
        }
        
        
    }
                    onError:^(NSError *error){
                        
                        [_loadingView hide];
                         
                         
                         NSString *emailMsg;
                         NSString *title;
                         NSString *cancel;
                         if (languageCode == 0 ) {
                              emailMsg = @"Check your internet connection setting.";
                              title = @"Error";
                              cancel = CANCEL;
                         } else if(languageCode == 1) {
                              emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                              title = @"خطأ";
                              cancel = CANCEL_1;
                         }else if (languageCode == 2){
                              emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
                              title = @"Erreur";
                              cancel = CANCEL_2;
                         }else if (languageCode == 3){
                              emailMsg = @"Revise su configuración de conexión a Internet.";
                              title = @"Error";
                              cancel = CANCEL_3;
                         }else if (languageCode == 4){
                              emailMsg = @"Verifique sua configuração de conexão à Internet";
                              title = @"Erro";
                              cancel = CANCEL_4;
                         }
                    
                         [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                       
                         
                      /*  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                        
                        [alert show];*/
                        
                    }];
    
    [engine enqueueOperation:operation];

}

#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float returnValue;
    if ([[UIScreen mainScreen] bounds].size.height == iPad)
    {
        /*Topic *tempToplic = [subtopicsArray objectAtIndex:indexPath.row];
        if(tempToplic.isSelected)
            returnValue = 64.0f;
        
        else
            returnValue = 50.0f;*/
    }
    else
    {
        History *tempHistory = [historyArray objectAtIndex:indexPath.row];
        if(tempHistory.isSelected)
            returnValue = 49.0f;
        
        else
            returnValue = 50.0f;
    }
    
    return returnValue;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [historyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    History *tempHistory = [historyArray objectAtIndex:indexPath.row];
    if(!tempHistory.isSelected)
    {
        HistoryCC *cell ;
        
        if ([[UIScreen mainScreen] bounds].size.height == iPad) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCC_iPad" owner:self options:nil];
          cell = [nib objectAtIndex:0];
        }
        else{
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCC" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
            cell.topicLbl.text = tempHistory.sub_topic_title;
            cell.messageLbl.text = tempHistory.game_message;
            cell.selectionStyle = NAN;
/*
            MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
            MKNetworkOperation *op = [engine operationWithURLString:tempHistory.opponent_image params:nil httpMethod:@"GET"];
        
            [op onCompletion:^(MKNetworkOperation *completedOperation) {
            [cell.opponentImageView setImage:[completedOperation responseImage]];
            
        } onError:^(NSError* error) {
            
        }];
        
        [engine enqueueOperation:op];
*/
        
        
        return cell;
    }
    else
    {
/*        SubTopicSelectedCC *cell ;
        
        if ([[UIScreen mainScreen] bounds].size.height == iPad) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubTopicSelectedCC_iPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        else{
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubTopicSelectedCC" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        Topic *tempTopic = [subtopicsArray objectAtIndex:indexPath.row];
        cell.titleLbl.text = tempTopic.title;
        cell.selectionStyle = NAN;
        
        [cell.discussionBtn setTag:indexPath.row];
        [cell.playBowBtn setTag:indexPath.row];
        [cell.rankingBtn setTag:indexPath.row];
        [cell.challengeBtn setTag:indexPath.row];
        
        [cell.discussionBtn addTarget:self action:@selector(discussionSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.playBowBtn addTarget:self action:@selector(PlayNowSlected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rankingBtn addTarget:self action:@selector(rankingsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.challengeBtn addTarget:self action:@selector(challengeSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;*/
        
    }
    return nil;
}

//

#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if ([SharedManager getInstance].isFriendListSelected) {
        
        Topic *subTopic = [subtopicsArray objectAtIndex:indexPath.row];
        
        ChallengeFriendsVC *challenge = [[ChallengeFriendsVC alloc] initWithTopic_ID:parentTopic.topic_id andSubTopic:subTopic];
        
        [self.navigationController pushViewController:challenge animated:YES];
        
    }
    else{
        
        Topic *tempToplic = [subtopicsArray objectAtIndex:indexPath.row];
        
        if(tempToplic.isSelected)
            tempToplic.isSelected = false;
        else
            tempToplic.isSelected = true;
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
