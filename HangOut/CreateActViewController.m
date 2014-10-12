//
//  CreateActViewController.m
//  HangOut
//
//  Created by ZhangKai on 14-8-21.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import "CreateActViewController.h"
#import "JsonSerialization.h"

@interface CreateActViewController ()
{
    UITextField *_titleField;
    UITextField *_slugField;
    UILabel *_titleLabel;
    UILabel *_slugLabel;
    UILabel *_slugSubLabel;
    UISwitch *_dateSwitch;
    UISwitch *_chatSwitch;
    UISwitch *_posiSwitch;
    UILabel *_dateLabel;
    UILabel *_chatLabel;
    UILabel *_posiLabel;
    UIButton *_btnConfirm;
    UIBarButtonItem *_leftBBI;
    UIControl *_control;
    UIActivityIndicatorView *_aiv;
    int _dateStatus;
    int _chatStatus;
    int _posiStatus;
}

@end

@implementation CreateActViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"创建活动";
    
    _control = [[UIControl alloc]init];
    _control.frame = self.view.bounds;
    [_control addTarget:self action:@selector(keyboardDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_control];
    [self.view sendSubviewToBack:_control];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 80, 30)];
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.text = @"活动名称";
    [self.view addSubview:_titleLabel];
    
    _titleField = [[UITextField alloc]initWithFrame:CGRectMake(120, 80, 180, 30)];
    _titleField.placeholder = @"活动名称";
    _titleField.borderStyle = UITextBorderStyleLine;
    _titleField.delegate = self;
    _titleField.tag = 0;
    _titleField.autocorrectionType = UITextAutocorrectionTypeNo;
    _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_titleField];
    [_titleField becomeFirstResponder];
    
    _slugField = [[UITextField alloc]initWithFrame:CGRectMake(210, 170, 80, 30)];
    _slugField.placeholder = @"e.g. abc";
    _slugField.borderStyle = UITextBorderStyleLine;
    _slugField.delegate = self;
    _slugField.tag = 1;
    _slugField.autocorrectionType = UITextAutocorrectionTypeNo;
    _slugField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_slugField];
    
    _slugLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 80, 30)];
    _slugLabel.text = @"活动主页";
    _slugLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_slugLabel];
    
    _slugSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 200, 30)];
    _slugSubLabel.text = @"http://hangout.org.cn/a/";
    _slugSubLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_slugSubLabel];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnConfirm.frame = CGRectMake(80, 320, 160, 30);
    _btnConfirm.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    [_btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [_btnConfirm setTitle:@"网址已存在" forState:UIControlStateDisabled];
    [_btnConfirm addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnConfirm];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 230, 70, 30)];
    _dateLabel.text = @"时间表";
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_dateLabel];
    
    _dateSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(25, 270, 70, 30)];
    _dateSwitch.tag = 1;
    _dateStatus = 0;
    [_dateSwitch setOn:NO animated:NO];
    [_dateSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_dateSwitch];
    
    _chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 230, 70, 30)];
    _chatLabel.text = @"聊天室";
    _chatLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_chatLabel];
    
    _chatSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(115, 270, 70, 30)];
    _chatSwitch.tag = 2;
    _chatStatus = 0;
    [_chatSwitch setOn:NO animated:NO];
    [_chatSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_chatSwitch];
    
    _posiLabel = [[UILabel alloc]initWithFrame:CGRectMake(205, 230, 70, 30)];
    _posiLabel.text = @"位置共享";
    _posiLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_posiLabel];
    
    _posiSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(205, 270, 70, 30)];
    _posiSwitch.tag = 3;
    _posiStatus = 0;
    [_posiSwitch setOn:NO animated:NO];
    [_posiSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_posiSwitch];
    
    _aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _aiv.frame = CGRectMake(20, 0, 30, 30);
    [self.view addSubview:_aiv];
    
    _leftBBI = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(bbiClicked)];
    self.navigationItem.leftBarButtonItem = _leftBBI;
    
    
    
}

-(void)keyboardDismiss
{
    [_slugField resignFirstResponder];
    [_titleField resignFirstResponder];
}

//返回join
-(void)bbiClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"leftBBI clicked");
    }];
}

//确认按钮点击
-(void)btnPressed:(UIButton *)btn
{
    [_aiv stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].placeholder = @"输入密码";
    [alert textFieldAtIndex:0].secureTextEntry = YES;
    [alert textFieldAtIndex:1].placeholder = @"确认密码";
    [alert textFieldAtIndex:1].secureTextEntry = YES;
    [alert show];
    [alert release];
}

//开关切换
-(void)switchChanged:(UISwitch *)swh
{
    [_titleField resignFirstResponder];
    [_slugField resignFirstResponder];
    if(swh.tag == 1)
    {
        if(swh.isOn)
        {
            NSLog(@"date on");
            _dateStatus = 1;
        }
        else
        {
            NSLog(@"date off");
            _dateStatus = 0;
        }
    }
    else if(swh.tag == 2)
    {
        if(swh.isOn)
        {
            NSLog(@"chat on");
            _chatStatus = 1;
        }
        else
        {
            NSLog(@"chat off");
            _chatStatus = 0;
        }
    }
    else if (swh.tag == 3)
    {
        if(swh.isOn)
        {
            NSLog(@"posi on");
            _posiStatus = 1;
        }
        else
        {
            NSLog(@"posi off");
            _posiStatus = 0;
        }
    }
}

#pragma mark UITextViewDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_slugField resignFirstResponder];
    [_titleField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        _slugField.text = textField.text;
    }
    NSString *str=[NSString stringWithFormat:@"http://hangout.org.cn/api/getID/%@",_slugField.text];
    //转化成网址类对象
    NSURL *url=[NSURL URLWithString:str];
    //转化成请求类对象
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
    [_aiv startAnimating];
    NSMutableDictionary *dict = [json getSerialized];
    BOOL different = NO;
    if([[dict objectForKey:@"id"] isEqualToString:@""])
        different = YES;
    [json release];
    if(different)
    {
        _btnConfirm.enabled = YES;
    }
    else
    {
        _btnConfirm.enabled = NO;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 0)
    {
        _slugField.text = textField.text;
    }
    return YES;
}


#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if([[alertView textFieldAtIndex:0].text isEqualToString:[alertView textFieldAtIndex:1].text])
        {
            NSString *str = [NSString stringWithFormat:@"title=%@&slug=%@&model_timetable=%d&model_chatroom=%d&model_location=%d&password1=%@&password2=%@",_titleField.text,_slugField.text,_dateStatus,_chatStatus,_posiStatus,[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
            NSLog(@"%@",str);
            NSURL *url = [NSURL URLWithString:@"http://www.hangout.org.cn/api/createactivity"];
            //第二步，创建请求
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
            [_aiv startAnimating];
            NSMutableDictionary *dict = [json getSerialized];
            [_aiv stopAnimating];
            [json release];
            [request release];
            if([[dict objectForKey:@"status"]  isEqualToString: @"0"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"活动创建成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            else
            {
                if([[dict objectForKey:@"slugUnavailable"] isEqualToString:@"1"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您输入的网址不可用" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else if([[dict objectForKey:@"password2Error"] isEqualToString:@"1"] || [[dict objectForKey:@"password1Error"] isEqualToString:@"1"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您输入的密码有误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else if([[dict objectForKey:@"slugError"] isEqualToString:@"1"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您输入的网址有误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else if([[dict objectForKey:@"titleError"] isEqualToString:@"1"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您输入的活动标题有误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
            }
            
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您输入的密码前后不符，请重新输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        [[alertView textFieldAtIndex:1] resignFirstResponder];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_titleField release];
    [_slugField release];
    [_titleLabel release];
    [_slugLabel release];
    [_slugSubLabel release];
    [_dateSwitch release];
    [_chatSwitch release];
    [_posiSwitch release];
    [_dateLabel release];
    [_chatLabel release];
    [_posiLabel release];
    [_btnConfirm release];
    [_control release];
    [_aiv release];
    [_leftBBI release];
    [super dealloc];
}

@end
