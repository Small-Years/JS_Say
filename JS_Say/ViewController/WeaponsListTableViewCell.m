//
//  WeaponsListTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/9.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "WeaponsListTableViewCell.h"

@implementation WeaponsListTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row{
    WeaponsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WeaponsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict withRow:row];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.offset(90);
            make.height.offset(60);
        }];
        NSString *str = [infoDict objectForKey:@"img"];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"video_Default"]];
        
//      名称
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.textColor = RGB(74, 74, 74);
        titleLable.font = [UIFont systemFontOfSize:16];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.numberOfLines = 1;
        [titleLable sizeToFit];
        [self addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(10.0f);
            make.top.equalTo(self.mas_top).offset(7);
            make.right.equalTo(self.mas_right).offset(-10.0f);
        }];
        titleLable.text = [infoDict objectForKey:@"name"];
//  from
        UILabel *fromLable = [[UILabel alloc]init];
        fromLable.textColor = RGB(74, 74, 74);
        fromLable.font = [UIFont systemFontOfSize:13];
        fromLable.textAlignment = NSTextAlignmentLeft;
        fromLable.numberOfLines = 1;
        [fromLable sizeToFit];
        [self addSubview:fromLable];
        [fromLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(10.0f);
            make.top.equalTo(titleLable.mas_bottom).offset(5);
            make.right.equalTo(self.mas_right).offset(-10.0f);
        }];
        fromLable.text = [infoDict objectForKey:@"country"];
        //类型 | 时间
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.textColor = RGB(155, 155, 155);
        timeLable.font = [UIFont systemFontOfSize:12];
        timeLable.textAlignment = NSTextAlignmentLeft;
        timeLable.numberOfLines = 1;
        [timeLable sizeToFit];
        [self addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(10.0f);
            make.top.equalTo(fromLable.mas_bottom).offset(7);
            make.right.equalTo(self.mas_right).offset(-10.0f);
        }];
        timeLable.text = [NSString stringWithFormat:@"%@|%@",[infoDict objectForKey:@"typeName"],[infoDict objectForKey:@"period"]];
        
        
        //      最下面的分割线
        UILabel *lineLable = [[UILabel alloc]init];
        lineLable.backgroundColor = RGB(216, 214, 214);
        [self addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            make.top.equalTo(iconImageView.mas_bottom).offset(10);
            make.height.offset(1);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
