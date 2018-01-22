//
//  ShareBtnTableViewCell.h
//  JS_Say
//
//  Created by yangjian on 2017/9/12.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareBtnTableViewCell;

@protocol shareBtnDelegate <NSObject>

-(void)ShareBtnClicked;

@end


@interface ShareBtnTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithIndex:(NSIndexPath *)indexPath;

@property (nonatomic,weak) id<shareBtnDelegate> delegate;

@end
