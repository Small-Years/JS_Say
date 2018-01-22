//
//  Other_WaterFlow_ViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/9/11.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "Other_WaterFlow_ViewController.h"
#import "WaterFlowLayout.h"
#import "WaterFlowCollectionViewCell.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "showWaterFlowViewController.h"


@interface Other_WaterFlow_ViewController ()<NSXMLParserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSString *baseUrl;
    int pageIndex;
    BaseCollectionView *_collectionView;
}

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * urlArray;

@end

@implementation Other_WaterFlow_ViewController
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
    
    WaterFlowLayout *waterFlowLayout = [WaterFlowLayout new];
    _collectionView = [[BaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterFlowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource  = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"WaterFlowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WaterFlowCollectionViewCell"];
    self.view = _collectionView;
    
    _collectionView.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(getMoreData)];
    
    [self getData];
}

-(void)getData{
    pageIndex = 0;
    [self.dataArray removeAllObjects];
    [self.urlArray removeAllObjects];

    NSString *str = [NSString stringWithFormat:@"http://360web.shoujiduoduo.com/wallpaper/wplist.php?type=getlist&prod=WallPaperDD_ip_1.7.2.4.ipa&listid=21&pg=%d&pc=48&st=hot",pageIndex];
    
    AFHTTPSessionManager *mgr =[AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml",@"application/atom+xml",@"text/html",nil];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        pageIndex = pageIndex+1;
        //1.创建NSXMLParser
        NSXMLParser *XMLParser = [[NSXMLParser alloc] initWithData:responseObject];
        //2.设置代理
        [XMLParser setDelegate:self];
        //3.开始解析
        [XMLParser parse];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-----error:%@",error);
    }];
}
-(void)getMoreData{
    NSString *str = [NSString stringWithFormat:@"http://360web.shoujiduoduo.com/wallpaper/wplist.php?type=getlist&prod=WallPaperDD_ip_1.7.2.4.ipa&listid=21&pg=%d&pc=48&st=hot",pageIndex];
    //    NSLog(@"下滑请求的接口：%@",str);
    AFHTTPSessionManager *mgr =[AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml",@"application/atom+xml",@"text/html",nil];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        pageIndex = pageIndex+1;
        //1.创建NSXMLParser
        NSXMLParser *XMLParser = [[NSXMLParser alloc] initWithData:responseObject];
        //2.设置代理
        [XMLParser setDelegate:self];
        //3.开始解析
        [XMLParser parse];
        [_collectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"------error:%@",error);
        [_collectionView.mj_footer endRefreshing];
    }];
}

-(void)dealData{
    NSString *thumblink= @"";
    for (NSDictionary *obj in self.dataArray) {
        thumblink = [NSString stringWithFormat:@"%@%@",baseUrl,[obj objectForKey:@"link"]];
        [self.urlArray addObject:thumblink];
    }
    //    根据URlArray创建出图片列表
    
    [self.dataArray removeAllObjects];
    [_collectionView reloadData];
    
}


#pragma mark - NSXMLParserDelegate

//2.解析XML文件中所有的元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    //    NSLog(@"解析XML文件中所有的元素:elementName:%@,attributeDict:%@",elementName,attributeDict);
    if ([elementName isEqualToString:@"list"]) {
        baseUrl = [attributeDict objectForKey:@"baseurl"];
    }
    if ([elementName isEqualToString:@"img"]) {
        [self.dataArray addObject:attributeDict];
    }
}
//4.XML所有元素解析完毕
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //刷新界面
    [self dealData];
}


#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    WaterFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaterFlowCollectionViewCell" forIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:self.urlArray[indexPath.row]];
    [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"video_Default"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    showWaterFlowViewController *vc = [[showWaterFlowViewController alloc]init];
    vc.imgURL = self.urlArray[indexPath.row];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
