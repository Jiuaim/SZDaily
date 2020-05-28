//
//  UITableView+AutoLayoutHeader.m
//  SZDaily_Example
//
//  Created by hsz on 2020/5/28.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "UITableView+AutoLayoutHeader.h"

@implementation UITableView (AutoLayoutHeader)

- (void)sz_sizeHeaderToFit {
    UIView *header = self.tableHeaderView;

    [header setNeedsLayout];
    [header layoutIfNeeded];

    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = header.frame;

    frame.size.height = height;
    header.frame = frame;

    [self beginUpdates];
    self.tableHeaderView = header;
    [self endUpdates];
}

@end
