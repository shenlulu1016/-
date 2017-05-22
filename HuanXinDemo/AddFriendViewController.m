//
//  AddFriendViewController.m
//  HuanXinDemo
//
//  Created by 申露露 on 16/7/17.
//  Copyright © 2016年 申露露. All rights reserved.
//

#import "AddFriendViewController.h"
#import <EaseMob.h>

@interface AddFriendViewController ()
@property (nonatomic, strong) UITextField * userNameTextField;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}
- (void)makeUI{
    UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 50)];
    userNameLabel.text = @"用户名";
    userNameLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:userNameLabel];
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x + userNameLabel.frame.size.width + 10, userNameLabel.frame.origin.y, 250, 50)];
    _userNameTextField.borderStyle = UITextBorderStyleBezel;
    _userNameTextField.placeholder = @"请输入用户名";
    [self.view addSubview:_userNameTextField];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(170, 250, 100, 50);
    addButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(didClickedAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}
- (void)didClickedAddButton{
    EMError * error;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_userNameTextField.text message:@"我想加你好友" error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
    }else{
        NSLog(@"%@", error);
    }
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
