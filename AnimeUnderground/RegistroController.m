//
//  RegistroController.m
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import "RegistroController.h"
#import "AUnder.h"
#import "Foro.h"
#import "LoginViewController.h"

@implementation RegistroController

@synthesize catcha;
@synthesize username,password,catpcha,email;

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
    [loadingSpinner release];
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
    [self setTitle:@"Registro"];
    AUnder *aunder = [AUnder sharedInstance];
    Foro *foro = [aunder foro];
    
    // el botón de volver nos lleva a la ventana de login
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)];	
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
    
    NSString *url = @"http://foro.aunder.org/member.php";
    NSString *parametros = @"action=register&agree=OK";
    NSString *datos= [foro webPost: url : parametros];
    if ([datos length] !=0) {
        NSRange rangoABuscar = [datos rangeOfString:@"imagehash="];
        if (rangoABuscar.location != NSNotFound){
            
        
            NSRange rangoAux = [datos rangeOfString:@"\" alt=\"Verificaci"];
            rangoABuscar.length = rangoAux.location-rangoABuscar.location;
    
            imagehash = [[datos substringWithRange:rangoABuscar] retain];
            // http://foro.aunder.org/member.php?action=register&step=agreement&agree=Estoy%20de%20acuerdo
            NSString *imageURL = @"http://foro.aunder.org/captcha.php?action=regimage&";
            imageURL = [imageURL stringByAppendingString:imagehash];

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
                UIImage *myimage = [[UIImage alloc] initWithData:mydata];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingSpinner stopAnimating];
                    [catcha setAlpha:0.0];                    
                    catcha.image = myimage;
                    [myimage release];
                    
                    [UIView animateWithDuration:1 animations:^{
                        [catcha setAlpha:0.7]; 
                    }];
                    
                });
        
            });

        } else {
            //TODO ERROR Ya se ha registrado alguien con esta IP.
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error"
                                       message: @"Ya se ha realizado un registro con esta IP."
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    } else {
        //TODO ERROR
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Error"
                                   message: @"No se ha podido acceder al servicio de AnimeUnderground, por favor pruebe luego."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        [alert release];
    }	
}
- (void) handleBack:(id)sender
{
	NSLog(@"Atrás");
	//int anterior = [self.navigationController.viewControllers count]-3;
	LoginViewController *lvc = [[LoginViewController alloc]init];
    [[AppDelegate menuController] setRootController:lvc animated:YES];
	//[self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:anterior] animated:YES];
}


- (void)viewDidUnload
{
    [containerView release];
    containerView = nil;
    [loadingSpinner release];
    loadingSpinner = nil;
    [super viewDidUnload];
    [imagehash release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) touchAway {
    

    [username resignFirstResponder];
    [password resignFirstResponder];
    [email resignFirstResponder];
    [catpcha resignFirstResponder];
    [catcha becomeFirstResponder];
        
} 

-(IBAction) registrarse {
    //TODO mandar registro a AU accion do_login y que sea lo que dios quiera.
    
    AUnder *aunder = [AUnder sharedInstance];
    Foro *foro = [aunder foro];
    BOOL correcto = YES;
    
    if ([username.text length]==0)
        correcto = NO;
    
    if ([password.text length] <= 3)
        correcto = NO;
    
    if ([catpcha.text length] == 0)
        correcto = NO;
    
    if ([email.text length] != 0) {
        NSString *emailRegex = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:email.text])
            correcto = NO;
    } else {
        correcto = NO;
    }
    
    if (correcto) {
        NSString *url = @"http://foro.aunder.org/member.php";
        NSString *parametros = [NSString stringWithFormat: @"action=do_register&step=registration&username=%@&password=%@&password2=%@&email=%@&email2=%@&imagestring=%@&%@&allownotices=1&hideemail=1&receivepms=1&pmnotice=1&emailpmnotify=1&invisible=0&subscriptionmethod=0&timezoneoffset=2&dstcorrection=2&language=",username.text,password.text,password.text,email.text,email.text,catpcha.text,imagehash];
        NSLog(@"%@",parametros);
        NSString *datos= [foro webPost: url : parametros];
        NSRange range = [datos rangeOfString:@"Gracias por registrarte"];
        if (range.location == NSNotFound)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se ha podido registrar el usuario debido a un error de comunicación con la web. Inténtalo de nuevo más tarde." 
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];            
        } else {
            foro.user = username.text;
            [[NSUserDefaults standardUserDefaults] setValue:foro.user forKey:@"usuarioLogin_preference"];
            foro.pass = password.text;
            [[NSUserDefaults standardUserDefaults] setValue:foro.pass forKey:@"passwordLogin_preference"];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se puede proceder al registro debido a que hay algún error en los campos a rellenar." 
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    

}
@end
