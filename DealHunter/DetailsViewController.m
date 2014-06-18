//
//  DetailsViewController.m
//  DealHunter
//
//  Created by Pratik on 19-11-13.
//  Copyright (c) 2014 Appacitive. All rights reserved.
//

#import "DetailsViewController.h"
#import <Appacitive/AppacitiveSDK.h>

@interface DetailsViewController ()

@end

@implementation DetailsViewController {
    IBOutlet UILabel *_storeName;
    IBOutlet UILabel *_location;
    IBOutlet UILabel *_details;
}

NSString *uniqueID;

-(void) setUniqueID:(id)newID {
    uniqueID = newID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [APConnections fetchObjectsConnectedToObjectOfType:@"deal" withObjectId:uniqueID withRelationType:@"details" fetchConnections:NO successHandler:^(NSArray *objects) {
        APGraphNode *node = [objects lastObject];
        [_storeName setText:(NSString*)[node.object getPropertyWithKey:@"storename"]];
        [_location setText:(NSString*)[node.object getPropertyWithKey:@"location"]];
        [_details setText:(NSString*)[node.object getPropertyWithKey:@"details"]];
    }];
}

@end
