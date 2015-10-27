//
//  TreeViewCell.m
//  TreeViewExample
//
//  Created by Bui Duy Doanh on 10/27/15.
//  Copyright © 2015 doanhkisi. All rights reserved.
//

#import "TreeViewCell.h"

@implementation TreeViewCell

@synthesize expand = _expand;
@synthesize checked = _checked;

- (void)awakeFromNib {
    // Initialization code
    UIViewAutoresizing autoResizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.autoresizingMask = autoResizingMask;
    self.contentView.autoresizingMask = autoResizingMask;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExpand:(BOOL)expand {
    if (_expand != expand) {
        _expand = expand;
        // 展開状況に応じて画像を変更
        if (expand) {
            [self.expandButtonImage setImage:[UIImage imageNamed:@"module_btn_minus"]];
        }
        else {
            [self.expandButtonImage setImage:[UIImage imageNamed:@"module_btn_plus"]];
        }
    }
}

- (void)setChecked:(BOOL)checked {
    if (_checked != checked) {
        _checked = checked;
        if (checked) {
            [self.checkbox setImage:[UIImage imageNamed:@"area_checkbox_on"]
                           forState:UIControlStateNormal];
        } else {
            [self.checkbox setImage:[UIImage imageNamed:@"area_checkbox_off"]
                           forState:UIControlStateNormal];
        }
    }
}

- (IBAction)expandButtonTapped:(id)sender {
    if (self.expandButtonTapAction) {
        self.expandButtonTapAction(self, sender);
    }
}

- (IBAction)checkboxTapped:(id)sender {
    if (self.checkboxTapAction) {
        self.checkboxTapAction(self, sender);
    }
}

- (void)setupWithTitle:(NSString *)title level:(NSInteger)level isShowExpand:(BOOL)isShowExpand {
    self.label.text = title;
    NSInteger marginLeft = 10;
    NSInteger paragraphConst = 0;
    self.leftSpaceSeparatorConstraint.constant = 0.f;
    if (level > 0) {
        paragraphConst = 20;
        marginLeft = 20;
        if (level == 2) {
            paragraphConst += marginLeft;
        }
        self.leftSpaceSeparatorConstraint.constant = paragraphConst + 4.f;
    }
    self.leftSpaceCheckboxConstraint.constant = paragraphConst;
    self.checkbox.hidden = NO;
    self.expandButton.hidden = self.expandButtonImage.hidden = (level == 2 || !isShowExpand);
}

@end
