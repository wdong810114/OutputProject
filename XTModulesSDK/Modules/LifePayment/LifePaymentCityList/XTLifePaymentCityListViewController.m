//
//  XTLifePaymentCityListViewController.m
//  XTModulesSDK
//
//  Created by wdd on 2019/8/20.
//  Copyright © 2019年 Newsky Payment. All rights reserved.
//

#import "XTLifePaymentCityListViewController.h"

#import "XTLifePaymentApi.h"
#import "XTLifePaymentCityListSupplementaryHeaderView.h"
#import "XTLifePaymentCityListItemCell.h"

@interface XTLifePaymentCityListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@end

@implementation XTLifePaymentCityListViewController
{
    NSArray *_cityArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"城市列表";
    [self setLeftBarButtonItem:@selector(backButtonClicked) image:@"back_icon_n" highlightedImage:@"back_icon_h"];
    
    [self.view addSubview:self.mainCollectionView];
    
    [self requestCities];
}

#pragma mark - Button
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private
- (void)requestCities
{
    if (XTIsReachable) {
        [self showLoading];
        
        NSString *companyType = XTCompanyTypeFromLifePaymentType(self.lifePaymentType);
        
        XTWeakSelf(weakSelf);
        [[XTLifePaymentApi sharedAPI] postGetCitiesWithCompanyType:companyType completionHandler:^(NSArray<XTLifePaymentCityModel> *output, NSError *error) {
            [weakSelf hideLoading];
            
            if (!error) {
                if (output && output.count > 0) {
                    _cityArray = [NSArray arrayWithArray:output];
                    
                    [self.mainCollectionView reloadData];
                }
            }
        }];
    } else {
        [self showToastWithText:XTNetworkUnavailable];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTLifePaymentCityListItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XTLifePaymentCityListItemCellIdentifier" forIndexPath:indexPath];
    
    XTLifePaymentCityModel *model = _cityArray[indexPath.item];
    cell.cityLabel.text = model.cityName;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XTLifePaymentCityListSupplementaryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"XTLifePaymentCityListSupplementaryHeaderViewIdentifier" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"已开通城市";
        }
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lifePaymentCityListViewController:didSelectCityModel:)]) {
        XTLifePaymentCityModel *cityModel = _cityArray[indexPath.item];
        [self.delegate lifePaymentCityListViewController:self didSelectCityModel:cityModel];
    }
}

#pragma mark - Getter
- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(XTMainScreenWidth, 50.0);
        layout.sectionInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
        layout.minimumInteritemSpacing = 10.0;
        layout.minimumLineSpacing = 10.0;
        layout.itemSize = CGSizeMake((XTMainScreenWidth - 60.0) / 4, 40.0);
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, XTMainScreenWidth, XTNonTopLevelViewHeight) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.alwaysBounceVertical = YES;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        [_mainCollectionView registerNib:XTModulesSDKNib(@"XTLifePaymentCityListSupplementaryHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XTLifePaymentCityListSupplementaryHeaderViewIdentifier"];
        [_mainCollectionView registerNib:XTModulesSDKNib(@"XTLifePaymentCityListItemCell") forCellWithReuseIdentifier:@"XTLifePaymentCityListItemCellIdentifier"];
    }
    
    return _mainCollectionView;
}

@end
