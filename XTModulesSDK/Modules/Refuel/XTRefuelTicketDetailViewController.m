//
//  XTRefuelTicketDetailViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/9.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTRefuelTicketDetailViewController.h"

#import "XTRefuelApi.h"

@interface XTRefuelTicketDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation XTRefuelTicketDetailViewController
{
    XTRefuelTicketModel *_model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"加油券详情";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    
    [self.view addSubview:self.mainTableView];
    
    [self requestData];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private
- (void)requestData
{
    if (XTIsReachable) {
        [self showLoading];
        
        XTWeakSelf(weakSelf);
        [[XTRefuelApi sharedAPI] postQueryAccountCouponOrderinfoWithTicketId:self.ticketId completionHandler:^(NSArray<XTRefuelTicketModel> *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                if (output && output.count > 0) {
                    _model = output[0];
                    
                    weakSelf.mainTableView.tableHeaderView = self.tableHeaderView;
                    [weakSelf.mainTableView reloadData];
                    weakSelf.mainTableView.hidden = NO;
                }
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_model.status integerValue] == 3) {
        return 5;
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *XTRefuelTicketDetailCellIdentifier = @"XTRefuelTicketDetailCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:XTRefuelTicketDetailCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:XTRefuelTicketDetailCellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = XTFont(14.0);
        cell.textLabel.textColor = XTBrandBlackColor;
        cell.detailTextLabel.font = XTFont(14.0);
        cell.detailTextLabel.textColor = XTBrandGrayColor;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"订单编号";
            cell.detailTextLabel.text = _model.orderId;
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"券号";
            cell.detailTextLabel.text = _model.ticketId;
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"有效期至";
            if ([_model.endTime longLongValue] != 0) {
                cell.detailTextLabel.text = [XTAppUtils formatYMDWithTimestamp:[_model.endTime longLongValue]];
            } else {
                cell.detailTextLabel.text = @"长期有效";
            }
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"使用日期";
            cell.detailTextLabel.text = [XTAppUtils formatYMDHMWithTimestamp:[_model.usedTime longLongValue]];
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"使用地点";
            cell.detailTextLabel.text = _model.usedStation;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

#pragma mark - Getter
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorColor = XTSeparatorColor;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        if (XTDeviceSystemVersion >= 11.0) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _mainTableView.hidden = YES;
    }
    
    return _mainTableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.mainTableView.bounds), 170.0)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *ticketNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, CGRectGetWidth(_tableHeaderView.bounds), 20.0)];
        ticketNameLabel.backgroundColor = [UIColor clearColor];
        ticketNameLabel.font = XTFont(14.0);
        ticketNameLabel.textAlignment = NSTextAlignmentCenter;
        ticketNameLabel.textColor = XTBrandBlackColor;
        ticketNameLabel.text = self.ticketName;
        
        UIImageView *qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_tableHeaderView.bounds) - 100.0) / 2, 50.0, 100.0, 100.0)];
        qrCodeImageView.backgroundColor = [UIColor clearColor];
        qrCodeImageView.layer.borderColor = XTBrandGrayColor.CGColor;
        qrCodeImageView.layer.borderWidth = 1.0;
        if ([_model.status integerValue] == 3) {
            qrCodeImageView.image = [UIImage imageNamed:XTModulesSDKImage(@"refuel_ticket_used_qrcode")];
        } else {
            NSData *rawData = [[NSData alloc] initWithBase64EncodedString:_model.wbmp options:NSDataBase64DecodingIgnoreUnknownCharacters];
            qrCodeImageView.image = [UIImage imageWithData:rawData];
        }
        
        [_tableHeaderView addSubview:ticketNameLabel];
        [_tableHeaderView addSubview:qrCodeImageView];
    }
    
    return _tableHeaderView;
}

@end
