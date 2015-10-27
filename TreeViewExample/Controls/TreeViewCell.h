//
//  TreeViewCell.h
//  TreeViewExample
//
//  Created by Bui Duy Doanh on 10/27/15.
//  Copyright © 2015 doanhkisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIImageView *expandButtonImage;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceCheckboxConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceSeparatorConstraint;

@property (nonatomic, copy) void (^expandButtonTapAction)(TreeViewCell *cell, id sender);
@property (nonatomic, copy) void (^checkboxTapAction)(TreeViewCell *cell, id sender);

@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) BOOL checked;

- (void)setupWithTitle:(NSString *)title
                 level:(NSInteger)level
          isShowExpand:(BOOL)isShowExpand;

@end
