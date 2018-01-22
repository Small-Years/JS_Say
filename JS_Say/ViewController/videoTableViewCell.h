//
//  videoTableViewCell.h
//  Charles_learn
//
//  Created by yangjian on 2017/7/18.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface videoTableViewCell : TBbaseTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict;

@end
