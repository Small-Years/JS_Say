//
//  WeaponsTableViewCell.h
//  JS_Say
//
//  Created by yangjian on 2017/8/8.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeaponsBtnClickDelegate <NSObject>

-(void)WeaponsKindBtnClicked:(NSDictionary *)infoDict;

@end

@interface WeaponsTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withSection:(NSInteger)section;

@property(nonatomic,weak) id<WeaponsBtnClickDelegate> delegate;

@end
