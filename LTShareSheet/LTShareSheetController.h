//
//  LTShareSheetController.h
//  Collection
//
//  Created by 谭罗林 on 2018/3/6.
//  Copyright © 2018年 谭罗林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSheetItem : UIButton
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title imageNamed:(NSString *)imageNamed;
@end

@interface LTShareSheetController : UIViewController
+ (LTShareSheetController *)shareSheetControllerWithTitle:(NSString *)title topModels:(NSArray *)topModels botModels:(NSArray *)botModels;
@property (nonatomic, copy) void(^clickedTopAlertAction)(LTSheetItem* sheetItem,NSInteger index);
@property (nonatomic, copy) void(^clickedBotAlertAction)(LTSheetItem* sheetItem,NSInteger index);
@property (nonatomic, copy) void(^clickedCancel)(BOOL isCancel);
@end
