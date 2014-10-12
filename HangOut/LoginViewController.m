//
//  LoginViewController.m
//  HangOut
//
//  Created by ZhangKai on 14-8-28.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import "LoginViewController.h"
#import "JsonSerialization.h"
#import "ManageActViewController.h"

@interface LoginViewController ()
{
    UIBarButtonItem *_backBtn;
    UITextField *_slugField;
    UILabel *_slugLabel;
    UILabel *_slugSubLabel;
    UISegmentedControl *_adminSeg;
    UITextField *_passwordField;
    UILabel *_passwordLabel;
    UILabel *_userLabel;
    UITextField *_userField;
    UIButton *_confirmBtn;
    UIControl *_control;
    
    NSMutableData *downloadData;
}

@end

@implementation LoginViewController

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
    self.navigationItem.title = @"登陆";
    
    _control = [[UIControl alloc]init];
    _control.frame = self.view.bounds;
    [_control addTarget:self action:@selector(keyboardDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_control];
    [self.view sendSubviewToBack:_control];
    
    _backBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = _backBtn;
    
    NSArray *array = [NSArray arrayWithObjects:@"用户登陆",@"管理员登陆", nil];
    _adminSeg = [[UISegmentedControl alloc]initWithItems:array];
    _adminSeg.frame = CGRectMake(60, 80, 200, 40);
    _adminSeg.selectedSegmentIndex = 0;
    [_adminSeg addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_adminSeg];
    
    
    _slugField = [[UITextField alloc]initWithFrame:CGRectMake(210, 170, 80, 30)];
    _slugField.placeholder = @"e.g. abc";
    _slugField.borderStyle = UITextBorderStyleLine;
    _slugField.delegate = self;
    _slugField.tag = 99;
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
    
    _userLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 80, 30)];
    _userLabel.text = @"用户名";
    _userLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_userLabel];
    
    _userField = [[UITextField alloc]initWithFrame:CGRectMake(100, 210, 200, 30)];
    _userField.placeholder = @"用户名";
    _userField.borderStyle = UITextBorderStyleLine;
    _userField.delegate = self;
    _userField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userField.tag = 1;
    [self.view addSubview:_userField];
    
    _passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 80, 30)];
    _passwordLabel.text = @"密码";
    _passwordLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_passwordLabel];
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(100, 250, 200, 30)];
    _passwordField.placeholder = @"密码";
    _passwordField.borderStyle = UITextBorderStyleLine;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    _passwordField.tag = 2;
    [self.view addSubview:_passwordField];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"活动不存在" forState:UIControlStateDisabled];
    [_confirmBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:22]];
    _confirmBtn.frame = CGRectMake(60, 300, 200, 30);
    [_confirmBtn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    
    
}

-(void)keyboardDismiss
{
    [_userField resignFirstResponder];
    [_slugField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

-(void)goBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)valueChanged
{
    if(_adminSeg.selectedSegmentIndex == 1)
    {
        _adminSeg.userInteractionEnabled = NO;
        _userLabel.hidden = YES;
        _userField.hidden = YES;
        _userField.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.6 animations:^{
            _passwordLabel.frame = CGRectMake(10, 210, 80, 30);
            _passwordField.frame = CGRectMake(100, 210, 200, 30);
            _confirmBtn.frame = CGRectMake(60, 260, 200, 30);
        } completion:^(BOOL finished) {
            _adminSeg.userInteractionEnabled = YES;
        }];
    }
    else if(_adminSeg.selectedSegmentIndex == 0)
    {
        _adminSeg.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.6 animations:^{
            _passwordLabel.frame = CGRectMake(10, 250, 80, 30);
            _passwordField.frame = CGRectMake(100, 250, 200, 30);
            _confirmBtn.frame = CGRectMake(60, 300, 200, 30);
        } completion:^(BOOL finished) {
            _userLabel.hidden = NO;
            _userField.hidden = NO;
            _userField.userInteractionEnabled = YES;
            _adminSeg.userInteractionEnabled = YES;
        }];
    }
}

-(void)btnPressed
{
    [self performSelector:@selector(keyboardDismiss)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/getID/%@",_slugField.text]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request];
    NSMutableDictionary *dict = [json getSerialized];
    [request release];
    [json release];
    if([[dict objectForKey:@"id"]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您输入的活动不存在" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    if(_adminSeg.selectedSegmentIndex == 0)
    {
        
        NSURL *url2 = [NSURL URLWithString:@"http://hangout.org.cn/api/userlogin"];
        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request2 setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *string = [NSString stringWithFormat:@"id=%@&username=%@&password=%@",[dict objectForKey:@"id"],_userField.text,_passwordField.text];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        [request2 setHTTPBody:data];
        JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request2];
        NSMutableDictionary *dict2 = [json getSerialized];
        if([[dict2 objectForKey:@"status"]isEqualToString:@"0"])
        {
            ManageActViewController *mavc = [[[ManageActViewController alloc]init]autorelease];
            mavc.isAdmin = NO;
            mavc.ID = [dict objectForKey:@"id"];
            mavc.userName = _userField.text;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mavc];
            mavc.modalPresentationStyle = UIModalPresentationFullScreen;
            mavc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController presentViewController:nav animated:YES completion:^{
                NSLog(@"用户管理活动");
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您输入的用户名或密码有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        [request2 release];
        [json release];
        
    }
    else
    {
        NSURL *url2 = [NSURL URLWithString:@"http://hangout.org.cn/api/adminlogin"];
        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request2 setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *string = [NSString stringWithFormat:@"id=%@&password=%@",[dict objectForKey:@"id"],_passwordField.text];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        [request2 setHTTPBody:data];
        JsonSerialization *json = [[JsonSerialization alloc]initWithRequest:request2];
        NSMutableDictionary *dict3 = [json getSerialized];
        if([[dict3 objectForKey:@"status"]isEqualToString:@"0"])
        {
            ManageActViewController *mavc = [[[ManageActViewController alloc]init]autorelease];
            mavc.isAdmin = YES;
            mavc.ID = [dict objectForKey:@"id"];
            mavc.userName = @"";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mavc];
            mavc.modalPresentationStyle = UIModalPresentationFullScreen;
            mavc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController presentViewController:nav animated:YES completion:^{
                NSLog(@"管理员管理活动");
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您输入密码有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        [request2 release];
        [json release];
    }
}

#pragma UITextfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 2)
    {
        if(_adminSeg.selectedSegmentIndex == 0 && ![_userField.text isEqualToString:@""] && ![_slugField.text isEqualToString:@""])
           [self btnPressed];
        else if(_adminSeg.selectedSegmentIndex == 1 && ![_slugField.text isEqualToString:@""])
           [self btnPressed];
    }
    else
    {
        [self keyboardDismiss];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 99)
    {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/getID/%@",_slugField.text]]];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if (connection) {
            downloadData = [[NSMutableData alloc]initWithCapacity:0];
        }
        [request release];
    }
}

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [downloadData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [downloadData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:downloadData options:NSJSONReadingMutableContainers error:nil];
    if([[dict objectForKey:@"id"]isEqualToString:@""])
    {
        _confirmBtn.enabled = NO;
    }
    else
    {
        _confirmBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_slugField release];
    [_slugLabel release];
    [_slugSubLabel release];
    [_adminSeg release];
    [_passwordField release];
    [_passwordLabel release];
    [_userLabel release];
    [_userField release];
    [_confirmBtn release];
    [_control release];
    [super dealloc];
}

@end
