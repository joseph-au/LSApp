//
//  StreamCVCell.m
//  ExpoxeS
//
//  Created by LZ's MBA on 4/5/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "StreamCVCell.h"


@implementation StreamCVCell

-(void)setTheFile:(PFImageView *)theFile
{
    _theFile = theFile;
    [self.theFile loadInBackground:^(UIImage *image, NSError *error) {
        self.image.image = image;
    }];
}

@end
