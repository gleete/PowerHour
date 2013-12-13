//
//  phv2SecondViewController.h
//  phv2
//
//  Created by Gordon Leete on 11/13/13.
//  Copyright (c) 2013 Gordon Leete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface phv2SecondViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource> {
    NSArray *tableData;
    
    //Music information
    IBOutlet UILabel    *musicInfo;
    NSString            *songDescip;
    IBOutlet UILabel    *artistAlbum;
    NSString            *artAlb;
    
    IBOutlet UIImageView *artworkImageView;
    MPMediaItemCollection *collection;
    MPMusicPlayerController *musicPlayer;
    
    NSMutableArray *theSongList;
    NSMutableArray *theArtistList;

}




@end
