//
//  MenuViewController.m
//  AnimeUnderground
//
//  Created by Nacho Lopez on 03/02/12.
//  Copyright (c) 2012 AUDev. All rights reserved.
//

#import "MenuViewController.h"
#import "NoticiasController.h"
#import "SeriesController.h"
#import "EntesController.h"
#import "ForoController.h"
#import "AnimeUndergroundAppDelegate.h"

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NoticiasController *nc = [[NoticiasController alloc]initWithStyle:UITableViewStylePlain];
        SeriesController *sc = [[SeriesController alloc]initWithNibName:@"SeriesController" bundle:nil];
        EntesController *ec = [[EntesController alloc]initWithStyle:UITableViewStylePlain];
        ForoController *fc = [[ForoController alloc]initWithNibName:@"ForoController" bundle:nil];
        
        menuElements_ = [[[NSArray alloc]initWithObjects:nc,sc,ec,fc, nil] retain];
        menuTitles_ = [[NSArray alloc]initWithObjects:@"Noticias", @"Series", @"Entes", @"Foro", nil];
        
        [nc release];
        [sc release];
        [ec release];
        [fc release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [menuTitles_ release];
    [menuElements_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuElements_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
       
    [cell.textLabel setText:[menuTitles_ objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"AnimeUnderground";
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [[AppDelegate menuController] setRootController:[menuElements_ objectAtIndex:indexPath.row] animated:YES];
    [[AppDelegate menuController] setLeftController:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
