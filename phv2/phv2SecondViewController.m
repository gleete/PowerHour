//
//  phv2SecondViewController.m
//  phv2
//
//  Created by Gordon Leete on 11/13/13.
//  Copyright (c) 2013 Gordon Leete. All rights reserved.
//

#import "phv2SecondViewController.h"
//#import "phv2FirstViewController.h"

@interface phv2SecondViewController ()

@end

@implementation phv2SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"songsList"] != nil) {
        
        NSData *songData = [[NSUserDefaults standardUserDefaults] objectForKey:@"songsList"];
        NSData *artistData = [[NSUserDefaults standardUserDefaults] objectForKey:@"artistList"];
        
        
        NSArray *decodedSongData = [NSKeyedUnarchiver unarchiveObjectWithData:songData];
        NSArray *decodedArtistData = [NSKeyedUnarchiver unarchiveObjectWithData:artistData];
        
        
        [theSongList addObjectsFromArray:decodedSongData];
        [theArtistList addObjectsFromArray:decodedArtistData];
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [theSongList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"song_cell"];
    
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:@"song_cell"];

        
    
        for (int i = 0; i < [theSongList count]; i++) {
            cell.textLabel.text = theSongList[i];
            cell.detailTextLabel.text = theArtistList[i];
        }
    
    
    NSLog(@"All the songs: %@",theSongList);
    
        
    //[tableView reloadData];
    return cell;

    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
