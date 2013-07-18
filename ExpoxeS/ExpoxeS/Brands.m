//
//  Brands.m
//  Expoxe
//
//  Created by LZ's MBA on 3/22/13.
//  Copyright (c) 2013 Expoxe. All rights reserved.
//

#import "Brands.h"
#import <Parse/Parse.h>
#import "TITokenField.h"

@implementation Brands
//+(NSArray*)listOfBrands:(NSString*)input token:(NSArray*)tokens
+(void)listOfBrands:(NSString*)input token:(NSArray*)tokens target:(id)theTarget;
{
    if([tokens count] == 0)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Category"];
        [query whereKey:@"canonicalName" containsString:[input lowercaseString]];
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        //NSArray *result = [query findObjects];
        [query cancel];
        [query findObjectsInBackgroundWithTarget:theTarget selector:@selector(callBack:)];
        //return result;
        /*NSMutableArray *array = [[NSMutableArray alloc]init];
        for(PFObject *object in result)
        {
            [array addObject:[object objectForKey:@"categoryName"]];
        }
        return array;*/
    }
    else if ([tokens count] == 1)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Brand"];
        [query whereKey:@"canonicalName" containsString:[input lowercaseString]];
        TIToken *token = [tokens objectAtIndex:0];
        PFObject *cat = token.thePFObject;
        [query whereKey:@"category" equalTo:cat];
        [query cancel];
        [query findObjectsInBackgroundWithTarget:theTarget selector:@selector(callBack:)];
        //NSArray *result = [query findObjects];
        //return result;
        /*NSMutableArray *array = [[NSMutableArray alloc]init];
        for(PFObject *object in result)
        {
            [array addObject:[object objectForKey:@"brandName"]];
        }
        return array;*/
    }
    else if ([tokens count] == 2)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Model"];
        [query whereKey:@"canonicalName" hasPrefix:[input lowercaseString]];
        TIToken *token = [tokens objectAtIndex:1];
        PFObject *bra = token.thePFObject;
        [query whereKey:@"brand" equalTo:bra];
        [query cancel];
        [query findObjectsInBackgroundWithTarget:theTarget selector:@selector(callBack:)];
        //NSArray *result = [query findObjects];
        //return result;
    }
    //return nil;
}
@end
