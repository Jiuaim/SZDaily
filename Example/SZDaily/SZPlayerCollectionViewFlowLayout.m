//
//  SZPlayerCollectionViewFlowLayout.m
//  SZDaily_Example
//
//  Created by hsz on 2020/6/15.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZPlayerCollectionViewFlowLayout.h"

@implementation SZPlayerCollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [self getCopyOfAttributes:[super layoutAttributesForElementsInRect:rect]];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0f;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat distance = fabs(attributes.center.x - centerX);
        CGFloat apartScale = distance/self.collectionView.bounds.size.width;
        CGFloat scale = fabs(cos(apartScale * M_PI / 4));
        attributes.transform = CGAffineTransformMakeScale(1.0, scale);
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

- (NSArray *)getCopyOfAttributes:(NSArray *)attributes {
    NSMutableArray *copyArrributes = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyArrributes addObject:[attribute copy]];
    }
    return copyArrributes;
}

@end
