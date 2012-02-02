//
//  EnteDetailsController.m
//  AnimeUnderground
//
//  Created by Nacho López on 27/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnteDetailsController.h"
#import "Ente.h"
#import "MMGridViewDefaultCell.h"
#import "CargoEnteSerie.h"
#import "SerieDetailsController.h"
#import "AUnder.h"
#import "UIImageView+WebCache.h"

@interface EnteDetailsController (Private)

- (void) setupGridPages;

@end

@implementation EnteDetailsController

@synthesize estado;
@synthesize avatar;
@synthesize subnick;
@synthesize datosExtra;
@synthesize gridView;
@synthesize rolFavorito;
@synthesize sliderPageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEnteId:(int)enteId {
    self = [super init];
    if (self) {
        ente = [[[AUnder sharedInstance] getEnteById:enteId]retain];

    }
    
    return self;
}

- (void)dealloc
{
    [rolFavorito release];
    [datosExtra release];
    [subnick release];
    [estado release];
    [avatar release];
    [ente release];
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
    self.title = ente.nick;
    
    if (ente.activo) 
        self.estado.text = @"Ente activo";
    else
        self.estado.text = @"Ente inactivo / Ex-miembro";

    self.subnick.text = ente.titulo;
    self.datosExtra.text = [NSString stringWithFormat:@"%@ - %d años - %@",ente.sexo,ente.edad,ente.ciudad];
    
    self.sliderPageControl = [[SliderPageControl alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
    [self.sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderPageControl setDelegate:self];
    [self.sliderPageControl setShowsHint:YES];
    [self.view addSubview:self.sliderPageControl];
    [self.sliderPageControl release];
    [self.sliderPageControl setNumberOfPages:[ente.cargos count]];
    [self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    [self setupGridPages];

    
    NSMutableDictionary *roles = [[[NSMutableDictionary alloc]init]autorelease];
    
    // iniciamos lazy loading de imágenes
    
    [self.avatar setImageWithURL:[NSURL URLWithString:ente.avatar]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // carga de lazyloading
        for (CargoEnteSerie *s in ente.cargos) {
            
            // aprovechamos para hacer un piggyback de la seleccion de rol favorito            
            NSNumber *num = [roles objectForKey:s.cargo];
            if (num==nil) {
                num = [NSNumber numberWithInt:1];
                [roles setValue:num forKey:s.cargo];
            } else {
                NSNumber *anotherNum = [NSNumber numberWithInt:[num intValue]+1];
                [roles setValue: anotherNum forKey:s.cargo];
            }
        }
        
        // obtenemos el cargo más repetido
        NSEnumerator *enumerator = [roles keyEnumerator];
        id key;
        NSString *cargoMax = [[NSString alloc]init];
        int numMax = 0;
        
        while ((key = [enumerator nextObject])) {
            NSNumber *tmp = [roles objectForKey:key];
            NSString *tmpStr = key;
            if ([tmp intValue]>numMax) {
                cargoMax = tmpStr;
                numMax = [tmp intValue];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rolFavorito setText: [[NSString alloc] initWithFormat:@"%@ (%d veces)",cargoMax,numMax]];
            [cargoMax release];
        });

    });
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.avatar = nil;
    self.estado = nil;
    self.subnick = nil;
    self.datosExtra = nil;
    self.rolFavorito = nil;
}

- (void)setupGridPages {
    [sliderPageControl setNumberOfPages:gridView.numberOfPages];
    [sliderPageControl setCurrentPage:gridView.currentPageIndex animated:YES];
}

- (void)onPageChanged:(id)sender
{
    [gridView moveToPage:sliderPageControl.currentPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma - MMGridViewDataSource

- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
	NSString *hintTitle = [[NSString alloc]initWithFormat:@"Página %d",page];
	return hintTitle;
}


- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [[ente cargos]count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull] autorelease];
    
    CargoEnteSerie *s = [[ente cargos]objectAtIndex:index];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d cap.)",s.cargo,s.capitulos];
    
    if (![cell.backgroundView tag]) {
        [cell.backgroundView setTag:1];
        CGRect newRect = CGRectMake(0, 0, 155, 40);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:newRect];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        [imgView setImageWithURL:[NSURL URLWithString:[[s serie]imagen]] placeholderImage:[UIImage imageNamed:@"logro_barra_au.png"]];
        [cell.backgroundView setClipsToBounds:YES];
        [cell.backgroundView addSubview:imgView];
        [imgView release];
        
    }

    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    CargoEnteSerie *s = [[ente cargos]objectAtIndex:index];
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[[s serie]codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
    [sdc release];
}


- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
    NSLog(@"Cambio de página a %d",index);
    [self setupGridPages];
}

@end
