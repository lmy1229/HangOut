//
//  TimeTableViewController.m
//  HangOut
//
//  Created by Mark Lv on 14-10-12.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import "TimeTableViewController.h"

@interface TimeTableViewController ()

@end

@implementation TimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnclick:)];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)btnclick:(UIBarButtonItem *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
