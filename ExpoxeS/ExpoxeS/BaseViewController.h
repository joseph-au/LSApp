//
//  BaseViewController.h
//  ExpoxeS
//
//  Created by LZ's MBA on 3/29/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface BaseViewController : UITabBarController
@property (nonatomic, strong) User *user;
-(void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;
@end
