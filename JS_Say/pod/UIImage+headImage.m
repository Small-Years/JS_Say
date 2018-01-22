//
//  UIImage+headImage.m
//  画图
//
//  Created by yangjian on 2016/11/24.
//  Copyright © 2016年 yangjian. All rights reserved.
//

#import "UIImage+headImage.h"

@implementation UIImage (headImage)

+ (instancetype)imageWithIcon:(NSString *)iconName border:(NSInteger)border color:(UIColor *)color
{
    // 0. 加载原有图片
    UIImage *image = [UIImage imageNamed:iconName];
    
    // 1.创建图片上下文
    CGFloat margin = border;
    CGSize size = CGSizeMake(image.size.width + margin, image.size.height + margin);
    
    // YES 不透明 NO 透明
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 2.绘制大圆
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, size.width, size.height));
    [color set];
    CGContextFillPath(ctx);
    
    // 3.绘制小圆
    CGFloat smallX = margin * 0.5;
    CGFloat smallY = margin * 0.5;
    CGFloat smallW = image.size.width;
    CGFloat smallH = image.size.height;
    CGContextAddEllipseInRect(ctx, CGRectMake(smallX, smallY, smallW, smallH));
    //    [[UIColor greenColor] set];
    //    CGContextFillPath(ctx);
    // 4.指点可用范围, 可用范围的适用范围是在指定之后,也就说在在指定剪切的范围之前绘制的东西不受影响
    CGContextClip(ctx);
    
    // 5.绘图图片
    [image drawInRect:CGRectMake(smallX, smallY, smallW, smallH)];
    
    // 6.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
    
}

@end
