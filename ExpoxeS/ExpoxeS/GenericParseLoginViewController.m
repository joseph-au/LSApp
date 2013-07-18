//
//  LoginParseLoginViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 4/29/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "GenericParseLoginViewController.h"

@interface GenericParseLoginViewController ()

@end

@implementation GenericParseLoginViewController

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
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![PFUser currentUser])
    {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc]init];
        [logInViewController setDelegate:self];
        NSArray *permissionArray = @[@"email",
                                    @"user_birthday"];
        [logInViewController setFacebookPermissions:permissionArray];
        [logInViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
        
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc]init];
        [signUpViewController setDelegate:self];
        [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
        
        [logInViewController setSignUpController:signUpViewController];
        
        [self presentViewController:logInViewController animated:YES completion:nil];
    }
}

-(BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    if(username && password && username.length != 0 && password.length != 0)
    {
        return YES;
    }
    
    [[[UIAlertView alloc]initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return NO;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Failed to log in...");
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    BOOL informationComplete = YES;
    for(id key in info)
    {
        NSString *field = [info objectForKey:key];
        if(!field || field.length == 0)
        {
            informationComplete = NO;
            break;
        }
    }
    
    if(!informationComplete)
    {
        [[[UIAlertView alloc]initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    return informationComplete;
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"Failed to sign up...");
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"User dismissed the signupviewcontroller...");
}
@end
