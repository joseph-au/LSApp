//
//  SearchViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 5/7/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>

@interface SearchViewController ()
@property (nonatomic) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL categorySearchDone;
@property (nonatomic) BOOL brandSearchDone;
@property (nonatomic) BOOL modelSearchDone;
@property (nonatomic) BOOL modelSearchDone2;
@property (nonatomic, strong) NSArray* sourceList;
@property (nonatomic, strong) NSMutableArray *filteredList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation SearchViewController

-(NSMutableArray*)filteredList
{
    if(!_filteredList)
        _filteredList = [[NSMutableArray alloc]init];
    return _filteredList;
}

-(NSMutableDictionary*)filteredObjects
{
    if(!_filteredObjects)
        _filteredObjects = [[NSMutableDictionary alloc]init];
    return _filteredObjects;
}

-(void)setTheTitle:(NSString *)theTitle
{
    _theTitle = theTitle;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self doSearch];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.isSearching = YES;

}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.isSearching = NO;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if([searchString length] > 0)
    {
        [self filterListForSearchText:searchString];
    }
    return NO;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.hidden = YES;
}

-(void)doSearch
{
    [self.filteredObjects removeAllObjects];
    [self.activity startAnimating];
    self.categorySearchDone = NO;
    self.brandSearchDone = NO;
    self.modelSearchDone = NO;
    self.modelSearchDone2 = NO;
    PFQuery *categoryQuery = [PFQuery queryWithClassName:@"Category"];
    //[categoryQuery whereKey:@"canonicalName" containsString:[searchText lowercaseString]];
    categoryQuery.limit = 1000;
    PFQuery *tagCategory = [self tagQuery];
    [tagCategory whereKey:@"category" matchesQuery:categoryQuery];
    [tagCategory includeKey:@"category"];
    
    //NSArray *objects = [tagCategory findObjects];
    [tagCategory findObjectsInBackgroundWithTarget:self selector:@selector(categoryCallback:)];
    
    
    PFQuery *tagBrand = [self tagQuery];
    PFQuery *brandQuery = [PFQuery queryWithClassName:@"Brand"];
    brandQuery.limit = 1000;
    //[brandQuery whereKey:@"canonicalName" containsString:[searchText lowercaseString]];
    [tagBrand whereKey:@"brand" matchesQuery:brandQuery];
    [tagBrand includeKey:@"brand"];
    //NSArray *objects2 = [tagBrand findObjects];
    [tagBrand findObjectsInBackgroundWithTarget:self selector:@selector(brandCallback:)];
    
    
    PFQuery *tagModel = [self tagQuery];
    PFQuery *modelQuery = [PFQuery queryWithClassName:@"Model"];
    [modelQuery orderByAscending:@"canonicalName"];
    modelQuery.limit = 1000;
    //[modelQuery whereKey:@"canonicalName" containsString:[searchText lowercaseString]];
    [tagModel whereKey:@"model" matchesQuery:modelQuery];
    [tagModel includeKey:@"model"];
    [tagModel includeKey:@"Post"];
    //NSArray *objects3 = [tagModel findObjects];
    [tagModel findObjectsInBackgroundWithTarget:self selector:@selector(modelCallback:)];
    
    PFQuery *tagModel2 = [self tagQuery];
    PFQuery *modelQuery2 = [PFQuery queryWithClassName:@"Model"];
    [modelQuery2 orderByAscending:@"canonicalName"];
    modelQuery2.limit = 1000;
    modelQuery2.skip = 1000;
    [tagModel2 whereKey:@"model" matchesQuery:modelQuery2];
    [tagModel2 includeKey:@"model"];
    [tagModel2 includeKey:@"Post"];
    [tagModel2 findObjectsInBackgroundWithTarget:self selector:@selector(modelCallback2:)];
}

-(void)filterListForSearchText:(NSString*)searchText
{
    [self.filteredList removeAllObjects];
    for (NSString *string in self.sourceList)
    {
        NSRange range = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
        {
            [self.filteredList addObject:string];
        }
    }
    [self.tableView reloadData];
}

-(void)categoryCallback:(NSArray*)results error:(NSError*)error
{
    if(!error)
    {
        for(PFObject *object in results)
        {
            PFObject *o1 = object;
            PFObject *cat = [o1 objectForKey:@"category"];
            NSString *categoryName = [cat objectForKey:@"name"];
            NSMutableArray *array = self.filteredObjects[categoryName];
            if(array == nil)
            {
                array = [[NSMutableArray alloc]init];
            }
            [array addObject:[o1 objectForKey:@"post"]];
            self.filteredObjects[categoryName] = array;
        }
        self.categorySearchDone = YES;
        if([results count] > 0)
            [self searchDone];
    }
    else
    {
        NSLog(@"category error");
    }
}

-(void)brandCallback:(NSArray*)results error:(NSError*)error
{
    if(!error)
    {
        for(PFObject *object in results)
        {
            PFObject *o1 = object;
            PFObject *bra = [o1 objectForKey:@"brand"];
            NSString *brandName = [bra objectForKey:@"name"];
            NSMutableArray *array = self.filteredObjects[brandName];
            if(array == nil)
            {
                array = [[NSMutableArray alloc]init];
            }
            [array addObject:[o1 objectForKey:@"post"]];
            self.filteredObjects[brandName] = array;
        }
        self.brandSearchDone = YES;
        if([results count] > 0)
            [self searchDone];
    }
    else
    {
            NSLog(@"category error");
    }
}

-(void)modelCallback:(NSArray*)results
{
    for(PFObject *object in results)
    {
        PFObject *o1 = object;
        PFObject *mod = [o1 objectForKey:@"model"];
        NSString *modelName = [mod objectForKey:@"name"];
        NSMutableArray *array = self.filteredObjects[modelName];
        if(array == nil)
        {
            array = [[NSMutableArray alloc]init];
        }
        [array addObject:[o1 objectForKey:@"post"]];
        self.filteredObjects[modelName] = array;
    }
    self.modelSearchDone = YES;
    if([results count] > 0)
        [self searchDone];
}

-(void)modelCallback2:(NSArray*)results
{
    for(PFObject *object in results)
    {
        PFObject *o1 = object;
        PFObject *mod = [o1 objectForKey:@"model"];
        NSString *modelName = [mod objectForKey:@"name"];
        NSMutableArray *array = self.filteredObjects[modelName];
        if(array == nil)
        {
            array = [[NSMutableArray alloc]init];
        }
        [array addObject:[o1 objectForKey:@"post"]];
        self.filteredObjects[modelName] = array;
    }
    self.modelSearchDone2 = YES;
    if([results count] > 0)
        [self searchDone];
}

-(void)searchDone
{
    if(self.categorySearchDone &&
       self.brandSearchDone &&
       self.modelSearchDone &&
       self.modelSearchDone2)
    {
        
       self.sourceList = [self.filteredObjects allKeys];
        [self.activity stopAnimating];
        //[self.tableView reloadData];
    }
}

-(PFQuery*)tagQuery
{
    PFQuery *newQuery = [[PFQuery alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    newQuery = [PFQuery queryWithClassName:@"Tag"];
    [newQuery whereKey:@"post" matchesQuery:query];
    [newQuery includeKey:@"Post"];
    return newQuery;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idenifier = @"searchCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:idenifier];
    cell.textLabel.text = [self.filteredList objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedKey = [self.filteredList objectAtIndex:indexPath.row];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = nil;
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell*)sender;
    }
    
    if(cell)
    {
        self.selectedKey = cell.textLabel.text;
    }
}

@end
