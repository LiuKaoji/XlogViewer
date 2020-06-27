//
//  ViewController.m
//  Example
//
//  Created by Kaoji on 2020/4/28.
//  Copyright © 2020 Kaoji. All rights reserved.
//

#import "MainViewController.h"
#import <XlogPlugin/XlogPlugin.h>
#import "SandBoxPreviewTool.h"
#import "MBProgressHUD+JDragon.h"
#import "MainView.h"

@interface MainViewController ()<MainViewDelegate>
@property(nonatomic,strong)MainView *mainView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [self setupUI];
}

-(void)setupUI{
    _mainView = [[MainView alloc] initWithFrame:self.view.frame];
    _mainView.delegate = self;
    [self.view addSubview:_mainView];
}

-(void)onClickOption:(NSInteger)tag{
    //创建日志
       if(tag == 0){
           [self checkFolderAndCopyLog];
       }else if(tag == 1){
       //显示日志列表
           XlogListView *listView = [[XlogListView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
           [listView show];
       }else{
           //沙盒查看
           [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
       }
}

//检查日志目录
-(void)checkFolderAndCopyLog{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:kPathLog]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
        [fileManager createDirectoryAtPath:kPathLog withIntermediateDirectories:YES attributes:nil error:nil];
        [self copyLog];
    }else{
        [self copyLog];
    }
}

//拷贝测试日志到沙盒
-(void)copyLog{
   NSString *testLogPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"xlog"];
    NSString *copyPath = [kPathLog stringByAppendingPathComponent:testLogPath.lastPathComponent];
    if(![[NSFileManager defaultManager]fileExistsAtPath:copyPath]){
        [[NSFileManager defaultManager] copyItemAtPath:testLogPath toPath:copyPath error:nil];
         [MBProgressHUD showInfoMessage:@"文件已拷贝"];
    }else{
        [MBProgressHUD showInfoMessage:@"文件已存在"];
    }
}

@end
