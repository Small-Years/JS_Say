//
//  videoTableViewCell.m
//  Charles_learn
//
//  Created by yangjian on 2017/7/18.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "videoTableViewCell.h"

@interface videoTableViewCell(){
    
    UIImageView *iconImageView;
    BaseView *moreView;
}
@property (nonatomic,strong)BaseLabel *titleLable;
@end

@implementation videoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict{
    videoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[videoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
//         self.backgroundColor = RGB(247, 247, 245);
        //创建自定义cell
        self.titleLable = [[BaseLabel alloc]init];
//        self.titleLable.textColor = RGB(74, 74, 74);
        self.titleLable.font = [UIFont systemFontOfSize:16];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.numberOfLines = 0;
        [self.titleLable sizeToFit];
        [self addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self.mas_right).offset(-10.0f);
        }];
        
        self.titleLable.attributedText = [NSAttributedString_Encapsulation string:[infoDict objectForKey:@"title"] withHotLogo:[infoDict objectForKey:@"isPop"] withJingLogo:[infoDict objectForKey:@"isHot"] withDingLogo:[infoDict objectForKey:@"isTop"]];
        
        iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.titleLable.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right);
            make.height.offset(200);
        }];
        
        NSString *imgStr = [infoDict objectForKey:@"thumbnail"];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"video_Default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat height = (SCREEN_WIDTH * image.size.height)/image.size.width;
            [iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(height);
            }];
            [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(iconImageView.mas_bottom).offset(15);
                make.right.equalTo(self.mas_right);
                make.height.offset(40);
//                make.bottom.equalTo(self.mas_bottom).offset(5);
            }];
            
        }];
        
        moreView = [[BaseView alloc]init];
//        moreView.viewStyle = BaseViewStyleGeneral;
        [self addSubview:moreView];
        [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(iconImageView.mas_bottom).offset(2);
            make.right.equalTo(self.mas_right);
            make.height.offset(35);
//            make.bottom.equalTo(self.mas_bottom);
        }];
        
//      发表人头像
        CGFloat headImageWidth = 29;
        UIImageView *headImageView = [[UIImageView alloc]init];
        headImageView.backgroundColor = [UIColor blueColor];
        [moreView addSubview:headImageView];
        headImageView.layer.cornerRadius = headImageWidth*0.5;
        headImageView.layer.masksToBounds = YES;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[infoDict objectForKey:@"issuerFaceSrc"]] placeholderImage:[UIImage imageNamed:@"headImage_Default"]];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moreView.mas_left).offset(15);
            make.top.equalTo(moreView.mas_top).offset(3);
            make.height.offset(headImageWidth);
            make.width.offset(headImageWidth);
        }];
        
        
        
//        评论数
        UILabel *pingLable = [[UILabel alloc]init];
        pingLable.text = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"commentCount"]];
        pingLable.textColor = RGB(126, 126, 126);
        pingLable.font = [UIFont systemFontOfSize:14];
        pingLable.textAlignment = NSTextAlignmentRight;
        [pingLable sizeToFit];
        [moreView addSubview:pingLable];
        [pingLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moreView.mas_right).offset(-10);
            make.top.equalTo(moreView.mas_top);
            make.bottom.equalTo(moreView.mas_bottom);
        }];
//      评论图标
        UIImageView *pingImageView = [[UIImageView alloc]init];
        UIImage *pingImage = [UIImage imageNamed:@"ping_Logo"];
        pingImageView.image = pingImage;
        [moreView addSubview:pingImageView];
        CGFloat ping_Height = (13 * pingImage.size.height)/pingImage.size.width;
        [pingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(pingLable.mas_left).offset(-5);
            make.centerY.equalTo(moreView.mas_centerY).offset(1);
            make.height.offset(ping_Height);
            make.width.offset(13);
        }];
        
//        点赞数
        UILabel *zanLable = [[UILabel alloc]init];
        zanLable.text = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"likeCount"]];
        zanLable.textColor = RGB(126, 126, 126);
        zanLable.font = [UIFont systemFontOfSize:14];
        zanLable.textAlignment = NSTextAlignmentRight;
        [zanLable sizeToFit];
        [moreView addSubview:zanLable];
        [zanLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(pingImageView.mas_left).offset(-10);
            make.top.equalTo(pingLable.mas_top);
            make.bottom.equalTo(pingLable.mas_bottom);
        }];
        //      赞图标
        UIImageView *zanImageView = [[UIImageView alloc]init];
        UIImage *zanImage = [UIImage imageNamed:@"zan_Logo"];
        zanImageView.image = zanImage;
        [moreView addSubview:zanImageView];
        CGFloat zan_Height = (16 * zanImage.size.height)/zanImage.size.width;
        [zanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(zanLable.mas_left).offset(-5);
            make.centerY.equalTo(moreView.mas_centerY).offset(1);
            make.height.offset(zan_Height);
            make.width.offset(16);
        }];
    
//      发表人名称
        BaseLabel *nameLable = [[BaseLabel alloc]init];
        nameLable.text = [infoDict objectForKey:@"issuerName"];
//        nameLable.textColor = RGB(100, 100, 100);
        nameLable.font = [UIFont systemFontOfSize:14];
        nameLable.textAlignment = NSTextAlignmentLeft;
        [moreView addSubview:nameLable];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(10);
            make.top.equalTo(headImageView.mas_top);
            make.height.equalTo(headImageView.mas_height);
        }];
        
        //播放图标
        UIImageView *start_ImageView = [[UIImageView alloc]init];
        start_ImageView.image = [UIImage imageNamed:@"start_Logo"];
        [self addSubview:start_ImageView];
        [start_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconImageView.mas_centerY);
            make.centerX.equalTo(iconImageView.mas_centerX);
            make.height.offset(50);
            make.width.offset(50);
        }];
        //播放次数
        UILabel *bofangLable = [[UILabel alloc]init];
        bofangLable.text = [NSString stringWithFormat:@"%@已播放",[infoDict objectForKey:@"playCount"]];
        bofangLable.textColor = [UIColor whiteColor];
        bofangLable.font = [UIFont systemFontOfSize:13];
        bofangLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:bofangLable];
        [bofangLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.bottom.equalTo(iconImageView.mas_bottom).offset(-10);
            make.height.offset(20);
        }];
        
        //视频时间
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.text = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"playTime"]];
        timeLable.textColor = [UIColor whiteColor];
        timeLable.font = [UIFont systemFontOfSize:13];
        timeLable.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(bofangLable.mas_centerY);
            make.height.offset(20);
        }];
        
        
//      最下面的分割线
        UILabel *lineLable = [[UILabel alloc]init];
        lineLable.backgroundColor = RGB(216, 214, 214);
        [self addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            make.top.equalTo(moreView.mas_bottom).offset(1);
            make.height.offset(1);
            make.bottom.equalTo(self.mas_bottom).offset(1);
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
