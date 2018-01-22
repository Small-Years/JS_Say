//
//  recommendTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/4.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "recommendTableViewCell.h"
@interface recommendTableViewCell(){
    UIImageView *iconImageView;
}
@property (nonatomic,strong)BaseLabel * titleLable;

@end

@implementation recommendTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict{
    recommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[recommendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        //创建自定义cell
        
        iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.offset(80);
            make.width.offset(110);
        }];
        NSString *imgString = [infoDict objectForKey:@"thumbnail"];
        NSArray *imageArray = [imgString componentsSeparatedByString:@","];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"video_Default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        
        self.titleLable = [[BaseLabel alloc]init];
//        self.titleLable.textColor = RGB(74, 74, 74);
        self.titleLable.font = [UIFont systemFontOfSize:16];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.text = [infoDict objectForKey:@"title"];
        self.titleLable.numberOfLines = 2;
        //        self.titleLable.text = [infoDict objectForKey:@"title"];
        [self addSubview:self.titleLable];
        
        // 调整行间距
//        NSString *titleStr = [infoDict objectForKey:@"title"];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:6];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
//        self.titleLable.attributedText = attributedString;
        
        self.titleLable.attributedText = [NSAttributedString_Encapsulation string:[infoDict objectForKey:@"title"] withHotLogo:[infoDict objectForKey:@"isPop"] withJingLogo:[infoDict objectForKey:@"isHot"] withDingLogo:[infoDict objectForKey:@"isTop"] WithPadding:6];
        [self.titleLable sizeToFit];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(iconImageView.mas_top).offset(7);
            make.right.equalTo(iconImageView.mas_left).offset(-10);
        }];
        
        UILabel *lineLable = [[UILabel alloc]init];
        lineLable.backgroundColor = RGB(216, 214, 214);
        [self addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            make.top.equalTo(iconImageView.mas_bottom).offset(5);
            make.height.offset(1);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        //      发表人名字
        UILabel *nameLable = [[UILabel alloc]init];
        nameLable.text = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"communityName"]];
        nameLable.textColor = RGB(126, 126, 126);
        nameLable.font = [UIFont systemFontOfSize:12];
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.numberOfLines = 1;
        [self addSubview:nameLable];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.titleLable.mas_left);
            make.bottom.equalTo(lineLable.mas_top).offset(-7);
        }];
        
        //time
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.text = [NSString stringWithFormat:@"%@",[AllMethod changeMethodFromSQL:[infoDict objectForKey:@"createDate"] With:@"MM-dd HH:MM"]];
        timeLable.textColor = RGB(126, 126, 126);
        timeLable.font = [UIFont systemFontOfSize:12];
        timeLable.textAlignment = NSTextAlignmentLeft;
        timeLable.numberOfLines = 1;
        [self addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.titleLable.mas_right).offset(-10);
            make.top.equalTo(nameLable.mas_top);
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
