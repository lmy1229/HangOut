//
//  MAVCSettingView.m
//  HangOut
//
//  Created by ZhangKai on 14-9-26.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import "MAVCSettingView.h"

@implementation MAVCSettingView
{
    UILabel *_chatLabel;
    UILabel *_posiLabel;
    UILabel *_timeLabel;
    UIButton *_confirmBtn;
}

@synthesize chatSwitch = _chatSwitch,posiSwitch = _posiSwitch,timeSwitch = _timeSwitch,MAVCSettingDelegate = _MAVCSettingDelegate;
@synthesize timeCount = _timeCount, chatCount = _chatCount, posiCount = _posiCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _chatCount = 0;
        _posiCount = 0;
        _timeCount = 0;
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 100, 60)];
        _timeLabel.text = @"时间表";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        [self addSubview:_timeLabel];
        
        _timeSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(185, 20, 120, 30)];
        _timeSwitch.tag = 1;
        [_timeSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_timeSwitch];
        
        _chatLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 70, 100, 60)];
        _chatLabel.text = @"聊天室";
        _chatLabel.textAlignment = NSTextAlignmentCenter;
        _chatLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        [self addSubview:_chatLabel];
        
        _chatSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(185, 85, 120, 30)];
        _chatSwitch.tag = 2;
        [_chatSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_chatSwitch];
        
        _posiLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 135, 100, 60)];
        _posiLabel.text = @"位置共享";
        _posiLabel.textAlignment = NSTextAlignmentCenter;
        _posiLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        [self addSubview:_posiLabel];
        
        _posiSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(185, 150, 120, 30)];
        _posiSwitch.tag = 3;
        [_posiSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_posiSwitch];
        
//        CGRectMake(5, 5, 310, 60)
//        CGRectMake(5, 70, 310, 60)
//        CGRectMake(5, 135, 310, 60)
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_confirmBtn setTitle:@"返回" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        _confirmBtn.tag = 99;
        _confirmBtn.frame = CGRectMake(40, 190, 240, 60);
        [_confirmBtn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
        
    }
    return self;
}


-(void)valueChanged:(UISwitch *)iSwitch
{
    if(iSwitch.tag == 1)
    {
        _timeCount ++;
    }
    else if (iSwitch.tag == 2)
    {
        _chatCount ++;
    }
    else if(iSwitch.tag == 3)
    {
        _posiCount ++;
    }
    if( _posiCount%2==1 || _chatCount%2==1 || _timeCount%2==1)
    {
        [_confirmBtn setTitle:@"确认更改" forState:UIControlStateNormal];
    }
    else
    {
        [_confirmBtn setTitle:@"返回" forState:UIControlStateNormal];
    }
}

-(void)btnPressed
{
    [_MAVCSettingDelegate dataUpdate];
    [self reboot];
}

-(void)reboot
{
    _chatCount = 0;
    _posiCount = 0;
    _timeCount = 0;
    [_confirmBtn setTitle:@"返回" forState:UIControlStateNormal];
}

-(void)dealloc
{
    [_chatLabel release];
    [_posiLabel release];
    [_timeLabel release];
    [_chatSwitch release];
    [_posiSwitch release];
    [_timeSwitch release];
    [_confirmBtn release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
