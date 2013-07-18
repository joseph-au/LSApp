//
//  BaseViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 3/29/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "BaseViewController.h"
#import "PostViewController.h"
#import "TagLocal.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width*1.5, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(cameraButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];

}

-(void)viewWillLayoutSubviews
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
}

-(IBAction)cameraButtonPressed:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"showCamera" sender:sender];
}

-(IBAction)postCancel:(UIStoryboardSegue*)segue
{
    
}

-(IBAction)postDone:(UIStoryboardSegue*)segue
{
    /*PostViewController *pvc = (PostViewController*)segue.sourceViewController;
    [self.user.managedObjectContext performBlock:^{
       Post *p = [Post image:pvc.image comment:pvc.comments.text theUser:self.user inManagedObjectContext:self.user.managedObjectContext];
        for(TagLocal *t in pvc.tags)
       {
           [self.user.managedObjectContext performBlock:^{
               Product *prod = [Product productWithBrand:t.brandName withCategory:t.categoryName withModel:t.modelName inManagedObjectContext:self.user.managedObjectContext];
               [self.user.managedObjectContext performBlock:^{
                   [Tag theTag:t thePost:p theProduct:prod inManagedContext:self.user.managedObjectContext];
               }];
               
           }];
           
       }

    }];*/
}

@end
