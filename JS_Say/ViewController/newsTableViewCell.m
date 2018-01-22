//
//  newsTableViewCell.m
//  Charles_learn
//
//  Created by yangjian on 2017/7/24.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "newsTableViewCell.h"



@interface newsTableViewCell(){
    UILabel *titleLable;
    UIImageView *iconImageView;
    UIView *moreView;
    UIView *showImageView;//多张图片存放的view
    
}
@end


@implementation newsTableViewCell

+(instancetype)cellWithTableview:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict{
    newsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[newsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        titleLable = [[UILabel alloc]init];
        titleLable.textColor = RGB(74, 74, 74);
        titleLable.font = [UIFont systemFontOfSize:16];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.numberOfLines = 0;
//        [titleLable sizeToFit];
        [self addSubview:titleLable];
        titleLable.attributedText = [NSAttributedString_Encapsulation string:[infoDict objectForKey:@"title"] withHotLogo:[infoDict objectForKey:@"isPop"] withJingLogo:[infoDict objectForKey:@"isHot"] withDingLogo:[infoDict objectForKey:@"isTop"]];
        
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(self.mas_top).offset(15);
            make.right.equalTo(self.mas_right).offset(-10.0f);
        }];
       
        
        
        //iconImage有2种类型，根据图片的数量来判断
        NSString *imageString = [infoDict objectForKey:@"thumbnail"];
        NSArray *imageArray = [imageString componentsSeparatedByString:@","];
        
        if (imageArray.count == 1) {
            iconImageView = [[UIImageView alloc]init];
            iconImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:iconImageView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(10);
                make.top.equalTo(titleLable.mas_bottom).offset(10);
                make.right.equalTo(self.mas_right).offset(-100);
                make.height.offset(200);
            }];
            NSString *imgStr = imageArray[0];
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"video_Default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                CGFloat height = ((SCREEN_WIDTH-120) * image.size.height)/image.size.width;
                NSLog(@"----%f",height);
                [iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(height);
                }];
                
                [moreView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.mas_left);
                    make.top.equalTo(iconImageView.mas_bottom).offset(15);
                    make.right.equalTo(self.mas_right);
                    make.height.offset(40);
                    make.bottom.equalTo(self.mas_bottom).offset(5);
                }];
                [self reloadInputViews];
            }];
        }
        else if (imageArray.count == 0){
            iconImageView = [[UIImageView alloc]init ];
            iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//        WithFrame:CGRectMake(0,CGRectGetMaxY(titleLable.frame)+10,SCREEN_WIDTH, 0.5)];
            [self addSubview: iconImageView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(titleLable.mas_bottom).offset(10);
                make.right.equalTo(self.mas_right).offset(0);
                make.height.offset(1);
            }];
            
        }else{//说明有多张图片，需要显示成3列的那种
            
            showImageView = [[UIView alloc]init];
            [self addSubview:showImageView];
            [showImageView mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(titleLable.mas_bottom).offset(10);
                make.right.equalTo(self.mas_right).offset(-5);
                make.height.offset(70);
            }];
            
            
            if (imageArray.count>2) {
                //用来记录上一次创建的UILabel
                UIImageView *lastImageView = nil;
                for (int i = 0; i < imageArray.count; i++) {
                    UIImageView *smallImageView = [UIImageView new];
                    [showImageView addSubview:smallImageView];
                    smallImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        CGFloat padding = 10;
                        make.height.offset(70.0f);
                        make.top.offset(0);//计算距离顶部的公式 60 = 上一个距离顶部的高度 + UIlabel的高度
                        if (i%3 == 0) {//当是 左边一列的时候 都是 距离父视图 向左边 20的间隔
                            make.left.offset(padding);
                        }else{
                            //当时中间列的时候 在上一个UIlabel的右边 添加20个 距离 并且设置等高
                            make.width.equalTo(lastImageView.mas_width);
                            make.left.equalTo(lastImageView.mas_right).offset(padding);
                        }
                        //当是 最右边列的时候 距离右边父视图的 距离为20  因为是向左所以是-20  控制底部也是 负数!!
                        if (i%3 == 2) {
                            make.right.offset(-padding);
                        }
                    }];
                    NSString *imgStr = imageArray[i];
                    [smallImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"video_Default"]];
                    lastImageView = smallImageView;
                }
            }else{//如果是2张的话，则按照两张计算
                for (int i = 0; i<2; i++) {
                    if (i == 0) {
                        UIImageView *smallImageView = [UIImageView new];
                        smallImageView.contentMode = UIViewContentModeScaleAspectFit;
                        [showImageView addSubview:smallImageView];
                        [smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            CGFloat imageW = (SCREEN_WIDTH - 50)/3;
                            make.top.offset(0);
                            make.height.offset(70.0f);
                            make.left.offset(10);
                            make.width.offset(imageW);
                        }];
                        NSString *imgStr = imageArray[0];
                        [smallImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"video_Default"]];
                    }else{
                        UIImageView *smallImageView = [UIImageView new];
                        smallImageView.contentMode = UIViewContentModeScaleAspectFit;
                        [showImageView addSubview:smallImageView];
                        [smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            CGFloat imageW = (SCREEN_WIDTH - 50)/3;
                            make.top.offset(0);
                            make.height.offset(70.0f);
                            make.left.offset(20 + imageW);
                            make.width.offset(imageW);
                        }];
                        NSString *imgStr = imageArray[1];
                        [smallImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"video_Default"]];
                    }
                }
            }
            
            
            
            
        }
        
        
        
        moreView = [[UIView alloc]init];
        moreView.backgroundColor = [UIColor whiteColor];
        [self addSubview:moreView];
        if (imageArray.count >1) {
            [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(showImageView.mas_bottom).offset(7);
                make.right.equalTo(self.mas_right);
                make.height.offset(35);
                make.bottom.equalTo(self.mas_bottom);
            }];
        }else{
            [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(iconImageView.mas_bottom).offset(7);
                make.right.equalTo(self.mas_right);
                make.height.offset(35);
                make.bottom.equalTo(self.mas_bottom);
            }];
        }
        
       
        
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
        UILabel *nameLable = [[UILabel alloc]init];
        nameLable.text = [infoDict objectForKey:@"issuerName"];
        nameLable.textColor = RGB(100, 100, 100);
        nameLable.font = [UIFont systemFontOfSize:14];
        nameLable.textAlignment = NSTextAlignmentLeft;
        [moreView addSubview:nameLable];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(10);
            make.top.equalTo(headImageView.mas_top);
            make.height.equalTo(headImageView.mas_height);
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
        }];
        
//        [titleLable mas_updateConstraints:^(MASConstraintMaker *make){
//            make.left.equalTo(self.mas_left).offset(10.0f);
//            make.top.equalTo(self.mas_top).offset(15);
//            make.right.equalTo(self.mas_right).offset(-10.0f);
//        }];
        
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    //用来记录上一次创建的UILabel
    UILabel *lastLabel = nil;
    
    for (int i = 0; i < 9; i++) {
        
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"~%d~",i];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            //设置高度
            make.height.offset(40.0f);
            //计算距离顶部的公式 60 = 上一个距离顶部的高度 + UIlabel的高度
            float colTop = (20 + i/3 * 60.0f);
            
            make.top.offset(colTop);
            
            //当是 左边一列的时候 都是 距离父视图 向左边 20的间隔
            if (i%3 == 0) {
                
                make.left.offset(20.0f);
                
            }else{
                
                //当时中间列的时候 在上一个UIlabel的右边 添加20个 距离 并且设置等高
                make.width.equalTo(lastLabel.mas_width);
                make.left.equalTo(lastLabel.mas_right).offset(20.0f);
                
            }
            //当是 最右边列的时候 距离右边父视图的 距离为20  因为是向左所以是-20  控制底部也是 负数!!
            if (i%3 == 2) {
                
                make.right.offset(-20.0f);
                
            }
            
        }];
        lastLabel = label;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
