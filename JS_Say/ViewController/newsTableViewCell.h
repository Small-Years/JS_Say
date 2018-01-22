//
//  newsTableViewCell.h
//  Charles_learn
//
//  Created by yangjian on 2017/7/24.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsTableViewCell : UITableViewCell
+(instancetype)cellWithTableview:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict;

@end
