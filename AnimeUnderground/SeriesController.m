//
//  SeriesController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 08/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "SeriesController.h"
#import "Serie.h"
#import "Imagen.h"
#import "DeviantDownload.h"

@implementation SeriesController
@class AUnder,SerieDetailsController;
@synthesize carousel, nombreSerie, loadingView, loadingSpinner;

- (void)dealloc
{
    [loadingSpinner release];
    [loadingView release];
    [carousel release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Series";
    
    // en teoría esto carga la pantalla de carga, pero no se muestra
    [self.view addSubview:loadingView];
    loadingView.center = self.view.center;
    [loadingSpinner startAnimating];
    
    downloads = [[[NSMutableArray alloc]init]retain];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (Serie *s in [[AUnder sharedInstance] series]) {
            DeviantDownload *dd = [[DeviantDownload alloc]init];
            dd.urlString = [[s imagen] retain];
            [downloads addObject: [dd retain]];
        }
        
        carousel.type = iCarouselTypeCoverFlow;
        // habrá que añadir un loading al estilo de rootviewcontroller
        dispatch_async(dispatch_get_main_queue(), ^{
            [carousel reloadData];
            currentSelection = 0;
            [loadingView removeFromSuperview];
        });       
    });
    currentSelection = 0;
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:0];
    nombreSerie.text = s.nombre;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    self.loadingView = nil;
    self.loadingSpinner = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[[AUnder sharedInstance]series] count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    //create a numbered view
    
    DeviantDownload *download = [downloads objectAtIndex:index];
    
    UIImage *imagen = download.image;
    if (imagen == nil) {
        imagen = [UIImage imageNamed:@"page.png"];
        download.delegate = self;
    }
    UIView *view = [[[UIImageView alloc] initWithImage:[self imageWithImage:imagen scaledToSize:CGSizeMake(200, 200)]] autorelease];

    currentSelection = index;
    
    //UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];

    return view;
}


- (void)downloadDidFinishDownloading:(DeviantDownload *)download {
    
    NSUInteger index = [downloads indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    
    NSLog(@"Terminada descarga de %@",[download urlString]);
    
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}

- (void)carouselCurrentItemIndexUpdated:(iCarousel *)car {
    int index = carousel.currentItemIndex;
    currentSelection = index;
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:index];
    nombreSerie.text = s.nombre;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return 200;
}

- (CATransform3D)carousel:(iCarousel *)carousel transformForItemView:(UIView *)view withOffset:(float)offset
{
    //implement 'flip3D' style carousel
    
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)car
{
    //wrap all carousels
    return NO;
}

// reacción de la ui

-(IBAction) showSerieDetails {
    Serie *s = [[[AUnder sharedInstance]series] objectAtIndex:currentSelection];
    NSLog(@"serie elegida = %@",s.nombre);
    SerieDetailsController *sdc = [[SerieDetailsController alloc]init];
    [sdc setCodigoSerie:[s codigo]];
    [self.navigationController pushViewController:sdc animated:YES];
}

@end