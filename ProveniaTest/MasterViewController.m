//
//  MasterViewController.m
//  ProveniaTest
//
//  Created by Federico Frappi on 19/02/13.
//  Copyright (c) 2013 F&F Services S.R.L. All rights reserved.
//

#import "MasterViewController.h"
#import "CustomCell.h"
#import "DetailViewController.h"

@interface MasterViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *prevPageBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextPageBtn;

@property (nonatomic, strong) NSMutableData* connectionData;
@property (nonatomic, assign) NSUInteger currentPageNumber;

@property (nonatomic, strong) NSArray* fetchedObjects;

@property (nonatomic, strong) UIPopoverController* popover;

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																							   target:self
																							   action:@selector(reloadData)];
		[self updateTitle];
    }
    return self;
}
							

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self showPage:0];
	[self reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	[_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) updateTitle{
	NSString* revNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"revN"];
	self.title = revNumber!=nil?[NSString stringWithFormat:@"Rev. %@", revNumber]:@"";
}

#pragma mark - WS Connection

- (void)reloadData{
	self.title = @"Downloading...";
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:DATA_URL]];
	[NSURLConnection connectionWithRequest:req delegate:self];
}

- (void)parseResponse:(NSDictionary*)response{
	//Save the rev id and update the title accordingly
	NSString* rev = response[@"last_rev_id"];
	if (rev!=nil) {
		[[NSUserDefaults standardUserDefaults] setObject:rev forKey:@"revN"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	[self updateTitle];
	
	
	//Delete the old records from the data store
	NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:@"File"];
	NSError* error = nil;
	NSArray* toBeDeleted = [_managedObjectContext executeFetchRequest:req error:&error];
	if (error!=nil) {
		NSLog(@"Error while deleting existing objects!\n%@", [error userInfo]);
		[self connectionError];
		return;
	}
	for(NSManagedObject* obj in toBeDeleted){
		[_managedObjectContext deleteObject:obj];
	}
	
	
	//Add the new records to the data store
	NSArray* fileArray = response[@"my_files"][@"content"];
	if (fileArray!=nil) {
		for (NSDictionary* dict in response[@"my_files"][@"content"]){
			NSEntityDescription* entity = [NSEntityDescription entityForName:@"File" inManagedObjectContext:_managedObjectContext];
			
			NSManagedObject* obj = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:_managedObjectContext];
			[obj setValuesForKeysWithDictionary:dict];
		}
	} else{
		[self connectionError];
		return;
	}
	
	//Persist
    error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[self connectionError];
    }
}

- (void)connectionError{
	[self updateTitle];
	[[[UIAlertView alloc] initWithTitle:@"Connection error"
							   message:@"There was an error while downling the data, please try again later."
							  delegate:nil
					 cancelButtonTitle:@"Ok"
					 otherButtonTitles:nil] show];
}

#pragma mark - NSURLConnectionDataDelegate protocol

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{	
	self.connectionData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[_connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSError* error = nil;
	NSDictionary* response = [NSJSONSerialization JSONObjectWithData:_connectionData options:0 error:&error];
	if (error!=nil) {
		NSLog(@"Error while parsing JSON response!\n%@", [error userInfo]);
		[self connectionError];
		return;
	}
	
	[self parseResponse:response];
	[self showPage:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"Error While Downloading Data From The WS!");
	[self connectionError];
}

#pragma mark - Pagination Handling

- (IBAction)prevPageTapped:(id)sender {
	[self showPage:_currentPageNumber-1];
}

- (IBAction)nextPageTapped:(id)sender {
	[self showPage:_currentPageNumber+1];
}

- (void)showPage:(NSUInteger)page{
	NSUInteger totalItems = [_managedObjectContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"File"] error:nil];
	NSUInteger totalPages = ceil((double)totalItems/(double)ITEMS_PER_PAGE);
	
	_currentPageNumber = page;
	_statusLabel.text = [NSString stringWithFormat:@"Page %d/%d", _currentPageNumber+1, totalPages];
	
	_prevPageBtn.enabled = _currentPageNumber>0;
	_nextPageBtn.enabled = _currentPageNumber<(totalPages-1);
	
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"File"];
	
    fetchRequest.fetchBatchSize = ITEMS_PER_PAGE;
	fetchRequest.fetchLimit = ITEMS_PER_PAGE;
	fetchRequest.fetchOffset = _currentPageNumber*ITEMS_PER_PAGE;
	
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"last_updated_date" ascending:YES]];
	
	NSError *error = nil;
	NSArray* fetched = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (error) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	self.fetchedObjects = fetched;
	
	[_tableView reloadData];
}

#pragma mark - Table View DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CustomCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
			cell = [[[UINib nibWithNibName:@"CustomCell_iPhone" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        } else {
			cell = [[[UINib nibWithNibName:@"CustomCell_iPad" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
		}
    }
	
	[cell configureForObject:_fetchedObjects[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	DetailViewController* detailVC = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
	
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		[self.navigationController pushViewController:detailVC animated:YES];
	} else {
		self.popover = [[UIPopoverController alloc] initWithContentViewController:detailVC];
		[_popover setPopoverContentSize:CGSizeMake(300.f, 300.f)];
		[_popover setDelegate:self];
		
		[_popover presentPopoverFromRect:[_tableView cellForRowAtIndexPath:indexPath].frame
										   inView:_tableView
						 permittedArrowDirections:UIPopoverArrowDirectionAny
										 animated:YES];
		
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return 223.f;
	} else {
		return 395.f;
	}
}

# pragma mark UIPopoverDelegate protocol

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
	self.popover = nil;
}

@end
