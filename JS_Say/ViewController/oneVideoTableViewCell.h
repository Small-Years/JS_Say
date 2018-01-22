//
//  oneVideoTableViewCell.h
//  JS_Say
//
//  Created by yangjian on 2017/8/17.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface oneVideoTableViewCell : TBbaseTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict;

@end
