//
//  AllMethod.h
//  图片处理
//
//  Created by yangjian on 2017/2/23.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

@interface AllMethod : NSObject

+ (UIBarButtonItem *)getButtonBarItemWithImageName:(NSString *)str andSelect:(SEL)select andTarget:(id)obj;
+ (UIBarButtonItem *)getButtonBarItemWithTitle:(NSString *)str andSelect:(SEL)select andTarget:(id)obj;
+ (UIBarButtonItem *)getButtonBarItemWithImageName:(NSString *)str andTitle:(NSString *)tit andSelect:(SEL)select andTarget:(id)obj;
+(UIBarButtonItem *)getLeftButtonBarItemSelect:(SEL)select andTarget:(id)obj;

+ (void)showAltMsg:(NSString *)msg WithController:(UIViewController *)viewController WithAction:(void (^ __nullable)(UIAlertAction *action))action;



/**
 获取当前日期

 @param dateFormatter 日期格式：yyyy-MM-dd 、yyyy年MM月dd日 。。。
 @return 返回日期
 */
+(NSString *)getNowDateWithFormatter:(NSString *) dateFormatter;

/**
 更改日期格式

 @param dateStr 需要修改的日期
 @param formatter 现格式    @"yyyy年MM月dd日"
 @param n_Formatter 需修改格式   @"yyyy-MM-dd"
 @return 修改好的日期
 */
+(NSString *)changeDateMethod:(NSString *)dateStr From:(NSString *)formatter To:(NSString *)n_Formatter;
+(NSString *)changeDateWay:(NSDate*)date To:(NSString *)n_Formatter;

//转化编码
+(NSString*)encodeString:(NSString*)unencodedString;
//计算label的宽高
+(CGSize)sizeWithString: (NSString *)str fontSize:(int)fontSize maxSizeX:(CGFloat )maxSizeX maxSizeY:(CGFloat)maxSizeY;


/**
 更改数据库返回来的时间格式，

 @param oldTimeStr 后台返回来的类似于1502949763这样的时间格式
 @param Formatter 想输出的样式 yyyy-MM-dd HH:mm:ss
 @return string类型的时间
 */
+(NSString *)changeMethodFromSQL:(NSString *)oldTimeStr With:(NSString *)Formatter;


+(MJRefreshGifHeader *)createTableViewHeader:(id)obj andSelect:(SEL)select;

+(MJRefreshAutoGifFooter *)createTableViewFooter:(id)obj andSelect:(SEL)select;

@end
