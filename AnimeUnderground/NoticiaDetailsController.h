//
//  NoticiaDetailsController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 01/06/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Noticia.h"

@interface NoticiaDetailsController : UIViewController {
    int codigoNoticia;
    int totalImagenes;
    NSString *tid;
    int codigoEnte;
    Noticia *noti;
    IBOutlet UIButton *buttonImage_;
}

@property (nonatomic, assign) int codigoNoticia;

@property (nonatomic,retain) IBOutlet UILabel *nombreNoticia;
@property (nonatomic,retain) IBOutlet UILabel *nombreAutor;
@property (nonatomic,retain) IBOutlet UILabel *fechaNoticia;
@property (nonatomic,retain) IBOutlet UILabel *textoNoticia;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

- (IBAction)showEnteDetails;
- (IBAction)showForumThread;
- (IBAction)nextTap:(id)sender;

@end
