//
//  phv2AppDelegate.h
//  phv2
//
//  Created by Gordon Leete on 11/13/13.
//  Copyright (c) 2013 Gordon Leete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>



@interface phv2AppDelegate : UIResponder <UIApplicationDelegate> {
    IBOutlet UILabel *countdownLabel;
    NSTimer *timer;
    
    
}


@property (strong, nonatomic) UIWindow *window;

@end
