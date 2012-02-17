//
//  RegistroController.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegistroController : UIViewController {
    UIImageView *catcha;
    NSString* imagehash;
    UITextField* username;
    UITextField* password;
    UITextField* email;
    UITextField* catpcha;    
    IBOutlet UIButton *containerView;
    IBOutlet UIActivityIndicatorView *loadingSpinner;
}

@property (nonatomic,retain) IBOutlet UIImageView *catcha;
@property (nonatomic,retain) IBOutlet UITextField* username;
@property (nonatomic,retain) IBOutlet UITextField* password;
@property (nonatomic,retain) IBOutlet UITextField* email;
@property (nonatomic,retain) IBOutlet UITextField* catpcha;

-(IBAction) touchAway;
-(IBAction) preRegistrarse;
-(IBAction) registrarse;
@end
