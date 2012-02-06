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

@implementation NoticiasController

@class AUnder;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
