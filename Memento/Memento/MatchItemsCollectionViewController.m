//  MatchItemsCollectionViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchItemsCollectionViewController.h"
#import "ItemOfMatchCollectionViewCell.h"
#import "MatchModeDelegate.h"
#import "Set.h"
#import "ItemOfSet.h"
#import "NSMutableArray+Shuffle.h"

static NSString * const reuseIdentifier = @"ItemOfMatchCollectionViewCell";


@interface MatchItemsCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat itemsPerRow;
@property (nonatomic, assign) CGFloat itemsPerColumn;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/*!
 * @brief Contains some items (6) from whole set
 * for current round. Fills by random.
 */
@property (nonatomic, strong) Set *roundSet;
/*!
 * @brief Contains terms and definitions
 * from round set for representing in collection view.
 */
@property (nonatomic, strong) NSMutableArray<NSString *> *randomItems;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedItems;

@end

@implementation MatchItemsCollectionViewController


#pragma mark - Getters

- (Set *)roundSet {
    if (!_roundSet) {
        _roundSet = [Set new];
    }
    
    return _roundSet;
}

- (NSMutableArray<NSString *> *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    
    return _selectedItems;
}

- (NSMutableArray<NSString *> *)randomItems {
    if (!_randomItems) {
        _randomItems = [NSMutableArray array];
    }
    
    return _randomItems;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsPerRow = 3;
    self.itemsPerColumn = 4;
    self.sectionInsets = UIEdgeInsetsMake(25, 10, 10, 10);
    
    self.collectionView.allowsMultipleSelection = YES;
    
    [self fillRoundSetByRandom];
}



#pragma mark - Actions

- (IBAction)exitButtonTapped:(UIButton *)sender {
    [self.delegate exitMatchMode];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.randomItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfMatchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    
    NSString *randomItem = self.randomItems[indexPath.row];
    [cell configureWithText:randomItem];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"matchHeader" forIndexPath:indexPath];
    } else {
        return nil;
    }
}


#pragma mark - <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //get selected item
    NSString *selectedItem = self.randomItems[indexPath.row];
    [self.selectedItems addObject:selectedItem];
    
    if (self.selectedItems.count == 2) {
        //check items
        BOOL isMatching = [self checkMatchingItems];
        isMatching ? [self itemsDidMatched] : [self itemsDidMissed];
        
        //deselect all items
        [self.selectedItems removeAllObjects];
        
        //get new potions of items
        if (self.roundSet.isEmpty) {
            [self fillRoundSetByRandom];
            [collectionView reloadData];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *deselectedItem = self.randomItems[indexPath.row];
    [self.selectedItems removeObject:deselectedItem];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat horizontalPaddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1);
    CGFloat verticalPaddingSpace = self.sectionInsets.top * (self.itemsPerColumn + 1);
    
    CGFloat avaliableWidthSize = self.view.frame.size.width - horizontalPaddingSpace;
    CGFloat widthPerItem = avaliableWidthSize / self.itemsPerRow;
    
    CGFloat avaliableHeightSize = self.view.frame.size.height - verticalPaddingSpace;
    CGFloat heightPerItem = avaliableHeightSize / self.itemsPerColumn;
    
    return CGSizeMake(widthPerItem, heightPerItem);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets.left;
}


#pragma mark - Matching Helpers

- (BOOL)checkMatchingItems {
    BOOL isMatching = NO;
    
    NSString *firstSelectedItem = self.selectedItems[0];
    NSString *secondSelectedItem = self.selectedItems[1];
    
    ItemOfSet *checkingItem = [ItemOfSet itemOfSetWithTerm:firstSelectedItem definition:secondSelectedItem];
    isMatching = [self.roundSet containsItem:checkingItem];
    
    if (!isMatching) {
        checkingItem = [ItemOfSet itemOfSetWithTerm:secondSelectedItem definition:firstSelectedItem];
        isMatching = [self.roundSet containsItem:checkingItem];
    }
    
    if (isMatching) {
        [self.roundSet removeItem:checkingItem];
    }
    
    return isMatching;
}

- (void)itemsDidMatched {
    NSArray<NSIndexPath *> *selectedIndexPaths = self.collectionView.indexPathsForSelectedItems;
    
    for (NSIndexPath *idx in selectedIndexPaths) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:idx];
        cell.backgroundColor = [UIColor greenColor];
    }
    
    [self.randomItems removeObjectsInArray:self.selectedItems];
    [self.collectionView deleteItemsAtIndexPaths:selectedIndexPaths];
}

- (void)itemsDidMissed {
    NSArray<NSIndexPath *> *selectedIndexPaths = self.collectionView.indexPathsForSelectedItems;
    
    for (NSIndexPath *idx in selectedIndexPaths) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:idx];
        cell.backgroundColor = [UIColor redColor];
        
        [self.collectionView deselectItemAtIndexPath:idx animated:YES];
    }
}


#pragma mark - Helpers

- (void)fillRoundSetByRandom {
    if (self.set.isEmpty) {
        //it means, that user matched all items.
        [self.delegate finishedMatchMode];
    }
    
    NSUInteger randomIndex;
    ItemOfSet *randomItem;
    
    //get 6 items for current round from set by random.
    for (int i = 0; i < 6 && !self.set.isEmpty; i++) {
        randomIndex = arc4random() % self.set.count;
        randomItem = self.set[randomIndex];
        
        [self.roundSet addItem:randomItem];
        
        [self.randomItems addObject:randomItem.term];
        [self.randomItems addObject:randomItem.definition];
        
        [self.set removeItemAtIndex:randomIndex];
    }
    
    [self.randomItems shuffle];
}

-(void)dealloc {
    NSLog(@"Match mode dealloced");
}
@end
