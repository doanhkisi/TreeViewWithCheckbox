//
//  DataObject.m
//  MynaviHighschool
//
//  Created by Bui Duy Doanh on 10/3/15.
//  Copyright © 2015 Mynavi Corporation. All rights reserved.
//

#import "DataTreeViewObject.h"

@implementation DataTreeViewObject

- (id)initWithName:(NSString *)name
                ID:(NSString *)ID
          jobCount:(NSInteger)jobCount
          children:(NSArray *)children {
    self = [super init];
    if (self) {
        self.name = name;
        self.ID = ID;
        self.jobCount = jobCount;
        self.children = [NSArray arrayWithArray:children];
        self.checked = NO;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name
                      ID:(NSString *)ID
                jobCount:(NSInteger)jobCount
                children:(NSArray *)children {
    return [[self alloc] initWithName:name
                                   ID:ID
                             jobCount:jobCount
                             children:children];
}

- (void)addChild:(id)child {
    NSMutableArray *children = [self.children mutableCopy];
    NSInteger index = children.count == 0 ? 0 : children.count -1;
    [children insertObject:child atIndex:index];
    self.children = [children copy];
}

- (void)removeChild:(id)child {
    NSMutableArray *children = [self.children mutableCopy];
    [children removeObject:child];
    self.children = [children copy];
}

@end
