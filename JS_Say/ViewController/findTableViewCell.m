//
//  findTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/25.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "findTableViewCell.h"

@interface findTableViewCell(){

}
@end


@implementation findTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row{
    findTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[findTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict withRow:row];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        UIImageView *iconImage = [[UIImageView alloc]init];
        [self addSubview:iconImage];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.left.equalTo(self.mas_left).offset(10);
            make.height.offset(80);
            make.width.offset(110);
        }];
        NSString *iconUrl = [infoDict objectForKey:@"img_large"];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"video_Default"]];
        
        // 标题
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.textColor = RGB(74, 74, 74);
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textAlignment = NSTextAlignmentLeft;
        //            NSString *titleStr = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"title"]];
        //            titleLable.text = titleStr;
        titleLable.numberOfLines = 2;
        [self addSubview:titleLable];
        
        // 调整行间距
        NSString *titleStr = [infoDict objectForKey:@"title"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
        titleLable.attributedText = attributedString;
        [titleLable sizeToFit];
        
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImage.mas_right).offset(10.0f);
            make.top.equalTo(iconImage.mas_top).offset(7);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
//        UILabel *timeLable = [[UILabel alloc]init];
//        timeLable.text = [AllMethod changeDateMethod:[infoDict objectForKey:@"modified"] From:@"yyyy-MM-dd HH:mm:ss" To:@"MM-dd HH:mm"];
//        
//        timeLable.textColor = RGB(155, 155, 155);
//        timeLable.font = [UIFont systemFontOfSize:13];
//        timeLable.textAlignment = NSTextAlignmentRight;
//        [self addSubview:timeLable];
//        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(iconImage.mas_right).offset(10.0f);
//            make.right.equalTo(self.mas_right).offset(-10);
//            make.bottom.equalTo(iconImage.mas_bottom);
//        }];
        
        
        UILabel *lineLable = [[UILabel alloc]init];
        lineLable.backgroundColor = RGB(216, 214, 214);
        [self addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            make.top.equalTo(iconImage.mas_bottom).offset(5);
            make.height.offset(1);
            make.bottom.equalTo(self.mas_bottom);
        }];

        
        
        
        
    }
    return self;
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
