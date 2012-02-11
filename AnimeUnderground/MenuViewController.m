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
#import "MenuCell.h"
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
        menuImages_ = [[NSArray alloc]initWithObjects:@"noticia.png",@"series.png",@"entes.png",@"foro.png", nil];
        
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
    [menuImages_ release];
    [menuElements_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Estilo de tabla
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view setBackgroundColor:[UIColor colorWithRed:0x67/255.0f green:0x67/255.0f blue:0x67/255.0f alpha:1.0]];
    [self.tableView setBounces:NO];

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
    static NSString *CellIdentifier = @"MenuCell";
    
    MenuCell *cell = (MenuCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (MenuCell*) currentObject;
				break;
			}
		}
    }    
    
       
    [cell.titleLbl setText:[menuTitles_ objectAtIndex:indexPath.row]];
    [cell.titleImg setImage:[UIImage imageNamed:[menuImages_ objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [imgView setImage:[UIImage imageNamed:@"navbar.png"]];
    [headerView addSubview: imgView];
    [imgView release];
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [imgView setImage:[UIImage imageNamed:@"aunder_text.png"]];
    [headerView addSubview:imgView];
    [imgView release];
    
    return [headerView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //MenuCell *cell = (MenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [[AppDelegate menuController] setRootController:[menuElements_ objectAtIndex:indexPath.row] animated:YES];
    [[AppDelegate menuController] setLeftController:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
