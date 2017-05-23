//
//  Set.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "Set.h"
#import "ItemOfSet.h"
@interface Set ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, strong) NSMutableArray<ItemOfSet *> *items;

@end

@implementation Set


#pragma mark - Initializations

- (instancetype)init {
    return [self initWithTitle:@"" author:@"" items:nil];
}

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author items:(NSArray<ItemOfSet *> *)items {
    self = [super init];
    
    if (self) {
        _title = title;
        _author = author;
        _items = [NSMutableArray new];
        [self.items addObjectsFromArray:items];
    }
    
    return self;
}

+ (instancetype)setWithTitle:(NSString *)title author:(NSString *)author items:(NSArray<ItemOfSet *> *)items {
    return [[self alloc] initWithTitle:title author:author items:items];
}


#pragma mark - Getters

- (NSUInteger)count {
    return [self.items count];
}

-(BOOL)isEmpty {
    return self.items.count == 0;
}

- (Set *)itemsWithLearnState:(LearnState)learnState {
    NSMutableArray *filteredItems = [NSMutableArray array];
    for (ItemOfSet *item in self.items) {
        if (item.learnProgress == learnState) {
            [filteredItems addObject:item];
        }
    }
    
    Set *set = [Set setWithTitle:self.title author:self.author items:filteredItems];
    
    return set;
}

#pragma mark - Modifiers

- (void)addItem:(ItemOfSet *)item {
    [self.items addObject:item];
}

- (void)removeItem:(ItemOfSet *)item {
    [self.items removeObject:item];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self.items removeObjectAtIndex:index];
}

- (BOOL)containsItem:(ItemOfSet *)item {
    return [self.items containsObject:item];
}

- (ItemOfSet *)findItemWithTerm:(NSString *)term definition:(NSString *)definition {
    ItemOfSet *findingItem = [ItemOfSet itemOfSetWithTerm:term definition:definition];
    
    for (ItemOfSet *item in self.items) {
        if ([item isEqual:findingItem]) {
            return item;
        }
    }
    
    return nil;
}

- (Set *)subsetWithRange:(NSRange)range {
    NSArray<ItemOfSet *> *subitems = [self.items subarrayWithRange:range];
    Set *subset = [Set setWithTitle:self.title author:self.author items:subitems];
    
    return subset;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.items[idx];
}

- (id)copyWithZone:(NSZone *)zone {
    Set *copySet = [[[self class] allocWithZone:zone] init];
    copySet.title = self.title;
    copySet.author = self.author;
    
    for (ItemOfSet *item in self.items) {
        [copySet.items addObject:[item copy]];
    }
    
    return copySet;
}

@end
