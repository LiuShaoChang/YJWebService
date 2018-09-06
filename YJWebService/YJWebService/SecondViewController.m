//
//  SecondViewController.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/5.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "SecondViewController.h"
#import "SecondRequest.h"

@interface SecondViewController ()<YJRequestCallBackDelegate>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) SecondRequest *secondRequest;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *refreshBtn;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"SecondVC";
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.refreshBtn];
    
    [self loadNewData];
    
}

- (void)loadNewData {
    _page = 0;
    self.secondRequest.stucuid = @(14425);
    _secondRequest.page = _page;
    [self.secondRequest start];
    
}

- (void)loadMoreData {
    _secondRequest.page = _page;
    [self.secondRequest start];
}

- (void)dealloc {
    NSLog(@"SecondViewController dealloced");
}

- (void)requestDidSuccess:(YJBaseRequest *)request {
    _page += 1;
    SecondRequest *s_request = (SecondRequest *)request;
    NSLog(@"%@", s_request.dataArr);
}

- (void)requestDidFailed:(YJBaseRequest *)request {
    NSLog(@"did failed...:%@,error:%@", request,request.errorMessage);
}

- (SecondRequest *)secondRequest {
    if (!_secondRequest) {
        _secondRequest = [[SecondRequest alloc] init];
        _secondRequest.callBackDelegate = self;
        _secondRequest.failureBlock = ^(__kindof YJBaseRequest *request) {
            NSLog(@"jj%@", request);
        };
    }
    return _secondRequest;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(100, 200, 200, 100);
        [_nextBtn setTitle:@"load more" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.frame = CGRectMake(100, 400, 200, 100);
        [_refreshBtn setTitle:@"refresh" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(loadNewData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
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
