//
//  TagLocal.h
//  ExpoxeS
//
//  Created by LZ's MBA on 4/5/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface TagLocal : NSObject
@property (nonatomic, retain) NSNumber * locationX;
@property (nonatomic, retain) NSNumber * locationY;
@property (nonatomic, strong) PFObject * brandName;
@property (nonatomic, strong) PFObject * categoryName;
@property (nonatomic, strong) PFObject * modelName;
@end
