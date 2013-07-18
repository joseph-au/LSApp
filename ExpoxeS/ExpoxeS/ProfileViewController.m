//
//  ProfileViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 4/24/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "ProfileViewController.h"
#import "ECSlidingViewController.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profileImage;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[FBSession activeSession]isOpen])
        [self populateUserDetails];
}
- (IBAction)reveal:(UIBarButtonItem *)sender
{
     [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)populateUserDetails
{
    if([[FBSession activeSession]isOpen])
    {
        [[FBRequest requestForMe]startWithCompletionHandler:^(FBRequestConnection *connection,
                                                             NSDictionary<FBGraphUser> *user,
                                                             NSError *error)
        {
            if(!error)
            {
                self.userName.text = user.name;
                self.profileImage.profileID = user.id;
            }
        }];
    }
}

@end
