//
//  recommendTableViewCell.h
//  JS_Say
//
//  Created by yangjian on 2017/8/4.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recommendTableViewCell : TBbaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict;

@end
