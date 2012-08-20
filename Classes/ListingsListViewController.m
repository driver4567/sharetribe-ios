//
//  ListingsListViewController.m
//  Sharetribe
//
//  Created by Janne Käki on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListingsListViewController.h"

#import "Listing.h"
#import "ListingCell.h"
#import "ListingViewController.h"
#import "ListingsTopViewController.h"
#import "SharetribeAPIClient.h"

@interface ListingsListViewController () {
    NSMutableArray *listings;
}

@end

@implementation ListingsListViewController

@synthesize header;
@synthesize listingCollectionViewDelegate;
@synthesize disallowsRefreshing;

- (void)addListings:(NSArray *)newListings
{
    if (listings == nil) {
        listings = [NSMutableArray array];
    }
    
    for (Listing *newListing in newListings) {
        NSInteger oldIndex = [listings indexOfObject:newListing];
        if (oldIndex != NSNotFound) {
            [listings removeObjectAtIndex:oldIndex];
        }
        [listings addObject:newListing];
    }
    
    [listings sortUsingFunction:compareListingsByDate context:NULL];
    [self.tableView reloadData];
    
    if (listings.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self updateFinished];
}

- (void)clearAllListings
{
    [listings removeAllObjects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kSharetribeLightBrownColor;
    self.tableView.separatorColor = [UIColor clearColor];
    
    if (!disallowsRefreshing) {
        self.header = [[PullDownToRefreshHeaderView alloc] init];
        self.tableView.tableHeaderView = header;
    }
        
    [self observeNotification:kNotificationForDidRefreshListing withSelector:@selector(listingRefreshed:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self stopObservingAllNotifications];
    
    self.listingCollectionViewDelegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)startIndicatingRefresh
{
    [header startIndicatingRefreshWithTableView:self.tableView];
}

- (void)updateFinished
{
    [header updateFinishedWithTableView:self.tableView];
}

- (void)listingRefreshed:(NSNotification *)notification
{
    NSInteger index = [listings indexOfObject:notification.object];
    if (index != NSNotFound) {
        [listings replaceObjectAtIndex:index withObject:notification.object];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListingCell *cell = (ListingCell *) [tableView dequeueReusableCellWithIdentifier:[ListingCell reuseIdentifier]];
    if (cell == nil) {
        cell = [ListingCell instance];
    }
    
    Listing *listing = [listings objectAtIndex:indexPath.row];
    [cell setListing:listing];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kListingCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Listing *listing = [listings objectAtIndex:indexPath.row];
    
    if (listingCollectionViewDelegate != nil) {
        
        [listingCollectionViewDelegate viewController:self didSelectListing:listing];
        
    } else {
        
        ListingViewController *listingViewer = [[ListingViewController alloc] init];
        listingViewer.listing = listing;
        [self.navigationController pushViewController:listingViewer animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [header tableViewDidScroll:self.tableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([header triggersRefreshAsTableViewEndsDragging:self.tableView]) {
        [listingCollectionViewDelegate viewController:self wantsToRefreshPage:1];
    }
}

@end
