//
//  phv2FirstViewController.h
//  phv2
//
//  Created by Gordon Leete on 11/13/13.
//  Copyright (c) 2013 Gordon Leete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface phv2FirstViewController : UIViewController  <MPMediaPickerControllerDelegate>{
    //Countdown Label
    IBOutlet UILabel    *countdownLabel;
    NSTimer             *countdownTimer;
    int                 secondsCount;
    //Songs Played Label
    IBOutlet UILabel    *numSongs;
    int                 totalCount;
    //Are we paused?
    BOOL                timerEnabled;
    //Pause Button
    IBOutlet UIButton   *playPause;
    //Music information
    IBOutlet UILabel    *musicInfo;
    NSString            *songDescip;
    IBOutlet UILabel    *artistAlbum;
    NSString            *artAlb;
    
    IBOutlet UIImageView *artworkImageView;
    IBOutlet UIImageView *background;
    MPMusicPlayerController *musicPlayer;
    
    NSMutableArray      *playlistMetadata;
    
    //interludeTimer
    NSTimer             *interludeTimer;
    int                 secondsTwo;
    AVAudioPlayer *playerAudio;
    
   // MPMediaItemCollection * collection;

}

- (IBAction)showMediaPicker:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)pauseAction:(id)sender;

@property (nonatomic, strong) AVAudioPlayer *player;


@property (nonatomic,retain) AVAudioPlayer *playerAudio;



@end
