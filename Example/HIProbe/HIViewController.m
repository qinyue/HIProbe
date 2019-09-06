//
//  HIViewController.m
//  HIProbe
//
//  Created by hushaohua on 09/05/2019.
//  Copyright (c) 2019 hushaohua. All rights reserved.
//

#import "HIViewController.h"
#import "HIProbeWorker.h"

@interface HIViewController ()

@property(nonatomic, strong) HIProbeWorker* worker;

@end

@implementation HIViewController

- (HIProbeWorker *)worker{
    if (!_worker){
        _worker = [[HIProbeWorker alloc] init];
    }
    return _worker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
