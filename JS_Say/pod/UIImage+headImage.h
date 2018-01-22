//
//  UIImage+headImage.h
//  画图
//
//  Created by yangjian on 2016/11/24.
//  Copyright © 2016年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (headImage)
/**
 *  生成头像
 *
 *  @param iconName   头像图片名称
 *  @param border 头像边框大小
 *  @param color  头像边框的颜色
 *
 *  @return 生成好的头像
 */
+(instancetype)imageWithIcon:(NSString *)iconName border:(NSInteger)border color:(UIColor *)color;
@end

