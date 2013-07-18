//
//  PostViewController.h
//  Expoxe
//
//  Created by LZ's MBA on 3/13/13.
//  Copyright (c) 2013 Expoxe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSData *image;
@property (strong, nonatomic) IBOutlet UITextView *comments;
@end
