//
//  InfoF10MainView.h
//  IosYtz_HTF
//
//  Created by CK on 14-11-10.
//
//

#import <UIKit/UIKit.h>
#import "InfoService.h"
#import "InfoF10DetailViewController.h"

@protocol InfoF10MainView_Delegate <NSObject>

-(void)doSwitchViewController:(NSInteger)_index andTitle:(NSString*)_navtitle;

@end

@interface InfoF10MainView : UIView<UITableViewDataSource,UITableViewDelegate,InfoServiceDelegate>{
    
    
    UITableView *tbView;
    NSMutableArray *data;
}

@property(nonatomic)CGFloat *btnWidth;
@property(nonatomic)CGFloat *btnHeight;
@property(nonatomic,strong)InfoService *service;
@property(nonatomic,assign)id<InfoF10MainView_Delegate> F10MainView_Delegate;
@property(nonatomic,strong)NSString *stockCode;    //股票代码
@property(nonatomic,strong)NSMutableArray *F10IndexArray;   //F10接收的数据
@property(nonatomic,strong)InfoF10DetailViewController *F10DetailCtl;   //F10的详细信息
@property(nonatomic,assign)BOOL isShowLab;  //是否显示  暂无数据
@property(nonatomic,strong)UILabel *noDataLab; //暂无数据
- (id)initWithFrame:(CGRect)frame andDelegate:(id<InfoF10MainView_Delegate>)_F10MainView_Delegate andStockCode:_stockCode andIsHK:(BOOL)_isHK;

@end
