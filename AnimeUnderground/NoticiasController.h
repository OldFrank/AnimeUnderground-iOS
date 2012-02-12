//
//  NoticiasController.h
//  AnimeUnderground
//
//  Created by Nacho López Sais on 05/05/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"


@interface NoticiasController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
	
	EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

    UILabel *infoLabel_;
    
}

@end
