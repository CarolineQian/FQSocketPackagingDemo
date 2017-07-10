//
//  ViewController.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "ViewController.h"
#import "FQConnectTest.h"
#import "FQTestConnect.h"

@interface ViewController ()
{
    UIButton       *_openButton;
    UITextView     *_showMessageTextView;
    FQConnectTest  *_testConnect;
    FQTestConnect  *_test;
    
    UIButton       *_testButton;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    //_openButton
    _openButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 50, 150, 30)];
    _openButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_openButton setTitle:@"连接并发送请求1" forState:UIControlStateNormal];
    [_openButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_openButton addTarget:self action:@selector(openButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_openButton];
    
    //测试
    _testButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 50, 150, 30)];
    _testButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_testButton setTitle:@"发送请求2" forState:UIControlStateNormal];
    [_testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_testButton];
    
    //
    _showMessageTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 100, 300, 350)];
    _showMessageTextView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_showMessageTextView];
    
    //
    _testConnect = [FQConnectTest connect];
    _test = [FQTestConnect connect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Actions
//点击网络请求
- (void)openButtonAction
{
    [self sendConnect:@"fengqian" withPassCode:@"FqPwd123456" withCountryCode:@"abcdefg" withType:1];
}

- (void)testButtonAction
{
    [self sendConnect1:@"ren" withPassCode:@"RPwd123456" withCountryCode:@"abcdefg" withType:1];
}

#pragma mark - NetWork
- (void)sendConnect:(NSString *)name withPassCode:(NSString *)passCode withCountryCode:(NSString *)countryCode withType:(SInt32)type
{
    [_testConnect sendWithUser:name withPassworld:passCode withType:type withCountryCode:countryCode withCompleted:^(FQBaseConnect *con)
    {
        NSLog(@"冯");
        if(con.code == FQConnectErrorTypeOfConnectFail)
        {
            _showMessageTextView.text = [NSString stringWithFormat:@"请求失败"];
        }
        else
        {
            _showMessageTextView.text = [NSString stringWithFormat:@"请求成功,状态码是%d,内容是%@",con.code,con.message];
                                             
        }
    }];
}

#pragma mark - 测试
- (void)sendConnect1:(NSString *)name withPassCode:(NSString *)passCode withCountryCode:(NSString *)countryCode withType:(SInt32)type
{
    [_test sendWithUser1:name withPassworld1:passCode withType1:type withCountryCode1:countryCode withCompleted1:^(FQBaseConnect *con)
     {
         NSLog(@"任");
         if(con.code == -1111111)
         {
             _showMessageTextView.text = [NSString stringWithFormat:@"请求失败"];
         }
         else
         {
             _showMessageTextView.text = [NSString stringWithFormat:@"请求成功,状态码是%d,内容是%@",con.code,con.message];
             
         }
         
     }];
}




@end
