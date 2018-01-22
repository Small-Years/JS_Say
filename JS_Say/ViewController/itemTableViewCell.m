//
//  itemTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/7.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "itemTableViewCell.h"

@interface itemTableViewCell()

@end


@implementation itemTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row{
    itemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[itemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict withRow:row];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict withRow:(NSInteger)row{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        if (row == 0) {
            //创建大图
            UIImageView *iconImageView = [[UIImageView alloc]init];
            [self addSubview:iconImageView];
            iconImageView.contentMode = UIViewContentModeScaleAspectFit;
            iconImageView.backgroundColor = RGB(227, 227, 227);
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.mas_top);
                make.right.equalTo(self.mas_right);
                make.height.offset(213.5);
            }];
            NSString *iconUrl = [infoDict objectForKey:@"thumbnail"];
//            [iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"video_Default"]];
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"video_Default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
//                CGFloat height = (SCREEN_WIDTH * image.size.height)/image.size.width;
//                [iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.offset(height);
//                    make.left.equalTo(self.mas_left);
//                    make.top.equalTo(self.mas_top);
//                    make.right.equalTo(self.mas_right);
//                }];
            }];
            
            UILabel *titleLable = [[UILabel alloc]init];
            titleLable.textColor = [UIColor whiteColor];
            titleLable.font = [UIFont systemFontOfSize:16];
            titleLable.textAlignment = NSTextAlignmentLeft;
            titleLable.text = [infoDict objectForKey:@"title"];
            titleLable.numberOfLines = 2;
            [self addSubview:titleLable];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(5);
                make.right.equalTo(self.mas_right).offset(-5);
                make.top.equalTo(iconImageView.mas_bottom).offset(-44);
                make.height.offset(44);
                make.bottom.equalTo(self.mas_bottom);
            }];
            
        }else{//普通栏目
            
            UIImageView *iconImage = [[UIImageView alloc]init];
            [self addSubview:iconImage];
            iconImage.contentMode = UIViewContentModeScaleAspectFit;
            [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(5);
                make.left.equalTo(self.mas_left).offset(10);
                make.height.offset(80);
                make.width.offset(110);
            }];
            NSString *iconUrl = [infoDict objectForKey:@"thumbnail"];
            [iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"video_Default"]];
            
            // 标题
            UILabel *titleLable = [[UILabel alloc]init];
            titleLable.textColor = RGB(74, 74, 74);
            titleLable.font = [UIFont systemFontOfSize:15];
            titleLable.textAlignment = NSTextAlignmentLeft;
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
            
            UILabel *timeLable = [[UILabel alloc]init];
            timeLable.text = [AllMethod changeDateMethod:[infoDict objectForKey:@"modified"] From:@"yyyy-MM-dd HH:mm:ss" To:@"MM-dd HH:mm"];
            
            timeLable.textColor = RGB(155, 155, 155);
            timeLable.font = [UIFont systemFontOfSize:13];
            timeLable.textAlignment = NSTextAlignmentRight;
            [self addSubview:timeLable];
            [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImage.mas_right).offset(10.0f);
                make.right.equalTo(self.mas_right).offset(-10);
                make.bottom.equalTo(iconImage.mas_bottom);
            }];
            
            
            UILabel *lineLable = [[UILabel alloc]init];
            lineLable.backgroundColor = RGB(216, 214, 214);
            [self addSubview:lineLable];
            [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right);
                make.left.equalTo(self.mas_left);
                make.top.equalTo(iconImage.mas_bottom).offset(5);
                make.height.offset(1);
                make.bottom.equalTo(self.mas_bottom).offset(0);
            }];
        
            
            
        }
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
