//
//  MFViewController.m
//  MFMediaView
//
//  Created by NealWills on 08/08/2022.
//  Copyright (c) 2022 NealWills. All rights reserved.
//

#import "MFViewController.h"

#import <MFMediaView/MFMediaView.h>

@interface MFViewController ()

@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


//    "https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag"

    NSString *localPath = [NSBundle.mainBundle pathForResource:@"2_0080" ofType:@"pag"];
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag localPath:localPath];

    MFMediaView *mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
    [self.view addSubview:mediaView];
    mediaView.model = mediaViewModel;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
