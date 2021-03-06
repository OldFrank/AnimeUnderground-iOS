//
//  LoginViewController.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "LoginViewController.h"
#import "Foro.h"
#import "AUnder.h"
#import "PreRegistroController.h"
#import "NoticiasController.h"

@implementation LoginViewController

@synthesize usuario,pass;

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
    [containerView release];
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
    self.title = @"Iniciar sesión";

    [self.navigationController setNavigationBarHidden:NO];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBehind:)];
    
    singleTap.numberOfTapsRequired = 1;
    [containerView addGestureRecognizer:singleTap];
    
    
    AUnder *aunder = [AUnder sharedInstance];
    Foro *foro = [aunder foro];
    usuario.text = foro.user;
    pass.text = foro.pass;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self.navigationController setNavigationBarHidden:NO];
    [containerView release];
    containerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)tapBehind:(id)sender {
    [usuario resignFirstResponder];
    [pass resignFirstResponder];
}
-(IBAction)doLogin:(id)sender {
    NSString *user = usuario.text;
    NSString *password = pass.text;
    AUnder *aunder = [AUnder sharedInstance];
    Foro *foro = [aunder foro];
    if ([user length] != 0) { // comprueba vacío y nil
        foro.user = usuario.text;
        [[NSUserDefaults standardUserDefaults] setValue:foro.user forKey:@"usuarioLogin_preference"];
    }
    if ([password length] != 0) {
        foro.pass = pass.text;
        [[NSUserDefaults standardUserDefaults] setValue:foro.pass forKey:@"passwordLogin_preference"];
    }
    BOOL isOK = [foro doLogin];
    if (!isOK) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Error"
                                   message: @"No se pudo iniciar sesión: el usuario o la contraseña son incorrectos."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        //[self.navigationController popViewControllerAnimated:YES];
        NoticiasController *nc = [[NoticiasController alloc]init];
        [[AppDelegate menuController] setRootController:nc animated:NO];
        [nc release];
    }
}

-(IBAction)doRegister:(id)sender {
    PreRegistroController *rc = [[PreRegistroController alloc] init];
    [[AppDelegate menuController] setRootController:rc animated:YES];
    //[self.navigationController pushViewController: rc animated:YES];
    [rc release];
}
@end
