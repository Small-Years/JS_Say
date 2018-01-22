//
//  WeaponsViewController.m
//  JS_Say
//
//  Created by yangjian on 2017/8/8.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "WeaponsViewController.h"
#import "WeaponsTableViewCell.h"
#import "WeaponsListViewController.h"
#import "WeaponsNewsInfoViewController.h"


@interface WeaponsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,WeaponsBtnClickDelegate>{
    UITableView *mainTable;
    int pageIndex;
    
    UIImageView *headImageView;
    CGFloat height;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation WeaponsViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        NSDictionary *dict = @{@"name":@"图标"};
        [_dataArray addObject:dict];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"武器库";
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftButtonBarItemSelect:@selector(popView) andTarget:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-64) style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.estimatedRowHeight = 350;  //  随便设个不那么离谱的值
    mainTable.rowHeight = UITableViewAutomaticDimension;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    mainTable.mj_footer = [AllMethod createTableViewFooter:self andSelect:@selector(loadMoreData)];
    
    UIImage *headImage = [UIImage imageNamed:@"headImage"];
    height = (SCREEN_WIDTH * headImage.size.height)/headImage.size.width;
    mainTable.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    
    headImageView = [[UIImageView alloc]init];
    headImageView.image = headImage;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds=YES;
    headImageView.frame = CGRectMake(0, -height, SCREEN_WIDTH, height);
    [mainTable addSubview:headImageView];
    
    [self loadData];
    
}
-(void)loadData{
//    https://api.idwoo.com/api/junqing/get_category_posts/?id=6id&page=1
    pageIndex = 1;
    NSString *newURL = [NSString stringWithFormat:@"https://api.idwoo.com/api/junqing/get_category_posts/?id=6id&page=%d",pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:newURL withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = [dict objectForKey:@"posts"];
        self.dataArray = [arr mutableCopy];
        
        [mainTable.mj_header endRefreshing];
        [mainTable reloadData];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_header endRefreshing];
    } progress:^(float progress) {
    }];
    
}
-(void)loadMoreData{
    NSString *newURL = [NSString stringWithFormat:@"https://api.idwoo.com/api/junqing/get_category_posts/?id=6id&page=%d",++pageIndex];
    [NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:newURL withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *arr = [dict objectForKey:@"posts"];
        self.dataArray = [arr mutableCopy];
        [mainTable.mj_footer endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error：%@",error);
        [AllMethod showAltMsg:[NSString stringWithFormat:@"网络出错，请检查后再试！"] WithController:self WithAction:nil];
        [mainTable.mj_footer endRefreshing];
    } progress:^(float progress) {
    }];
}


#pragma mark -UITableviewDlegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        WeaponsTableViewCell *cell = [WeaponsTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:nil withSection:indexPath.section];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        NSDictionary *dict = self.dataArray[indexPath.row];
        WeaponsTableViewCell *cell = [WeaponsTableViewCell cellWithTableView:tableView withIdentifier:cellId WithDict:dict withSection:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        WeaponsNewsInfoViewController *vc = [[WeaponsNewsInfoViewController alloc]init];
        vc.infoDict = dict;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark -WeaponsBtnClickDelegate

-(void)WeaponsKindBtnClicked:(NSDictionary *)infoDict{
    
    WeaponsListViewController *vc = [[WeaponsListViewController alloc]init];
    vc.infoDict = infoDict;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + height)/2;
    
    if (yOffset < -height) {
        
        CGRect rect = headImageView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        
        headImageView.frame = rect;
    }
    
}


@end
