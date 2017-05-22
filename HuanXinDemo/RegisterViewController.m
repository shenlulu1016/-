//
//  RegisterViewController.m
//  HuanXinDemo
//
//  Created by 申露露 on 16/7/17.
//  Copyright © 2016年 申露露. All rights reserved.
//

#import "RegisterViewController.h"
#import <EaseMob.h>

@interface RegisterViewController ()
@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UITextField * passwordTextField;
@property (nonatomic, strong) UIButton * registerButton;
@property (nonatomic, strong) UIButton * backButton;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"注册界面";
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
    
    
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _registerButton.frame = CGRectMake(10, 280, 100, 50);
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(didClickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _backButton.frame = CGRectMake(170, 280, 100, 50);
    _backButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
}
//点击屏幕让键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
- (void)didClickRegisterButton:(id)sender{
    //登录注册有三种方法，1.同步方法。2.通过delegate回调的异步方法。3.block异步方法
    //这里使用block
    
    //开始注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_userNameTextField.text password:_passwordTextField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"%@",error);
        }
    } onQueue:dispatch_get_main_queue()];
    
}
- (void)didClickBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
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
