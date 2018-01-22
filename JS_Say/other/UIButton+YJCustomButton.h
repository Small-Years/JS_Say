//
//  UIButton+YJCustomButton.h
//  SQCustomButton
//
//  Created by yangjian on 2017/9/20.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YJCustomButtonType){
    YJCustomButtonRightImageType = 0,   //右图标，左文字
    YJCustomButtonTypeLeftImageType,    //左图标，右文字
    YJCustomButtonTypeTopImageType      //上图标，下文字
};

@interface UIButton (YJCustomButton)

-(void)setButtonCustomType:(YJCustomButtonType)type;

@end
