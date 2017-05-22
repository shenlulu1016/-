//
//  ViewController.m
//  HuanXinDemo
//
//  Created by 申露露 on 16/7/17.
//  Copyright © 2016年 申露露. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "FriendViewController.h"
#import <EaseMob.h>

@interface ViewController ()
@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UITextField * passwordTextField;
@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIButton * registerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"登陆界面";
    [self setUI];
}
- (void)setUI{
    UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 50)];
    userNameLabel.text = @"用户名";
    userNameLabel.font = [UIFont systemFontOfSize:25];
    userNameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userNameLabel];
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x + userNameLabel.frame.size.width + 10, userNameLabel.frame.origin.y, 250, userNameLabel.frame.size.height)];
    _userNameTextField.borderStyle = UITextBorderStyleBezel;
    _userNameTextField.placeholder = @"请输入用户名";
    _userNameTextField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_userNameTextField];
    
    UILabel * passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + 10, userNameLabel.frame.size.width, userNameLabel.frame.size.height)];
    passwordLabel.text = @"密码";
    passwordLabel.font = [UIFont systemFontOfSize:25];
    passwordLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:passwordLabel];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_userNameTextField.frame.origin.x, passwordLabel.frame.origin.y, _userNameTextField.frame.size.width, _userNameTextField.frame.size.height)];
    _passwordTextField.borderStyle = UITextBorderStyleBezel;
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_passwordTextField];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = CGRectMake(10, 300, 100, 50);
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(didClickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _registerButton.frame = CGRectMake(170, 300, 100, 50);
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(didClickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    
}
- (void)didClickLoginButton{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_userNameTextField.text password:_passwordTextField.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            //如果验证没有问题，就跳到好友界面
            [self.navigationController pushViewController:[[FriendViewController alloc] init] animated:YES];
        }else{
            NSLog(@"%@",error);
        }
    } onQueue:dispatch_get_main_queue()] ;
    
}
- (void)didClickRegisterButton{
    [self.navigationController presentViewController:[[RegisterViewController alloc] init] animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
