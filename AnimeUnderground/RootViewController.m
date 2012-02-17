//
//  RootViewController.m
//  AnimeUnderground
//
//  Created by Nacho L on 06/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "RootViewController.h"
#import "Noticia.h"
#import "Ente.h"
#import "Serie.h"
#import "NoticiaCell.h"
#import "DeviantDownload.h"
#import "Imagen.h"
#import "Foro.h"
#import "AUnder.h"
#import "LoginViewController.h"
#import "NoticiasController.h"
#import "MenuViewController.h"


@implementation RootViewController
@synthesize loadingView;
@synthesize loadingText;
@synthesize loadingSpinner;

@class SeriesController,EntesController, ForoController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Ponemos la pantalla de carga lo primero
    [self.view addSubview:loadingView];
    loadingView.center = self.view.center;
    [loadingSpinner startAnimating];

    
    self.title = @"AnimeUnderground";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    [[AUnder sharedInstance]setUpdateHandler:self];

    [[AUnder sharedInstance]update]; // el m�todo es as�ncrono

}

// delegates

- (void)onBeginUpdate:(AUnder*)aunder {
    NSLog(@"Actualizacion comenzada");
    
      
}
- (void)onUpdateStatus:(AUnder*)aunder:(NSString*)withStatus {
    //NSLog(@"Estado actual de la actualizaci�n: %@",withStatus);
    [loadingText setText:withStatus];
}

- (void)onUpdateError:(AUnder*)aunder {
    NSLog(@"Ha habido un error actualizando");
}

- (void)onFinishUpdate:(AUnder*)aunder {
    NSLog(@"Actualizacion finalizada");   
    self.title = @"Principal";
       
    [self.navigationController setNavigationBarHidden:NO];
    [loadingView removeFromSuperview];
    UIImage *image = [UIImage imageNamed: @"logo_barra_au.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage: image];    
	self.navigationItem.titleView = imageView;
    
    // Probamos si se puede hacer el Login
    AUnder *au = [AUnder sharedInstance];
    Foro *foro = [au foro];
    
    foro.user = [[NSUserDefaults standardUserDefaults] stringForKey:@"usuarioLogin_preference"];
    foro.pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"passwordLogin_preference"];
    
    MenuViewController *mvc = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    [[AppDelegate menuController] setLeftController:mvc];    
    [mvc release];
    
    BOOL autoLog = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin_preference"];
    
    if (autoLog) {
        BOOL isOK = [foro doLogin];
        if (!isOK) {
            LoginViewController *lvc = [[LoginViewController alloc]init];
            [[AppDelegate menuController] setRootController:lvc animated:NO];   
            [lvc release];
            return;
        } 
    } 
    
    NoticiasController *nc = [[NoticiasController alloc] initWithStyle:UITableViewStylePlain];
    [[AppDelegate menuController] setRootController:nc animated:NO];
    [nc release];

}

- (IBAction)showNoticias {
    NoticiasController *nc = [[NoticiasController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:nc animated:YES];
}

- (IBAction)showSeries {
    SeriesController *sc = [[SeriesController alloc]init];
    [self.navigationController pushViewController:sc animated:YES];
    
}

- (IBAction)showEntes {
    EntesController *ec = [[EntesController alloc]init];
    [self.navigationController pushViewController:ec animated:YES];
    
}

- (IBAction)showForo {
    ForoController *fc = [[ForoController alloc]init];
    [self.navigationController pushViewController:fc animated:YES];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loadingText = nil;
    self.loadingView = nil;
    self.loadingSpinner = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [loadingSpinner release];
    [loadingText release];
    [loadingView release];
    [super dealloc];
}

@end
