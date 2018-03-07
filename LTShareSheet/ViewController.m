//
//  ViewController.m
//  LTShareSheet
//
//  Created by 谭罗林 on 2018/3/7.
//  Copyright © 2018年 谭罗林. All rights reserved.
//

#import "ViewController.h"
#import "LTShareSheetController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 120;
    CGFloat h = 60;
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(x, y, w, h);
    shareBtn.center = self.view.center;
    shareBtn.backgroundColor = [UIColor blackColor];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
}

#pragma mark - Actions
- (void)shareAction:(id)sender {
    
    NSArray *images = @[@"toutiao",@"wechat",@"friendcircle",@"tencent",@"systemshare",@"copylink"];
    NSArray *titles = @[@"转发",@"微信",@"朋友圈",@"QQ",@"系统分享",@"复制链接"];
    
    NSArray *image1s = @[@"systemshare",@"message",@"email",@"copylink"];
    NSArray *title1s = @[@"系统",@"短信",@"邮箱",@"复制链接"];
    
    NSMutableArray *topModels = [NSMutableArray array];
    for (NSInteger i=0; i<images.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = titles[i];
        dict[@"image"] = images[i];
        [topModels addObject:dict];
    }
    
    NSMutableArray *botModels = [NSMutableArray array];
    for (NSInteger i=0; i<image1s.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = title1s[i];
        dict[@"image"] = image1s[i];
        [botModels addObject:dict];
    }
    
    LTShareSheetController *sheetVC = [LTShareSheetController shareSheetControllerWithTitle:nil topModels:topModels botModels:botModels];
    //__block typeof(self) blockSelf = self;
    sheetVC.clickedTopAlertAction = ^(LTSheetItem *sheetItem, NSInteger index) {
        
    };
    
    sheetVC.clickedBotAlertAction = ^(LTSheetItem *sheetItem, NSInteger index) {
        
    };
    [self presentViewController:sheetVC animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
