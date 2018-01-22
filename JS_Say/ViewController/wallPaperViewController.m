//
//  wallPaperViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/4.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "wallPaperViewController.h"

@interface wallPaperViewController (){
    int pageIndex;
    int pageSize;
    
    UIButton *btn;
}

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * urlArray;
@end

@implementation wallPaperViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)urlArray{
    if (_urlArray == nil) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"壁纸";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 50, 100, 50)];
    btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

-(void)loadData{
    [self.urlArray removeAllObjects];
    pageIndex = 1;
    pageSize = 21;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://bz.budejie.com/?typeid=3&ver=3.7.3&no_cry=1&client=iphone&c=wallPaper&a=wallPaperNew&index=%d&size=%d&bigid=1051",pageIndex,pageSize];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:self withSuccessBlock:^(NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"code"]isEqualToString:@"E00000000"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *picArr = [dict objectForKey:@"WallpaperListInfo"];
            
            for (NSDictionary *obj in picArr) {
                NSString *urlStr = [obj objectForKey:@"WallPaperDownloadPath"];
                [self.urlArray addObject:urlStr];
            }
            pageIndex = pageIndex + pageSize;
        }
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"++++%@",error);
        
    } progress:^(float progress) {
        
    }];
    
}

-(void)loadMoreData{
     NSLog(@"开始-%lu",(unsigned long)self.urlArray.count);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://bz.budejie.com/?typeid=3&ver=3.7.3&no_cry=1&client=iphone&c=wallPaper&a=wallPaperNew&index=%d&size=%d&bigid=1051",pageIndex,pageSize];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:self withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"code"]isEqualToString:@"E00000000"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *picArr = [dict objectForKey:@"WallpaperListInfo"];
            
            for (NSDictionary *obj in picArr) {
                NSString *urlStr = [obj objectForKey:@"WallPaperDownloadPath"];
                [self.urlArray addObject:urlStr];
            }
            pageIndex = pageIndex + pageSize;
        }else{
            NSLog(@"--self.urlArray:%@",self.urlArray);
            btn.backgroundColor = [UIColor redColor];
            btn.userInteractionEnabled = NO;
        }
        NSLog(@"-结束：--%lu",(unsigned long)self.urlArray.count);
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"++++%@",error);
        
    } progress:^(float progress) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"照片数组：%@",self.urlArray);
}
@end
