//
//  XlogListView.m
//  XlogPlugin
//
//  Created by Kaoji on 2020/5/6.
//  Copyright © 2020 Kaoji. All rights reserved.
//

#import "XlogListView.h"
#import "XlogManager.h"
#import "XLogFloatBtn.h"

@interface XlogListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *bgView;//弹窗主体
@property (nonatomic,strong)UIImageView *closeImageView;//关闭按扭
@property (nonatomic,strong)UITableView *tableView;//日志列表
@property (nonatomic,strong)NSMutableArray *logListArray;//数据源
@property (nonatomic,strong)UILabel *noDialogLabel;//数据源
@end

@implementation XlogListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self readDataSource];
    }
    return self;
}

-(void)createView{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    //背景
    _bgView = [self createPopView];
    _bgView.center = self.center;
    [self addSubview:_bgView];
    
    _closeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.frame.size.width - 50, 10, 30, 30)];
    NSString *closeImagePath = [XLOG_RES stringByAppendingPathComponent:@"close.png"];
    _closeImageView.image = [UIImage imageWithContentsOfFile:closeImagePath];
    _closeImageView.userInteractionEnabled = YES;
    _closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickClose)];
    [_closeImageView addGestureRecognizer:closeTap];
    [_bgView addSubview:_closeImageView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, _bgView.frame.size.width, _bgView.frame.size.height - 40) style:UITableViewStylePlain];
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"LOG_LIST"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = UIView.new;
    _tableView.tableFooterView = UIView.new;
    [_bgView addSubview:_tableView];
    
    
    _noDialogLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _bgView.frame.size.height *0.3 , _tableView.frame.size.width, 30)];
    _noDialogLabel.text = @"没有日志";
    _noDialogLabel.textAlignment = NSTextAlignmentCenter;
    _noDialogLabel.textColor = [UIColor darkGrayColor];
    [_tableView addSubview:_noDialogLabel];
}

-(void)readDataSource{
    //获取沙盒 Document
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取日志路径
    NSString *logPath =  [docPath stringByAppendingFormat:@"/log"];
    NSMutableArray *fileNames = [NSMutableArray arrayWithArray:[NSFileManager.defaultManager contentsOfDirectoryAtPath:logPath error:nil]];
   
    //倒序删除
    for(NSInteger i = fileNames.count - 1; i >=0 ; i--){
        NSString *item = fileNames[i];
        if([item.pathExtension isEqualToString:@"xlog"] == NO){
            [fileNames removeObjectAtIndex:i];
        }
    }
    _logListArray = fileNames;
    [self.tableView reloadData];
    
    _noDialogLabel.hidden = _logListArray.count? YES:NO;
}


#pragma mark - TableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _logListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOG_LIST" forIndexPath:indexPath];
    cell.textLabel.text = _logListArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //删除当前删除日志
    NSString *logPath =  [docPath stringByAppendingFormat:@"/log/%@",_logListArray[indexPath.row]];
    [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
    
    //删除当前已经解压的日志
    NSString *logExactedPath =  [docPath stringByAppendingFormat:@"/log/%@.log",_logListArray[indexPath.row]];
    [[NSFileManager defaultManager] removeItemAtPath:logExactedPath error:nil];
    
    //删除数据源
    [_logListArray removeObject:_logListArray[indexPath.row]];
   
    //删除Cell
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    //获取沙盒 Document
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取日志路径
    NSString *logPath =  [docPath stringByAppendingFormat:@"/log"];
    //目标日志文件
    NSString *logFilePath = [logPath stringByAppendingPathComponent:self.logListArray[indexPath.row]];
    NSString *outFilePath = [logFilePath stringByAppendingString:@".log"];
    
    [[XlogManager shared] decodeAndPreviewXlogFrom:logFilePath to:outFilePath];
    [self hide];

}

-(void)onClickClose{
    [self hide];
}

@end
