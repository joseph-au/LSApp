//
//  SearchViewController.h
//  ExpoxeS
//
//  Created by LZ's MBA on 5/7/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString* theTitle;
@property (nonatomic, strong) NSMutableDictionary *filteredObjects;
@property (nonatomic, strong) NSString *selectedKey;

@end
