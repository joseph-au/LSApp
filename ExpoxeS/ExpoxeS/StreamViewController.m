//
//  StreamViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 4/26/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "MenuViewController.h"
#import "StreamViewController.h"
#import "InitialSlidingViewController.h"
#import <Parse/Parse.h>
#import "PostViewController.h"
#import "TagLocal.h"
#import "SearchViewController.h"
#import "StreamCVCell.h"

@interface StreamViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSArray *objects;
@property (nonatomic) BOOL fromSearch;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation StreamViewController

-(void)viewDidLoad
{
    self.fromSearch = NO;
}

-(void)updateFromFacebook
{
    if([PFUser currentUser])
    {
        FBRequest *request = [FBRequest requestForMe];
        if(request)
        {
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error)
                {
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *firstName = userData[@"first_name"];
                    NSString *lastName = userData[@"last_name"];
                    NSString *gender = userData[@"gender"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"MM/dd/yyyy"];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                    NSDate *birthday = [formatter dateFromString:userData[@"birthday"]];
                    NSString *email = userData[@"email"];
                    [[PFUser currentUser] setObject:firstName forKey:@"firstName"];
                    [[PFUser currentUser] setObject:email forKey:@"email"];
                    [[PFUser currentUser] setObject:lastName forKey:@"lastName"];
                    [[PFUser currentUser] setObject:birthday forKey:@"birthday"];
                    [[PFUser currentUser] setObject:gender forKey:@"gender"];
                    [[PFUser currentUser]saveInBackground];
                    
                }
            }];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{

}

-(void)viewDidAppear:(BOOL)animated
{
    if([PFUser currentUser])
    {
        if(self.newRegistration)
        {
            [self updateFromFacebook];
        }
        if(!self.fromSearch)
        {
            self.label.text = @"";
        }
    
        // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
        // You just need to set the opacity, radius, and color.
        self.view.layer.shadowOpacity = 0.75f;
        self.view.layer.shadowRadius = 10.0f;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        
        if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
            self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
        }
        
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    else
    {
        [self performSegueWithIdentifier:@"loginView" sender:self];
    }
}

-(void)refresh
{
    [self getImages:nil];
    self.label.text = @"";
}

-(NSMutableArray*)images
{
    if(!_images)
    {
        _images = [[NSMutableArray alloc]init];
    }
    return _images;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%i", [self.objects count]);
    return [self.objects count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    if([cell isKindOfClass:[StreamCVCell class]])
    {
        StreamCVCell *streamCell = (StreamCVCell *)cell;
        //NSLog(@"%i", indexPath.row);
        //Post *post = [self.images objectAtIndex:indexPath.row];
        //UIImage *image = [[UIImage alloc]initWithData:post.image];
        //streamCell.image.image = [self.images objectAtIndex:indexPath.row];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        PFImageView *piv = [[PFImageView alloc]init];
        piv.file = [object objectForKey:@"image"];
        streamCell.theFile = piv;
    }
    return cell;
}

-(void)getImages:(NSArray*)array
{
    //InitialSlidingViewController *bvc = (InitialSlidingViewController*)self.parentViewController;
    //return [Post findPostByUser:bvc.user];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    if(array != nil)
       [query whereKey:@"objectId" containedIn:array];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.limit = 20;
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(callback:error:)];
    
    /*UIImage *image = [UIImage imageNamed:@"ButtonMenu.png"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:image];
    self.images = array;*/
}

-(void)callback:(NSArray*)result error:(NSError*)error
{
    self.images = nil;
    if(!error)
    {
        self.objects = result;
        [self.collectionView reloadData];
        /*for(PFObject *object in result)
        {
            [object fetchIfNeededInBackgroundWithTarget:self selector:@selector(objectReady:error:)];
        }*/
        /*self.objects = result;
        //[self.activity startAnimating];
            for(PFObject *object in result)
            {
                 dispatch_queue_t imageQueue = dispatch_queue_create("getImage", 0);
                dispatch_async(imageQueue, ^{
                [object fetch];
                PFFile *imageFile = [object objectForKey:@"image"];
                NSData *data = [imageFile getData];
                [self.images addObject:[UIImage imageWithData:data]];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activity stopAnimating];
                [self.collectionView reloadData];
                
            });*/
    }
}

-(void)objectReady:(PFObject*)object error:(NSError*)error
{
    PFFile *imageFile = [object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithTarget:self selector:@selector(dataReady:error:)];
}

-(void)dataReady:(NSData*)result error:(NSError*)error
{
    [self.images addObject:[UIImage imageWithData:result]];
    //if([self.images count] == [self.objects count])
    [self.collectionView reloadData];
}

- (IBAction)tapped:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    //NSLog(@"%i", indexPath.row);
    if(indexPath)
    {
        [self performSegueWithIdentifier:@"showImage" sender:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showImage"])
    {
        if([sender isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath *path = (NSIndexPath*)sender;
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
            if([cell isKindOfClass:[StreamCVCell class]])
            {
                StreamCVCell *streamCell = (StreamCVCell*)cell;
                UIImage *image = streamCell.image.image;
                if([segue.destinationViewController respondsToSelector:@selector(setImage:)])
                {
                    [segue.destinationViewController performSelector:@selector(setImage:) withObject:image];
                }
            }
            PFObject *thePFObject = [self.objects objectAtIndex:path.row];
            NSString *text = [thePFObject objectForKey:@"caption"];
            if([segue.destinationViewController respondsToSelector:@selector(setCaptionText:)])
            {
                [segue.destinationViewController performSelector:@selector(setCaptionText:) withObject:text];
            }
            //PFRelation *relation = [thePFObject relationforKey:@"tags"];
            PFQuery *query = [PFQuery queryWithClassName:@"Tag"];
            [query whereKey:@"post" equalTo:thePFObject];
            [query includeKey:@"category"];
            [query includeKey:@"brand"];
            [query includeKey:@"model"];
            NSArray *objects = [query findObjects];
            if([segue.destinationViewController respondsToSelector:@selector(setTags:)])
            {
                [segue.destinationViewController performSelector:@selector(setTags:) withObject:objects];
            }
        }
    }
    else if ([segue.identifier isEqualToString:@"showMedia"])
    {
        if([sender isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber*)sender;
            if([segue.destinationViewController respondsToSelector:@selector(setIndex:)])
            {
                [segue.destinationViewController performSelector:@selector(setIndex:) withObject:number];
            }
        }
    }
}

-(IBAction)postCancel:(UIStoryboardSegue*)segue
{
    
}

-(IBAction)postDone:(UIStoryboardSegue*)segue
{
    /*PostViewController *pvc = (PostViewController*)segue.sourceViewController;
    
    PFObject *post = [PFObject objectWithClassName:@"Post"];
    [post setObject:pvc.comments.text forKey:@"caption"];
    [post setObject:[PFUser currentUser] forKey:@"user"];
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:pvc.image];
    [imageFile saveInBackground];
    [post setObject:imageFile forKey:@"image"];
    [self.activity startAnimating];
    dispatch_queue_t q = dispatch_queue_create("savePost", 0);
    dispatch_async(q, ^{
        [post save];
         dispatch_async(dispatch_get_main_queue(), ^{
            for (TagLocal *tl in pvc.tags)
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
            [self.activity stopAnimating];
            [self refresh];
        });
    });*/
    [self refresh];
    
    //NSMutableArray *tagPFObjects = [[NSMutableArray alloc]init];
    

    /*PFRelation *relation = [post relationforKey:@"tags"];
    for (PFObject *tagObject in tagPFObjects)
    {
        [relation addObject:tagObject];
    }*/
    
        
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


- (IBAction)reveal:(UIBarButtonItem *)sender
{
     [self.slidingViewController anchorTopViewTo:ECRight];
}

-(IBAction)done:(UIStoryboardSegue*)sender
{
    
}

-(IBAction)searchDone:(UIStoryboardSegue*)segue
{
    SearchViewController *svc = (SearchViewController*)segue.sourceViewController;
    NSArray *preObjects = svc.filteredObjects[svc.selectedKey];
    NSMutableArray *postObjectIds = [[NSMutableArray alloc]init];
    for(PFObject *object in preObjects)
        [postObjectIds addObject:object.objectId];
    self.label.text = svc.selectedKey;
    self.fromSearch = YES;
    [self getImages:postObjectIds];
}
- (IBAction)showChooser:(UIBarButtonItem *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 2)
    {
        NSNumber *number = [NSNumber numberWithInteger:buttonIndex];
        [self performSegueWithIdentifier:@"showMedia" sender:number];
    }
}
- (IBAction)refresh:(id)sender
{
    [self refresh];
}

@end
