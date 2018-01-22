//
//  PhotoCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/21.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withSection:(NSInteger)section{
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict withSection:section];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict withSection:(NSInteger)section{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        //底下的主View
        UIView *mainView = [[UIView alloc]init];
//        mainView.backgroundColor = [UIColor whiteColor];
        mainView.layer.borderColor = RGB(215, 215, 215).CGColor;
        mainView.layer.borderWidth = 1;
        [self addSubview:mainView];
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
//        图像
        NSString *photoUrl = [infoDict objectForKey:@"img_large"];
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [mainView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainView.mas_top);
            make.left.equalTo(mainView.mas_left);
            make.right.equalTo(mainView.mas_right);
            make.height.offset(180);
        }];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"video_Default"]];
        
        
//        标题
        NSString *titleStr = [infoDict objectForKey:@"title"];
        BaseLabel *titleLable = [[BaseLabel alloc]init];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.font = [UIFont boldSystemFontOfSize:17];
        [mainView addSubview:titleLable];
        titleLable.text = titleStr;
        [titleLable sizeToFit];
        titleLable.numberOfLines = 0;
        
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(10);
            make.left.equalTo(mainView.mas_left).offset(10);
            make.right.equalTo(mainView.mas_right).offset(-10);
            make.bottom.equalTo(mainView.mas_bottom).offset(-35);
        }];
        
        
//      图片数量
        NSString *numStr = [infoDict objectForKey:@"num"];
        UILabel *imageLable = [[UILabel alloc]init];
        imageLable.textColor = RGB(155, 155, 155);
        imageLable.font = [UIFont systemFontOfSize:12];
        imageLable.textAlignment = NSTextAlignmentLeft;
        [mainView addSubview:imageLable];
        imageLable.attributedText = [NSAttributedString_Encapsulation string:numStr withImage:@"imageNum"];
        [imageLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(titleLable.mas_bottom).offset(5);
            make.bottom.equalTo(mainView.mas_bottom).offset(-5);
            make.left.equalTo(titleLable.mas_left);
            make.width.offset(100);
            make.height.offset(20);
        }];
        
//        日期
        UILabel *dateLable = [[UILabel alloc]init];
        dateLable.text = [infoDict objectForKey:@"gmdate"];
        dateLable.textColor = RGB(155, 155, 155);
        dateLable.font = [UIFont systemFontOfSize:12];
        dateLable.textAlignment = NSTextAlignmentRight;
        [mainView addSubview:dateLable];
        [dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(mainView.mas_bottom).offset(-5);
            make.right.equalTo(titleLable.mas_right);
            make.width.offset(100);
            make.height.offset(20);
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
