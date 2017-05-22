//
//  FriendViewController.m
//  HuanXinDemo
//
//  Created by 申露露 on 16/7/17.
//  Copyright © 2016年 申露露. All rights reserved.
//

#import "FriendViewController.h"
#import "AddFriendViewController.h"
#import "ChatViewController.h"
#import <EaseMob.h>

@interface FriendViewController ()<UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate, EMChatManagerBuddyDelegate>
{
    NSMutableArray * dataArray;
    UITableView * listView;
}
@end

@implementation FriendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    //左侧注销按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelButton)];
    self.title = @"好友";
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            NSLog(@"获取成功－－－%@", buddyList);
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:buddyList];
            [listView reloadData];
        }
    } onQueue:dispatch_get_main_queue()];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked)];
    [self makeTableView];
    //签协议
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (void)makeTableView{
    listView = [[UITableView alloc] initWithFrame:self.view.frame];
    listView.delegate = self;
    listView.dataSource = self;
    listView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:listView];
}
#pragma mark 注销按钮事件
- (void)didClickedCancelButton{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 添加按钮事件
- (void)addButtonClicked{
    [self.navigationController pushViewController:[[AddFriendViewController alloc] init] animated:YES];
}
#pragma mark TableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [listView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    EMBuddy * buddy = dataArray[indexPath.row];
    cell.textLabel.text = buddy.username;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatViewController * chat = [[ChatViewController alloc] init];
    EMBuddy * buddy = dataArray[indexPath.row];
    chat.name = buddy.username;
    [self.navigationController pushViewController:chat animated:YES];
}
#pragma mark EaseMob Delegate
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"受到来自%@请求", username] message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        EMError * error;
        //同意好友请求的方法
        if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error] && !error) {
            NSLog(@"发送同意成功");
            [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
                if (!error) {
                    NSLog(@"获取成功－－－%@",buddyList);
                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:buddyList];
                    [listView reloadData];
                }
            } onQueue:dispatch_get_main_queue()];
        }
    }];
    UIAlertAction * rejectAction = [UIAlertAction actionWithTitle:@"不同意" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        EMError * error;
        //拒绝好友请求的方法
        if ([[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"不想同意" error: &error] && !error) {
            NSLog(@"拒绝发送成功");
        }
    }];
    [alertVC addAction:acceptAction];
    [alertVC addAction:rejectAction];
    [self showDetailViewController:alertVC sender:nil];
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
