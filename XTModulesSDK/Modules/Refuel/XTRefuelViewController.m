//
//  XTRefuelViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/6.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelViewController.h"

#import "XTRefuelApi.h"
#import "XTRefuelCell.h"
#import "XTRoundCornerCell.h"
#import "XTBaseWebViewController.h"
#import "XTRefuelTicketsViewController.h"

typedef NS_ENUM(NSInteger, XTCountOperateType)
{
    XTCountOperateTypePlus = 0,
    XTCountOperateTypeMinus
};

@interface XTRefuelViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *refuelTableView;
@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *totalAmountLabel;

@property (nonatomic, strong) UIView *purchaseNoticeView;
@property (nonatomic, strong) UIView *instructionsView;
@property (nonatomic, strong) UIView *priceDescriptionView;

@property (nonatomic, strong) UIView *dataEmptyView;

@end

@implementation XTRefuelViewController
{
    NSArray *_refuelGoodsArray;
    
    NSMutableDictionary *_countDictionary;
    
    BOOL _isPurchaseNoticeFold;   // 购买须知是否是折叠状态
    BOOL _isInstructionsFold;     // 使用说明是否是折叠状态
    BOOL _isPriceDescriptionFold; // 价格说明是否是折叠状态
}

- (void)dealloc
{
    [XTNotificationCenter removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _countDictionary = [NSMutableDictionary dictionary];
        
        _isPurchaseNoticeFold = YES;
        _isInstructionsFold = YES;
        _isPriceDescriptionFold = YES;
        
        [XTNotificationCenter addObserver:self
                                 selector:@selector(refuelSuccess)
                                     name:XTLifeServicePayDidSuccessNotification
                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"特惠加油";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    [self setRightBarButtonItem:@selector(ticketsButtonClicked) title:@"我的油券"];
    
    [self initView];
    
    [self requestRefuelGoods];
}

- (void)backButtonClicked
{
    if (XTModuleShowModePush == [XTModulesManager sharedManager].mode) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)ticketsButtonClicked
{
    XTRefuelTicketsViewController *vc = [[XTRefuelTicketsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)purchaseButtonClicked
{
    if ([[_countDictionary allKeys] count] > 0) {
        if (XTIsReachable) {
            [self showLoading];
            
            NSMutableArray *goodsList = [NSMutableArray array];
            [[_countDictionary allKeys] enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *goodsDict = [NSMutableDictionary dictionary];
                
                goodsDict[@"num"] = [NSString stringWithFormat:@"%@", _countDictionary[indexPath]];
                
                XTRefuelGoodsModel *model = _refuelGoodsArray[indexPath.row];
                goodsDict[@"ruleId"] = model.goodsId;
                goodsDict[@"goodsname"] = model.goodsName;
                
                [goodsList addObject:goodsDict];
            }];
            
            XTWeakSelf(weakSelf);
            [[XTRefuelApi sharedAPI] postGetCouponAccountWithPhone:[XTModulesManager sharedManager].phone goodList:goodsList completionHandler:^(XTRefuelOrderModel *output, NSError *error) {
                [weakSelf hideLoading];
                
                if (!error) {
                    NSLog(@"orderId: %@", output.orderId);
                }
            }];
        } else {
            [self showToastWithText:XTNetworkUnavailable];
        }
    } else {
        [self showToastWithText:@"您还没有选择商品"];
    }
}

- (void)nearbyButtonClicked
{
    XTBaseWebViewController *vc = [[XTBaseWebViewController alloc] init];
    vc.shouldIgnoreCache = YES;
    vc.shouldShowNetworkUnavailableView = YES;
    vc.urlString = @"https://api.xtszkj.com/v1/redirection?pageId=100001";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification
- (void)refuelSuccess
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
    
    [_countDictionary removeAllObjects];
    
    _isPurchaseNoticeFold = YES;
    _isInstructionsFold = YES;
    _isPriceDescriptionFold = YES;
    
    [self.refuelTableView reloadData];
    
    self.totalAmountLabel.text = @"¥ 0.00";
}

#pragma mark - Private
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.bottomView addSubview:self.totalAmountLabel];
    
    [self.view addSubview:self.refuelTableView];
    [self.view addSubview:self.bottomView];
}

- (void)requestRefuelGoods
{
    self.refuelTableView.hidden = YES;
    self.bottomView.hidden = YES;
    
    if (XTIsReachable) {
        [self showLoading];
        
        XTWeakSelf(weakSelf);
        [[XTRefuelApi sharedAPI] postQueryCouponWithCompletionHandler:^(NSArray<XTRefuelGoodsModel> *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                _refuelGoodsArray = [NSArray arrayWithArray:output];
                
                if (_refuelGoodsArray.count > 0) {
                    weakSelf.totalAmountLabel.text = @"¥ 0.00";

                    weakSelf.refuelTableView.hidden = NO;
                    weakSelf.bottomView.hidden = NO;
                    
                    [weakSelf.refuelTableView reloadData];
                } else {
                    [weakSelf.view addSubview:weakSelf.dataEmptyView];
                    [weakSelf.view bringSubviewToFront:weakSelf.dataEmptyView];
                    weakSelf.dataEmptyView.hidden = NO;
                }
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

- (void)totalAmountChangeWithCountOperateType:(XTCountOperateType)type indexPath:(NSIndexPath *)indexPath
{
    if (XTCountOperateTypePlus == type) {
        NSInteger count = [_countDictionary[indexPath] integerValue] + 1;
        _countDictionary[indexPath] = @(count);
    } else {
        NSInteger count = [_countDictionary[indexPath] integerValue] - 1;
        if (count > 0) {
            _countDictionary[indexPath] = @(count);
        } else {
            [_countDictionary removeObjectForKey:indexPath];
        }
    }
    
    CGFloat totalAmount = [self calculateTotalAmount];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"¥ %.2f", totalAmount];
}

- (CGFloat)calculateTotalAmount
{
    CGFloat totalAmount = 0.0;
    
    for (NSIndexPath *indexPath in [_countDictionary allKeys]) {
        XTRefuelGoodsModel *model = [_refuelGoodsArray objectAtIndex:indexPath.row];
        totalAmount += [model.amount floatValue] * [_countDictionary[indexPath] integerValue];
    }
    
    return totalAmount;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _refuelGoodsArray.count;
    } else {
        if (_isPriceDescriptionFold) {
            return 5;
        } else {
            return 6;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        XTRefuelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XTRefuelCellIdentifier" forIndexPath:indexPath];
        
        XTWeakSelf(weakSelf);
        [cell setCountPlusBlock:^{
            [weakSelf totalAmountChangeWithCountOperateType:XTCountOperateTypePlus indexPath:indexPath];
        }];
        [cell setCountMinusBlock:^{
            [weakSelf totalAmountChangeWithCountOperateType:XTCountOperateTypeMinus indexPath:indexPath];
        }];
        cell.model = _refuelGoodsArray[indexPath.row];
        
        cell.countLabel.text = [NSString stringWithFormat:@"%@", _countDictionary[indexPath]];
        if ([[_countDictionary allKeys] containsObject:indexPath]) {
            cell.minusButton.hidden = NO;
            cell.countLabel.hidden = NO;
        } else {
            cell.minusButton.hidden = YES;
            cell.countLabel.hidden = YES;
        }
        
        return cell;
    } else {
        XTRoundCornerCell *cell = (XTRoundCornerCell *)[tableView dequeueReusableCellWithIdentifier:XTRoundCornerCellIdentifier];
        if (!cell) {
            cell = [[XTRoundCornerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XTRoundCornerCellIdentifier];
        }
        
        BOOL isFirstRow = (indexPath.row == 0);
        BOOL isLastRow = (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1);
        CGFloat offsetY = 0.0;
        
        if (isFirstRow) {
            // 第一行
            cell.roundCornerCellType = XTRoundCornerCellTypeTop;
            
            offsetY = XTCellShadowMarginVertical;
        } else if (isLastRow) {
            // 最后一行
            cell.roundCornerCellType = XTRoundCornerCellTypeBottom;
        } else {
            // 中间行
            cell.roundCornerCellType = XTRoundCornerCellTypeMiddle;
        }
        
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        if (indexPath.row % 2 == 0) {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, offsetY, 200.0, 50.0)];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = XTFont(14.0);
            textLabel.textColor = XTBrandBlackColor;
            
            UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tableView.bounds) - 25.0 - 6.5, 19.0 + offsetY, 6.5, 12.0)];
            indicatorImageView.backgroundColor = [UIColor clearColor];
            indicatorImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"more_indicator")];
            
            [cell.contentView addSubview:textLabel];
            [cell.contentView addSubview:indicatorImageView];
            
            switch (indexPath.row) {
                case 0:
                {
                    textLabel.text = @"购买须知";
                    indicatorImageView.transform = CGAffineTransformMakeRotation((_isPurchaseNoticeFold ? 0.0 : M_PI_2));
                    
                    cell.separatorHidden = !_isPurchaseNoticeFold;
                }
                    break;
                case 2:
                {
                    textLabel.text = @"使用说明";
                    indicatorImageView.transform = CGAffineTransformMakeRotation((_isInstructionsFold ? 0.0 : M_PI_2));
                    
                    cell.separatorHidden = !_isInstructionsFold;
                }
                    break;
                case 4:
                {
                    textLabel.text = @"价格说明";
                    indicatorImageView.transform = CGAffineTransformMakeRotation((_isPriceDescriptionFold ? 0.0 : M_PI_2));
                    
                    cell.separatorHidden = !_isPriceDescriptionFold;
                }
                    break;
                    
                default:
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 1:
                {
                    if (!_isPurchaseNoticeFold) {
                        [cell.contentView addSubview:self.purchaseNoticeView];
                    }
                    
                    cell.separatorHidden = _isPurchaseNoticeFold;
                }
                    break;
                case 3:
                {
                    if (!_isInstructionsFold) {
                        [cell.contentView addSubview:self.instructionsView];
                    }
                    
                    cell.separatorHidden = _isInstructionsFold;
                }
                    break;
                case 5:
                {
                    if (!_isPriceDescriptionFold) {
                        [cell.contentView addSubview:self.priceDescriptionView];
                    }
                    
                    cell.separatorHidden = _isPriceDescriptionFold;
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.0;
    } else {
        CGFloat rowHeight = 0.0;
        
        switch (indexPath.row) {
            case 0:
                rowHeight = 50.0 + XTCellShadowMarginVertical;
                break;
            case 1:
            {
                if (!_isPurchaseNoticeFold) {
                    rowHeight = CGRectGetHeight(self.purchaseNoticeView.bounds);
                }
            }
                break;
            case 2:
                rowHeight = 50.0;
                break;
            case 3:
            {
                if (!_isInstructionsFold) {
                    rowHeight = CGRectGetHeight(self.instructionsView.bounds);
                }
            }
                break;
            case 4:
            {
                if (!_isPriceDescriptionFold) {
                    rowHeight = 50.0;
                } else {
                    rowHeight = 50.0 + XTCellShadowMarginVertical;
                }
            }
                break;
            case 5:
            {
                if (!_isPriceDescriptionFold) {
                    rowHeight = CGRectGetHeight(self.priceDescriptionView.bounds) + XTCellShadowMarginVertical;
                }
            }
                break;
                
            default:
                break;
        }
        
        return rowHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XTRefuelVCHFIDHeaderSection"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"XTRefuelVCHFIDHeaderSection"];
        view.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return 5.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XTRefuelVCHFIDFooterSection"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"XTRefuelVCHFIDFooterSection"];
        view.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row % 2 == 0) {
            switch (indexPath.row) {
                case 0:
                    _isPurchaseNoticeFold = !_isPurchaseNoticeFold;
                    break;
                case 2:
                    _isInstructionsFold = !_isInstructionsFold;
                    break;
                case 4:
                    _isPriceDescriptionFold = !_isPriceDescriptionFold;
                    break;
                    
                default:
                    break;
            }
            
            [self.refuelTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - Getter
- (UITableView *)refuelTableView
{
    if (!_refuelTableView) {
        _refuelTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight - 49.0) style:UITableViewStyleGrouped];
        _refuelTableView.backgroundColor = [UIColor clearColor];
        _refuelTableView.dataSource = self;
        _refuelTableView.delegate = self;
        _refuelTableView.separatorColor = [UIColor clearColor];
        _refuelTableView.tableHeaderView = self.tableHeaderView;
        _refuelTableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _refuelTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_refuelTableView registerNib:[UINib nibWithNibName:XTModulesSDKResource(@"XTRefuelCell") bundle:nil] forCellReuseIdentifier:@"XTRefuelCellIdentifier"];
        _refuelTableView.hidden = YES;
    }
    
    return _refuelTableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.refuelTableView.bounds), ([[UIScreen mainScreen] scale] > 2.99 ? 160.0 : 145.0) + 44.0)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
        
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_tableHeaderView.bounds), [[UIScreen mainScreen] scale] > 2.99 ? 160.0 : 145.0)];
        bannerImageView.backgroundColor = [UIColor clearColor];
        bannerImageView.clipsToBounds = YES;
        bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        bannerImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_banner")];
        
        CGFloat titleWidth = [XTAppUtils sizeOfString:@"附近加油站"
                                                 font:XTFont(14.0)
                                    constrainedToSize:CGSizeMake(200.0, 25.0)].width;
        CGFloat buttonWidth = titleWidth + 5.0 + 14.0;
        
        UIButton *nearbyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_tableHeaderView.bounds) - 15.0 - buttonWidth, CGRectGetMaxY(bannerImageView.frame) + 12.0, buttonWidth, 25.0)];
        nearbyButton.backgroundColor = [UIColor clearColor];
        nearbyButton.adjustsImageWhenHighlighted = NO;
        nearbyButton.titleLabel.font = XTFont(14.0);
        [nearbyButton setTitleColor:XTBrandBlueColor forState:UIControlStateNormal];
        [nearbyButton setTitle:@"附近加油站" forState:UIControlStateNormal];
        [nearbyButton setImage:[UIImage imageNamed:XTModulesSDKImage(@"refuel_nearby_station")] forState:UIControlStateNormal];
        [nearbyButton addTarget:self action:@selector(nearbyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        nearbyButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleWidth + 2.5, 0.0, -(titleWidth + 2.5));
        nearbyButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -(14.0 + 2.5), 0.0, 14.0 + 2.5);
        
        [_tableHeaderView addSubview:bannerImageView];
        [_tableHeaderView addSubview:nearbyButton];
    }
    
    return _tableHeaderView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.refuelTableView.frame), XTMainScreenWidth, 49.0)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
        
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 14.0, 46.0, 24.0)];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.font = XTFont(14.0);
        totalLabel.textColor = XTColorFromHex(0x666666);
        totalLabel.text = @"合计：";
        
        UILabel *totalAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame), 0.0, CGRectGetWidth(_bottomView.bounds) - CGRectGetMaxX(totalLabel.frame) - 120.0 - 15.0, CGRectGetHeight(_bottomView.bounds))];
        totalAmountLabel.backgroundColor = [UIColor clearColor];
        totalAmountLabel.font = XTFont(24.0);
        totalAmountLabel.textColor = XTBrandRedColor;
        totalAmountLabel.text = @"¥ 0.00";
        self.totalAmountLabel = totalAmountLabel;
        
        UIButton *purchaseButton = [XTAppUtils redButtonWithFrame:CGRectMake(CGRectGetWidth(_bottomView.bounds) - 120.0, 0.0, 120.0, 49.0)];
        [purchaseButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [purchaseButton addTarget:self action:@selector(purchaseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, -0.5, CGRectGetWidth(_bottomView.bounds), 0.5)];
        topLine.backgroundColor = XTSeparatorColor;
        
        [_bottomView addSubview:totalLabel];
        [_bottomView addSubview:self.totalAmountLabel];
        [_bottomView addSubview:purchaseButton];
        [_bottomView addSubview:topLine];
    }
    
    return _bottomView;
}

- (UIView *)purchaseNoticeView
{
    if (!_purchaseNoticeView) {
        NSString *purchaseNotice = @"1、此电子券由中国石油天然气股份有限公司辽宁销售分公司发行，在所属指定加油站通用（仅限辽宁省内使用）。\n\n2、此卡不记名，有效期自购买之日起3年，不挂失补办和退卡、不找零、不兑现，请勿将二维码泄露给他人，因保管不当造成损失后果自负。\n\n3、此卡200元(含)面值以下一次性核销。\n\n4、可以一次购买一张或者多张电子券，可多张叠加使用，不找零。\n\n5、可使用右上角“附近加油站”功能查看可使用的加油站。如遇到不能使用的情况请拨打客服电话400-024-0700";
        CGFloat height = [XTAppUtils sizeOfString:purchaseNotice font:XTFont(12.0) constrainedToSize:CGSizeMake(CGRectGetWidth(self.refuelTableView.bounds) - 50.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height + 10.0;
        _purchaseNoticeView = [[UIView alloc] initWithFrame:CGRectMake(25.0, 0.0, CGRectGetWidth(self.refuelTableView.bounds) - 50.0, height)];
        _purchaseNoticeView.backgroundColor = [UIColor clearColor];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, CGRectGetWidth(_purchaseNoticeView.bounds), CGRectGetHeight(_purchaseNoticeView.bounds) - 10.0)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.font = XTFont(12.0);
        contentLabel.textColor = XTBrandLightBlackColor;
        contentLabel.text = purchaseNotice;
        
        [_purchaseNoticeView addSubview:contentLabel];
    }
    
    return _purchaseNoticeView;
}

- (UIView *)instructionsView
{
    if (!_instructionsView) {
        CGFloat height = 190.0 * (CGRectGetWidth(self.refuelTableView.bounds) - 60.0) / 157.0 + 20.0;
        _instructionsView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 0.0, CGRectGetWidth(self.refuelTableView.bounds) - 30.0, height)];
        _instructionsView.backgroundColor = [UIColor clearColor];
        
        CGFloat imageWidth = (CGRectGetWidth(_instructionsView.bounds) - 30.0) / 2;
        CGFloat imageHeight = 190.0 * imageWidth / 157.0;
        
        for (NSInteger i = 0; i < 4; i++) {
            NSInteger row = i / 2;
            NSInteger column = i % 2;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((10.0 + imageWidth) * column + 10.0, (5.0 + imageHeight + 5.0) * row + 5.0, imageWidth, imageHeight)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.layer.shadowColor = [UIColor blackColor].CGColor;
            imageView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            imageView.layer.shadowOpacity = 0.1;
            imageView.layer.shadowRadius = 5.0;
            NSString *name = [NSString stringWithFormat:@"refuel_instruction0%i", (int)(i + 1)];
            imageView.image = [UIImage imageNamed:XTModulesSDKImage(name)];
            
            [_instructionsView addSubview:imageView];
        }
    }
    
    return _instructionsView;
}

- (UIView *)priceDescriptionView
{
    if (!_priceDescriptionView) {
        NSString *priceDescription = @"面值：指加油券的价值数额。\n\n折扣：如无特殊说明，折扣指加油券面值基础上计算出的优惠比例或优惠金额；如有疑问，您可在购买前联系客服进行咨询。\n\n异常问题：具体的成交价格可能因用户使用优惠券产生变化，最终价格以订单结算价为准。";
        CGFloat height = [XTAppUtils sizeOfString:priceDescription font:XTFont(12.0) constrainedToSize:CGSizeMake(CGRectGetWidth(self.refuelTableView.bounds) - 50.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height + 10.0;
        _priceDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(25.0, 0.0, CGRectGetWidth(self.refuelTableView.bounds) - 50.0, height)];
        _priceDescriptionView.backgroundColor = [UIColor clearColor];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, CGRectGetWidth(_priceDescriptionView.bounds), CGRectGetHeight(_priceDescriptionView.bounds) - 10.0)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.font = XTFont(12.0);
        contentLabel.textColor = XTBrandLightBlackColor;
        contentLabel.text = priceDescription;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:priceDescription];
        [attributedText addAttributes:@{NSForegroundColorAttributeName : XTBrandRedColor} range:NSMakeRange(0, 2)];
        [attributedText addAttributes:@{NSForegroundColorAttributeName : XTBrandRedColor} range:NSMakeRange(15, 2)];
        [attributedText addAttributes:@{NSForegroundColorAttributeName : XTBrandRedColor} range:NSMakeRange(72, 4)];
        contentLabel.attributedText = attributedText;
        
        [_priceDescriptionView addSubview:contentLabel];
    }
    
    return _priceDescriptionView;
}

- (UIView *)dataEmptyView
{
    if (!_dataEmptyView) {
        _dataEmptyView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight)];
        _dataEmptyView.backgroundColor = XTViewBGColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_dataEmptyView.bounds) - 74.0) / 2, (CGRectGetHeight(_dataEmptyView.bounds) - 128.0) / 2, 74.0, 91.0)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:XTModulesSDKImage(@"data_empty")];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(imageView.frame) + 16.0, CGRectGetWidth(_dataEmptyView.bounds), 21.0)];
        label.backgroundColor = [UIColor clearColor];
        label.font = XTFont(17.0);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = XTColorFromHex(0x666666);
        label.text = @"暂无内容";
        
        [_dataEmptyView addSubview:imageView];
        [_dataEmptyView addSubview:label];
    }
    
    return _dataEmptyView;
}

@end
