//
//  InitialSlidingViewController.m
//  Expoxe
//
//  Created by LZ's MBA on 3/27/13.
//  Copyright (c) 2013 Expoxe. All rights reserved.
//

#import "InitialSlidingViewController.h"


@interface InitialSlidingViewController ()

@end

@implementation InitialSlidingViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *storyBoard;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        storyBoard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    }
    self.topViewController = [storyBoard instantiateViewControllerWithIdentifier:@"Stream"];
    
}

@end
