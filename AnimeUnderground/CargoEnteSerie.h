//
//  CargoEnteSerie.h
//  AnimeUnderground
//
//  Created by Nacho L on 14/04/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Ente, Serie;

@interface CargoEnteSerie : NSObject {
    Ente *ente;
    Serie *serie;
    NSString *cargo;
    int capitulos;
}
@property (nonatomic, retain) Ente *ente;
@property (nonatomic, retain) Serie *serie;
@property (nonatomic, retain) NSString *cargo;
@property (nonatomic, assign) int capitulos;

- (id)initWithEnte:(Ente*)anEnte serie:(Serie*)aSerie cargo:(NSString*)aCargo capitulos:(int)aCapitulos;

@end
