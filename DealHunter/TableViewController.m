//
//  TableViewController.m
//  DealHunter
//
//  Created by Pratik on 18-11-13.
//  Copyright (c) 2014 Appacitive. All rights reserved.
//

#import "TableViewController.h"
#import "DetailsViewController.h"
#import <Appacitive/AppacitiveSDK.h>

@interface TableViewController() <CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate>
@end

@implementation TableViewController {
    CLLocationManager *_locationManager;
    NSMutableArray *_deals;
    CLLocation *_location;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _deals = [[NSMutableArray alloc]init];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 500;
    [_locationManager startUpdatingLocation];
}

#pragma mark CLLocationManager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _location = locations.lastObject;
    [_deals removeAllObjects];
    APQuery *locationQuery= [[APQuery alloc] init];
    locationQuery.filterQuery = [APQuery queryWithRadialSearchForProperty:@"location" nearLocation:_location withinRadius:@5 usingDistanceMetric:kKilometers];
    [APObject searchAllObjectsWithTypeName:@"deal" withQuery:[locationQuery stringValue] successHandler:^(NSArray *objects, NSInteger pageNumber, NSInteger pageSize, NSInteger totalRecords) {
        for (APObject *obj in objects) {
            NSArray *loc = [(NSString*)[obj getPropertyWithKey:@"location"] componentsSeparatedByString:@","];
            if(((CLLocation*)locations.lastObject).coordinate.latitude == [loc[0] doubleValue] && (((CLLocation*)locations.lastObject).coordinate.longitude == [loc[1] doubleValue]))
                [_deals addObject:obj];
                [self.tableView reloadData];
        }
    }
     failureHandler:^(APError *error) {
         NSLog(@"ERROR: %@",[error description]);
     }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"LOCATION FETCH ERROR:%@", error);
}

#pragma mark UITableView Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [[_deals lastObject] getPropertyWithKey:@"name"];
    cell.accessibilityValue = ((APObject*)[_deals lastObject]).objectId;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *dvc = [[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
    [dvc setUniqueID:[self.tableView cellForRowAtIndexPath:indexPath].accessibilityValue];
    [self performSegueWithIdentifier:@"showDetails" sender:self];
}

@end
