//
//  InfoF10MainView.m
//  IosYtz_HTF
//
//  Created by CK on 14-11-10.
//
//

#import "InfoF10MainView.h"

@interface InfoF10MainView()
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *titleLists;
@property(nonatomic,assign)BOOL isHK;//是否是港股
@end

@implementation InfoF10MainView
@synthesize titleLists,F10MainView_Delegate,btnHeight,btnWidth,stockCode,F10IndexArray,F10DetailCtl,isShowLab,noDataLab;
@synthesize service,isHK;

- (id)initWithFrame:(CGRect)frame andDelegate:(id<InfoF10MainView_Delegate>)_F10MainView_Delegate andStockCode:_stockCode andIsHK:(BOOL)_isHK
{
    self = [super initWithFrame:frame];
    if (self) {
        isShowLab = YES;
//        service = [[InfoService alloc]initWithDelegate:self];
//        F10MainView_Delegate = _F10MainView_Delegate;
        F10IndexArray = [[NSMutableArray alloc] initWithCapacity:0];  //初始化数组
        stockCode = _stockCode;
 //       [self loadHttpData];
        [self initUI];
        isHK = _isHK;
       
    }
    
    return self;
}

//-(void) loadHttpData{
//    [service getF10DetailWithCode:stockCode];
//}
////F10首页数据
//-(void)infoF10IndexListSuc:(BOOL)_isOk errorMsg:(NSString *)_err list:(NSMutableArray *)_dataList{
//    
//    if (_isOk) {
//        if (_dataList.count >0) {
//            F10IndexArray = _dataList;
//        }
//    }
//    
//}

-(void)initUI{
//    NSArray *infoArray = [NSArray arrayWithObjects:@"公司简况",@"财务分析",@"经营分析",@"行业分析",@"股东情况",@"股本股改",@"分红扩股",@"价值分析", nil];
//    //加载F10初始界面
//    for (int i=0; i<infoArray.count; i++) {
//        //先计算button的高度和宽度
//        NSInteger col = i/3;
//        NSInteger row = i;
//        if (i>2) {
//            row = i-3;
//        }
//        if(i>5){
//            row = i-6;
//        }
//        UIButton *showButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        showButton.frame = CGRectMake(self.bounds.size.width*row/3+5, 35*col+10, self.bounds.size.width/3-10, 30);
//
//        showButton.tag = i;
//        [showButton setTitle:infoArray[i] forState:UIControlStateNormal];
//        showButton.userInteractionEnabled = YES;
//        [showButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
//        UIColor *color = [[ThemeManager shareInstence]getColorWithName:CELLNAMECOLOR];
//        showButton.tintColor = color;
//        [showButton.layer setBorderWidth:0.5];
//        [showButton.layer setCornerRadius:3.0];
//        if ([[UIDevice currentDevice] systemVersion].floatValue<7.0) {
//             [showButton.layer setBorderColor:[UIColor clearColor].CGColor];
//        }else{
//             [showButton.layer setBorderColor:color.CGColor];
//        }
//       
//    
//       [self addSubview:showButton];
//    }
//
    //创建demo数据
    data = [[NSMutableArray alloc]initWithCapacity : 2];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity : 2];
    [dict setObject:@"好友" forKey:@"groupname"];
    
    //利用数组来填充数据
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity : 2];
    [arr addObject: @"关羽"];
    [arr addObject: @"张飞"];
    [arr addObject: @"孔明"];
    [dict setObject:arr forKey:@"users"];
    [data addObject: dict];
    
    dict = [[NSMutableDictionary alloc]initWithCapacity : 2];
    [dict setObject:@"对手" forKey:@"groupname"];
    
    arr = [[NSMutableArray alloc] initWithCapacity : 2];
    [arr addObject: @"曹操"];
    [arr addObject: @"司马懿"];
    [arr addObject: @"张辽"];
    [dict setObject:arr forKey:@"users"];
    [data addObject: dict];
    
    
    
    //创建一个tableView视图
    //创建UITableView 并指定代理
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;
    tbView = [[UITableView alloc]initWithFrame: frame style:UITableViewStylePlain];
    [tbView setDelegate: self];
    [tbView setDataSource: self];
    [self addSubview: tbView];
    
    [tbView reloadData];

}
#pragma mark -
#pragma mark Table view data source


//对指定的节进行“展开/折叠”操作
-(void)collapseOrExpand:(int)section{
    Boolean expanded = NO;
    //Boolean searched = NO;
    NSMutableDictionary* d=[data objectAtIndex:section];
    
    //若本节model中的“expanded”属性不为空，则取出来
    if([d objectForKey:@"expanded"]!=nil)
        expanded=[[d objectForKey:@"expanded"]intValue];
    
    //若原来是折叠的则展开，若原来是展开的则折叠
    [d setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
    
}


//返回指定节的“expanded”值
-(Boolean)isExpanded:(int)section{
    Boolean expanded = NO;
    NSMutableDictionary* d=[data objectAtIndex:section];
    
    //若本节model中的“expanded”属性不为空，则取出来
    if([d objectForKey:@"expanded"]!=nil)
        expanded=[[d objectForKey:@"expanded"]intValue];
    
    return expanded;
}


//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn= (UIButton*)sender;
    int section= btn.tag; //取得tag知道点击对应哪个块
    
    //	NSLog(@"click %d", section);
    [self collapseOrExpand:section];
    
    //刷新tableview
    [tbView reloadData];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [data count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    //对指定节进行“展开”判断
    if (![self isExpanded:section]) {
        
        //若本节是“折叠”的，其行数返回为0
        return 0;
    }
    
    NSDictionary* d=[data objectAtIndex:section];
    return [[d objectForKey:@"users"] count];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary* m= (NSDictionary*)[data objectAtIndex: indexPath.section];
    NSArray *d = (NSArray*)[m objectForKey:@"users"];
    
    if (d == nil) {
        return cell;
    }
    
    //显示联系人名称
    
    cell.textLabel.text = [d objectAtIndex: indexPath.row];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    //UIColor *newColor = [[UIColor alloc] initWithRed:(float) green:(float) blue:(float) alpha:(float)];
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_listbg.png"]];
    cell.imageView.image = [UIImage imageNamed:@"mod_user.png"];
    
    
    //选中行时灰色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}



// 设置header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    
    
    UIView *hView;
    if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
        UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
    {
        hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 40)];
    }
    else
    {
        hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        //self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);
    }
    //UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UIButton* eButton = [[UIButton alloc] init];
    
    //按钮填充整个视图
    eButton.frame = hView.frame;
    [eButton addTarget:self action:@selector(expandButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    eButton.tag = section;//把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
    //根据是否展开，切换按钮显示图片
    if ([self isExpanded:section])
        [eButton setImage: [ UIImage imageNamed: @"btn_down.png" ] forState:UIControlStateNormal];
    else
        [eButton setImage: [ UIImage imageNamed: @"btn_right.png" ] forState:UIControlStateNormal];
    
    
    //由于按钮的标题，
    //4个参数是上边界，左边界，下边界，右边界。
    eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
    
    
    //设置按钮显示颜色
    eButton.backgroundColor = [UIColor lightGrayColor];
    [eButton setTitle:[[data objectAtIndex:section] objectForKey:@"groupname"] forState:UIControlStateNormal];
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [eButton setBackgroundImage: [ UIImage imageNamed: @"btn_listbg.png" ] forState:UIControlStateNormal];//btn_line.png"
    //[eButton setTitleShadowColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
    //[eButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    
    [hView addSubview: eButton];
        return hView;
    
}

//显示对应的详细数据
-(void)showInfo:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    if (isHK) {//港股显示暂无数据
        [self promatLable];
        return;
    }
    
    if(F10IndexArray.count>0){
        for (int i= 0; i<F10IndexArray.count; i++) {
            InfoF10IndexBeans *f10IndexInfo = F10IndexArray[i];
            if([f10IndexInfo.title isEqualToString:button.titleLabel.text]){
                InfoF10DetailViewController *infoF10Ctl = [[InfoF10DetailViewController alloc] initWithId:f10IndexInfo.guid withTitle:button.titleLabel.text withTime:@"" withType:@"" withArticleid:f10IndexInfo.articleid withGathertime:f10IndexInfo.gathertime withCatalogid:f10IndexInfo.catalogid];
                [[self viewController].navigationController pushViewController:infoF10Ctl animated:YES];
            }
            else{
                
            }
        }
    }
    else{
            [self promatLable];
    }
}


/**
 *  获得当前视图所在的控制器
 */
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
//点击按钮，如无数据，提示暂无数据动画
-(void)promatLable{
    if (isShowLab) {
        isShowLab = NO;
        noDataLab = [[UILabel alloc]init];
        noDataLab.frame = CGRectMake((self.bounds.size.width-80)/2, self.bounds.size.height, 80, 30);
        noDataLab.text = @"暂无数据";
        noDataLab.font = [UIFont systemFontOfSize:12.0];
        noDataLab.textColor = [UIColor whiteColor];
        noDataLab.layer.cornerRadius = 5.0;
        noDataLab.layer.masksToBounds =YES;
        noDataLab.textAlignment = NSTextAlignmentCenter;
        noDataLab.backgroundColor = [UIColor blackColor];
        [[[UIApplication sharedApplication].delegate window] addSubview:noDataLab];
        [UIView animateWithDuration:0.3 animations:^{
            noDataLab.frame = CGRectMake((self.bounds.size.width-80)/2, self.bounds.size.height-100, 80, 30);
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [noDataLab removeFromSuperview];
                isShowLab = YES;
            });
            
        }];

    }
}

@end
