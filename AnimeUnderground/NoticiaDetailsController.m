//
//  NoticiaDetailsController.m
//  AnimeUnderground
//
//  Created by Nacho López Sais on 01/06/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "NoticiaDetailsController.h"
#import "iCarousel.h"
#import "DeviantDownload.h"
#import "Imagen.h"
#import "EnteDetailsController.h"
#import "Noticia.h"
#import "AUnder.h"
#import "UIImage+Resize.h"
#import "AUnder.h"
#import "Noticia.h"
#import "ForoController.h"
#import "UIImageView+WebCache.h"

@implementation NoticiaDetailsController

@synthesize codigoNoticia;
@synthesize nombreNoticia;
@synthesize nombreAutor;
@synthesize fechaNoticia;
@synthesize textoNoticia;
@synthesize imagenesNoticia = imagenesNoticia_;
@synthesize scroll;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [imagenesNoticia_ setDelegate: nil];
    [imagenesNoticia_ setDataSource: nil];
    [imagenesNoticia_ release]; imagenesNoticia_ = nil;
    
    [noti release];
    [fechaNoticia release];
    [nombreNoticia release];
    [nombreAutor release];
    [fechaNoticia release];
    [textoNoticia release];
    [scroll release];
    
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
    // Do any additional setup after loading the view from its nib.
    
    noti = [[[AUnder sharedInstance]getNoticiaByCodigo:codigoNoticia]retain];
    self.title = [NSString stringWithFormat:@"Detalles de %@",[noti titulo]];
    self.fechaNoticia.text = [noti fecha];
    self.textoNoticia.text = [noti texto];
    self.textoNoticia.numberOfLines = 0;
    [self.textoNoticia sizeToFit];
    self.nombreNoticia.text = [noti titulo];
    self.nombreAutor.text = [[noti autor]nick];
    
    tid = [[NSString alloc]initWithString:[noti tid]];
    codigoEnte = [[noti autor]codigo];
   
    
    //Si la noticia es de una serie se podrá hacer checkin en cualquier otro caso estoy haciendo check a un ente desconocido.
    
    if (noti.serie != nil) {
        UIImage  *backImage = [UIImage imageNamed:@"check.png"];
        NSArray *capis = [[[AUnder sharedInstance] checkin] getSerieInfo:noti.serie];

        float alpha = 0.5f;
        if ([capis containsObject:[NSNumber numberWithInteger:noti.capitulo]]) {
            alpha = 1.0f;
        }
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];  
        [checkButton addTarget:self action:@selector(changeCheck) forControlEvents:UIControlEventTouchUpInside];
        [checkButton setFrame:CGRectMake(0.0f, 0, 28, 28)];  
    
        
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:backImage] autorelease];
        [imageView setFrame:CGRectMake(5.0f, 0.0f, 16.0f, 18.0f)];
        [checkButton addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 18.0f, 25.0f, 10.0f)];
        label.text =@"Visto";
        label.textColor = [UIColor whiteColor];
        label.alpha = alpha;
        label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
        label.shadowOffset=CGSizeMake(1.0f, 1.0f);

        
        [checkButton addSubview:label];
        imageView.alpha = alpha;
        [label release];
        UIBarButtonItem *checkButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:checkButton] autorelease];  
    
        self.navigationItem.rightBarButtonItem = checkButtonItem; 
        
        imagenesNoticia_.type = iCarouselTypeCoverFlow2;
        [imagenesNoticia_ reloadData];
        
    } else {

        // eliminamos el iCarousel
        
        int yTexto = imagenesNoticia_.frame.origin.y;
        int xTexto = textoNoticia.frame.origin.x;
        int wTexto = textoNoticia.frame.size.width;
        int hTexto = textoNoticia.frame.size.height;
        
        CGRect newFrame = CGRectMake(xTexto, yTexto, wTexto, hTexto);
        
        [imagenesNoticia_ removeFromSuperview];
        
        [self.textoNoticia setFrame:newFrame];

    }
    
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, (textoNoticia.frame.origin.y+textoNoticia.frame.size.height));

}
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fechaNoticia = nil;
    self.textoNoticia = nil;
    self.nombreNoticia = nil;
    self.nombreAutor = nil;
    self.imagenesNoticia = nil;

}

// Action que activa o desactiva el "boton" se puede asignar dos funciones distintas con un forState pero esto es mas rapido.
-(IBAction) changeCheck {
    UIView *custom = [[self.navigationItem.rightBarButtonItem.customView subviews] objectAtIndex:0];
    UIView *customText = [[self.navigationItem.rightBarButtonItem.customView subviews] objectAtIndex:1];
    Noticia *noti = [[AUnder sharedInstance]getNoticiaByCodigo:codigoNoticia];
    if ( custom.alpha == 0.5f ) {
        NSLog(@"Click seleccionando el boton de check");
        custom.alpha = 1.0f;
        customText.alpha = 1.0f;
        NSInteger capitulo = noti.capitulo;
        [[[AUnder sharedInstance] checkin] add:noti.serie elCapitulo:[NSNumber numberWithInteger:capitulo]];
        
        //TODO hago check a la serie
    } else {
        NSLog(@"Click deseleccionando el boton de check");
        custom.alpha = 0.5f;
        customText.alpha = 0.5f;
        NSInteger capitulo1 = noti.capitulo;
        [[[AUnder sharedInstance] checkin] del:noti.serie elCapitulo:[NSNumber numberWithInteger:capitulo1]];
    }
}

-(IBAction)showEnteDetails {
    NSLog(@"Click en ente %d",codigoEnte);
    EnteDetailsController *edc = [[EnteDetailsController alloc]initWithEnteId:codigoEnte];
    [self.navigationController pushViewController:edc animated:YES];
    [edc release];
}

-(IBAction)showForumThread {
    NSLog(@"Click en url %@",tid);
    ForoController *fc = [[ForoController alloc]init];
    [fc setUrlString:[NSString stringWithFormat:@"http://foro.aunder.org/showthread.php?tid=%@",tid]];
    [self.navigationController pushViewController:fc animated:YES];
    [fc release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [noti.imagenes count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    if (view==nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 250)];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setClipsToBounds:YES];
        Imagen *img = [[noti imagenes]objectAtIndex:index];
        [imgView setImageWithURL:[NSURL URLWithString:[img getThumbUrl]]];
        view = imgView;
    }
    
    return view;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return 150;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)car
{
    //wrap all carousels
    return NO;
}



@end
