//
//  ImageViewController.m
//  ExpoxeS
//
//  Created by LZ's MBA on 4/3/13.
//  Copyright (c) 2013 Joseph Au. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) NSMutableArray *tagLabels;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation ImageViewController

-(NSMutableArray*)tagLabels
{
    if(!_tagLabels)
        _tagLabels = [[NSMutableArray alloc]init];
    return _tagLabels;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
}

-(void)setCaptionText:(NSString *)captionText
{
    _captionText = captionText;
}

-(UIImageView*)imageView
{
    if(!_imageView) _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    return _imageView;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.image.size;
    self.imageView.image = self.image;
    [self resetImage];
    self.toolBar.hidden = YES;
    self.label.text = self.captionText;
    [self drawTags];
}


-(void)resetImage
{
    if(self.scrollView)
    {
        self.scrollView.contentSize = self.image.size;
        self.scrollView.zoomScale = 1.0;
        self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

-(void)drawTags
{
    if(self.tags)
    {
        for(PFObject *object in self.tags)
        {
            NSNumber *locationX = [object objectForKey:@"locationX"];
            NSNumber *locationY = [object objectForKey:@"locationY"];
            NSMutableArray *tagText = [[NSMutableArray alloc]init];
            
            PFObject *categoryFromTags = [object objectForKey:@"category"];
            PFObject *category = [categoryFromTags fetchIfNeeded];
            if(category)
            {
                NSString *categoryName = [category objectForKey:@"name"];
                [tagText addObject:categoryName];
            }
            
            PFObject *brandFromTags = [object objectForKey:@"brand"];
            PFObject *brand = [brandFromTags fetchIfNeeded];
            if(brand)
            {
                NSString *brandName = [brand objectForKey:@"name"];
                [tagText addObject:brandName];
            }
            
            PFObject *modelFromTags = [object objectForKey:@"model"];
            PFObject *model = [modelFromTags fetchIfNeeded];
            if(model)
            {
                NSString *modelName = [model objectForKey:@"name"];
                [tagText addObject:modelName];
            }
            
            NSString *tagTextString = [tagText componentsJoinedByString:@" "];
            //CGRect aRect = CGRectMake([locationX floatValue],
            //                          [locationY floatValue],
                                      //[tagTextString length]*5,
            //                          320 - [locationX floatValue],
            //                          ((320 - [locationX floatValue]) / [tagTextString length]) * 5);
            CGRect aRect = CGRectMake([locationX floatValue],
                                      [locationY floatValue],
                                      [tagTextString length]*10,
                                      20);
            UIButton *button = [[UIButton alloc]initWithFrame:aRect];
            [button setTitle:tagTextString forState:UIControlStateNormal];
            button.backgroundColor = [UIColor blackColor];
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            button.hidden = !button.hidden;
            [self.tagLabels addObject:button];
            [self.view addSubview:button];
        }
    }
}

- (IBAction)tapped:(UITapGestureRecognizer *)sender
{
    [self resetImage];
    self.toolBar.hidden = !self.toolBar.hidden;
    self.label.hidden = !self.label.hidden;
    for (UIButton *tagButton in self.tagLabels)
    {
        tagButton.hidden = !tagButton.hidden;
    }
}

@end
