//
//  LTShareSheetController.m
//  Collection
//
//  Created by 谭罗林 on 2018/3/6.
//  Copyright © 2018年 谭罗林. All rights reserved.
//

#import "LTShareSheetController.h"
#import "UIView+MJExtension.h"

#define KScreenWidth      [UIScreen mainScreen].bounds.size.width
#define KScreenHeight     [UIScreen mainScreen].bounds.size.height
#define KSheetItemW 56
#define KSheetItemH 80
#define KLeftRightW 24
#define KEdgeWidth  12

@interface LTSheetItem ()

@end

@implementation LTSheetItem

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title imageNamed:(NSString *)imageNamed {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
        imageView.image = [UIImage imageNamed:imageNamed];
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, frame.size.width+6, frame.size.width, 18);
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:10.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    return self;
}

@end

@interface LTShareSheetController ()
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSArray *tops;
@property (nonatomic, copy) NSArray *bots;

@property (nonatomic, strong) NSMutableArray *topItems;
@property (nonatomic, strong) NSMutableArray *botItems;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) UIScrollView *scrollView2;
@end

@implementation LTShareSheetController

+ (LTShareSheetController *)shareSheetControllerWithTitle:(NSString *)title topModels:(NSArray *)topModels botModels:(NSArray *)botModels {
    
    LTShareSheetController *sheetVC = [[LTShareSheetController alloc] initWithTitle:title topModels:topModels botModels:botModels];
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    return sheetVC;
}

- (instancetype)initWithTitle:(NSString *)title topModels:(NSArray *)topModels botModels:(NSArray *)botModels {
    self = [super init];
    if (self) {
        
        _titleName = title;
        _tops = topModels;
        _bots = botModels;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
    [self.topItems removeAllObjects];
    [self.botItems removeAllObjects];
    
    //第一行
    UIScrollView *scrollView1 = [[UIScrollView alloc] init];
    scrollView1.frame = CGRectMake(0, 0, KScreenWidth, KLeftRightW+KLeftRightW/1.5+KSheetItemH);
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.showsHorizontalScrollIndicator = NO;
    
    
    CGFloat w = KSheetItemW;
    CGFloat h = w+(KSheetItemH-KSheetItemW);
    CGFloat x = KLeftRightW;
    CGFloat y = KLeftRightW;
    LTSheetItem *lastItem = nil;
    for (NSInteger i=0; i<_tops.count; i++) {
        
        NSDictionary *dict = _tops[i];
        LTSheetItem *alertAction = [[LTSheetItem alloc] initWithFrame:CGRectMake(x, y, w, h) withTitle:dict[@"title"] imageNamed:dict[@"image"]];
        alertAction.tag = i;
        [alertAction addTarget:self action:@selector(topItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView1 addSubview:alertAction];
        x += w+KEdgeWidth;
        
        //拿到最后的X值
        if (i==_tops.count-1) {
            lastItem = alertAction;
        }
        [self.topItems addObject:alertAction];
    }
    scrollView1.contentSize = CGSizeMake(CGRectGetMaxX(lastItem.frame)+KLeftRightW, scrollView1.mj_h);
    _scrollView1 = scrollView1;

    
    //第二行
    UIScrollView *scrollView2 = [[UIScrollView alloc] init];
    scrollView2.frame = scrollView1.frame;
    scrollView2.mj_y = scrollView1.mj_h;
    scrollView2.showsVerticalScrollIndicator = NO;
    scrollView2.showsHorizontalScrollIndicator = NO;
    
    
    w = KSheetItemW;
    h = w+(KSheetItemH-KSheetItemW);
    x = KLeftRightW;
    y = KLeftRightW/1.5;
    lastItem = nil;
    for (NSInteger i=0; i<_bots.count; i++) {
        
        NSDictionary *dict = _bots[i];
        LTSheetItem *alertAction = [[LTSheetItem alloc] initWithFrame:CGRectMake(x, y, w, h) withTitle:dict[@"title"] imageNamed:dict[@"image"]];
        alertAction.tag = i;
        [alertAction addTarget:self action:@selector(botItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView2 addSubview:alertAction];
        x += w+KEdgeWidth;
        
        //拿到最后的X值
        if (i==_bots.count-1) {
            lastItem = alertAction;
        }
        [self.botItems addObject:alertAction];
    }
    scrollView2.contentSize = CGSizeMake(CGRectGetMaxX(lastItem.frame)+KLeftRightW, scrollView1.mj_h);
    _scrollView2 = scrollView2;
    
    [self.contentView addSubview:scrollView1];
    [self.contentView addSubview:scrollView2];
    
    x = 0;
    h = 50;
    y = scrollView1.mj_h*2;
    w = KScreenWidth;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, w, h);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(KLeftRightW, scrollView1.mj_h+5, KScreenWidth-KLeftRightW*2, 0.5);
    line.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:0.8];
    [self.contentView addSubview:line];
    
    line = [[UIView alloc] init];
    line.frame = CGRectMake(0, y, KScreenWidth, 0.5);
    line.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:0.8];
    [_contentView addSubview:line];
    
    
    x = 0;
    y = KScreenHeight;
    w = KScreenWidth;
    h = scrollView1.mj_h*2+button.mj_h;
    self.contentView.frame = CGRectMake(x, y, w, h);
    _height = h;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(0, KScreenHeight-_height, KScreenWidth, _contentView.frame.size.height);
        
        //动画效果
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        
        for (NSInteger i=0; i<self.topItems.count; i++) {
            LTSheetItem *action = self.topItems[i];
            action.mj_y = KLeftRightW+action.mj_h;
    
            dispatch_async(queue, ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIView animateWithDuration:0.3f+i/30.f animations:^{
                        action.mj_y = KLeftRightW;
                        action.transform = CGAffineTransformTranslate(action.transform, 0, -10);
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.2f animations:^{
                            
                            action.transform = CGAffineTransformTranslate(action.transform, 0, 10);
                        }];
                    }];
                });
            });
        }
        
        for (NSInteger i=0; i<self.botItems.count; i++) {
            LTSheetItem *action = self.botItems[i];
            action.mj_y = KLeftRightW/1.5+action.mj_h;
            dispatch_async(queue, ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    [UIView animateWithDuration:0.3f+i/30.f animations:^{
                        action.mj_y = KLeftRightW/1.5;
                        action.transform = CGAffineTransformTranslate(action.transform, 0, -10);
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.2f animations:^{
                            
                            action.transform = CGAffineTransformTranslate(action.transform, 0, 10);
                        }];
                    }];
                });
            });
        }
        
    } completion:^(BOOL finished) {
    
    }];
}

#pragma mark - Actions
- (void)topItemAction:(LTSheetItem *)sheetItem {
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, _contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.clickedTopAlertAction) {
                self.clickedTopAlertAction(sheetItem, sheetItem.tag);
            }
        }];
    }];
}
- (void)botItemAction:(LTSheetItem *)sheetItem {
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, _contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.clickedBotAlertAction) {
                self.clickedBotAlertAction(sheetItem, sheetItem.tag);
            }
        }];
    }];
}
- (void)cancelAction {
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, _contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.clickedCancel) {
                self.clickedCancel(YES);
            }
        }];
    }];
}


#pragma mark - 赖加载

- (NSMutableArray *)topItems {
    if (_topItems) {
        return _topItems;
    }
    _topItems = [NSMutableArray array];
    return _topItems;
}
- (NSMutableArray *)botItems {
    if (_botItems) {
        return _botItems;
    }
    _botItems = [NSMutableArray array];
    return _botItems;
}

- (UIView *)backgroundView {
    if (_backgroundView) {
        return _backgroundView;
    }
    _backgroundView = [[UIView alloc] init];
    _backgroundView.frame = self.view.bounds;
    _backgroundView.alpha = 0.3;
    _backgroundView.userInteractionEnabled = YES;
    _backgroundView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(cancelAction)];
    [_backgroundView addGestureRecognizer:tap];
    return _backgroundView;
}

- (UIView *)contentView {
    if (_contentView) {
        return _contentView;
    }
    _contentView = [[UIView alloc] init];
    _contentView.alpha = 1;
    _contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    
    CGFloat x = 0;
    CGFloat y = KScreenHeight;
    CGFloat w = KScreenWidth;
    CGFloat h = 1;
    _contentView.frame = CGRectMake(x, y, w, h);
    
    return _contentView;
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
