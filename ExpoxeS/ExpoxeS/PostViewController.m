//
//  PostViewController.m
//  Expoxe
//
//  Created by LZ's MBA on 3/13/13.
//  Copyright (c) 2013 Expoxe. All rights reserved.
//

#import "PostViewController.h"
#import "TagLocal.h"

@interface PostViewController () 

@end

@implementation PostViewController 

/*- (IBAction)cancel:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Don't Save" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];    
}*/

-(void)viewDidLoad
{
    [self.comments becomeFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [self performSegueWithIdentifier:@"postDone" sender:self];
        return NO;
    }
    return YES; 
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"postDone"])
    {
        PFObject *post = [PFObject objectWithClassName:@"Post"];
        [post setObject:self.comments.text forKey:@"caption"];
        [post setObject:[PFUser currentUser] forKey:@"user"];
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:self.image];
        [imageFile saveInBackground];
        [post setObject:imageFile forKey:@"image"];
        [post save];
            
        for (TagLocal *tl in self.tags)
        {
            PFObject *tag = [PFObject objectWithClassName:@"Tag"];
            [tag setObject:post forKey:@"post"];
            [tag setObject:tl.locationX forKey:@"locationX"];
            [tag setObject:tl.locationY forKey:@"locationY"];
            if(tl.categoryName)
            {
                [tag setObject:tl.categoryName forKey:@"category"];
            }
            if(tl.brandName)
            {
                [tag setObject:tl.brandName forKey:@"brand"];
            }
            if(tl.modelName)
            {
                [tag setObject:tl.modelName forKey:@"model"];
            }
            [tag saveInBackground];
            //[tagPFObjects addObject:tag];
        }
    }
}



@end
