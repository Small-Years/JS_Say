//
//  NSDictionary+JSON.h
//  FMDBDemo
//
//  Created by yangjian on 2017/6/5.
//  Copyright © 2017年 zenoV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
