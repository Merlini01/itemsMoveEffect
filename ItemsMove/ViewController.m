//
//  ViewController.m
//  ItemsMove
//
//  Created by 王家亮 on 2016/10/18.
//  Copyright © 2016年 王家亮. All rights reserved.
//

#import "ViewController.h"
#import "HeadView.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

typedef enum{
    itemStatusNormal = 0,
    itemStatusEdit
}itemChangeStatus;

@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSMutableArray * dataArray1;
@property(nonatomic,strong)NSMutableArray * dataArray2;
@property(nonatomic,strong)UIButton * deleteButton;
@property(nonatomic,strong)UIButton * editButton;
@property(nonatomic,assign)UIColor * CurrentColor;
@property(nonatomic,assign)itemChangeStatus status;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self dataInit];
    [self creatButtons];
    [self collectionViewInit:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
}
- (void)creatButtons{
    [self buttonInit:self.editButton title:@"完成" rect:CGRectMake(self.view.frame.size.width - 70, 30, 60, 25) backColor:[UIColor orangeColor]];
    [self buttonInit:self.editButton title:@"编辑" rect:CGRectMake(self.view.frame.size.width - 140, 30, 60, 25) backColor:[UIColor greenColor]];
}
- (void)buttonInit:(UIButton *)button title:(NSString *)title rect:(CGRect)rect backColor:(UIColor *)color{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = color;
    button.layer.cornerRadius = 5;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonClick:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"完成"]) {
        self.CurrentColor = [UIColor orangeColor];
        self.status = 0;
    }else{
        self.CurrentColor = [UIColor greenColor];
        self.status = 1;
    }
    [self.collectionView reloadData];

}
- (void)dataInit{
    self.status = 0;
    self.dataArray1 = [[NSMutableArray alloc]init];
    self.dataArray2 = [[NSMutableArray alloc]init];
    self.CurrentColor = [UIColor orangeColor];
    for (NSInteger index = 0; index < 20; index++) {
        if (index < 4) {
            [self.dataArray1 addObject:[NSString stringWithFormat:@"A-%lu",index]];
        }
        [self.dataArray2 addObject:[NSString stringWithFormat:@"B-%lu",index]];
    }
}
- (void)collectionViewInit:(CGRect)rect{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 100)/4, 30);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UILongPressGestureRecognizer * Ges = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPress:)];
    [self.collectionView addGestureRecognizer:Ges];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[HeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [self.view addSubview:self.collectionView];
}
- (void)LongPress:(UIGestureRecognizer *)sender{
    CGPoint point =[sender locationInView:sender.view];
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
        [self.dataArray1 exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (_status) {
        case itemStatusNormal:
            break;
        case itemStatusEdit:
            if (indexPath.section == 0) {
                [self.dataArray2 addObject:self.dataArray1[indexPath.row]];
                [self.dataArray1 removeObjectAtIndex:indexPath.row];
            }else if (indexPath.section == 1){
                [self.dataArray1 addObject:self.dataArray2[indexPath.row]];
                [self.dataArray2 removeObjectAtIndex:indexPath.row];
                
                NSInteger index = self.dataArray1.count - 1;
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            }
            break;
        default:
            break;
    }

     [collectionView reloadData];
}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_status == itemStatusEdit && indexPath.section == 0) {
        return YES;
    }
    return NO;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray1.count;
    }else if (section == 1){
        return self.dataArray2.count;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellStr = @"cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
    for (UIView * view in cell.subviews) {
        [view removeFromSuperview];
    }
    UILabel * testLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 3, 60, 20)];
    testLabel.text = indexPath.section == 0 ? self.dataArray1[indexPath.row]:self.dataArray2[indexPath.row];
    testLabel.textColor = [UIColor blackColor];
    [cell addSubview:testLabel];
    cell.backgroundColor = self.CurrentColor;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView * reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HeadView * headView = (HeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
        [headView setTitleLabelWithText:[NSString stringWithFormat:@"标题-%lu",indexPath.section]];
        reusableview = headView;
    }
    return reusableview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}














@end
