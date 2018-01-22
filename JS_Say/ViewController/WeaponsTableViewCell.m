//
//  WeaponsTableViewCell.m
//  JS_Say
//
//  Created by yangjian on 2017/8/8.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "WeaponsTableViewCell.h"
@implementation UIColor (Extensions)


+ (instancetype)randomColor {
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    return [self colorWithRed:red green:green blue:blue alpha:1.0];
}

@end

@interface WeaponsTableViewCell()
@property (nonatomic,strong)NSMutableArray * titleArray;
@end

@implementation WeaponsTableViewCell
-(NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        NSArray *arr = @[@{@"iconName":@"飞行器",@"text":@"飞行器",@"url":@"1"},
                         @{@"iconName":@"舰船",@"text":@"舰船",@"url":@"2"},
                         @{@"iconName":@"枪械与单兵",@"text":@"枪械与单兵",@"url":@"3"},
                         @{@"iconName":@"坦克装甲车",@"text":@"坦克装甲车",@"url":@"4"},
                         @{@"iconName":@"火炮",@"text":@"火炮",@"url":@"5"},
                         @{@"iconName":@"导弹",@"text":@"导弹",@"url":@"6"},
                         @{@"iconName":@"太空装备",@"text":@"太空装备",@"url":@"7"},
                         @{@"iconName":@"爆炸物",@"text":@"爆炸物",@"url":@"8"},
                         @{@"iconName":@"发动机",@"text":@"航空发动机",@"url":@"9"},
                         @{@"iconName":@"雷达",@"text":@"雷达",@"url":@"10"},
                         @{@"iconName":@"军火商",@"text":@"军火商",@"url":@"11"},
                         @{@"iconName":@"军事术语",@"text":@"军事术语",@"url":@"12"}];
        _titleArray = [arr mutableCopy];
    }
    return _titleArray;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier WithDict:(NSDictionary *)infoDict withSection:(NSInteger)section{
    WeaponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WeaponsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier WithDict:infoDict withSection:section];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithDict:(NSDictionary *)infoDict withSection:(NSInteger)section{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        if (section == 0) {
//            创建九宫格
            CGFloat width = SCREEN_WIDTH/4;
            UIView *mainView = [[UIView alloc]init];
            mainView.backgroundColor = [UIColor clearColor];
            mainView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:mainView];
            [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(SCREEN_WIDTH);
                make.top.equalTo(self.mas_top);
                make.height.offset((width+20) * 3);
                make.bottom.equalTo(self.mas_bottom);
            }];
            
            for (int i = 0; i < 12; i++) {
                NSDictionary *dict = self.titleArray[i];
                UIButton *btn = [[UIButton alloc] init];
                btn.translatesAutoresizingMaskIntoConstraints = NO;
                btn.backgroundColor = [UIColor clearColor];
                btn.layer.borderColor = RGB(244, 244, 244).CGColor;
                btn.layer.borderWidth = 0.5;
                btn.tag = i;
                [mainView addSubview:btn];
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, width-20, width-20)];
                iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"iconName"]];
                [btn addSubview:iconImageView];

                UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0,iconImageView.max_Y+5,width,20)];
                titleLable.text = [dict objectForKey:@"text"];
                titleLable.textColor = RGB(76, 76, 76);
                titleLable.font = [UIFont systemFontOfSize:12];
                titleLable.textAlignment = NSTextAlignmentCenter;
                [btn addSubview:titleLable];
                
            }
            [mainView.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:width+15
                                                                    fixedLineSpacing:0 fixedInteritemSpacing:0
                                                                           warpCount:4
                                                                          topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];

        }else{
//            创建武器快讯cell
            
            UIImageView *iconImageView = [[UIImageView alloc]init];
            iconImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:iconImageView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(10);
                make.top.equalTo(self.mas_top).offset(10);
                make.width.offset(90);
                make.height.offset(60);
            }];
            NSString *str = [infoDict objectForKey:@"thumbnail"];
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"video_Default"]];
            
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
            
            //      名称
            UILabel *titleLable = [[UILabel alloc]init];
            titleLable.textColor = RGB(74, 74, 74);
            titleLable.font = [UIFont systemFontOfSize:16];
            titleLable.textAlignment = NSTextAlignmentLeft;
            titleLable.numberOfLines = 2;
            [titleLable sizeToFit];
            [self addSubview:titleLable];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImageView.mas_right).offset(10.0f);
                make.top.equalTo(self.mas_top).offset(7);
                make.right.equalTo(self.mas_right).offset(-10.0f);
            }];
            titleLable.text = [infoDict objectForKey:@"title"];
            //  from
//            UILabel *fromLable = [[UILabel alloc]init];
//            fromLable.textColor = RGBCOLOR(74, 74, 74);
//            fromLable.font = [UIFont systemFontOfSize:13];
//            fromLable.textAlignment = NSTextAlignmentLeft;
//            fromLable.numberOfLines = 1;
//            [fromLable sizeToFit];
//            [self addSubview:fromLable];
//            [fromLable mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(iconImageView.mas_right).offset(10.0f);
//                make.top.equalTo(titleLable.mas_bottom).offset(5);
//                make.right.equalTo(self.mas_right).offset(-10.0f);
//            }];
//            fromLable.text = [infoDict objectForKey:@"country"];
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
                make.bottom.equalTo(lineLable.mas_top).offset(-7);
                make.right.equalTo(self.mas_right).offset(-10.0f);
            }];
            NSString *timeStr = [infoDict objectForKey:@"date"];
//            2017-07-27 07:02:39
            timeLable.text = [NSString stringWithFormat:@"%@",[AllMethod changeDateMethod:timeStr From:@"yyyy-MM-dd HH:mm:ss" To:@"MM-dd HH:mm"]];

            
        }
    }
    return self;
}



-(void)btnClicked:(UIButton *)btn{
    NSDictionary *dict = self.titleArray[btn.tag];
    if ([self.delegate respondsToSelector:@selector(WeaponsKindBtnClicked:)]) {
        [self.delegate WeaponsKindBtnClicked:dict];
    }
    
    
}




@end
