//
//  ViewController.m
//  EngineDemoiOS
//
//  Created by Hongjie Fu on 2021/1/22.
//

#import "ViewController.h"
#import <MMXEngine/XSKEngine.h>
#import <MMXEngine/XSKEngine+Lua.h>
#import <MMXEngine/XEGameView.h>
#import <MMXEngine/XSKScriptBridge.h>

@interface ViewController () <XEGameViewDelegate>

@property (nonatomic, strong) XEGameView *gameView;

@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建GameView
    _gameView = [[XEGameView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_gameView];
    //设置GameView代理
    _gameView.delegate = self;
    //启动GameView
    [_gameView start];
    
}

//GameView启动回调
- (void)onStart:(XSKEngine *)engine {
    //设置引擎日志开关
    [engine setLogEnable:YES];
    //添加引擎资源搜索路径
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/GameRes"];
    [engine addLibraryPath:path];
    //为游戏Lua脚本注册原生bridge功能（非必需）
    [engine.scriptBridge regist:self forHandler:@"LiveGameHandler"];
    //执行游戏启动脚本
    [engine execteGameScriptFile:@"app"];
}

//同步Bridge方法
XE_BBRIDGE_METHOD(func1) {
    return @"OC同步返回";
}

//异步Bridge方法
XE_BBRIDGE_ASYNC_METHOD(func2) {
    callback(@"OC异步回调");
}

@end
