//
//  ImageHelper.h
//  ExpoxeS
//
//  Created by LZ's MBA on 5/29/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
@end
