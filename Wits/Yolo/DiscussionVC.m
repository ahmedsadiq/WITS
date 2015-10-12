//
//  DiscussionVC.m
//  Yolo
//
//  Created by Nisar Ahmad on 08/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "DiscussionVC.h"
#import "SharedManager.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "MessageThreads.h"
#import "RightBarVC.h"
#import "ThreadCC.h"
#import "ConversationVC.h"
#import "ChatVC.h"


@interface DiscussionVC ()

@end

@implementation DiscussionVC

@synthesize isNewDiscussion;

- (id)initWithSub_Topic:(Topic *)_subTopic
{
    if ([[UIScreen mainScreen] bounds].size.height == iPad)
        self = [super initWithNibName:@"DiscussionVC_iPad" bundle:nil];
    else
        self = [super initWithNibName:@"DiscussionVC" bundle:nil];
   
    if (self) {
        subTopic = _subTopic;
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
    
    _loadView = [[LoadingView alloc] init];
    discussionArray = [[NSMutableArray alloc] init];
    
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
    if (!(isNewDiscussion)){
        newDiscussionBtn.hidden = YES;
        seperator.hidden = YES;
        if ([[UIScreen mainScreen] bounds].size.height == iPad)
        {
            [discussionTbl setFrame:CGRectMake(discussionTbl.frame.origin.x, 100.0, discussionTbl.frame.size.width, self.view.frame.size.height-65.0)];
        }
        else
            [discussionTbl setFrame:CGRectMake(discussionTbl.frame.origin.x, 70.0, discussionTbl.frame.size.width, self.view.frame.size.height-65.0)];
        
    }
    
    [self GetDiscussionThreads];
}




#pragma mark --------
#pragma mark Get Discussions

-(void)GetDiscussionThreads{
    
    [_loadView showInView:self.view withTitle:@"Getting Discussion"];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:@"getDiscussionThreads" forKey:@"method"];
    [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
    [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
    
    if (isNewDiscussion) {
        [postParams setObject:subTopic.topic_id forKey:@"sub_topic_id"];
    }
    
    
    MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation){
        
        [_loadView hide];
        NSDictionary *tempDict = [completedOperation responseJSON];
        NSLog(@"%@",tempDict);
        
        NSNumber *flag = [tempDict objectForKey:@"flag"];
        if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
            
            NSArray *mainArray = [tempDict objectForKey:@"data"];
            if ([mainArray count]>0) {
                
                [discussionArray removeAllObjects];
                for (int y=0; y<[mainArray count]; y++) {
    
                    MessageThreads *thread = [[MessageThreads alloc] init];
                    [thread SetValuesFromDictionary:[mainArray objectAtIndex:y]];
                    thread.discussionTitle = [[mainArray objectAtIndex:y] objectForKey:@"discussion_title"];
                    thread.discussion_ID = [[mainArray objectAtIndex:y] objectForKey:@"thread_id"];
                    [discussionArray addObject:thread];
                }
                
                [discussionTbl reloadData];
            }
        }
        
    }onError:^(NSError *error){
        
        [_loadView hide];
         
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
         /*
        UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [notifi show]; */
        
    }];
    
    [engine enqueueOperation:operation];
    
}





#pragma mark ------------
#pragma mark Create Discussions

- (IBAction)CreateNewDiscussion:(id)sender {
    
     [_loadView showInView:self.view withTitle:loadingTitle];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:@"createDiscussion" forKey:@"method"];
    [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
    [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
    [postParams setObject:subTopic.topic_id forKey:@"sub_topic_id"];
    [postParams setObject:subTopic.title forKey:@"title"];
    
    MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation){
        
        [_loadView hide];
        NSDictionary *tempDict = [completedOperation responseJSON];
        NSLog(@"%@",tempDict);
        
        NSNumber *flag = [tempDict objectForKey:@"flag"];
        if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
            
            NSArray *mainArray = [tempDict objectForKey:@"data"];
            if ([mainArray count]>0)
                [self GetDiscussionThreads];
        }
        
    }onError:^(NSError *error){
        
        [_loadView hide];
        
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
         /*
          UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
          
          [notifi show]; */
         
        
        
    }];
    
    [engine enqueueOperation:operation];
    
}



#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float returnValue;
    if ([[UIScreen mainScreen] bounds].size.height == iPad)
    {
        returnValue = 67.0f;
    }
    else
    {
        returnValue = 43.0f;
    }
    
    return returnValue;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [discussionArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ThreadCC *cell;
    
    if ([[UIScreen mainScreen] bounds].size.height == iPad) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ThreadCC_iPad" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    else{
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ThreadCC" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    MessageThreads *_thread = [discussionArray objectAtIndex:indexPath.row];
    cell.nameLbl.text = _thread.displayName;
    cell.messageLbl.text = _thread.discussionTitle;
    cell.timeLbl.text = _thread.lastMessage;
    
    
    // add gesture to delete Discussion
    
    cell.tag = indexPath.row;
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(DeleteDiscussion:)];
    
    longGesture.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:longGesture];
    
    cell.selectionStyle =  NAN;
    
    return cell;
}




#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageThreads *tempThread = [discussionArray objectAtIndex:indexPath.row];
    
}





#pragma mark ----------
#pragma mark Delete Discussion

-(void)DeleteDiscussion:(UILongPressGestureRecognizer *)sender{
    
    UITableViewCell *tempCell = (UITableViewCell *)[sender view];
    indexToDelete = tempCell.tag;
    NSLog(@"%i",tempCell.tag);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
         [AlertMessage showAlertWithMessage:@"You want to delete conversation ?" andTitle:@"Delete" SingleBtn:NO cancelButton:@"NO" OtherButton:@"YES"];
     
        UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"You want to delete conversation ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        [notifi show];
    }
    
    
}



#pragma mark ------------
#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%i",buttonIndex);
    if (buttonIndex == 1) {
        
        [self YesDeleteDiscussion];
    }
}



-(void)YesDeleteDiscussion{
    
    MessageThreads *_thread = [discussionArray objectAtIndex:indexToDelete];
    
    [_loadView showInView:self.view withTitle:loadingTitle];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
    [postParams setObject:@"deleteDiscussionThread" forKey:@"method"];
    [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
    [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
    [postParams setObject:_thread.discussion_ID forKey:@"discussion_id"];
    
    MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation){
        
        [_loadView hide];
        NSDictionary *tempDict = [completedOperation responseJSON];
        NSLog(@"%@",tempDict);
        
        NSString *message = [tempDict objectForKey:@"message"];
        NSNumber *flag = [tempDict objectForKey:@"flag"];
        if ([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]]) {
            
            [discussionArray removeObjectAtIndex:indexToDelete];
            [discussionTbl reloadData];
        }
        else{
            
             [AlertMessage showAlertWithMessage:message andTitle:@"Error" SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
             
        /*    UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            
            [notifi show]; */
        }
        
    }onError:^(NSError *error){
        
        [_loadView hide];
         
         NSString *emailMsg;
         NSString *title;
         if (languageCode == 0 ) {
              emailMsg = @"Check your internet connection setting.";
              title = @"Error";
         } else if(languageCode == 1) {
              emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
              title = @"خطأ";
         }else if (languageCode == 2){
              emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
              title = @"Erreur";
         }else if (languageCode == 3){
              emailMsg = @"Revise su configuración de conexión a Internet.";
              title = @"Error";
         }else if (languageCode == 4){
              emailMsg = @"Verifique sua configuração de conexão à Internet";
              title = @"Erro";
         }
         
         [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
        
      /*  UIAlertView *notifi = [[UIAlertView alloc] initWithTitle:@"Error" message:emailMsg delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        
        [notifi show]; */
        
    }];
    
    [engine enqueueOperation:operation];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Set Language

-(void)setLanguageForScreen {
     NSString* language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     int languageCode = [language intValue];
     if (languageCode == 0) {
          
          loadingTitle = Loading;
          
     }else if (languageCode == 1){
          
          loadingTitle = Loading_1;
          
     }else if (languageCode == 2){
          
          loadingTitle = Loading_2;
          
     }else if (languageCode == 3){
          
          loadingTitle = Loading_3;
          
     }else if (languageCode == 4){
          
          loadingTitle = Loading_4;
          
     }
}
@end
