//
//  NoticiasController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 05/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "NoticiasController.h"
#import "Noticia.h"
#import "Ente.h"
#import "Serie.h"
#import "NoticiaCell.h"
#import "Imagen.h"
#import "NoticiaDetailsController.h"
#import "AUnder.h"
#import "UIImageView+WebCache.h"
#import "PullToRefreshCell.h"

@implementation NoticiasController

@class AUnder;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init]; //[super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [infoLabel_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    [self setTitle:@"Noticias"];
    
    infoLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(16, 4, 140, 20)];
    infoLabel_.font = [UIFont boldSystemFontOfSize:12];
    infoLabel_.textAlignment = UITextAlignmentLeft;
    infoLabel_.textColor = [UIColor whiteColor];
    infoLabel_.shadowColor = [UIColor blackColor];
    infoLabel_.backgroundColor = [UIColor clearColor];
    infoLabel_.shadowOffset = CGSizeMake(0, 1);
    
    // set the custom view for "pull to refresh". See DemoTableHeaderView.xib.
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PullToRefreshCell" owner:self options:nil];
    PullToRefreshCell *headerView = (PullToRefreshCell *)[nib objectAtIndex:0];
    self.headerView = headerView;
     
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

#pragma mark - STableView stuff

- (void) pinHeaderView
{
    [super pinHeaderView];
    
    PullToRefreshCell *p2rc = (PullToRefreshCell *)self.headerView;
    [p2rc.pullActivityIndicator setHidden:NO];
    [p2rc.pullActivityIndicator startAnimating];
    [p2rc.pullLabel setText:@"Tira para actualizar"];
}

- (void) unpinHeaderView
{
    [super unpinHeaderView];
    
    PullToRefreshCell *p2rc = (PullToRefreshCell *)self.headerView;
    [p2rc.pullActivityIndicator stopAnimating];
}

- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    PullToRefreshCell *p2rc = (PullToRefreshCell *)self.headerView;
    if (willRefreshOnRelease)
        p2rc.pullLabel.text = @"Tira para actualizar";
    else
        p2rc.pullLabel.text = @"Suelta para actualizar";
}


- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    // [self performSelector:@selector(addItemsOnTop) withObject:nil afterDelay:2.0];
    // See -addItemsOnTop for more info on how to finish loading
    
    [[AUnder sharedInstance]setUpdateHandler:self];
    
    [[AUnder sharedInstance]update]; // el método es asíncrono
    
    return YES;
}

#pragma mark - AUnder update delegate
- (void)onBeginUpdate:(AUnder*)aunder {
    NSLog(@"Actualizacion comenzada");
    PullToRefreshCell *p2rc = (PullToRefreshCell *)self.headerView;
    p2rc.pullLabel.text = @"Actualizando...";

}

- (void)onUpdateStatus:(AUnder*)aunder:(NSString*)withStatus {
    //NSLog(@"Estado actual de la actualización: %@",withStatus);
}

- (void)onUpdateError:(AUnder*)aunder {
    NSLog(@"Ha habido un error actualizando");
    [self refreshCompleted];
}

- (void)onFinishUpdate:(AUnder*)aunder {
    NSLog(@"Actualizacion finalizada");   
    [self.tableView reloadData];
    [self refreshCompleted];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AUnder sharedInstance] noticias]count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"NoticiaCell";
    
    NoticiaCell *cell = (NoticiaCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NoticiaCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (NoticiaCell*) currentObject;
				break;
			}
		}
    }    
    
    Noticia *noti = [[[AUnder sharedInstance]noticias] objectAtIndex:indexPath.row];
    
    cell.titulo.text = [noti titulo];
    cell.autor.text = [[noti autor]nick];
    cell.fecha.text = [noti fecha];
    
    cell.titulo.tag = [noti codigo];
    
    if ([[noti imagenes] count]>0 && cell.imageView.image==nil) {
        NSString *url = [(Imagen*)[noti.imagenes objectAtIndex:0] getThumbUrl];
        [cell.imagen setImageWithURL:[NSURL URLWithString: url] placeholderImage:nil];
    }
    
    // Configure the cell.
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - KNTableView stuff

/*
-(void)infoPanelDidScroll:(UIScrollView *)scrollView atPoint:(CGPoint)point {
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    Noticia *noti = [[[AUnder sharedInstance]noticias] objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];    
    
    NSDate *fecha = [dateFormatter dateFromString:noti.fecha];

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat: @"MMMM, yyyy"];
    NSString *newFecha = [[dateFormatter stringFromDate:fecha] capitalizedString];
    
    [locale release];
    [dateFormatter release];
    
    [infoLabel_ setText:newFecha];
}


-(void)infoPanelWillAppear:(UIScrollView *)scrollView {
    if (![infoLabel_ superview]) [self.infoPanel addSubview:infoLabel_];
}
*/
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Index of the menu item currently clicked: %u", ([indexPath row]));
	int codigo = [[[[AUnder sharedInstance] noticias] objectAtIndex: indexPath.row] codigo];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NoticiaDetailsController *tmp = [[NoticiaDetailsController alloc]init];
    tmp.codigoNoticia = codigo;
	
	[self.navigationController pushViewController:tmp animated:YES];
    [tmp release];
}

@end
