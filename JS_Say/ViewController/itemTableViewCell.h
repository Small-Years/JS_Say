//
//  itemTableViewCell.h
//  JS_Say
//
//  Created by yangjian on 2017/8/7.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface itemTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row;

@end
