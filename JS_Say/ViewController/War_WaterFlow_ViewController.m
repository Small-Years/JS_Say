//
//  WaterFlowCollectionViewController.m
//  CollectionPictures
//
//  Created by runlhy on 16/7/2.
//  Copyright © 2016年 runlhy. All rights reserved.
//

#import "War_WaterFlow_ViewController.h"
#import "WaterFlowLayout.h"
#import "WaterFlowCollectionViewCell.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "showWaterFlowViewController.h"


@interface War_WaterFlow_ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    BaseCollectionView *_collectionView;
    int pageIndex;
    int pageSize;
    UITapGestureRecognizer *tap;
    
    UIView *showMainView;//显示壁纸的页面
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *randomDataArray;

@end

@implementation War_WaterFlow_ViewController


- (NSMutableArray *)randomDataArray
{
    if (!_randomDataArray){
        _randomDataArray = [NSMutableArray array];
    }
    return _randomDataArray;
}

- (NSMutableArray *)allDataArray
{
    if (!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精美壁纸";
    self.view.backgroundColor = [UIColor whiteColor];
    
    WaterFlowLayout *waterFlowLayout = [WaterFlowLayout new];
    _collectionView = [[BaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterFlowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource  = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"WaterFlowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WaterFlowCollectionViewCell"];
    self.view = _collectionView;
    
    _collectionView.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadData)];
    
    [self loadData];
}

- (void)loadData{
    [self.dataArray removeAllObjects];
    [_collectionView reloadData];
    pageIndex = 1;
    pageSize = 21;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://bz.budejie.com/?typeid=3&ver=3.7.3&no_cry=1&client=iphone&c=wallPaper&a=wallPaperNew&index=%d&size=%d&bigid=1051",pageIndex,pageSize];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:self withSuccessBlock:^(NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"code"]isEqualToString:@"E00000000"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *picArr = [dict objectForKey:@"WallpaperListInfo"];
            
            self.dataArray = [picArr mutableCopy];
            pageIndex = pageIndex + pageSize;
            [_collectionView reloadData];
            [_collectionView.mj_header endRefreshing];
        }
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"++++%@",error);
        
    } progress:^(float progress) {
        
    }];
}

-(void)loadMoreData{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://bz.budejie.com/?typeid=3&ver=3.7.3&no_cry=1&client=iphone&c=wallPaper&a=wallPaperNew&index=%d&size=%d&bigid=1051",pageIndex,pageSize];
    
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:self withSuccessBlock:^(NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"code"]isEqualToString:@"E00000000"]) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *picArr = [dict objectForKey:@"WallpaperListInfo"];
//            for (NSDictionary *obj in picArr) {
//                NSString *urlStr = [obj objectForKey:@"WallPaperDownloadPath"];
//                [self.dataArray addObject:urlStr];
//            }
            [self.dataArray addObjectsFromArray:picArr];
            pageIndex = pageIndex + pageSize;
            [_collectionView reloadData];
            [_collectionView.mj_footer endRefreshing];
            
            
        }else{
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
        }
//        NSLog(@"-结束：--%lu",(unsigned long)self.dataArray.count);
        
    } withFailureBlock:^(NSError *error) {
//        NSLog(@"++++%@",error);
        
    } progress:^(float progress) {
        
    }];
    
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
    NSLog(@"-------:%lu",(unsigned long)self.dataArray.count);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WaterFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaterFlowCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"WallPaperDownloadPath"]];
    [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"video_Default"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imgURL = [self.dataArray[indexPath.row] objectForKey:@"WallPaperDownloadPath"];
    showWaterFlowViewController *vc = [[showWaterFlowViewController alloc]init];
    vc.imgURL = imgURL;
    [self presentViewController:vc animated:YES completion:nil];
}



#pragma mark - 向上拖动隐藏导航栏
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity < -5) {
        //向上拖动，隐藏导航栏
        //        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setTabBarHidden:YES];
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        //        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setTabBarHidden:NO];
    }else if(velocity == 0){
        //停止拖拽
    }
}

//隐藏显示tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    CGRect tabRect = self.tabBarController.tabBar.frame;
    if ([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
        tabRect.origin.y = SCREEN_HEIGHT + self.tabBarController.tabBar.height;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        tabRect.origin.y = SCREEN_HEIGHT - self.tabBarController.tabBar.height;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.tabBarController.tabBar.frame = tabRect;
    }completion:^(BOOL finished) {
        
    }];
}



@end
