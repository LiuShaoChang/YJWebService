//
//  ViewController.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/7/18.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "ViewController.h"
#import "YJAPIDefines.h"
#import "DemoRequest.h"
#import "SecondViewController.h"

@interface ViewController ()<YJRequestCallBackDelegate>

@property (nonatomic, strong) DemoRequest *drequest;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nextBtn];
    
    
    NSLog(@"%@", kBaseUrl);
    [self.drequest start];
    
}

- (void)goToNextViewController {
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

#pragma mark - callback
- (void)requestWillStart:(YJBaseRequest *)request {
    NSLog(@"will start");
}

- (void)requestDidStarted:(YJBaseRequest *)request {
    NSLog(@"did start");
}

- (void)requestDidSuccess:(YJBaseRequest *)request {
    NSLog(@"did success");
}

- (void)requestDidFailed:(YJBaseRequest *)request {
    NSLog(@"did failed...:%@,error:%@", request,request.errorMessage);
}


#pragma mark - getter
- (DemoRequest *)drequest {
    if (!_drequest) {
        _drequest = [[DemoRequest alloc] init];
        _drequest.callBackDelegate = self;
    }
    return _drequest;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(100, 200, 200, 100);
        [_nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(goToNextViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
