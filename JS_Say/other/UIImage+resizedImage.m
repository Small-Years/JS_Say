//
//  UIImage+resizedImage.m
//  Charles_learn
//
//  Created by yangjian on 2017/7/18.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "UIImage+resizedImage.h"


@implementation UIImage (resizedImage)

+(instancetype)IMGCompressed:(UIImage *)image targetWidth:(CGFloat)width
{
    NSData *imageData = UIImageJPEGRepresentation(image, width);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

@end
