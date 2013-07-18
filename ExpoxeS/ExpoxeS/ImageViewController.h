//
//  ImageViewController.h
//  ExpoxeS
//
//  Created by LZ's MBA on 4/3/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *captionText;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) PFQuery *tagQuery;
@end
