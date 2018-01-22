//
//  UIButton+YJCustomButton.m
//  SQCustomButton
//
//  Created by yangjian on 2017/9/20.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "UIButton+YJCustomButton.h"

@implementation UIButton (YJCustomButton)

-(void)setButtonCustomType:(YJCustomButtonType)type{
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageViewFrame = self.imageView.frame;
    
    CGFloat space = titleFrame.origin.x - imageViewFrame.origin.x - imageViewFrame.size.width;

    if (type == YJCustomButtonTypeTopImageType) {//上图标，下文字
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, titleFrame.size.height + space, -(titleFrame.size.width))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageViewFrame.size.height + space, -(imageViewFrame.size.width), 0, 0)];
    }else if (type == YJCustomButtonRightImageType){//右图标，左文字
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,titleFrame.size.width + space, 0, -(titleFrame.size.width + space))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(titleFrame.origin.x - imageViewFrame.origin.x), 0, titleFrame.origin.x - imageViewFrame.origin.x)];
    }else{
//        默认就是为左侧图标，右侧文字
        
    }
    
}

@end
