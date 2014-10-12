//
//  JoinActViewController.m
//  HangOut
//
//  Created by ZhangKai on 14-8-21.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import "JoinActViewController.h"
#import "JsonSerialization.h"
#import "CreateActViewController.h"
#import "LoginViewController.h"

@interface JoinActViewController ()

@end

@implementation JoinActViewController
{
    UITextField *_slug;
    UITextField *_userNameField;
    UITextField *_password1;
    UITextField *_password2;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [_slug release];
    [_userNameField release];
    [_password1 release];
    [_password2 release];
    [super dealloc];
}

- (void)controlclick
{
    [_slug resignFirstResponder];
    [_userNameField resignFirstResponder];
    [_password1 resignFirstResponder];
    [_password2 resignFirstResponder];
}

-(void)confirmLogin
{
    
    if (_slug.text.length * _userNameField.text.length * _password1.text.length * _password2.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请检查是否有空项" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if (![_password1.text isEqualToString:_password2.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"两次密码输入不符" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self getIDRequest];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"注册加入活动";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.192 green:0.545 blue:0.949 alpha:0.1];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(245, 85, 70, 30)];
    
    UILabel *address1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 300, 20)];
    address1.text = @"请输入活动代码";
    [self.view addSubview:address1];
    [address1 release];
    
    UILabel *address2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 90, 140, 20)];
    address2.text = @"hangout.org.cn/a/";
    [self.view addSubview:address2];
    [address2 release];
    
    _slug = [[UITextField alloc]initWithFrame:CGRectMake(145, 85, 100, 30)];
    _slug.backgroundColor = [UIColor grayColor];
    _slug.borderStyle = UITextBorderStyleRoundedRect;
    _slug.clearButtonMode = UITextFieldViewModeWhileEditing;
    _slug.delegate = self;
    _slug.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, 320, 20)];
    lab.text = @"------请填写您的注册信息------";
    [self.view addSubview:lab];
    [lab release];
    
    UILabel *userName1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 135, 20)];
    userName1.text = @"用户名:";
    [self.view addSubview:userName1];
    [userName1 release];
    
    _userNameField = [[UITextField alloc]initWithFrame:CGRectMake(145, 165, 170, 30)];
    _userNameField.backgroundColor = [UIColor grayColor];
    _userNameField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameField.placeholder = @"用户名";
    _userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UILabel *enterPassword = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 135, 20)];
    enterPassword.text = @"输入密码:";
    [self.view addSubview:enterPassword];
    [enterPassword release];
    
    _password1 = [[UITextField alloc]initWithFrame:CGRectMake(145, 205, 170, 30)];
    _password1.backgroundColor = [UIColor grayColor];
    _password1.borderStyle = UITextBorderStyleRoundedRect;
    _password1.placeholder = @"密码";
    _password1.secureTextEntry = YES;
    
    UILabel *reEnterPassword = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 135, 20)];
    reEnterPassword.text = @"再次输入密码:";
    [self.view addSubview:reEnterPassword];
    [reEnterPassword release];
    
    _password2 = [[UITextField alloc]initWithFrame:CGRectMake(145, 245, 170, 30)];
    _password2.backgroundColor = [UIColor grayColor];
    _password2.borderStyle = UITextBorderStyleRoundedRect;
    _password2.placeholder = @"密码";
    _password2.secureTextEntry = YES;
    
    UIControl *control = [[UIControl alloc]init];
    control.frame = self.view.bounds;
    control.backgroundColor = [UIColor clearColor];
    [control addTarget:self action:@selector(controlclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    
    [self.view addSubview:_slug];
    [self.view addSubview:_userNameField];
    [self.view addSubview:_password1];
    [self.view addSubview:_password2];

    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirm.frame = CGRectMake(110, 290, 100, 30);
    [confirm setTitle:@"确认提交" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
    
    UIButton *creat2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [creat2 setFrame:CGRectMake(90, 330, 130, 30)];
    [creat2 setTitle:@"我要创建活动" forState:UIControlStateNormal];
    [creat2 addTarget:self action:@selector(creatActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creat2];
    
    UIButton *manage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [manage setFrame:CGRectMake(90, 370, 130, 30)];
    [manage setTitle:@"管理我的活动" forState:UIControlStateNormal];
    [manage addTarget:self action:@selector(manageActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manage];

    
}

//获得活动ID
-(void)getIDRequest
{
    if ([label.text isEqualToString:@"活动不存在"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"活动不存在，请检查" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        [self joinActivityRequest];
    }
}


//请求加入活动
-(void)joinActivityRequest
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://hangout.org.cn/api/joinactivity"]];
    [request setHTTPMethod:@"POST"];
    NSString *joinParameter = [NSString stringWithFormat:@"id=%@&username=%@&password1=%@&password2=%@",activityid,_userNameField.text,_password1.text,_password2.text];
    NSData *parameter = [joinParameter dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:parameter];
    
    JsonSerialization *js = [[JsonSerialization alloc]initWithRequest:request];
    
    NSMutableDictionary *dict = [js getSerialized];
    for (NSString *s in [dict allKeys])
    {
        NSLog(@"%@:%@",s,[dict valueForKey:s]);
    }
    
    if ([[dict valueForKey:@"status"]  isEqual: @"2"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名重复，请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    [js release];
    [request release];
    [label release];
}

//跳转到创建事件
-(void)creatActivity
{
    CreateActViewController *cavc = [[[CreateActViewController alloc]init]autorelease];
//    NSLog(@"retain1 : %lu",(unsigned long)[cavc retainCount]);
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cavc];
//    NSLog(@"retain2 : %lu",(unsigned long)[cavc retainCount]);
    cavc.modalPresentationStyle = UIModalPresentationFullScreen;
//    NSLog(@"retain3 : %lu",(unsigned long)[cavc retainCount]);
    cavc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    NSLog(@"retain4 : %lu",(unsigned long)[cavc retainCount]);
    [self.navigationController presentViewController:nav animated:YES completion:^{
//        NSLog(@"retain5 : %lu",(unsigned long)[cavc retainCount]);
    }];
//    [nav release];
//    [cavc release];
}

//跳转到管理事件
-(void)manageActivity
{
    LoginViewController *lvc = [[[LoginViewController alloc]init]autorelease];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lvc];
    lvc.modalPresentationStyle = UIModalPresentationFullScreen;
    lvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:nav animated:YES completion:^{
        NSLog(@"登陆管理活动");
    }];
}


#pragma mark UITextViewDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hangout.org.cn/api/getID/%@",_slug.text]]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        downloadData = [[NSMutableData alloc]initWithCapacity:0];
    }
    [request release];
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
    activityid = [dict valueForKey:@"id"];
    
    if (_slug.text.length == 0) {
        [label removeFromSuperview];
        label.text = @"未填入";
        [label setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        label.textColor = [UIColor redColor];
        [self.view addSubview:label];
    }
    else if(activityid.length == 0){
        [label removeFromSuperview];
        label.text = @"活动不存在";
        [label setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        label.textColor = [UIColor redColor];
        [self.view addSubview:label];
    }
    else{
        [label removeFromSuperview];
        label.text = @"活动存在";
        [label setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        label.textColor = [UIColor greenColor];
        [self.view addSubview:label];
    }
    [connection release];
}

#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
