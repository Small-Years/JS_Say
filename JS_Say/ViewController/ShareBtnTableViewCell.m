//
//  ShareBtnTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/9/12.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "ShareBtnTableViewCell.h"

@implementation ShareBtnTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithIndex:(NSIndexPath *)indexPath{
    ShareBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ShareBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithIndex:indexPath];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithIndex:(NSIndexPath *)indexPath{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        UIImage *smallImage = [UIImage imageNamed:@"footView_Default"];
        CGFloat smallImg_Height = (SCREEN_WIDTH * smallImage.size.height)/smallImage.size.width;
//        UIImage *bigImage = [UIImage imageNamed:@"footView_Default2"];
//        CGFloat bigImage_Height = (SCREEN_WIDTH * bigImage.size.height)/bigImage.size.width;
        
        UIImageView *bgImageView = [[UIImageView alloc]init];
        bgImageView.image = smallImage;
        [self addSubview:bgImageView];
        
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.offset(smallImg_Height);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        //加个阅读规范：WithFrame:CGRectMake(0,20,SCREEN_WIDTH,30)
        UILabel *warnLable = [[UILabel alloc]init];
        //        warnLable.text = @"------ 直抒胸臆 理性爱国 ------";
        warnLable.textColor = RGB(120, 120, 120);
        warnLable.font = [UIFont boldSystemFontOfSize:15];
        warnLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:warnLable];
        warnLable.attributedText = [NSAttributedString_Encapsulation  string:@"直抒胸臆 理性爱国" withLineImage:@"no_content_arrow_image" withLableHeight:30];
        [warnLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).offset(20);
            make.height.offset(30);
        }];
        
        
        UIButton *shareBtn = [[UIButton alloc]init];
        shareBtn.backgroundColor = [UIColor clearColor];
        [shareBtn setImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(80);
            make.height.offset(80);
            make.centerX.equalTo(self);
            make.top.equalTo(warnLable.mas_bottom).offset(50);
        }];
        
//        WithFrame:CGRectMake(0,shareBtn.max_Y+10,SCREEN_WIDTH,20)
        UILabel *numLable = [[UILabel alloc]init];
        numLable.textColor = RGB(100, 100, 100);
        numLable.font = [UIFont systemFontOfSize:13];
        numLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numLable];
        [numLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(shareBtn.mas_bottom).offset(10);
        }];
    }
    return self;
}


-(void)shareBtnClick{
    if ([self.delegate respondsToSelector:@selector(ShareBtnClicked)]) {
        [self.delegate ShareBtnClicked];
    }
}

@end
