//
//  StreamViewController.h
//  ExpoxeS
//
//  Created by LZ's MBA on 4/26/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface StreamViewController : UIViewController <UICollectionViewDataSource, UIActionSheetDelegate>
@property (nonatomic) BOOL newRegistration;
@property (nonatomic) BOOL fromMenu;
@end
