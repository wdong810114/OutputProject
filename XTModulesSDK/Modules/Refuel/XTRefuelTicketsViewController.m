//
//  XTRefuelTicketsViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/8.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelTicketsViewController.h"

#import "XTRefuelApi.h"
#import "XTRefuelTicketCell.h"
#import "XTRefuelTicketDetailViewController.h"

static NSInteger const XTTabItemButtonTagBase = 1000;

static CGFloat const XTTabViewHeight = 50.0;

@interface XTRefuelTicketsViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) NSMutableArray *tabItemButtonArray;
@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *ticketsTableViewArray;

@end

@implementation XTRefuelTicketsViewController
{
    BOOL _isSwitchAnimation;
    NSInteger _selectedTabItemButtonTag;
    
    NSMutableDictionary *_dataSourceDictionary;
    NSMutableDictionary *_pageNumberDictionary;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isSwitchAnimation = NO;
        _selectedTabItemButtonTag = XTTabItemButtonTagBase;
        
        _dataSourceDictionary = [NSMutableDictionary dictionary];
        _pageNumberDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的油券";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tabItemButtonClicked:(UIButton *)tabItemButton
{
    if (_isSwitchAnimation || _selectedTabItemButtonTag == tabItemButton.tag) {
        return;
    }
    
    _selectedTabItemButtonTag = tabItemButton.tag;
    [self switchTabWithTabItemButtonTag:_selectedTabItemButtonTag];
    
    [self requestData];
}

#pragma mark - Private
- (void)initView
{
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.mainScrollView];
    
    [self switchTabWithTabItemButtonTag:_selectedTabItemButtonTag];
}

- (void)switchTabWithTabItemButtonTag:(NSInteger)tabItemButtonTag
{
    _isSwitchAnimation = YES;
    
    [self.tabItemButtonArray enumerateObjectsUsingBlock:^(UIButton *tabItemButton, NSUInteger idx, BOOL *stop) {
        if (tabItemButton.tag == tabItemButtonTag) {
            tabItemButton.selected = YES;
        } else {
            tabItemButton.selected = NO;
        }
    }];
    
    NSInteger selectedIndex = tabItemButtonTag - XTTabItemButtonTagBase;
    
    [self.ticketsTableViewArray enumerateObjectsUsingBlock:^(UITableView *ticketsTableView, NSUInteger idx, BOOL *stop) {
        if (selectedIndex == idx) {
            ticketsTableView.scrollsToTop = YES;
        } else {
            ticketsTableView.scrollsToTop = NO;
        }
    }];
    
    // 设置主滚动视图的偏移及Tab栏指示视图的位置
    CGFloat scrollOffsetX = selectedIndex * CGRectGetWidth(self.mainScrollView.bounds);
    self.mainScrollView.contentOffset = CGPointMake(scrollOffsetX, 0.0);
    
    CGFloat indicatorX = selectedIndex * CGRectGetWidth(self.tabView.bounds) / self.tabItemButtonArray.count;
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect frame = self.indicatorView.frame;
                         frame.origin.x = indicatorX;
                         self.indicatorView.frame = frame;
                     } completion:^(BOOL finished) {
                         _isSwitchAnimation = NO;
                     }];
}

- (void)requestData
{
    NSInteger index = _selectedTabItemButtonTag - XTTabItemButtonTagBase;
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    if (dataSource.count == 0) {
        UITableView *ticketsTableView = self.ticketsTableViewArray[index];
        [ticketsTableView.mj_header beginRefreshing];
    } else {
        [self showLoading];
        
        _pageNumberDictionary[@(index)] = @1;
        [self requestTickets:index];
    }
}

- (void)requestTickets:(NSInteger)index
{
    if (index < 0 || index > self.ticketsTableViewArray.count - 1) return;
    
    if (XTIsReachable) {
        UITableView *ticketsTableView = self.ticketsTableViewArray[index];
        NSArray *dataSource = _dataSourceDictionary[@(index)];
        
        NSString *phone = [XTModulesManager sharedManager].phone;
        NSString *oilStatus = nil;
        if (index == 0) {
            oilStatus = @"0";
        } else if (index == 1) {
            oilStatus = @"3";
        } else if (index == 2) {
            oilStatus = @"2";
        } else {
        }
        NSString *currentPage = [NSString stringWithFormat:@"%@", _pageNumberDictionary[@(index)]];
        NSString *pageSize = [NSString stringWithFormat:@"%i", (int)XTPageCapacity];
        
        XTWeakSelf(weakSelf);
        [[XTRefuelApi sharedAPI] postQueryAccountCouponWithPhone:phone oilStatus:oilStatus currentPage:currentPage pageSize:pageSize completionHandler:^(NSArray<XTRefuelTicketModel> *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                NSMutableArray *ticketsArray = [NSMutableArray array];
                if (dataSource && dataSource.count > 0) {
                    [ticketsArray addObjectsFromArray:dataSource];
                }
                if ([currentPage integerValue] == 1) {
                    [ticketsArray removeAllObjects];
                }
                if (output && output.count > 0) {
                    [ticketsArray addObjectsFromArray:output];
                }
                
                if (ticketsArray.count > 0) {
                    ticketsTableView.tableHeaderView = nil;
                } else {
                    ticketsTableView.tableHeaderView = [weakSelf generateDataEmptyView];
                }
                
                _dataSourceDictionary[@(index)] = ticketsArray;
                [ticketsTableView reloadData];
                
                if (output.count < XTPageCapacity) {
                    ticketsTableView.mj_footer.hidden = YES;
                } else {
                    ticketsTableView.mj_footer.hidden = NO;
                }
                
                if ([currentPage integerValue] == 1) {
                    [weakSelf scrollToTop:ticketsTableView];
                }
            }
            
            [ticketsTableView.mj_header endRefreshing];
            [ticketsTableView.mj_footer endRefreshing];
        }];
    } else {
        [self hideLoading];
            
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (void)scrollToTop:(UITableView *)tableView
{
    XTDispatchAsyncOnMainQueue({
        NSInteger index = [self.ticketsTableViewArray indexOfObject:tableView];
        NSArray *dataSource = _dataSourceDictionary[@(index)];

        BOOL bShouldScroll = dataSource.count > 0;
        if (bShouldScroll) {
            [tableView scrollToRowAtIndexPath:XTIndexPath(0, 0)
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:NO];
        }
    })
}

- (UIView *)generateDataEmptyView
{
    UIView *dataEmptyView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight - XTTabViewHeight)];
    dataEmptyView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(dataEmptyView.bounds) - 90.0) / 2, (CGRectGetHeight(dataEmptyView.bounds) - 114.0) / 2, 90.0, 61.0)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:XTModulesSDKImage(@"tickets_empty")];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(imageView.frame) + 9.0, CGRectGetWidth(dataEmptyView.bounds), 16.0)];
    label.backgroundColor = [UIColor clearColor];
    label.font = XTFont(14.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = XTColorFromHex(0x666666);
    label.text = @"暂无油券";
    
    [dataEmptyView addSubview:imageView];
    [dataEmptyView addSubview:label];
    
    return dataEmptyView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        NSInteger selectedIndex = self.mainScrollView.contentOffset.x / CGRectGetWidth(self.mainScrollView.bounds);
        NSInteger tabItemButtonTag = XTTabItemButtonTagBase + selectedIndex;
        if (_selectedTabItemButtonTag == tabItemButtonTag) {
            return;
        }
        
        _selectedTabItemButtonTag = tabItemButtonTag;
        [self switchTabWithTabItemButtonTag:_selectedTabItemButtonTag];
        
        [self requestData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = [self.ticketsTableViewArray indexOfObject:tableView];
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XTRefuelTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTRefuelTicketCellIdentifier" forIndexPath:indexPath];
    
    NSInteger index = [self.ticketsTableViewArray indexOfObject:tableView];
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    XTRefuelTicketModel *model = dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isSwitchAnimation) {
        NSInteger index = [self.ticketsTableViewArray indexOfObject:tableView];
        NSArray *dataSource = _dataSourceDictionary[@(index)];
        XTRefuelTicketModel *model = dataSource[indexPath.row];
        
        XTRefuelTicketDetailViewController *vc = [[XTRefuelTicketDetailViewController alloc] init];
        vc.ticketId = model.ticketId;
        vc.ticketName = model.ticketName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getter
- (UIView *)tabView
{
    if (!_tabView) {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTTabViewHeight)];
        _tabView.backgroundColor = [UIColor whiteColor];
        
        NSArray *buttonTitleArray = @[@"未使用", @"已使用", @"已过期"];
        
        CGFloat buttonWidth = CGRectGetWidth(_tabView.bounds) / buttonTitleArray.count;
        CGFloat buttonHeight = CGRectGetHeight(_tabView.bounds);
        
        self.tabItemButtonArray = [[NSMutableArray alloc] initWithCapacity:buttonTitleArray.count];
        
        [buttonTitleArray enumerateObjectsUsingBlock:^(NSString *buttonTitle, NSUInteger idx, BOOL *stop) {
            UIButton *tabItemButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * idx, 0.0, buttonWidth, buttonHeight)];
            tabItemButton.backgroundColor = [UIColor clearColor];
            tabItemButton.tag = XTTabItemButtonTagBase + idx;
            tabItemButton.titleLabel.font = XTFont(14.0);
            [tabItemButton setTitleColor:XTBrandLightBlackColor forState:UIControlStateNormal];
            [tabItemButton setTitleColor:XTBrandRedColor forState:UIControlStateSelected];
            [tabItemButton setTitle:buttonTitle forState:UIControlStateNormal];
            [tabItemButton addTarget:self action:@selector(tabItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_tabView addSubview:tabItemButton];
            [self.tabItemButtonArray addObject:tabItemButton];
        }];
        
        self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(_tabView.bounds) - 2.0, CGRectGetWidth(_tabView.bounds) / self.tabItemButtonArray.count, 2.0)];
        self.indicatorView.backgroundColor = XTBrandRedColor;
        [_tabView addSubview:self.indicatorView];
    }
    
    return _tabView;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, XTTabViewHeight, XTMainScreenWidth, XTNonTopLevelViewHeight - XTTabViewHeight)];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.scrollsToTop = NO;
        _mainScrollView.bounces = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(_mainScrollView.bounds) * self.tabItemButtonArray.count, CGRectGetHeight(_mainScrollView.bounds));
        [_mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.ticketsTableViewArray = [[NSMutableArray alloc] initWithCapacity:self.tabItemButtonArray.count];
        
        for (NSInteger index = 0; index < self.tabItemButtonArray.count; index++) {
            UITableView *ticketsTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_mainScrollView.bounds) * index, 0.0, CGRectGetWidth(_mainScrollView.bounds), CGRectGetHeight(_mainScrollView.bounds)) style:UITableViewStylePlain];
            ticketsTableView.backgroundColor = [UIColor clearColor];
            ticketsTableView.dataSource = self;
            ticketsTableView.delegate = self;
            ticketsTableView.separatorColor = [UIColor clearColor];
            ticketsTableView.tableFooterView = [[UIView alloc] init];
            [ticketsTableView registerNib:XTModulesSDKNib(@"XTRefuelTicketCell") forCellReuseIdentifier:@"XTRefuelTicketCellIdentifier"];
            ticketsTableView.mj_header = [XTDIYHeader headerWithRefreshingBlock:^{
                _pageNumberDictionary[@(index)] = @1;
                [self requestTickets:index];
            }];
            ticketsTableView.mj_footer = [XTDIYFooter footerWithRefreshingBlock:^{
                NSArray *dataSource = _dataSourceDictionary[@(index)];
                _pageNumberDictionary[@(index)] = @(dataSource.count / XTPageCapacity + 1);
                [self requestTickets:index];
            }];
            ticketsTableView.mj_footer.hidden = YES;
            if (@available(iOS 11.0, *)) {
                ticketsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            [_mainScrollView addSubview:ticketsTableView];
            [self.ticketsTableViewArray addObject:ticketsTableView];
        }
    }
    
    return _mainScrollView;
}

@end
