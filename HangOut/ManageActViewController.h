//
//  ManageActViewController.h
//  HangOut
//
//  Created by ZhangKai on 14-8-28.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAVCSettingView.h"

@interface ManageActViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextViewDelegate,MAVCSettingViewDelegate>

@property (nonatomic) BOOL isAdmin;
@property (strong,nonatomic) NSString *ID;
@property (strong,nonatomic) NSString *userName;

@end
