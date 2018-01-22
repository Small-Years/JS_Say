//
//  AllMethod.m
//  图片处理
//
//  Created by yangjian on 2017/2/23.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "AllMethod.h"

@implementation AllMethod

+(UIBarButtonItem *)getLeftButtonBarItemSelect:(SEL)select andTarget:(id)obj{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setImage:[UIImage imageNamed:@"jd_done_icon"] forState:UIControlStateNormal];
    [btn addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)getButtonBarItemWithImageName:(NSString *)str andSelect:(SEL)select andTarget:(id)obj{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [btn addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)getButtonBarItemWithTitle:(NSString *)str andSelect:(SEL)select andTarget:(id)obj{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 17*[str length]+10, 32);
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:RGB(126, 185, 255) forState:UIControlStateNormal];
    [btn.titleLabel sizeToFit];
    [btn addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)getButtonBarItemWithImageName:(NSString *)str andTitle:(NSString *)tit andSelect:(SEL)select andTarget:(id)obj{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 30);
    [leftButton setImage:[UIImage imageNamed:@"whitebutton2"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [leftButton addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    return leftItem;
}


+ (void)showAltMsg:(NSString *)msg WithController:(UIViewController *)viewController WithAction:(void (^ _Nullable)(UIAlertAction *))cancleAction {
    if([msg isEqual:@""]||msg==nil){
        return;
    }
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:cancleAction];
    [controller addAction:cancle];
    
    
    
    [viewController presentViewController:controller animated:YES completion:nil];
    
}







+(NSString *)getNowDateWithFormatter:(NSString *)dateFormatter{
//    dateFormatter格式：yyyy-MM-dd 、yyyy年MM月dd日 。。。
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

+(NSString *)changeDateMethod:(NSString *)dateStr From:(NSString *)formatter To:(NSString *)n_Formatter{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSDate *date = [dateformatter dateFromString:dateStr];
    [dateformatter setDateFormat:n_Formatter];
    dateStr = [dateformatter stringFromDate:date];
    return dateStr;
}
+(NSString *)changeDateWay:(NSDate *)date To:(NSString *)n_Formatter{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:n_Formatter];
    NSString *dateStr = [dateformatter stringFromDate:date];
    return dateStr;
}
//转化编码
+(NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

//计算文本的宽高，(字符串、字号、最大宽度、最大高度)
+(CGSize)sizeWithString: (NSString *)str fontSize:(int)fontSize maxSizeX:(CGFloat )maxSizeX maxSizeY:(CGFloat)maxSizeY {
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize maxSize = CGSizeMake(maxSizeX, maxSizeY);
    CGSize textsize= [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textsize;
}


+(NSString *)changeMethodFromSQL:(NSString *)oldTimeStr With:(NSString *)Formatter{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:oldTimeStr.doubleValue / 1000];
    if ([Formatter isEqualToString:@""]) {
        Formatter = @"yyyy-MM-dd HH:mm:ss";
    }
    NSString *timeStr = [AllMethod changeDateWay:date To:Formatter];
    return timeStr;
}



+(MJRefreshGifHeader *)createTableViewHeader:(id)obj andSelect:(SEL)select{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:obj refreshingAction:select];
    [header setImages:Animation_ImageArray duration:1 forState:MJRefreshStateRefreshing];
    return header;
}

+(MJRefreshAutoGifFooter *)createTableViewFooter:(id)obj andSelect:(SEL)select{
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:obj refreshingAction:select];
    [footer setImages:Animation_ImageArray duration:1 forState:MJRefreshStateRefreshing];
    return footer;
}




@end
