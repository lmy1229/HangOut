//
//  ManageActViewController.m
//  HangOut
//
//  Created by ZhangKai on 14-8-28.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import "ManageActViewController.h"
#import "JsonSerialization.h"
#import "CKCalendarView.h"
#import "MAVCSettingView.h"
#import "TimeTableViewController.h"

@interface ManageActViewController ()
{
    MAVCSettingView *_settingView;
    UIView *_backView;
    UITapGestureRecognizer *_tapGR;
    
    UIBarButtonItem *_rightBBI;
    UITableView *_usersView;
//    UIRefreshControl *_refreshView;
    UILabel *_usersLabel;
    NSMutableDictionary *_userDict;
    NSString *_removeUserName;
    UILabel *_infoLabel;
    UITextView *_infoField;
    UIControl *_control;
    CKCalendarView *_calendar;
    UILabel *_dateLabel;
    UIButton *_timeBtn;
    UIButton *_chatBtn;
    UIButton *_posiBtn;
    UIButton *_quitBtn;
}
@end

@implementation ManageActViewController
@synthesize ID = _ID, isAdmin = _isAdmin,userName  = _userName;

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
	// Do any additional setup after loading the view.
    self.navigationItem.title = [self performSelector:@selector(getTitle:) withObject:_ID];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _rightBBI = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(bbiClicked)];
    self.navigationItem.rightBarButtonItem = _rightBBI;
    
     _userDict = [[NSMutableDictionary alloc]init];
    if(_isAdmin)
        NSLog(@"管理员");
    
    [self getUserData];
    
    _control = [[UIControl alloc]init];
    _control.frame = self.view.bounds;
    [_control addTarget:self action:@selector(keyboardDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_control];
    [self.view sendSubviewToBack:_control];
    
    _usersView = [[UITableView alloc]initWithFrame:CGRectMake(10, 260, 150, 230) style:UITableViewStylePlain];
    _usersView.dataSource = self;
    _usersView.delegate = self;
    
//    _refreshView = [[UIRefreshControl alloc]init];
//    _refreshView.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
//    [_refreshView addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_usersView addSubview:_refreshView];
    
    [self.view addSubview:_usersView];
  
    /*----------------------------------Text---------------------------------------*/
    
    _usersLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 220, 150, 40)];
    _usersLabel.text = @"一起的小伙伴";
    _usersLabel.textAlignment = NSTextAlignmentCenter;
    _usersLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_usersLabel];
    
    _infoField = [[UITextView alloc]initWithFrame:CGRectMake(10, 100, 150, 120)];
    _infoField.text = [self getActivityInfo];
    _infoField.editable = _isAdmin;
    _infoField.backgroundColor = [UIColor whiteColor];
    _infoField.delegate = self;
    [self.view addSubview:_infoField];
    
    _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 150, 30)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.text = @"活动信息";
    _infoLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_infoLabel];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 70, 150, 30)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.text = @"活动日期";
    _dateLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_dateLabel];
    
    /*----------------------------------UIButton---------------------------------------*/
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _timeBtn.frame = CGRectMake(170, 320, 150, 30);
    _timeBtn.tag = 1;
    _timeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [_timeBtn setTitle:@"时间表" forState:UIControlStateNormal];
    _timeBtn.enabled = [self getState:@"time"];
    [_timeBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeBtn];
    
    _chatBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _chatBtn.frame = CGRectMake(170, 390, 150, 30);
    _chatBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    _chatBtn.tag = 2;
    [_chatBtn setTitle:@"聊天室" forState:UIControlStateNormal];
    _chatBtn.enabled = [self getState:@"chat"];
    [_chatBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chatBtn];
    
    _posiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _posiBtn.frame = CGRectMake(170, 460, 150, 30);
    _posiBtn.tag = 3;
    _posiBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [_posiBtn setTitle:@"位置共享" forState:UIControlStateNormal];
    _posiBtn.enabled = [self getState:@"location"];
    [_posiBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_posiBtn];
    
    
    _quitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _quitBtn.frame = CGRectMake(30, 510, 260, 30);
    _quitBtn.tag = 4;
    _quitBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    if(!_isAdmin)
        [_quitBtn setTitle:@"退出活动" forState:UIControlStateNormal];
    else if (_isAdmin)
        [_quitBtn setTitle:@"更改设置" forState:UIControlStateNormal];
    [_quitBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quitBtn];
    
    /*----------------------------------CustomView---------------------------------------*/
    
    _calendar = [[CKCalendarView alloc]initWithFrame:CGRectMake(170, 100, 150, 140)];
    _calendar.titleFont = [UIFont fontWithName:@"Helvetica" size:10];
    _calendar.dateFont = [UIFont fontWithName:@"Helvetica" size:9];
    [self.view addSubview:_calendar];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 640)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.3;
    _backView.hidden = YES;
    _tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapped)];
    [_backView addGestureRecognizer:_tapGR];
    [self.view addSubview:_backView];
    
    _settingView = [[MAVCSettingView alloc]initWithFrame:CGRectMake(0, 600, 320, 250)];
    _settingView.backgroundColor = [UIColor whiteColor];
    _settingView.MAVCSettingDelegate = self;
    [self.view addSubview:_settingView];
    
    
    
}

-(void)refresh
{
    _timeBtn.enabled = [self getState:@"time"];
    _chatBtn.enabled = [self getState:@"chat"];
    _posiBtn.enabled = [self getState:@"location"];
}

-(void)btnPressed:(UIButton *)btn
{

    if(btn.tag == 1)
    {
        NSLog(@"should open timetable");
        TimeTableViewController *ttvc = [[TimeTableViewController alloc]init];
        [self.navigationController pushViewController:ttvc animated:YES];
    }
    else if(btn.tag == 2)
    {
        NSLog(@"should open chatroom");
    }
    else if(btn.tag == 3)
    {
        NSLog(@"should open position share");
    }
    else if(btn.tag == 4)
    {
        if(!_isAdmin)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定退出活动" message:@"您将退出此次活动，如您仅想关闭页面请单击右上角的Done按钮" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 4;
            [alert show];
            [alert release];
        }
        else if(_isAdmin)
        {
            [_settingView.chatSwitch setOn:_chatBtn.enabled];
            [_settingView.posiSwitch setOn:_posiBtn.enabled];
            [_settingView.timeSwitch setOn:_timeBtn.enabled];
            [UIView animateWithDuration:0.5 animations:^{
                _settingView.frame = CGRectMake(0, 320, 320, 250);
                _backView.hidden = NO;
                _rightBBI.enabled = NO;
            }];
        }
        
    }
}

-(void)backViewTapped
{
    if(_settingView.timeCount %2 == 1 || _settingView.chatCount %2 == 1 || _settingView.posiCount %2 == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认更改" message:@"您的设置已变更，是否保存更改？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        alert.tag = 5;
        [alert show];
        [alert release];
    }
    else
    {
        [_settingView btnPressed];
    }
}

-(void)backViewDismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        _settingView.frame = CGRectMake(0, 600, 320, 250);
        _backView.hidden = YES;
        _rightBBI.enabled = YES;
    }];
}

-(void)keyboardDismiss
{
    [_infoField resignFirstResponder];
}

-(void)bbiClicked
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 3;
    [alert show];
    [alert release];
}

#pragma customDelegate
-(void)dataUpdate
{
    int state = -1;
    BOOL change = NO;
    BOOL success = NO;
    if(_settingView.timeCount % 2 == 1)
    {
        change = YES;
        if(_settingView.timeSwitch.isOn)
            state = 1;
        else
            state = 0;
        success = [self updateState:@"time" withState:state];
    }
    if(_settingView.chatCount % 2 == 1)
    {
        change = YES;
        if(_settingView.chatSwitch.isOn)
            state = 1;
        else
            state = 0;
        success = [self updateState:@"chat" withState:state];
    }
    if(_settingView.posiCount % 2 == 1)
    {
        change = YES;
        if(_settingView.posiSwitch.isOn)
            state = 1;
        else
            state = 0;
        success = [self updateState:@"location" withState:state];
    }
    if(change)
    {
        if(success)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"更新成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            [self refresh];
            [self backViewDismiss];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新失败" message:@"服务器好像罢工了，过会儿再试吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    else
    {
        [self backViewDismiss];
    }
    [_settingView reboot];
}


#pragma mark GET/POST from api
-(void)getUserData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/getUserList/%@",_ID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
    _userDict = [json getSerialized];
    [request release];
    [json release];
    if([[_userDict objectForKey:@"status"]isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错啦" message:@"服务器好像罢工了，再试试吧" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(BOOL)getState:(NSString *)stateName
{
    NSDictionary *urlDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"getModelTimetable",@"time",
                             @"getModelChatroom",@"chat",
                             @"getModelLocation",@"location", nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/%@/%@",[urlDict objectForKey:stateName],_ID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
    NSMutableDictionary *dict = [json getSerialized];
    [request release];
    [json release];
    if([[dict objectForKey:@"status"]isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错啦" message:@"服务器好像罢工了，再试试吧" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if([[dict objectForKey:@"state"]isEqualToString:@"0"])
    {
        return NO;
    }
    else if([[dict objectForKey:@"state"]isEqualToString:@"1"])
    {
        return YES;
    }
    return NO;

}

-(NSString *)getTitle:(NSString *)ActivityID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/getActivityTitle/%@",_ID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
    NSMutableDictionary *dict = [json getSerialized];
    [request release];
    [json release];
    return [dict objectForKey:@"title"];
}

-(NSString *)getActivityInfo
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/getActivityInfo/%@",_ID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
    NSMutableDictionary *dict = [json getSerialized];
    [request release];
    [json release];
    return [dict objectForKey:@"info"];
}

-(BOOL)updateState:(NSString *)stateName withState:(int)state
{
    NSDictionary *urlDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"setModelTimetable",@"time",
                             @"setModelChatroom",@"chat",
                             @"setModelLocation",@"location", nil];
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/%@",[urlDict objectForKey:stateName]]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request2 setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *string = [NSString stringWithFormat:@"id=%@&state=%d",_ID,state];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request2 setHTTPBody:data];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request2];
    NSMutableDictionary *dict2 = [json getSerialized];
    if([[dict2 objectForKey:@"status"]isEqualToString:@"0"])
    {
        [request2 release];
        [json release];
        return YES;
    }
    else
    {
        [request2 release];
        [json release];
    }
    return NO;
}

-(void)updateActivityInfo
{
    NSURL *url2 = [NSURL URLWithString:@"http://hangout.org.cn/api/updateActivityInfo"];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request2 setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *string = [NSString stringWithFormat:@"id=%@&info=%@",_ID,_infoField.text];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request2 setHTTPBody:data];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request2];
    NSMutableDictionary *dict2 = [json getSerialized];
    if([[dict2 objectForKey:@"status"]isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"更新成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    [request2 release];
    [json release];
}

-(void)userUnregister
{
    NSURL *url2 = [NSURL URLWithString:@"http://hangout.org.cn/api/userUnregister"];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request2 setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *string = [NSString stringWithFormat:@"id=%@&username=%@",_ID,_userName];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request2 setHTTPBody:data];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request2];
    NSMutableDictionary *dict2 = [json getSerialized];
    if([[dict2 objectForKey:@"status"]isEqualToString:@"0"])
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    [request2 release];
    [json release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_rightBBI release];
    [_usersView release];
    [_usersLabel release];
//    [_userDict release];
    [_removeUserName release];
    [_infoLabel release];
    [_infoField release];
    [_control release];
    [_calendar release];
    [_settingView release];
    [_backView release];
    [_tapGR release];
    [super dealloc];
}

#pragma mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            NSURL *url2 = [NSURL URLWithString:@"http://hangout.org.cn/api/removeUser"];
            NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request2 setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
            NSString *string = [NSString stringWithFormat:@"id=%@&username=%@",_ID,_removeUserName];
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            [request2 setHTTPBody:data];
            JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request2];
            NSMutableDictionary *dict2 = [json getSerialized];
            if([[dict2 objectForKey:@"status"]isEqualToString:@"0"])
            {
                [self performSelector:@selector(getUserData)];
                [_usersView reloadData];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [alert release];
                _removeUserName = @"";
            }
            [request2 release];
            [json release];
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            _infoField.text = [self getActivityInfo];
        }
        else
        {
            [self updateActivityInfo];
        }
    }
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 1)
        {
            NSURL *url;
            if(_isAdmin)
            {
                url = [NSURL URLWithString:@"http://hangout.org.cn/api/adminLogout"];
            }
            else
            {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/userLogout/%@",_ID]];
            }
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
            JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
            NSMutableDictionary *dict = [json getSerialized];
            [request release];
            [json release];
            if([[dict objectForKey:@"status"]isEqualToString:@"0"])
            {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错啦" message:@"服务器好像罢工了呢，待会再试吧" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
        }
    }
    else if(alertView.tag == 4)
    {
        if(buttonIndex == 1)
            [self userUnregister];
    }
    else if(alertView.tag == 5)
    {
        if(buttonIndex == 1)
            [self dataUpdate];
        else
        {
            [self backViewDismiss];
            [_settingView reboot];
        }
    }
}

#pragma mark TextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(![textView.text isEqualToString:[self getActivityInfo]])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"活动信息已更改，是否更新？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 2;
        [alert show];
        [alert release];
    }
}

#pragma mark TableViewDelegate & DataSource

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isAdmin)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        _removeUserName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [_usersView resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"确认删除 %@ ?",_removeUserName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 1;
        [alert show];
        [alert release];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userDict count]-1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
    }
    if(indexPath.row < [_userDict count])
        cell.textLabel.text = [_userDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    cell.detailTextLabel.hidden = YES;
    return cell;
}

@end
