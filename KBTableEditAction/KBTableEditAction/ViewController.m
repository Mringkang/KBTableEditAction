//
//  ViewController.m
//  KBTableEditAction
//
//  Created by kangbing on 16/5/4.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        
        _dataArray = [[NSMutableArray alloc]initWithObjects:@"jack",@"rose",@"kobe",@"李冰",@"张三",@"李四",@"hello",@"word",@"angelbaby",@"熊黛林",@"黄晓明",@"詹姆斯",@"加内特",@"邓肯",@"杜兰特",@"阿尔德里奇",@"莱昂纳德",@"帕克", nil];
    }
    return _dataArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
    // ios8分割线样式
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    
    _tableView.separatorEffect = vibrancyEffect;
    
    
    
    // 注册
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    
    
    // 右上角编辑按钮
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;


}
// 编辑按钮
- (void)setEditing:(BOOL)editing animated:(BOOL)animated

{
    
    [super setEditing:editing animated:animated];
    
    
    
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    
}


#pragma mark - UITableViewDataSource Methods

#pragma mark 设置有多少分组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
    return 1;
    
}


#pragma mark 设置每个分组有多少行

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.dataArray.count;
    
}

#pragma mark 设置某行上显示的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   static NSString *ID = @"cellIdentifier";
    //使用dequeueReuseableCellWithIdentifier:可不注册，但是必须对获取回来的cell进行判断是否为空，若空则手动创建新的cell；
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    //使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
//        cell.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0f];
    
    
    
    return cell;
    
}




#pragma mark 设置可以进行编辑

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return YES;
    
}

#pragma mark 设置编辑的样式

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

#pragma mark 设置处理编辑情况

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 1. 更新数据
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    
    
}


#pragma mark 设置可以移动

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return YES;
    
}

#pragma mark 处理移动的情况
//
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath

{
    
    // 1. 更新数据
    
    NSString *title = _dataArray[sourceIndexPath.row];
    
    [_dataArray removeObject:title];
    
    [_dataArray insertObject:title atIndex:destinationIndexPath.row];
    
    
    
    // 2. 更新UI
    [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    
}

#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 1 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        
        // 1.1 更新数据
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        // 1.2 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    
        // 2 删除一个置顶按钮
    
        UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    
            NSLog(@"点击了置顶");
    
    
    
            // 2.1 更新数据
    
            [_dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    
            // 2.2 更新UI
    
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
            [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
            
//            [tableView reloadData]; 全局刷新
    
        }];
    
        topRowAction.backgroundColor = [UIColor blueColor];
    
    
    
    //3 添加一个更多按钮
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了更多");
        
        
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    
    
    // 将设置好的按钮放到数组中返回
    
     return @[deleteRowAction, topRowAction, moreRowAction];
    
//    return @[deleteRowAction,moreRowAction];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
