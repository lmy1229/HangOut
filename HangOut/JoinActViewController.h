//
//  JoinActViewController.h
//  HangOut
//
//  Created by ZhangKai on 14-8-21.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinActViewController : UIViewController<NSURLConnectionDataDelegate,UITextFieldDelegate>
{    
    NSMutableData *downloadData;
    NSString *activityid;
    UILabel *label;
}

@end
