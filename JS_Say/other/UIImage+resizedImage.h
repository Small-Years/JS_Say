//
//  UIImage+resizedImage.h
//  Charles_learn
//
//  Created by yangjian on 2017/7/18.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (resizedImage)


/**
 压缩图片质量

 @param image 需要压缩的图片
 @param width 压缩范围
 @return 压缩好的图片
 */
+(instancetype)IMGCompressed:(UIImage *)image targetWidth:(CGFloat)width;

@end
