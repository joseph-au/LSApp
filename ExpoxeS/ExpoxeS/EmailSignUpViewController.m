//
//  EmailSignUpViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 4/22/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "EmailSignUpViewController.h"

@interface EmailSignUpViewController ()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textField;
@end

@implementation EmailSignUpViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if([string isEqualToString:@"Sign Up"])
    {
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

@end
