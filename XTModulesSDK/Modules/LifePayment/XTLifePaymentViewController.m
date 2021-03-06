//
//  XTLifePaymentViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/13.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentViewController.h"

#import "XTLifePaymentConstants.h"
#import "XTLifePaymentApi.h"
#import "XTLifePaymentAccountCell.h"
#import "XTLifePaymentAccountViewController.h"
#import "XTLifePaymentPayBillViewController.h"

static NSInteger const XTTabItemButtonTagBase = 1000;

static CGFloat const XTTabViewHeight = 116.0;

@interface XTLifePaymentViewController () <UITableViewDataSource, UITableViewDelegate, XTLifePaymentAccountCellDelegate>

@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) NSMutableArray *tabItemButtonArray;
@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *accountsTableViewArray;

@end

@implementation XTLifePaymentViewController
{
    BOOL _isSwitchAnimation;
    NSInteger _selectedTabItemButtonTag;
    
    NSMutableDictionary *_dataSourceDictionary;
    
    BOOL _isManaging;
}

- (void)dealloc
{
    [XTNotificationCenter removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isSwitchAnimation = NO;
        _selectedTabItemButtonTag = XTTabItemButtonTagBase;
        
        _dataSourceDictionary = [NSMutableDictionary dictionary];
        
        _isManaging = NO;
        
        [XTNotificationCenter addObserver:self
                                 selector:@selector(lifePaymentSuccess)
                                     name:XTLifeServicePayDidSuccessNotification
                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"生活缴费";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    [self setRightBarButtonItem:@selector(addAccountButtonClicked) title:@"新增+"];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resetManageStatus];
}

#pragma mark - Button
- (void)backButtonClicked
{
    if (XTModuleShowModePush == [XTModulesManager sharedManager].mode) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addAccountButtonClicked
{
    XTLifePaymentAccountViewController *vc = [[XTLifePaymentAccountViewController alloc] init];
    vc.lifePaymentType = [self lifePaymentType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tabItemButtonClicked:(UIButton *)tabItemButton
{
    if (_isSwitchAnimation || _selectedTabItemButtonTag == tabItemButton.tag) {
        return;
    }
    
    [self resetManageStatus];
    
    _selectedTabItemButtonTag = tabItemButton.tag;
    [self switchTabWithTabItemButtonTag:_selectedTabItemButtonTag];
    
    [self requestData];
}

- (void)manageButtonClicked
{
    NSInteger index = _selectedTabItemButtonTag - XTTabItemButtonTagBase;
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    if (dataSource && dataSource.count > 0) {
        _isManaging = !_isManaging;
        
        UITableView *accountsTableView = self.accountsTableViewArray[index];
        [accountsTableView reloadData];
    }
}

#pragma mark - Notification
- (void)lifePaymentSuccess
{
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (NSInteger i = vcArray.count - 2; i > 0; i--) {
        UIViewController *vc = vcArray[i];
        if ([vc isKindOfClass:[self class]]) {
            break;
        } else {
            [vcArray removeObject:vc];
        }
    }
    [self.navigationController setViewControllers:vcArray];
    
    [self requestData];
}

#pragma mark - Private
- (void)initView
{
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.mainScrollView];
    
    [self switchTabWithTabItemButtonTag:_selectedTabItemButtonTag];
}

- (UIView *)generateTableHeaderView:(BOOL)isEmpty
{
    if (isEmpty) {
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:self.mainScrollView.bounds];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        
        UIButton *payButton = [XTAppUtils redButtonWithFrame:CGRectMake((CGRectGetWidth(tableHeaderView.bounds) - 120.0) / 2, CGRectGetHeight(tableHeaderView.bounds) / 3, 120.0, 40.0)];
        payButton.layer.masksToBounds = YES;
        payButton.layer.cornerRadius = 5.0;
        payButton.titleLabel.font = XTFont(14.0);
        [payButton setTitle:@"立即缴费" forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(addAccountButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [tableHeaderView addSubview:payButton];
        
        return tableHeaderView;
    } else {
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.mainScrollView.bounds), 50.0)];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 150.0, CGRectGetHeight(tableHeaderView.bounds))];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = XTFont(14.0);
        tipLabel.textColor = XTColorFromHex(0x999999);
        tipLabel.text = @"缴费账户";
        
        UIButton *manageButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(tableHeaderView.bounds) - 67.0, 0.0, 67.0, CGRectGetHeight(tableHeaderView.bounds))];
        manageButton.backgroundColor = [UIColor clearColor];
        manageButton.titleLabel.font = XTFont(14.0);
        [manageButton setTitleColor:XTBrandRedColor forState:UIControlStateNormal];
        [manageButton setTitleColor:[XTBrandRedColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        [manageButton setTitle:@"管理" forState:UIControlStateNormal];
        [manageButton addTarget:self action:@selector(manageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [tableHeaderView addSubview:tipLabel];
        [tableHeaderView addSubview:manageButton];
        
        return tableHeaderView;
    }
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
    
    [self.accountsTableViewArray enumerateObjectsUsingBlock:^(UITableView *accountsTableView, NSUInteger idx, BOOL *stop) {
        if (selectedIndex == idx) {
            accountsTableView.scrollsToTop = YES;
        } else {
            accountsTableView.scrollsToTop = NO;
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

- (XTLifePaymentType)lifePaymentType
{
    NSInteger index = _selectedTabItemButtonTag - XTTabItemButtonTagBase;
    if (index == 0) {
        return XTLifePaymentTypeWater;
    } else if (index == 1) {
        return XTLifePaymentTypeElectric;
    } else if (index == 2) {
        return XTLifePaymentTypeGas;
    } else {
        return XTLifePaymentTypeUnknown;
    }
}

- (void)requestData
{
    if (XTIsReachable) {
        [self showLoading];
        
        NSInteger index = _selectedTabItemButtonTag - XTTabItemButtonTagBase;
        UITableView *accountsTableView = self.accountsTableViewArray[index];
        
        NSString *phone = [XTModulesManager sharedManager].phone;
        NSString *accountType = nil;
        if (index == 0) {
            accountType = @"1";
        } else if (index == 1) {
            accountType = @"2";
        } else if (index == 2) {
            accountType = @"3";
        } else {
        }
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postQueryAccountsWithPhone:phone accountType:accountType completionHandler:^(NSArray<XTLifePaymentAccountModel> *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                _isManaging = NO;
                
                NSMutableArray *accountsArray = [NSMutableArray array];
                if (output && output.count > 0) {
                    [accountsArray addObjectsFromArray:output];
                }
                
                _dataSourceDictionary[@(index)] = accountsArray;
                accountsTableView.tableHeaderView = [weakSelf generateTableHeaderView:(accountsArray.count == 0)];
                [accountsTableView reloadData];
                
                [weakSelf scrollToTop:accountsTableView];
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (void)deleteAccountWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (XTIsReachable) {
        [self showLoading];
        
        NSInteger index = [self.accountsTableViewArray indexOfObject:tableView];
        NSArray *dataSource = _dataSourceDictionary[@(index)];
        XTLifePaymentAccountModel *accountModel = dataSource[indexPath.row];
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postDeleteAccountWithUUID:accountModel.uuid completionHandler:^(XTModuleObject *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                NSMutableArray *accountsArray = [NSMutableArray array];
                [accountsArray addObjectsFromArray:dataSource];
                [accountsArray removeObjectAtIndex:indexPath.row];
                _dataSourceDictionary[@(index)] = accountsArray;
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                tableView.tableHeaderView = [weakSelf generateTableHeaderView:(accountsArray.count == 0)];
                
                if (accountsArray.count == 0) {
                    [weakSelf resetManageStatus];
                }
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (void)scrollToTop:(UITableView *)tableView
{
    XTDispatchAsyncOnMainQueue({
        NSInteger index = [self.accountsTableViewArray indexOfObject:tableView];
        NSArray *dataSource = _dataSourceDictionary[@(index)];
        
        BOOL bShouldScroll = dataSource.count > 0;
        if (bShouldScroll) {
            [tableView scrollToRowAtIndexPath:XTIndexPath(0, 0)
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:NO];
        }
    })
}

- (void)showAccountDeleteAlert:(void (^)(BOOL isConfirm))block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        block(NO);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        block(YES);
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetManageStatus
{
    if (!_isManaging) {
        return;
    }
    
    NSInteger index = _selectedTabItemButtonTag - XTTabItemButtonTagBase;
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    if (dataSource && dataSource.count > 0) {
        _isManaging = NO;
        
        UITableView *accountsTableView = self.accountsTableViewArray[index];
        [accountsTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = [self.accountsTableViewArray indexOfObject:tableView];
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XTLifePaymentAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTLifePaymentAccountCellIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    cell.isManaging = _isManaging;
    
    NSInteger index = [self.accountsTableViewArray indexOfObject:tableView];
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    XTLifePaymentAccountModel *model = dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isSwitchAnimation) {
        if (_isManaging) {
            _isManaging = NO;
            [tableView reloadData];
        } else {
            NSInteger index = [self.accountsTableViewArray indexOfObject:tableView];
            NSArray *dataSource = _dataSourceDictionary[@(index)];
            XTLifePaymentAccountModel *accountModel = dataSource[indexPath.row];
            
            XTLifePaymentPayBillViewController *vc = [[XTLifePaymentPayBillViewController alloc] init];
            vc.lifePaymentType = [self lifePaymentType];
            vc.accountModel = accountModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - XTLifePaymentAccountCellDelegate
- (void)lifePaymentAccountCellDidClickEdit:(XTLifePaymentAccountCell *)lifePaymentAccountCell
{
    NSInteger index = _selectedTabItemButtonTag - XTTabItemButtonTagBase;
    UITableView *accountsTableView = self.accountsTableViewArray[index];
    NSIndexPath *indexPath = [accountsTableView indexPathForCell:lifePaymentAccountCell];
    NSArray *dataSource = _dataSourceDictionary[@(index)];
    XTLifePaymentAccountModel *accountModel = dataSource[indexPath.row];
    
    XTLifePaymentAccountViewController *vc = [[XTLifePaymentAccountViewController alloc] init];
    vc.lifePaymentType = [self lifePaymentType];
    vc.isEdit = YES;
    vc.accountModel = accountModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lifePaymentAccountCellDidClickDelete:(XTLifePaymentAccountCell *)lifePaymentAccountCell
{
    XTWeakSelf(weakSelf);
    [self showAccountDeleteAlert:^(BOOL isConfirm) {
        if (isConfirm) {
            NSInteger index = _selectedTabItemButtonTag - XTTabItemButtonTagBase;
            UITableView *accountsTableView = weakSelf.accountsTableViewArray[index];
            NSIndexPath *indexPath = [accountsTableView indexPathForCell:lifePaymentAccountCell];
            
            [weakSelf deleteAccountWithTableView:accountsTableView indexPath:indexPath];
        }
    }];
}

#pragma mark - Getter
- (UIView *)tabView
{
    if (!_tabView) {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTTabViewHeight)];
        _tabView.backgroundColor = [UIColor whiteColor];
        
        NSArray *buttonTitleArray = @[@"水费", @"电费", @"燃气费"];
        NSArray *buttonNormalImageNameArray = @[@"life_payment_water_gray", @"life_payment_electric_gray", @"life_payment_gas_gray"];
        NSArray *buttonSelectedImageNameArray = @[@"life_payment_water", @"life_payment_electric", @"life_payment_gas"];
        
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
            [tabItemButton setImage:[UIImage imageNamed:XTModulesSDKImage(buttonNormalImageNameArray[idx])] forState:UIControlStateNormal];
            [tabItemButton setImage:[UIImage imageNamed:XTModulesSDKImage(buttonSelectedImageNameArray[idx])] forState:UIControlStateSelected];
            tabItemButton.titleEdgeInsets = UIEdgeInsetsMake((tabItemButton.imageView.bounds.size.height + 8.0) / 2, -tabItemButton.imageView.bounds.size.width / 2, -(tabItemButton.imageView.bounds.size.height + 8.0) / 2, tabItemButton.imageView.bounds.size.width / 2);
            tabItemButton.imageEdgeInsets = UIEdgeInsetsMake(-(tabItemButton.titleLabel.bounds.size.height + 8.0) / 2, tabItemButton.titleLabel.bounds.size.width / 2, (tabItemButton.titleLabel.bounds.size.height + 8.0) / 2, -tabItemButton.titleLabel.bounds.size.width / 2);
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
        _mainScrollView.scrollEnabled = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(_mainScrollView.bounds) * self.tabItemButtonArray.count, CGRectGetHeight(_mainScrollView.bounds));
        [_mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        if (XTDeviceSystemVersion >= 11.0) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.accountsTableViewArray = [[NSMutableArray alloc] initWithCapacity:self.tabItemButtonArray.count];
        
        for (NSInteger index = 0; index < self.tabItemButtonArray.count; index++) {
            UITableView *accountsTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_mainScrollView.bounds) * index, 0.0, CGRectGetWidth(_mainScrollView.bounds), CGRectGetHeight(_mainScrollView.bounds)) style:UITableViewStylePlain];
            accountsTableView.backgroundColor = [UIColor clearColor];
            accountsTableView.dataSource = self;
            accountsTableView.delegate = self;
            accountsTableView.separatorColor = XTSeparatorColor;
            accountsTableView.tableHeaderView = [self generateTableHeaderView:YES];
            accountsTableView.tableFooterView = [[UIView alloc] init];
            [accountsTableView registerNib:XTModulesSDKNib(@"XTLifePaymentAccountCell") forCellReuseIdentifier:@"XTLifePaymentAccountCellIdentifier"];
            if (XTDeviceSystemVersion >= 11.0) {
                accountsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            [_mainScrollView addSubview:accountsTableView];
            [self.accountsTableViewArray addObject:accountsTableView];
        }
    }
    
    return _mainScrollView;
}

@end
