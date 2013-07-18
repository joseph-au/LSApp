//
//  StreamCVCell.h
//  ExpoxeS
//
//  Created by LZ's MBA on 4/5/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StreamCVCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) PFImageView *theFile;
@end
