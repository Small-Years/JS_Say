//
//  YJ_WebView.h
//  JS_Say
//
//  Created by yangjian on 2017/8/12.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJ_WebView;

@protocol shareBtnClickDelegate <NSObject>

-(void)webShareBtnClicked;

@end

@interface YJ_WebView : BaseWebView


-(instancetype)initWithFrame:(CGRect)frame WithTitleText:(NSString *)titleStr WithTimeStr:(NSString *)timeStr;



@property (nonatomic,weak)id <shareBtnClickDelegate> shareDelegate;


@property (nonatomic,strong)NSString * likeCount;

@property(nonatomic,assign)BOOL canShare;

@property(nonatomic,copy)NSString *titleText;

@end
