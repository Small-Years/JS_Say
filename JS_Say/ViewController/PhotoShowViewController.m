//
//  PhotoShowViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/22.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "PhotoShowViewController.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"

@interface PhotoShowViewController ()<IDMPhotoBrowserDelegate>

@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation PhotoShowViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.infoDict objectForKey:@"title"];
    
    [self loadData];
}

-(void)loadData{
    //    http://mobile.chinaiiss.com/strategy/v3/pic/get_picinfo?picid=92572
    
    NSString *url = [NSString stringWithFormat:@"%@/strategy/v3/pic/get_picinfo?picid=%@",kPicUrl,[self.infoDict objectForKey:@"picid"]];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:url withParaments:self withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
            NSDictionary *obj = [responseObject objectForKey:@"data"];
            NSArray *arr = [obj objectForKey:@"contents"];
            for (NSDictionary *obj in arr) {
                [self.dataArray addObject:obj];
            }
//            NSLog(@"%@",self.dataArray);
            [self dealData];
        }
        
    } withFailureBlock:^(NSError *error) {
        
    } progress:^(float progress) {
        
    }];
}


-(void)dealData{
    NSLog(@"----%@",self.dataArray);
    NSMutableArray *photoArr = [NSMutableArray array];
    
    for (NSDictionary *obj in self.dataArray) {
        NSString *str = [obj objectForKey:@"img_url"];
        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:str]];
        photo.caption = [obj objectForKey:@"img_summary"];
        [photoArr addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photoArr];
    browser.delegate = self;
//    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:sender];
//    browser.scaleImage = buttonSender.currentImage;
    browser.displayActionButton = NO;
    browser.displayArrowButton = YES;
    browser.displayCounterLabel = YES;
    browser.autoHideInterface = NO;
    browser.forceHideStatusBar = NO;
    browser.actionButtonTitles = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4"];
    
    [self presentViewController:browser animated:YES completion:nil];
    
}

#pragma -mark IDMPhotoBrowserDelegate
- (void)willDisappearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser{
    [self popView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
