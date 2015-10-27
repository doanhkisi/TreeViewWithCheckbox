//
//  ViewController.m
//  TreeViewExample
//
//  Created by Bui Duy Doanh on 10/27/15.
//  Copyright © 2015 doanhkisi. All rights reserved.
//

#import "ViewController.h"
#import "RATreeView.h"
#import "RATreeView+Private.h"
#import "RATreeNode.h"
#import "TreeViewCell.h"
#import "DataTreeViewObject.h"

@interface ViewController ()  <RATreeViewDelegate, RATreeViewDataSource>

@property (weak, nonatomic) IBOutlet RATreeView *treeView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL displayFooter;

- (void)expandCellForTreeView:(RATreeView *)treeView
                     treeNode:(RATreeNode *)treeNode
               informDelegate:(BOOL)informDelegate;
- (void)collapseCellForTreeView:(RATreeView *)treeView
                       treeNode:(RATreeNode *)treeNode
                 informDelegate:(BOOL)informDelegate;

@end

@interface RATreeView ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [NSMutableArray new];
    if ([self.treeView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.treeView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.treeView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.treeView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.treeView registerNib:[UINib nibWithNibName:@"TreeViewCell" bundle:nil]
        forCellReuseIdentifier:NSStringFromClass([TreeViewCell class])];
    self.treeView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [self.treeView reloadData];
    [self fakeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fakeData {
    DataTreeViewObject *supperData = [DataTreeViewObject dataObjectWithName:@"doanhkisi dzai có gì nổi bật" ID:@"1" jobCount:0 children:@[]];
    DataTreeViewObject *data1 = [DataTreeViewObject dataObjectWithName:@"depzai" ID:@"2" jobCount:0 children:@[]];
    DataTreeViewObject *subData1 = [DataTreeViewObject dataObjectWithName:@"depzai do bản chất" ID:@"3" jobCount:0 children:nil];
    DataTreeViewObject *subData2 = [DataTreeViewObject dataObjectWithName:@"depzai do a thích thế" ID:@"4" jobCount:0 children:nil];
    [data1 addChild:subData1];
    [data1 addChild:subData2];
    DataTreeViewObject *data2 = [DataTreeViewObject dataObjectWithName:@"tốt bụng" ID:@"5" jobCount:0 children:nil];
    DataTreeViewObject *data3 = [DataTreeViewObject dataObjectWithName:@"hiền lành" ID:@"6" jobCount:0 children:nil];
    DataTreeViewObject *data4 = [DataTreeViewObject dataObjectWithName:@"vui tính" ID:@"7" jobCount:0 children:nil];
    [supperData addChild:data1];
    [supperData addChild:data2];
    [supperData addChild:data3];
    [supperData addChild:data4];
    [self.dataSource addObject:supperData];
    [self.treeView reloadData];
}

#pragma mark - RATreeViewDelegate

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 40.0f;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    // セルの展開状態を設定
    TreeViewCell *cell = (TreeViewCell *)[treeView cellForItem:item];
    if (cell) {
        cell.expand = YES;
    }
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    // セルの展開状態を設定
    TreeViewCell *cell = (TreeViewCell *)[treeView cellForItem:item];
    if (cell) {
        cell.expand = NO;
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    // セルのチェック状態を設定
    DataTreeViewObject *dataObject = item;
    [self treeView:treeView toggleCheckBoxForItem:dataObject];
}

- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item {
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)treeView:(RATreeView *)treeView heightForFooterInSection:(NSInteger)section {
    if (!self.displayFooter) {
        return 0.f;
    }
    return 58.f;
}

- (UIView *)treeView:(RATreeView *)treeView viewForFooterInSection:(NSInteger)section {
    if (!self.displayFooter) {
        return nil;
    }
    return nil;
}
#pragma mark - RATreeViewDataSource

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    // 対象セル取得
    TreeViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([TreeViewCell class])];
    // セパレーターの左端が切れないように
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
        cell.preservesSuperviewLayoutMargins = false;
    }
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    // 選択色なし
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // 対象セルの展開状況を同期
    NSIndexPath *indexPath = [treeView indexPathForItem:item];
    RATreeNode *treeNode = [treeView treeNodeForIndexPath:indexPath];
    cell.expand = treeNode.expanded;

    // セルにデータオブジェクトの情報を設定
    DataTreeViewObject *dataObject = item;
    cell.checked = dataObject.checked;
    NSString *displayText = dataObject.name;
    BOOL isShowExpand = dataObject.children.count > 0;
    [cell setupWithTitle:displayText level:[self.treeView levelForCellForItem:item] isShowExpand:isShowExpand];
    __weak typeof(self) weakSelf = self;

    // 展開ボタンが押されたときに実行するブロックを設定
    cell.expandButtonTapAction = ^(TreeViewCell *cell, id sender) {
        DataTreeViewObject *item = [weakSelf.treeView itemForCell:cell];
        NSIndexPath *indexPath = [treeView indexPathForItem:item];
        RATreeNode *treeNode = [treeView treeNodeForIndexPath:indexPath];
        if (treeNode.expanded) {
            if ([treeView.delegate respondsToSelector:@selector(treeView:shouldCollapaseRowForItem:)]) {
                if ([treeView.delegate treeView:treeView shouldCollapaseRowForItem:treeNode.item]) {
                    [self collapseCellForTreeView:treeView treeNode:treeNode informDelegate:YES];
                }
            } else {
                [self collapseCellForTreeView:treeView treeNode:treeNode informDelegate:YES];
            }
        } else {
            if ([treeView.delegate respondsToSelector:@selector(treeView:shouldExpandRowForItem:)]) {
                if ([treeView.delegate treeView:treeView shouldExpandRowForItem:treeNode.item]) {
                    [self expandCellForTreeView:treeView treeNode:treeNode informDelegate:YES];
                }
            } else {
                [self expandCellForTreeView:treeView treeNode:treeNode informDelegate:YES];
            }
        }
    };
    // チェックボックスが押されたときに実行するブロックを設定
    cell.checkboxTapAction = ^(TreeViewCell *cell, id sender) {
        // セルのチェック状態を設定
        [weakSelf treeView:weakSelf.treeView toggleCheckBoxForItem:[weakSelf.treeView itemForCell:cell]];
    };
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (!item) {
        return [self.dataSource count];
    }
    DataTreeViewObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        return [self.dataSource objectAtIndex:index];
    }
    DataTreeViewObject *data = item;
    return data.children[index];
}

#pragma mark - Expand tree

/** 指定したノードを展開する */
- (void)expandCellForTreeView:(RATreeView *)treeView
                     treeNode:(RATreeNode *)treeNode
               informDelegate:(BOOL)informDelegate {
    if (informDelegate) {
        if ([treeView.delegate respondsToSelector:@selector(treeView:willExpandRowForItem:)]) {
            [treeView.delegate treeView:treeView willExpandRowForItem:treeNode.item];
        }
    }

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if ([treeView.delegate respondsToSelector:@selector(treeView:didExpandRowForItem:)] &&
            informDelegate) {
            [treeView.delegate treeView:treeView didExpandRowForItem:treeNode.item];
        }
    }];

    [treeView expandCellForTreeNode:treeNode];
    [CATransaction commit];
}

/** 指定したノードを閉じる */
- (void)collapseCellForTreeView:(RATreeView *)treeView
                       treeNode:(RATreeNode *)treeNode
                 informDelegate:(BOOL)informDelegate {
    if (informDelegate) {
        if ([treeView.delegate respondsToSelector:@selector(treeView:willCollapseRowForItem:)]) {
            [treeView.delegate treeView:treeView willCollapseRowForItem:treeNode.item];
        }
    }

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if ([treeView.delegate respondsToSelector:@selector(treeView:didCollapseRowForItem:)] &&
            informDelegate) {
            [treeView.delegate treeView:treeView didCollapseRowForItem:treeNode.item];
        }
    }];

    [treeView collapseCellForTreeNode:treeNode];
    [CATransaction commit];
}
#pragma mark - Checkbox

- (void)treeView:(RATreeView *)treeView toggleCheckBoxForItem:(DataTreeViewObject *)item {
    item.checked = !item.checked;
    // 表示中のセルにも反映
    DataTreeViewObject *parrentObject = [self checkItemParent:item treeView:treeView];
    if (parrentObject) {
        [self checkItemParent:parrentObject treeView:treeView];
    }
    TreeViewCell *cell = (TreeViewCell *)[treeView cellForItem:item];
    if (cell) {
        cell.checked = item.checked;
    }
    for (DataTreeViewObject *childItem in item.children) {
        childItem.checked = item.checked;
        // セルが展開中の場合、表示中の子セルにも反映
        TreeViewCell *childCell = (TreeViewCell *)[treeView cellForItem:childItem];
        if (childCell) {
            childCell.checked = childItem.checked;
        }
        for (DataTreeViewObject *grandChildItem in childItem.children) {
            grandChildItem.checked = childItem.checked;
            TreeViewCell *grandChildCell = (TreeViewCell *)[treeView cellForItem:grandChildItem];
            if (grandChildCell) {
                grandChildCell.checked = grandChildItem.checked;
            }
        }
    }

    // フッターを表示するかどうか判断
    BOOL displayFooter = NO;
    for (DataTreeViewObject *companyData in self.dataSource) {
        for (DataTreeViewObject *lineData in companyData.children) {
            if (lineData.checked) {
                displayFooter = YES;
                break;
            }
            if (displayFooter) {
                break;
            }
        }
        if (displayFooter) {
            break;
        }
    }
    if (self.displayFooter != displayFooter) {
        self.displayFooter = displayFooter;
        [self.treeView.tableView reloadData];
    }
}

- (DataTreeViewObject *)checkItemParent:(DataTreeViewObject *)curentItem treeView:(RATreeView *)treeView {
    DataTreeViewObject *parentItem = [treeView parentForItem:curentItem];
    TreeViewCell *parentCell = (TreeViewCell *)[treeView cellForItem:parentItem];
    parentItem.checked = curentItem.checked;
    for (DataTreeViewObject *childOfParent in parentItem.children) {
        if (!childOfParent.checked) {
            parentItem.checked = NO;
            break;
        }
    }
    if (parentCell) {
        parentCell.checked = parentItem.checked;
    }
    return parentItem;
}
@end
