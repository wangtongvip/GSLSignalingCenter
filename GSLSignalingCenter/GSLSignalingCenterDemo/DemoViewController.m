//
//  DemoViewController.m
//  GSLSignalingCenter
//
//  Created by wangtong on 2019/7/9.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import "DemoViewController.h"
#import <GSLSignalingCenterFramework/GSLSignalingCenterFramework.h>

@interface DemoViewController ()<GSLSignalingCenterDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    GSLSignalingCenter *_signalingCenter;
    NSArray *_users;
    UIPickerView *_selectPicker;
}

@property (weak, nonatomic) IBOutlet UITextField *appIdTF;
@property (weak, nonatomic) IBOutlet UITextField *roomIdTF;
@property (weak, nonatomic) IBOutlet UITextField *userIdTF;
@property (weak, nonatomic) IBOutlet UITextField *tokenTF;
@property (weak, nonatomic) IBOutlet UILabel *connectInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *targetUserIdTF;
@property (weak, nonatomic) IBOutlet UITextView *messageTV;

@end

@implementation DemoViewController

- (void)dealloc {
    //NSLog(@"FirstViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GSLSignalingCenter openDebugLogInfo:YES];
    _signalingCenter = [[GSLSignalingCenter alloc] init];
    [_signalingCenter registDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_signalingCenter removeDelegate:self];
    [_signalingCenter disConnect];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.selectPicker setFrame:self.view.bounds];
}

- (IBAction)connectAction:(id)sender {
    NSError *error;
    [_signalingCenter connectWithAppId:self.appIdTF.text
                                roomId:self.roomIdTF.text
                                 token:self.tokenTF.text
                              userFlag:self.userIdTF.text
                              userRole:@"teacher"
                             groupFlag:@"all"
                                 error:&error];
    if (error) {
        [self showAlert:[NSString stringWithFormat:@"%@", error.description]];
    }
}

- (IBAction)inviteAction:(id)sender {
    // 邀请连麦
    NSString *sub_type = @"INVITE_LINK";
    NSDictionary *body = @{@"user" : @{@"userId" : [NSString stringWithFormat:@"%@",self.targetUserIdTF.text]}};
    [_signalingCenter sendMessageToUserWithType:GSLSignalingMessageTypeLive subType:sub_type userId:self.targetUserIdTF.text userRole:@"student" body:body];
}

- (IBAction)breakLinkAction:(id)sender {
    // 将某人下麦
    NSString *sub_type = @"BREAK_LINK";
    NSDictionary *body = @{@"user" : @{@"userId" : [NSString stringWithFormat:@"%@",self.targetUserIdTF.text]}};
    [_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeLive subType:sub_type groupId:@"all" body:body];
}

- (IBAction)banAudioAction:(id)sender {
    // 禁音
    NSString *sub_type = @"BAN_AUDIO";
    NSDictionary *body = @{@"user" : @{@"userId" : [NSString stringWithFormat:@"%@",self.targetUserIdTF.text]}, @"status" : @(YES)};
    [_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeLive subType:sub_type groupId:@"all" body:body];
}

- (IBAction)unBanAudioAction:(id)sender {
    // 解除禁音
    NSString *sub_type = @"BAN_AUDIO";
    NSDictionary *body = @{@"user" : @{@"userId" : [NSString stringWithFormat:@"%@",self.targetUserIdTF.text]}, @"status" : @(NO)};
    [_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeLive subType:sub_type groupId:@"all" body:body];
}

- (IBAction)banVideoAction:(id)sender {
    // 禁画
    NSString *sub_type = @"BAN_VIDEO";
    NSDictionary *body = @{@"user" : @{@"userId" : [NSString stringWithFormat:@"%@",self.targetUserIdTF.text]}, @"status" : @(YES)};
    [_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeLive subType:sub_type groupId:@"all" body:body];
}

- (IBAction)unBanVideoAction:(id)sender {
    // 解除禁画
    NSString *sub_type = @"BAN_VIDEO";
    NSDictionary *body = @{@"user" : @{@"userId" : [NSString stringWithFormat:@"%@",self.targetUserIdTF.text]}, @"status" : @(NO)};
    [_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeLive subType:sub_type groupId:@"all" body:body];
}

- (IBAction)sendMessageToUser:(id)sender {
    // 发送单聊消息
    NSString *sub_type = @"message";
    NSDictionary *body = @{@"text" : [NSString stringWithFormat:@"%@", self.messageTV.text]};
    [_signalingCenter sendMessageToUserWithType:GSLSignalingMessageTypeCustom subType:sub_type userId:self.targetUserIdTF.text userRole:@"student" body:body];
}

- (IBAction)sendMessageToGroup:(id)sender {
    // 发送群聊消息
    NSString *sub_type = @"message";
    NSDictionary *body = @{@"text" : [NSString stringWithFormat:@"%@", self.messageTV.text]};
    [_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeCustom subType:sub_type groupId:@"all" body:body];
}

- (IBAction)getUserList:(id)sender {
    NSString *sub_type = @"GET_USER_LIST";
    NSDictionary *body = @{};
    [_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeExtra subType:sub_type groupId:@"all" body:body];
}

#pragma mark- GSLSignalingCenterDelegate

- (void)signalingCenter:(id)center onError:(NSError *)error{
    //NSLog(@"信令出错 : %@",error.description);
    [self showAlert:error.description];
}

- (void)signalingCenter:(id)center connectSuccess:(BOOL)success{
    //NSLog(@"信令连接状态 : %d",success);
    self.connectInfoLabel.text = success ? @"信令连接成功" : @"信令连接失败";
}

- (void)signalingCenter:(id)center didReceiveMessageWithType:(GSLSignalingMessageType)messageType messageBody:(NSDictionary *)body {
    //NSLog(@"收到消息：%@",body);
    //NSDictionary *content = [message objectForKey:@"content"];
    NSString *subMessageType = [NSString stringWithFormat:@"%@", body[@"subType"]];
    if (messageType == GSLSignalingMessageTypeLive) {
        if ([subMessageType isEqualToString:@"APPLY_LINK"]) {
            if ([[NSString stringWithFormat:@"%@", body[@"targetUserFlag"]] isEqualToString:[NSString stringWithFormat:@"%@", self.userIdTF.text]]) {
                [self reciveApplyMessage:[NSString stringWithFormat:@"%@", body[@"userFlag"]]];
            }
        } else if ([subMessageType isEqualToString:@"REFUSE_INVITE_LINK"]) {
            [self showAlert:[NSString stringWithFormat:@"%@拒绝了您的连麦邀请",body[@"userFlag"]]];
        }  else if ([subMessageType isEqualToString:@"AGREE_INVITE_LINK"]) {
            [self showAlert:[NSString stringWithFormat:@"%@接受了您的连麦邀请",body[@"userFlag"]]];
        }
    }
}

- (void)reciveApplyMessage:(NSString *)userFlag {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到了%@的连麦申请", userFlag] message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝连麦申请" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        // 拒绝申请
        NSString *sub_type = @"REFUSE_APPLY_LINK";
        NSDictionary *body = @{@"user" : @{@"userId" : [NSString stringWithFormat:@"%@",userFlag]}};
        [strongSelf->_signalingCenter sendMessageToUserWithType:GSLSignalingMessageTypeLive subType:sub_type userId:[NSString stringWithFormat:@"%@",userFlag] userRole:@"student" body:body];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"同意连麦申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        // 同意申请
        NSString *sub_type = @"AGREE_APPLY_LINK";
        NSDictionary *body = @{@"user" : @{@"userId" : userFlag}};
        [strongSelf->_signalingCenter sendMessageToGroupWithType:GSLSignalingMessageTypeLive subType:sub_type groupId:@"all" body:body];
    }]];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark- getter

- (UIPickerView *)selectPicker {
    if (!_selectPicker) {
        _selectPicker = [[UIPickerView alloc] initWithFrame:self.view.frame];
        _selectPicker.delegate = self;
        _selectPicker.dataSource = self;
        [_selectPicker setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9f]];
    }
    return _selectPicker;
}

#pragma mark- selectParamsMethods

- (IBAction)selectParams:(id)sender {
    if (self.selectPicker.superview) {
        [self.selectPicker removeFromSuperview];
    } else {
        if ([self loadJsonConfig]) {
            [self.view addSubview:self.selectPicker];
        }
    }
}

- (BOOL)loadJsonConfig {
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"paramsConfiguration" ofType:@"json"];
    if (configPath == nil) return NO;
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:configPath];
    [stream open];
    NSError *error = nil;
    NSDictionary *config = [NSJSONSerialization JSONObjectWithStream:stream options:0 error:&error];
    [stream close];
    if (config == nil) {
        NSLog(@"Error when loading config at %@: %@", configPath, error);
        return NO;
    }
    _users = [NSArray arrayWithArray:config[@"users"]];
    return YES;
}

#pragma mark - UIPickerView DataSource and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_users count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 46;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _users[row][@"userId"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _appIdTF.text = [NSString stringWithFormat:@"%@", _users[row][@"appId"]];
    _roomIdTF.text = [NSString stringWithFormat:@"%@", _users[row][@"roomId"]];
    _userIdTF.text = [NSString stringWithFormat:@"%@", _users[row][@"userId"]];
    _tokenTF.text = [NSString stringWithFormat:@"%@", _users[row][@"userToken"]];
    
    [self.selectPicker removeFromSuperview];
}

@end
