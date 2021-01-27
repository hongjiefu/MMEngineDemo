//
//  ViewController.m
//  EngineDemoiOS
//
//  Created by Hongjie Fu on 2021/1/22.
//

#import "ViewController.h"
#import "GameViewController.h"




@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"打棒球" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
}
- (void)playGame {
    GameViewController *vc = [[GameViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
