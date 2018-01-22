//
//  talkTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/1.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "talkTableViewCell.h"
@interface talkTableViewCell(){
    NSArray *talkArr;
}
@end

@implementation talkTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithInfoDict:(NSDictionary *)infoDict{
    talkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[talkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithInfoDict:infoDict];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithInfoDict:(NSDictionary *)infoDict{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        //创建自定义cell
        NSLog(@"-----:%@",infoDict);
//        头像
        CGFloat headImageWidth = 40;
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.layer.cornerRadius = headImageWidth *0.5;
        iconImageView.layer.masksToBounds = YES;
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.offset(headImageWidth);
            make.height.offset(headImageWidth);
        }];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDict objectForKey:@"faceSrc"]] placeholderImage:[UIImage imageNamed:@"head_Default"]];
        
        UILabel *nameLable = [[UILabel alloc]init];
        nameLable.text = [infoDict objectForKey:@"nickName"];
        nameLable.textColor = RGB(155, 155, 155);
        nameLable.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:nameLable];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(10);
            make.top.equalTo(iconImageView.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.offset(23);
        }];
        
//        楼层
        UILabel *floorLable = [[UILabel alloc]init];
//        floorLable.text = [NSString stringWithFormat:@"%@楼   %@",[infoDict objectForKey:@"floor"],[AllMethod changeMethodFromSQL:[infoDict objectForKey:@"createDate"] With:@"MM-dd HH:mm"]];
        floorLable.text = [NSString stringWithFormat:@"%@",[AllMethod changeMethodFromSQL:[infoDict objectForKey:@"createDate"] With:@"MM-dd HH:mm"]];
        floorLable.textColor = RGB(155, 155, 155);
        floorLable.font = [UIFont systemFontOfSize:12];
        floorLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:floorLable];
        [floorLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLable.mas_left);
            make.top.equalTo(nameLable.mas_bottom).offset(3);
            make.right.equalTo(self.mas_right);
            make.height.offset(17);
        }];
//    评论内容
        BaseLabel *textLable = [[BaseLabel alloc]init];
        textLable.text = [infoDict objectForKey:@"content"];
//        textLable.textColor = RGB(76, 76, 76);
        textLable.font = [UIFont systemFontOfSize:16];
        textLable.textAlignment = NSTextAlignmentLeft;
        textLable.numberOfLines = 0;
        [self addSubview:textLable];
        [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(nameLable.mas_left);
//                        make.top.equalTo(nameLable.mas_bottom).offset(5);
//                        make.right.equalTo(self.mas_right);
//                        make.height.offset(17);
            make.left.equalTo(floorLable.mas_left);
            make.top.equalTo(floorLable.mas_bottom).offset(5);
            make.right.equalTo(self.mas_right);
            //高度先不设定，如果有回复，则加载回复，如果没有回复，则重新设定约束
        }];
        
//    回复列表
        talkArr = [infoDict objectForKey:@"replyCommentsVos"];
        
        if (talkArr.count != 0) {
            UILabel *new_Lable = nil;
            new_Lable = textLable;
            for (int i = 0; i<talkArr.count; i++) {
                NSDictionary *dict = talkArr[i];
                
                UILabel *lineLable = [[UILabel alloc]init];
                lineLable.backgroundColor = RGB(216, 214, 214);
                [self addSubview:lineLable];
                [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(new_Lable.mas_right);
                    make.left.equalTo(new_Lable.mas_left);
                    make.top.equalTo(new_Lable.mas_bottom).offset(6);
                    make.height.offset(0.5);
                }];
                UILabel *talkBackLable = [[UILabel alloc]init];
                talkBackLable.numberOfLines = 0;
                talkBackLable.font = [UIFont systemFontOfSize:14];
                talkBackLable.textColor = RGB(76, 76, 76);
                talkBackLable.tag = i+100;
                [self addSubview:talkBackLable];
                talkBackLable.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TalkBtnClicked:)];
                [talkBackLable addGestureRecognizer:tap];
                
                NSString *str = [NSString stringWithFormat:@"%@ 回复 %@：%@",[dict objectForKey:@"nickName"],[dict objectForKey:@"replyNickName"],[dict objectForKey:@"content"]];
                NSArray *arr = @[[NSString stringWithFormat:@"%@ 回复 %@：",[dict objectForKey:@"nickName"],[dict objectForKey:@"replyNickName"]]];
                talkBackLable.attributedText = [NSAttributedString_Encapsulation changeTextColorWithColor:RGB(155, 155, 155) string:str andSubString:arr];
//                需要设置其他颜色字体
                [talkBackLable mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(new_Lable.mas_left);
                    make.right.equalTo(new_Lable.mas_right);
                    make.top.equalTo(lineLable.mas_bottom).offset(6);
//                    make.height.offset(40);
                    if (i == talkArr.count-1) {
                        make.bottom.equalTo(self.mas_bottom).offset(-15);
                    }
                }];
                new_Lable = talkBackLable;
            }
        }else{
//            如果没有回复，则设定楼主评论距离底边多少距离就ok了
            [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(floorLable.mas_left);
                make.top.equalTo(floorLable.mas_bottom).offset(5);
                make.right.equalTo(self.mas_right).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-15);
            }];
        }
        
        
    }
    return self;
}

-(void)TalkBtnClicked:(UITapGestureRecognizer *)tap{
    int tag = (int)tap.view.tag-100;
    NSDictionary *infoDict = talkArr[tag];
//    NSLog(@"---%@",infoDict);
    
//    if ([self.delegate respondsToSelector:@selector(talkBtnClick:WithInfoDict:)]) {
        [self.delegate talkBtnClick:tag WithInfoDict:infoDict];
//    }
}


@end
