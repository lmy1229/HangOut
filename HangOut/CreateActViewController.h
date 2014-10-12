//
//  CreateActViewController.h
//  HangOut
//
//  Created by ZhangKai on 14-8-21.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateActViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

-(void)keyboardDismiss;
-(void)btnPressed:(UIButton *)btn;
-(void)switchChanged:(UISwitch *)swh;
-(void)bbiClicked;


@end
