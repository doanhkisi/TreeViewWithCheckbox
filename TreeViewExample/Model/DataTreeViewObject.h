//
//  DataObject.h
//  MynaviHighschool
//
//  Created by Bui Duy Doanh on 10/3/15.
//  Copyright © 2015 Mynavi Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTreeViewObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSInteger jobCount;
@property (nonatomic, strong) NSArray *children;

@property (nonatomic, assign) BOOL checked;

+ (id)dataObjectWithName:(NSString *)name
                      ID:(NSString *)ID
                jobCount:(NSInteger)jobCount
                children:(NSArray *)children;

- (id)initWithName:(NSString *)name
                ID:(NSString *)ID
          jobCount:(NSInteger)jobCount
          children:(NSArray *)children;

- (void)addChild:(id)child;
- (void)removeChild:(id)child;
@end
