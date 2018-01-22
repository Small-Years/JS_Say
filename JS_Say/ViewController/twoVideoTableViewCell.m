//
//  twoVideoTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/17.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "twoVideoTableViewCell.h"
@interface twoVideoTableViewCell(){
    UIImageView *iconImageView;
}

@property (nonatomic,strong)BaseLabel *titleLable;
@end

@implementation twoVideoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict{
    twoVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[twoVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        //创建自定义cell
        self.titleLable = [[BaseLabel alloc]init];
//        self.titleLable.textColor = RGB(74, 74, 74);
        self.titleLable.font = [UIFont systemFontOfSize:16];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.numberOfLines = 2;
        self.titleLable.text = [infoDict objectForKey:@"title"];
        [self.titleLable sizeToFit];
        [self addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.offset(40);
//          make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//        iconImageView.layer.borderWidth = 1;
//        iconImageView.layer.borderColor = RGB(227, 227, 227).CGColor;
//        self.backgroundColor = RGB(247, 247, 245);
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.titleLable.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.offset(150);
        }];
        
        //      最下面的分割线
        UILabel *lineLable = [[UILabel alloc]init];
        lineLable.backgroundColor = RGB(216, 214, 214);
        [self addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.mas_left);
            make.top.equalTo(iconImageView.mas_bottom).offset(10);
            make.height.offset(1);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
        }];
        
        NSString *imgStr = [infoDict objectForKey:@"img_large"];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"video_Default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            CGFloat height = ((SCREEN_WIDTH-30) * image.size.height)/image.size.width;
//            [iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.offset(height);
//            }];
//            
//            [lineLable mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(iconImageView.mas_bottom).offset(10);
//                make.bottom.equalTo(self.mas_bottom).offset(-2);
//            }];
//            [self updateConstraintsIfNeeded];
//            [self layoutIfNeeded];
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
