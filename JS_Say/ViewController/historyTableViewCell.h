//
//  historyTableViewCell.h
//  JS_Say
//
//  Created by yangjian on 2017/8/24.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface historyTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row;
@end
