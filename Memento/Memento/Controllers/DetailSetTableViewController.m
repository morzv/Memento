//
//  DetailSetTableViewController.m
//  Memento
//
//  Created by Andrey Morozov on 14.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "DetailSetTableViewController.h"
#import "MatchPrepareViewController.h"
#import "LearnRoundViewController.h"
#import "ItemOfSetTableViewCell.h"

#import "Set.h"
#import "ItemOfSet.h"

#import "LearnOrganizer.h"
#import "MatchOrganizer.h"

static NSString * const kItemOfSetCellID        = @"ItemOfSetTableViewCell";
static NSString * const kMatchModePrepareSegue  = @"matchModePrepareSegue";
static NSString * const kRoundLearnModeSegue    = @"roundLearnModeSegue";


@interface DetailSetTableViewController () 

@end

@implementation DetailSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[ItemOfSetTableViewCell nib] forCellReuseIdentifier:kItemOfSetCellID];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.set.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemOfSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemOfSetCellID
                                                                   forIndexPath:indexPath];
    ItemOfSet *item = self.set[indexPath.row];
    [cell configureWithTerm:item.term definition:item.definition];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:kMatchModePrepareSegue]) {
        MatchPrepareViewController *dvc = segue.destinationViewController;
        MatchOrganizer *matchModeOrganizer = [MatchOrganizer createWithSet:self.set];
        
        dvc.organizer = matchModeOrganizer;
        dvc.cancelBlock = ^void() { [self dismissViewControllerAnimated:YES completion:nil]; };
        dvc.finishMatchBlock = ^void() { [self dismissViewControllerAnimated:YES completion:nil]; };
        
    } else if ([identifier isEqualToString:kRoundLearnModeSegue]) {
        LearnRoundViewController *dvc = segue.destinationViewController;
        LearnOrganizer *learnModeOrganizer = [LearnOrganizer createWithSet:self.set];
        
        learnModeOrganizer.delegate = dvc;
        
        dvc.organizer = learnModeOrganizer;
        dvc.cancelingBlock = ^void() { [self dismissViewControllerAnimated:YES completion:nil]; };
    }
}

@end
