//
//  ItemsOfSetMapper.m
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "ItemsOfSetMapper.h"
#import "ItemOfSet.h"

@implementation ItemsOfSetMapper

- (NSUInteger)parseLearnProgressFromString:(NSString *)string {
    if ([string isEqualToString:@"failed"]) {
        return -1;
    } else if ([string isEqualToString:@"unknown"]) {
        return 0;
    } else if ([string isEqualToString:@"learnt"]) {
        return 1;
    } else if ([string isEqualToString:@"mastered"]) {
        return 2;
    } else {
        return 0;
    }
}

- (ItemOfSet *)modelFromJsonOfItem:(NSDictionary *)json {
    NSString *definition = json[@"definition"];
    NSString *term = json[@"term"];
    LearnState learnProgress = [self parseLearnProgressFromString:json[@"learnProgress"]];
    
    ItemOfSet *item = [ItemOfSet itemOfSetWithTerm:term definition:definition learnProgress:learnProgress];
    
    return item;
}

- (NSMutableArray<ItemOfSet *> *)modelsFromJsonOfListItems:(NSDictionary *)json {
    NSMutableArray <ItemOfSet *> *items = [NSMutableArray array];
    
    for (NSString *key in json) {
        NSDictionary *jsonOfItem = [json objectForKey:key];
        ItemOfSet *item = [self modelFromJsonOfItem:jsonOfItem];
        
        [items addObject:item];
    }
    
    return items;
}

@end
