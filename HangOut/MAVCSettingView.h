//
//  MAVCSettingView.h
//  HangOut
//
//  Created by ZhangKai on 14-9-26.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAVCSettingViewDelegate <NSObject>
-(void)dataUpdate;
@end

@interface MAVCSettingView : UIView
{
    UISwitch *_chatSwitch;
    UISwitch *_posiSwitch;
    UISwitch *_timeSwitch;
    int _chatCount;
    int _posiCount;
    int _timeCount;
    id<MAVCSettingViewDelegate> _MAVCSettingDelegate;
}

-(void)btnPressed;
-(void)reboot;

@property (nonatomic,strong) UISwitch *chatSwitch;
@property (nonatomic,strong) UISwitch *posiSwitch;
@property (nonatomic,strong) UISwitch *timeSwitch;
@property (nonatomic) int chatCount;
@property (nonatomic) int posiCount;
@property (nonatomic) int timeCount;
@property (nonatomic,assign) id<MAVCSettingViewDelegate> MAVCSettingDelegate;

@end
