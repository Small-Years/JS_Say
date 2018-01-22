//
//  talkTableViewCell.h
//  JS_Say
//
//  Created by yangjian on 2017/8/1.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol talkBackBtnDelegate <NSObject>

-(void)talkBtnClick:(int)number WithInfoDict:(NSDictionary *)dict;

@end

@interface talkTableViewCell : TBbaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithInfoDict:(NSDictionary *)infoDict;

@property (nonatomic,weak) id<talkBackBtnDelegate> delegate;

@end
