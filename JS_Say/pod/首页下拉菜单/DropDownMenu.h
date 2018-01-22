//
//  DropDownMenu.h
//  BaiduCloudStorage
//
//  Created by 曾诗亮 on 2017/1/13.
//  Copyright © 2017年 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedAtIndex)(NSInteger index);

@interface DropDownMenu : UIView

@property (copy, nonatomic) SelectedAtIndex selectedAtIndex;
//- (void)selectedAtIndex:(SelectedAtIndex)block;

- (instancetype)initWithWidth:(CGFloat)width imagesArray:(NSArray *)images titlesArray:(NSArray *)titles;

- (void)showMenu;


@property(nonatomic,copy)void (^selectedBtnAtIndex)(NSInteger index);

@end
