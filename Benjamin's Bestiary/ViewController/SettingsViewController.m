//
//  SettingsViewController.m
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/1/26.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view.
    NSLog(@"The view did load");
}

// Auto-play selected; the book reads aloud automatically when each page is displayed.
// preference stored as user defaults; sent to the console for debugging.
- (IBAction)autoplay:(UISwitch *)sender {
  NSLog(@"Autoplay On:%d", sender.isOn);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:sender.isOn forKey:@"kAutoplayPreference"];
}

// Tap-to-play selected; a button on each page triggers read-aloud manually.
// preference stored as user defaults; sent to the console for debugging.
- (IBAction)tapToPlay:(UISwitch *)sender {
  NSLog(@"Tap-to-play On:%d", sender.isOn);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:sender.isOn forKey:@"kTapToPlayPreference"];
}

@end
