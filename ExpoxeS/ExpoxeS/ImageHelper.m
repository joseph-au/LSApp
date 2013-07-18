//
//  ImageHelper.m
//  ExpoxeS
//
//  Created by LZ's MBA on 5/29/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
