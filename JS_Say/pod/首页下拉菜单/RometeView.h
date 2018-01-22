//
//  RometeView.h
//  RomateDemo
//
//  Created by tianlei on 16/6/30.
//  Copyright © 2016年 tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RemateDelegate<NSObject>

-(void)itemsButtonClicked:(UIButton *)btn;

@end


@interface RometeView : UIView

//+ (instancetype)sharedRometeView;

- (instancetype)initWithFrame:(CGRect)rect;

- (void)show;


@property (nonatomic, assign) NSInteger menuCount;

@property (nonatomic,weak)id<RemateDelegate> delegate;

@end
