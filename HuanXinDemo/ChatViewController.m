//
//  ChatViewController.m
//  HuanXinDemo
//
//  Created by 申露露 on 16/7/17.
//  Copyright © 2016年 申露露. All rights reserved.
//

#import "ChatViewController.h"
#import "DialogBoxView.h"
#import <EaseMob.h>

@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>
@property (nonatomic, strong) UITableView * listView;
@property (nonatomic, strong) DialogBoxView * dialogBoxView;
@property (nonatomic, strong) EMConversation * conversation;

@end

@implementation ChatViewController

- (void)loadView{
    [super loadView];
    self.title = _name;
    self.navigationController.navigationBar.translucent = NO;
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_listView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_listView setAllowsSelection:NO];
    [self regiisterForKeyboardNotifications];
    _dialogBoxView = [[DialogBoxView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50)];
    
    __weak typeof(self) weakSelf = self;
    _dialogBoxView.buttonClicked = ^(NSString * draftText){
        [weakSelf sendMessageWithDraftText:draftText];
    };
    [self.view addSubview:_dialogBoxView];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self reloadChatRecords];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移出通知中心
    [self removeForKeyboardNotifications];
    //移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
//使用草稿发送一条信息
- (void)sendMessageWithDraftText:(NSString *)draftText{
    EMChatText * chatText = [[EMChatText alloc] initWithText:draftText];
    EMTextMessageBody * body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    //生成message
    EMMessage * message = [[EMMessage alloc] initWithReceiver:self.name bodies:@[body]];
    message.messageType = eMessageTypeChat;//设置为单聊消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        //准备发送
    } onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        [self reloadChatRecords];
        //发送完成
    } onQueue:dispatch_get_main_queue()];
    
}
//当收到一条消息
- (void)didReceiveMessage:(EMMessage *)message{
    [self reloadChatRecords];
}
//重新加载tableview上面显示的聊天信息，并移到最后一条
- (void)reloadChatRecords{
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.name conversationType:eConversationTypeChat];
    
    [_listView reloadData];
    if ([_conversation loadAllMessages].count > 0) {
        [_listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_conversation loadAllMessages].count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}
#pragma mark KeyBoard Method
//注册通知中心
- (void)regiisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//移出通知中心
- (void)removeForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//键盘将要弹出
- (void)didKeyboardWillShow:(NSNotification *)notification{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSLog(@"%f", keyboardSize.height);
    //输入框位置动画加载
    [self beginMoveUpAnimation:keyboardSize.height];
}
//键盘将要隐藏
- (void)didKeyboardWillHide:(NSNotification *)notification{
    [self beginMoveUpAnimation:0];
}
//开始执行键盘改变后对应视图的变化
- (void)beginMoveUpAnimation:(CGFloat)height{
    [UIView animateWithDuration:0.3 animations:^{
        [_dialogBoxView setFrame:CGRectMake(0, self.view.frame.size.height - (height + 40), _dialogBoxView.frame.size.width, _dialogBoxView.frame.size.height)];
    }];
    
    [_listView layoutIfNeeded];
    
    if ([_conversation loadAllMessages].count > 1) {
        [_listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_conversation.loadAllMessages.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
        
    }
}
#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _conversation.loadAllMessages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    EMMessage * message = _conversation.loadAllMessages[indexPath.row];
    EMTextMessageBody * body = [message.messageBodies lastObject];
    //判断发送的人是否为当前聊天的人，左边是对方发过来的，右边是自己发过去的
    if ([message.to isEqualToString:self.name]) {
        cell.detailTextLabel.text = body.text;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.text = @"";
        cell.textLabel.textColor = [UIColor blueColor];
    }else{
        cell.detailTextLabel.text = @"";
        cell.textLabel.text = body.text;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.textColor = [UIColor blueColor];
    }
    return cell;
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
