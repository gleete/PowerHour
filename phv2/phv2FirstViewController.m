//
//  phv2FirstViewController.m
//  phv2
//
//  Created by Gordon Leete on 11/13/13.
//  Copyright (c) 2013 Gordon Leete. All rights reserved.
//

#import "phv2FirstViewController.h"
#import "phv2AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define PH_FILE @"ez"
#define PH_FORMAT @"mp3"


@interface phv2FirstViewController ()
@end

@implementation phv2FirstViewController

@synthesize player;
@synthesize playerAudio;



void AudioServicesPlayAlertSound (
    SystemSoundID inSystemSoundID
);

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil){
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:PH_FILE ofType:PH_FORMAT];
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        [self.player prepareToPlay]; //eliminate delay
    }
    return self;
}
*/
-(void)playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ez" ofType:@"mp3"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
	
    
	playerAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [playerAudio prepareToPlay];
    [playerAudio play];
    while (playerAudio.playing){
        //wait for it to finish;
    }
    [playerAudio stop];
}

-(void)audioPlayerBeginInterruption:(MPMusicPlayerController * )player
{
    [musicPlayer pause];
}

-(void)audioPlayerEndInterruption:(MPMusicPlayerController *)player withFlags:(NSUInteger)flags
{
        [musicPlayer play];
}


- (IBAction)pauseAction:(id)sender {
    
    if (!timerEnabled) {
        [self getTrackInfo];
        [sender setTitle:@"Something" forState:UIControlStateNormal];
        timerEnabled = YES;
        UIImage * btnImage2 = [UIImage imageNamed:@"media-pause.png"];
        [playPause setImage:btnImage2 forState:UIControlStateNormal];
        [self getTrackInfo];
        [musicPlayer play];
    }
    else {
        [self getTrackInfo];
        UIImage * btnImage1 = [UIImage imageNamed:@"triangle.png"];
        [playPause setImage:btnImage1 forState:UIControlStateNormal];
        timerEnabled = NO;
        [musicPlayer pause];
    }
}

-(void)timerRun {
    if (timerEnabled) {
        secondsCount = secondsCount - 1;

        
        if (secondsCount > 9) {
            NSString *timerOutput = [NSString stringWithFormat: @"%2d",secondsCount];

            countdownLabel.text = timerOutput;
        }
        if (secondsCount < 10) {
            NSString *timerOutput = [NSString stringWithFormat: @"%1d",secondsCount];

            countdownLabel.text = timerOutput;
        }
        if (secondsCount == -1){
            //We finished one minute
            //Invalidate the timer & reset it
            [countdownTimer invalidate];
            countdownTimer = nil;

            //THIS IS WHERE THE SOUND CLIP NEEDS TO GET PLAYED

            [self audioPlayerBeginInterruption:musicPlayer];
            [self playSound];


            [self audioPlayerEndInterruption:musicPlayer withFlags:1];
            
            secondsCount = 60;
            [self setTimer];
            
            //THIS is where the timer will get reset to 60 and increment to minutes.
            NSString *timerOutput = [NSString stringWithFormat: @"%2d",secondsCount];
            countdownLabel.text = timerOutput;
            
            totalCount = totalCount + 1;
            
            if (totalCount > 9) {
                
                int count = totalCount;
                NSString *minsLeftOutput = [NSString stringWithFormat:@"%2d",count];
                numSongs.text = minsLeftOutput;
            }
            else {
                int count = totalCount;
                NSString *minsLeftOutput = [NSString stringWithFormat:@"%1d",count];
                numSongs.text = minsLeftOutput;
            }
        }
        
        if (totalCount == 60){
            //TO-DO - total set reached. You're done.
            //Let the user know and congradulate them
        }
    }
}

-(void)setTimer {
    secondsCount = 60;
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:(nil) repeats:(YES)];
    
}


-(void)setTotalSongs {
    totalCount = 0;
    NSString *minsLeftOutput = [NSString stringWithFormat:@"%1d",totalCount];
    numSongs.text = minsLeftOutput;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self setTotalSongs];
    [self setTimer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    [musicPlayer beginGeneratingPlaybackNotifications];
}


- (void) handle_NowPlayingItemChanged: (id) notification
{
    [self getTrackInfo];
}

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    if (playbackState == MPMusicPlaybackStatePaused) {
        [playPause setImage:[UIImage imageNamed:@"triangle.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPause setImage:[UIImage imageNamed:@"media-pause.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        [playPause setImage:[UIImage imageNamed:@"triangle.png"] forState:UIControlStateNormal];
        [musicPlayer stop];
    }
}


- (IBAction)playPause:(id)sender
{
    /*
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
    } else {
        [musicPlayer play];
    }
     */
}

- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];
    [self getTrackInfo];
}

- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];
    [self getTrackInfo];
}

- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    [self presentViewController:mediaPicker animated:YES completion:nil];
    
    [self getTrackInfo];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [self getTrackInfo];
        
        //GET COLLECTION
        NSArray* items = [mediaItemCollection items];
        NSLog(@"the items: %@",items);
        
        NSMutableArray* listToSave = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* songList = [[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray* artistList = [[NSMutableArray alloc]initWithCapacity:0];

        
        for (MPMediaItem *song in items) {
            
            NSNumber *persistentId = [song valueForProperty:MPMediaItemPropertyPersistentID];
            
            [listToSave addObject:persistentId];
            
            NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
            //NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
            NSString *artistName = [song valueForProperty: MPMediaItemPropertyAlbumArtist];
            NSLog(@"Song and Artist: %@ - %@", songTitle, artistName);
            [songList addObject:songTitle];
            [artistList addObject:artistName];
            
        }
        NSLog(@"List to save %@",listToSave);
        NSLog(@"Songs to save %@",songList);
        NSLog(@"Artists to save %@",artistList);

        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: listToSave];
        NSData *songData = [NSKeyedArchiver archivedDataWithRootObject: songList];
        NSData *artistData = [NSKeyedArchiver archivedDataWithRootObject: artistList];

        
        //Save Picked items into playlist and keep within app as default
        [[NSUserDefaults standardUserDefaults] setObject:songData forKey:@"songsList"];
        [[NSUserDefaults standardUserDefaults] setObject:artistData forKey:@"artistList"];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"songsListIDs"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];


    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //playlistMetadata = [mediaItemCollection mutableCopy];
    //NSLog(@"Array information here %@", playlistMetadata);
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) getTrackInfo{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    
    NSString *songTitle = [currentItem valueForProperty: MPMediaItemPropertyTitle];
    //NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    NSString *album = [currentItem valueForProperty: MPMediaItemPropertyAlbumArtist];
    NSLog (@"song title: \t\t%@", songTitle);
    //NSLog (@"artist title: \t\t%@", artistString);
    //NSString *combined = [NSString stringWithFormat:@"%@ - %@", songTitle, artistString];
    musicInfo.text = songTitle;
    artistAlbum.text = album;
    
    
    //START TRY
    /*
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    //END TRY
    */
    
    
    UIImage *artworkImage = [UIImage imageNamed:@"ArtworkImage.png"];
    UIImage *background1 = [UIImage imageNamed:@"ArtworkImage1.png"];

    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (250, 250)];
        background1 = [artwork imageWithSize: CGSizeMake(520, 320)];
        
    }
    [artworkImageView setImage:artworkImage];
    //[background setImage:background1];
}

@end
