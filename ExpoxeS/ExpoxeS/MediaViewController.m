//
//  MediaViewController.m
//  Expoxe
//
//  Created by LZ's MBA on 3/12/13.
//  Copyright (c) 2013 Expoxe. All rights reserved.
//

#import "MediaViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TITokenField.h"
#import "Brands.h"
#import "BaseViewController.h"
#import "TagLocal.h"
#import "User.h"
#import <Parse/Parse.h>
#import "ImageHelper.h"

@interface MediaViewController () <UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    TITokenFieldDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic) CGPoint tappedLocation;
@property (strong, nonatomic) NSMutableArray *resultList;
@property (strong, nonatomic) TITokenFieldView *tokenFieldView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIImageView *mediaView;
@property (strong, nonatomic) NSMutableArray *tags;
@end

@implementation MediaViewController

-(User*)user
{
    BaseViewController *bvc = (BaseViewController*)self.presentingViewController;
    return bvc.user;
}

-(NSMutableArray*)tags
{
    if(!_tags)
    {
        _tags = [[NSMutableArray alloc]init];
    }
    return _tags;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    self.picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    NSNumber *takePhoto = [NSNumber numberWithInteger:0];
    NSNumber *album = [NSNumber numberWithInteger:1];
    if ([self.index isEqualToNumber:takePhoto]
        && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if([self.index isEqualToNumber:album]
            &&[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.picker) {
        [self presentViewController:self.picker
                           animated:YES
                         completion:nil];
    }
    else if (self.mediaView.image == nil)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark imagePicker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.picker = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectedImage =info[UIImagePickerControllerOriginalImage];
    if(selectedImage)
    {
        self.mediaView.image = selectedImage;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.picker = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancel:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Don't Save" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)tapped:(UITapGestureRecognizer *)sender
{
    [self displaySearchBar];
    self.tappedLocation = [sender locationInView:self.mediaView];
}

-(void)displaySearchBar
{
    
    //[self.search setBackgroundImage:self.image.image];
    //[self.search setTranslucent:YES];
    self.mediaView.alpha = 0.3;
    self.tokenFieldView = [[TITokenFieldView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 500)];
    /*NSArray *products = [Brands listOfBrands:self.tokenFieldView.tokenTitles];
    NSMutableArray *listOfProducts = [[NSMutableArray alloc]init];
    for (PFObject *object in products)
    {
        NSArray *product = @[[object objectForKey:@"categoryName"],
                             [object objectForKey:@"brandName"],
                             [object objectForKey:@"modelName"]];
        NSString *cbm = [product componentsJoinedByString:@" "];
        [listOfProducts addObject:cbm];
    }*/
    //[self.tokenFieldView setSourceArray:[Brands listOfBrands:nil]];
    [self.view addSubview:self.tokenFieldView];
    
    [self.tokenFieldView.tokenField setDelegate:self];
	[self.tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
    self.tokenFieldView.tokenField.returnKeyType = UIReturnKeyDone;
    [self.tokenFieldView becomeFirstResponder];
    //[self.search becomeFirstResponder];
}

-(IBAction)deleteButton:(UIButton*)sender
{
    //UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Delete?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
    //[actionSheet showInView:self.view];
    [sender removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.mediaView.alpha = 1.0;
    NSString *text = [[NSString alloc]init];
    if([self.tokenFieldView.tokenTitles count] > 0)
    {
        text = [self.tokenFieldView.tokenTitles componentsJoinedByString:@" "];
    }
    
    if([self.tokenFieldView.tokenTitles count] > 0)
    {
        CGRect aRect = CGRectMake(self.tappedLocation.x,
                                  self.tappedLocation.y,
                                  [text length]*10,
                                  20);
        TagLocal *t = [[TagLocal alloc]init];
        t.locationX = [NSNumber numberWithFloat:self.tappedLocation.x];
        t.locationY = [NSNumber numberWithFloat:self.tappedLocation.y];
        TIToken *token = [self.tokenFieldView.tokenField.tokens objectAtIndex:0];
        t.categoryName = token.thePFObject;
        if([self.tokenFieldView.tokenTitles count] > 1)
        {
            token = [self.tokenFieldView.tokenField.tokens objectAtIndex:1];
            t.brandName = token.thePFObject;
        }
        if([self.tokenFieldView.tokenTitles count] > 2)
        {
            token = [self.tokenFieldView.tokenField.tokens objectAtIndex:2];
            t.modelName = token.thePFObject;
        }
        [self.tags addObject:t];
        UIButton *button = [[UIButton alloc]initWithFrame:aRect];
        [button setTitle:text forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blackColor];
        [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mediaView addSubview:button];
    }
    [self.tokenFieldView removeFromSuperview];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"getUserInput"])
    {
        CGSize size = CGSizeMake(320, 640);
        UIImage *resized = [ImageHelper imageWithImage:self.mediaView.image
                                          scaledToSize:size];
        NSData *selectedImage = UIImagePNGRepresentation(resized);
        if([segue.destinationViewController respondsToSelector:@selector(setImage:)])
        {
            [segue.destinationViewController performSelector:@selector(setImage:) withObject:selectedImage];
        }
        if([segue.destinationViewController respondsToSelector:@selector(setTags:)])
        {
            [segue.destinationViewController performSelector:@selector(setTags:) withObject:self.tags];
        }
    }
}





@end
