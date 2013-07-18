//
//  DemoLoginViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 4/2/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "DemoLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface DemoLoginViewController ()
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tap;

@end

@implementation DemoLoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tap.cancelsTouchesInView = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*if([segue.identifier isEqualToString:@"login"])
    {
        if(self.managedObjectContext)
        {
            User *user = [User userName:@"Joe" password:@"joe" inManagedObjectContext:self.managedObjectContext];
            if([segue.destinationViewController respondsToSelector:@selector(setUser:)])
            {
                [segue.destinationViewController performSelector:@selector(setUser:) withObject:user];
            }
        }
    }*/
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //if(!self.managedObjectContext) [self useDemoDocument];
}

-(void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document1"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             if(success)
             {
                 self.managedObjectContext = document.managedObjectContext;
             }
         }];
    }
    else if (document.documentState == UIDocumentStateClosed)
    {
        [document openWithCompletionHandler:^(BOOL success){
            if(success)
            {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    }
    else
    {
        self.managedObjectContext = document.managedObjectContext;
    }
}
- (IBAction)facebook:(UIButton *)sender
{
    //[self openSession];
    
    NSArray *permissionArray = @[@"email",
                                 @"user_birthday",
                                 @"read_friendlists",
                                 @"user_hometown",
                                 @"user_interests",
                                 @"user_location"
                                 ];
    [PFFacebookUtils logInWithPermissions:permissionArray block:^(PFUser *user, NSError *error) {
        if(!user)
        {
            if(error)
            {
                UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                    message:@"Cannot log in using facebook"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView1 show];
            }
        }
        else
        {
            
            [self performSegueWithIdentifier:@"doneLogin" sender:self];
        }
    }];
}

-(void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
         [self sessionStateChanged:session state:state error:error];
     }
     ];
}

-(void)sessionStateChanged:(FBSession *)session
                     state:(FBSessionState)state
                     error:(NSError*)error
{
    switch(state)
    {
        case FBSessionStateOpen: //logged in
            [self performSegueWithIdentifier:@"doneLogin" sender:self];
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
        {//login failed
            UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"Error"
                                                                message:@"Cannot log in using facebook"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView1 show];
            break;
        }
        default:
            break;
    }
    
    if(error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)tapped:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}


@end
