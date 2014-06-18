Building a daily deals app using the Appacitive iOS SDK
==================

Hello and welcome to the first part of the tutorial series – “Working with Appacitive iOS SDK”.

Firstly, let me introduce you to a “backend as a service” platform called Appacitive. If you are not familiar with Appacitive, head over to [Appacitive home page](http://www.appacitive.com) and take a quick look around. If you have worked with platforms like Parse, Kinvey, StackMob etc, your first impression will be that Appacitive is quite similar in what it has to offers but I assure you there's a lot more than meets the eye. What sets it apart from the competition is the visual data modelling. It is a very intuitive feature and gives you a birds-eye view of your entire data model. To make it easier for you to begin modelling your data on Appacitive, the team has uploaded video walkthroughs at [Appacititve videos page](http://vimeo.com/appacitive). At any point if you get stuck, take a peek at the videos, they are really helpful.

A few more links worth checking out:

* [Documentation and samples](http://appacitive.github.io/)
* [Consolidated help for all platforms](http://help.appacitive.com/)
* [Blog](http://blogs.appacitive.com/)

Lets familiarise ourselves with the terminology of Appacitive platform since I will be using it frequently in the tutorial.

**Type**: A `type` in Appacitive is like a `class` in Objective-C. It represents a generic wireframe for an entity. Just like a class has properties and methods in Objective-C, a type in Appacitive can have properties, attributes and tags. Appacitive provides some pre-defined types out of the box so you don't have to create them. Two best examples of predefined types `User` and `Device`. You also have some predefined system properties for the types which saves a lot of time spent otherwise in defining and managing those properties. Most of the system defined properties are read-only and are either managed by the API or the SDK. Just like you extend and subclass classes in Objective-C, you can also add your own properties to a type in Appacitive apart from the system defined ones.

**Object**: An `object` in Appacitive is similar to an `object` in Objective-C. It is an instance of a type. It can hold properties, attributes and tags.

**Relation**: A `relation` in Appacitive is like a `table` in a relational database. It defines a relation between two objects. A relation can also have properties, attributes and tags. Again some system properties are predefined for you and you can always add as many of your own as you need. Think of properties, attributes and tags as columns in a relational database. You can perform all the operations on relations that you would perform on a table in a relational database. Relations can be one-to-one, one-to-many, many-to-one or many-to-many.

**Connection**: A `connection` is an instance of a relation. It is like a set of one or more `records` or `rows` in a relational database.

I assume that by now you have familiarised yourself with building your data model on appacitive. For the sake of this tutorial, we will create a simple app named DealHunter. The purpose of this app is to show deals on shopping to the users based on their location. Head over to http://portal.appacitive.com and login to your account or sign up for one if you didn't already do so. Create a new app named DealHunter. Now form the left hand side menu bar, select `design`. The content view will now display all the `Types` and `Relations` of your app. Select `edit` from the actions bar at the bottom and on the content view in the search field, type the `deal` and press return. This will create a new type named `deal`. Select the type and on the content view click the blue button that says 'add property' and add the properties as shown in the screenshots below.
	Also create the types `dealdetail` and `comment`. Then click on relations and create the relations `details`, `author`, `comments` and `liked`. Add the respective properties as shown in the screenshot images below.

<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss01.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss02.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss03.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss04.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss05.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss06.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss07.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss08.png" alt="Screenshot" style="max-width:100%;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss12.png" alt="Screenshot" style="max-width:100%;" />

Now that our model is set up lets begin creating the app. Open Xcode and create a new project, select the ‘Master-Detail Application’ project template. Name it `DealHunter` and select `iPhone` form the `Devices` drop down box.

There are two ways you can integrate the Appacitive SDK in to your project.

* Using the Appacitive SDK framework bundle.
* Using the CocoaPods dependency manager.

The guides to both the above mentioned methods to integrate the SDK can be found at <Insert_Link_Here>. For the sake of this tutorial, we will use the framework bundle, since it is more convenient.

####REGISTERING THE API KEY

In order to make communicate with the Appacitive back end you need to first register the APIkey in to your app. To do so, open the AppdDelegate.m and in the application:didFinishLaunchingWithOptions: method add the following line of code to register the APIKey in to your app. If you are using the live environment make sure to set the useLiveEnvironment parameter to YES.

```objectivec
[Appacitive registerAPIKey:@"YOUR_API_KEY_HERE" useLiveEnvironment:NO];
```

####IMPLEMENTING AUTHENTICATION:
Add a new file to the project. Select Objective-C class form the template. Name the class `LoginViewController` and select `UIViewController` form the Subclass of drop down menu. Make sure the `Targeted for iPad` and `With XIB for user interface` are unchecked.

Open the `LoginViewController.h` file and add two `IBOutlets` of type `UITextfield` for the *username* and *password* fields. Also add an action method for `Login`.

```objectivec
@interface LoginViewController : UIViewController

@property IBOutlet UITextField *username;
@property IBOutlet UITextField *password;

-(IBAction)login;

@end
```

Open the `LoginViewController.m` file. First add an import statement for the appacitive SDK.


```objectivec
#import <Appacitive/AppacitiveSDK.h> 
```

Lets implement the `login` method.

```objectivec
@implementation LoginViewController

-(IBAction)login {
    if(_username.text != nil && _password.text != nil)
    {
        [APUser authenticateUserWithUsername:_username.text password:_password.text sessionExpiresAfter:nil limitAPICallsTo:nil successHandler:^(APUser *user){
            [self dismissViewControllerAnimated:YES completion:nil];
        } failureHandler:^(APError *error) {
            NSLog(@"ERROR:%@",[error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error occurred" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

@end
```

In the `login` method we use the AppacitiveSDK’s `APUser` class method `authenticateUserWithUserName:password:successHandler:failureHandler` to login using a user created on appacitive. In the successHandler we dismiss the current view.

In the failure handler you can examine the error code and display a more appropriate error message i.e. **request failed** or **username or password was incorrect** etc. But for the sake of this tutorial we will just go with a generic error message.

Open the storyboard and add a new *ViewController* to the storyboard. Add a *segue* from the newly added ViewController to the `MasterViewController`. In the *identifier* field for the segue type `showLoginView`.

Add two `UITextFields` and a `UIButton` on the `LoginViewController`. Edit the placeholder text of the first `UITextField` to `username` and the second one to `password`. Select the second `UITextField` and open the *attributes inspector* and click on the `secure` checkbox to mask the input since its a password field.

Add a new *referencing outlet* for the username `UITextField`. Similarly, add an outlet for the password `UITextField`. Select the `UIButton` and open the *attributes inspector* and set the button title to `Login`. Now open the *connections inspector* and click + drag from the circle next to `Touch Up Inside` from `Sent events` to the Login View Controller and select `login` from the pop-up menu.

<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss17.png" alt="Screenshot" style="max-width:100%;" />

####IMPLEMENTING MASTER DETAIL VIEWS:

Open the master view controller named TableViewController.m and add in the following code:

```objectivec
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
```

In the `locationManager:didUpdateLocations:` method, we first build a location based query. 

```objectivec
APQuery *locationQuery= [[APQuery alloc] init];
locationQuery.filterQuery = [APQuery queryWithRadialSearchForProperty:@"location" nearLocation:_location withinRadius:@5 usingDistanceMetric:kKilometers];
```

The above statement will give us a query for making a radial search for `location` property of a deal within 5 km of users current location. We then use this query to search all objects of `deal` type that conform to the query conditions. In short its searching for all the objects in the `deal` schema that have the `location` property value within 5 km of user’s current location. In the success block of the search method we add the `deal` objects to the `UITableView’s` data source array and reload the `UITableView`.

In the `tableView:cellForRowAtIndexPath:` method, we set the text label of the table view cell to the name of the deal. We are going to need the unique identifier of the deal later so we add it to the cell’s `accessibilityValue`.

In the `tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath` method we use the unique id of the deal we had saved in the cell’s accessibilityValue to set the uniqueID of the DetailsViewController. We then call the segue showDetails to bring in the detailed view of the selected deal. But we haven’t set the segue identifier to showDetails so quickly go to the storyboard, select the segue connecting the MasterViewController and the DetailsViewController and set its identifier in the attributes inspector to `showDetails` without the quotes.


Open the `DetailsViewController.h` file and add replace all the code with the code below:

```objectivec
@interface DetailsViewController : UIViewController

-(void) setUniqueID:newID;

@end
```

All we have here is a method to set the unique identifier of the deal that we will need to retrieve its details.

Open the `DetailsViewController.m` file and replace all the code with the code below:

```objectivec
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
```

Here we have three `IBOutlets` for the `UILabels` for the `Store name`, `store location` and `details` about the deal. Make sure that you add these three labels in the storyboard and hook them up with the `ViewController` via a *referencing outlet* for each. 

We then implement the setter method for the uniqueID.

In the `viewDidLoad` method we call the `APConnection’s` `fetchConnectedObjectsOfType:withObjectId:withRelationType:successHandler` class method to fetch all the objects connected to the deal we want the details of. In the `successHandler`, we get the result in the form of an `APGraphNode` Object.

The structure of an APGraphNode is as follows:

```objectivec
APGraphNode {
	APObject, 
	APConnection,
	Map { 
		//Dictionary of GraphNodes
	}
}
```

######An APGraphNode object encapsulates:
An `APObject` that represents the object at current node.
An `APConnection` object that represents a connection between the current object and its parent object. For the root object, the connection will always be null since it has no parent.
A map that is a dictionary which holds the child objects(`APGraphNode` objects) of the current node.

In the success block of the `fetchConnectedObjectsOfType:withObjectId:withRelationType:successHandler` method, we get an array of objects of type APGraphNode. Since we are expecting only a single details object corresponding to a deal object, we set the values of the three UILabel outlets.

The project is complete, build and run it.

<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss14.png" alt="Screenshot" style="width:46%; padding:2%; float:left;" />
<img src="http://devcenter.appacitive.com/ios/samples/dealhunter/ss15.png" alt="Screenshot" style="width:46%; padding:2%;" />

####CONCLUSION:

We saw how we can access our model on Appacitive through the Appacitive SDK in various ways and forms. This is just a very small example of how you can implement the controller for your model on Appacitive. If you have got a hang of this sample, you can proceed with the next tutorial in this series.