//
//  CollectionViewController.m
//  Cocoa_Test
//
//  Created by feii on 17/3/13.
//  Copyright © 2017年 feii. All rights reserved.
//

#import "CollectionViewController.h"
#import "SpaceFooterView.h"
#import "SpaceTeamCell.h"
#import "STCollectionViewFlowLayout.h"
#import "UIColor+Util.h"
#import "CALayerViewController.h"

@interface CollectionViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) NSMutableArray *arrayData;

//团队风采
@property (nonatomic, strong) SpaceFooterView *footerView;

//团队风采Collection View
@property (nonatomic, strong) UICollectionView *teamView;

@property (nonatomic, strong) UIView *leftEffectView;

@property (nonatomic, strong) UIView *rightEffectView;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeOne;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeTwo;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeOne;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeTwo;

@property (nonatomic, assign) CGPoint offset;

@end

@implementation CollectionViewController

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";
static float     const cellWidth = 30;
static NSString *TeamCell = @"teamCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Collection";
    
    
    _leftSwipeOne = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToLeft:)];
    _leftSwipeOne.direction = UISwipeGestureRecognizerDirectionLeft;
    
    _leftSwipeTwo = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToLeft:)];
    _leftSwipeTwo.direction = UISwipeGestureRecognizerDirectionLeft;
    
    _rightSwipeOne = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToRight:)];
    _rightSwipeOne.direction = UISwipeGestureRecognizerDirectionRight;
    
    _rightSwipeTwo = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToRight:)];
    _rightSwipeTwo.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addSubview:self.footerView];

    
}

- (void)swipeToLeft:(UISwipeGestureRecognizer *)gesture {
    
    if (gesture.view.tag == 0) {
        NSLog(@"左侧view");
        NSIndexPath *targetIndexPath = [self calculateTargetIndexPath:gesture];
        [_teamView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    if (gesture.view.tag == 1) {
        NSLog(@"右侧view");
        NSIndexPath *targetIndexPath = [self calculateTargetIndexPath:gesture];
        [_teamView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)swipeToRight:(UISwipeGestureRecognizer *)gesture {
    
    NSIndexPath *targetIndexPath = [self calculateTargetIndexPath:gesture];
    [_teamView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (NSIndexPath *)calculateTargetIndexPath:(UISwipeGestureRecognizer *)gesture {
    
    CGFloat offsetX = _offset.x;
    
    CGRect visibleRect = CGRectMake(offsetX, 0, SCREEN_WIDTH, 140);
    CGFloat midX = CGRectGetMidX(visibleRect);
    
    __block CGFloat minX;
    __block NSUInteger index;
    NSArray *attrs = [_teamView.collectionViewLayout layoutAttributesForElementsInRect:visibleRect];
    [attrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat distance = midX - attribute.center.x;
        if (distance < 0) {
            distance = -distance;
        }
        
        if (idx == 0) {
            minX = distance;
            index = idx;
        } else {
            if (minX > distance) {
                minX = distance;
                index = idx;
            }
        }
    }];
    
    UICollectionViewLayoutAttributes *itemAttr = attrs[index];
    NSIndexPath *currentIndexPath = itemAttr.indexPath;
    
    NSIndexPath *targetIndexPath;
    if (UISwipeGestureRecognizerDirectionLeft == gesture.direction) {
        if (currentIndexPath.row == self.arrayData.count - 1) {
            targetIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row inSection:0];
        } else {
            targetIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:0];
        }
    } else {
        targetIndexPath = [NSIndexPath indexPathForRow:(currentIndexPath.row <= 0 ? 0 : currentIndexPath.row - 1) inSection:0];
    }
    
    return targetIndexPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- UICollectionViewDataSource

#pragma mark /********************** collection view delegate and datasource ************************/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.arrayData.count;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 140);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SpaceTeamCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeamCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.nameLabel.text = @"name";
    cell.headImgView.image = [UIImage imageNamed:@"forth"];
    cell.headImgView.backgroundColor = [UIColor blackColor];
    cell.jobLabel.text = @"jobLabel";
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > 0) {
        _offset = scrollView.contentOffset;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CALayerViewController *view = [[CALayerViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
    
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return self.arrayData.count;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor purpleColor];
//    
//    return cell;
//}
//
//// 和UITableView类似，UICollectionView也可设置段头段尾
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
//        if(headerView == nil)
//        {
//            headerView = [[UICollectionReusableView alloc] init];
//        }
//        headerView.backgroundColor = [UIColor blackColor];
//        
//        return headerView;
//    }
//    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
//    {
//        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
//        if(footerView == nil)
//        {
//            footerView = [[UICollectionReusableView alloc] init];
//        }
//        footerView.backgroundColor = [UIColor redColor];
//        
//        return footerView;
//    }
//    
//    return nil;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
//{
//    
//}




#pragma mark ---- UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return (CGSize){cellWidth,cellWidth};
//}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5.f;
//}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5.f;
//}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return (CGSize){SCREEN_WIDTH,44};
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return (CGSize){SCREEN_WIDTH,22};
//}




#pragma mark ---- UICollectionViewDelegate

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//// 点击高亮
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
//}
//
//
//// 选中某item
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//
//// 长按某item，弹出copy和paste的菜单
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//// 使copy和paste有效
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
//    {
//        return YES;
//    }
//    
//    return NO;
//}
//
////
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
//    {
//        //        NSLog(@"-------------执行拷贝-------------");
//        [collectionView performBatchUpdates:^{
//            [self.arrayData removeObjectAtIndex:indexPath.row];
//            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        } completion:nil];
//    }
//    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
//    {
//        NSLog(@"-------------执行添加-------------");
//        [collectionView performBatchUpdates:^{
//            // 构造一个indexPath
//            NSIndexPath *indePath = [NSIndexPath indexPathForItem:self.arrayData.count inSection:0];
//            [collectionView insertItemsAtIndexPaths:@[indePath]]; // 然后在此indexPath处插入给collectionView插入一个item
//            [self.arrayData addObject:@"x"]; // 保持collectionView的item和数据源一致
//        } completion:nil];
//    }
//}
//
#pragma mark /***懒加载***/

//- (UICollectionView*)mainCollection{
//    
//    if (_mainCollection == nil) {
//        
//        CustomCollectionViewFlowLayout *layout = [[CustomCollectionViewFlowLayout alloc]init];
//        layout.itemSize = CGSizeMake(120, 120);
//        layout.minimumInteritemSpacing = 5.0f;
//        layout.minimumLineSpacing = 5.0f;
//        layout.sectionInset = UIEdgeInsetsMake(-10.f, 10.f, 5.f, 10.f);
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        
//        _mainCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 120) collectionViewLayout:layout];
//        _mainCollection.backgroundColor = [UIColor grayColor];
//        _mainCollection.delegate = self;
//        _mainCollection.dataSource = self;
//        
//        // 注册cell、sectionHeader、sectionFooter
//        [_mainCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
////        [_mainCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
////        [_mainCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
//        
//    }
//    
//    return _mainCollection;
//}

- (NSMutableArray*)arrayData{
    
    if (_arrayData==nil) {
        _arrayData = [[NSMutableArray alloc]initWithCapacity:5];
        [_arrayData addObject:@""];
        [_arrayData addObject:@""];
        [_arrayData addObject:@""];
        [_arrayData addObject:@""];
        [_arrayData addObject:@""];
        [_arrayData addObject:@""];
        [_arrayData addObject:@""];
        [_arrayData addObject:@""];
    }
    
    return _arrayData;
    
}

- (SpaceFooterView *)footerView {
    
    if (!_footerView) {
        _footerView = [[SpaceFooterView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 230.0f)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        STCollectionViewFlowLayout *flowLayout = [[STCollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection : UICollectionViewScrollDirectionHorizontal];
        
        _teamView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, 155.0f) collectionViewLayout:flowLayout];
        _teamView.backgroundColor = [UIColor whiteColor];
        _teamView.delegate = self;
        _teamView.dataSource = self;
        _teamView.showsHorizontalScrollIndicator = NO;
        _teamView.alwaysBounceHorizontal = YES;
        _teamView.alwaysBounceVertical = NO;
        [_teamView registerClass:[SpaceTeamCell class] forCellWithReuseIdentifier:TeamCell];
        
        [_footerView addSubview:_teamView];
        
        _leftEffectView = [[UIView alloc]init];
        _leftEffectView.tag = 0;
        _leftEffectView.userInteractionEnabled = YES;
        _leftEffectView.gestureRecognizers = @[_leftSwipeOne, _rightSwipeOne];
        _leftEffectView.frame = CGRectMake(0, 45, (SCREEN_WIDTH - 100) / 2, 155);
        [_leftEffectView.layer addSublayer:[self shadowAsInverse:CGRectMake(0, 0, _leftEffectView.frame.size.width, _leftEffectView.frame.size.height) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0) tag:0]];
        //        [_footerView addSubview:_leftEffectView];
        
        _rightEffectView = [[UIView alloc]init];
        _rightEffectView.tag = 1;
        _rightEffectView.userInteractionEnabled = YES;
        _rightEffectView.gestureRecognizers = @[_rightSwipeTwo, _leftSwipeTwo];
        _rightEffectView.frame = CGRectMake((SCREEN_WIDTH - 100) / 2 + 100, 45, (SCREEN_WIDTH - 100) / 2, 155);
        [_rightEffectView.layer addSublayer:[self shadowAsInverse:CGRectMake(0, 0, _rightEffectView.frame.size.width, _rightEffectView.frame.size.height) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0) tag:1]];
        //        [_footerView addSubview:_rightEffectView];
    }
    return _footerView;
}


#pragma mark /******************** btn clicked **********************/

- (CAGradientLayer *)shadowAsInverse:(CGRect)frame startPoint:(CGPoint)start endPoint:(CGPoint)end tag:(NSInteger)tag {
    
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = frame;
    
    newShadow.startPoint = start;
    newShadow.endPoint = end;
    
    //添加渐变的颜色组合（颜色透明度的改变）
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[[UIColor colorWithHex:0xf2f2f2] colorWithAlphaComponent:0.5] CGColor],
                       (id)[[[UIColor colorWithHex:0xf2f2f2] colorWithAlphaComponent:0.4] CGColor],
                       (id)[[[UIColor colorWithHex:0xf2f2f2] colorWithAlphaComponent:0.3] CGColor],
                       (id)[[[UIColor colorWithHex:0xf2f2f2] colorWithAlphaComponent:0.2] CGColor],
                       (id)[[[UIColor colorWithHex:0xf2f2f2] colorWithAlphaComponent:0.1] CGColor],
                       (id)[[[UIColor colorWithHex:0xf2f2f2] colorWithAlphaComponent:0] CGColor],
                       nil];
    if (tag == 0) {
        newShadow.colors = colors;
    } else {
        newShadow.colors = [[colors reverseObjectEnumerator]allObjects];
    }
    
    return newShadow;
}

@end
