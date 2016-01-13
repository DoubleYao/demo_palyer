//
//  DataDeal.m
//  Player
//
//  Created by yaoyao on 14-11-25.
//  Copyright (c) 2014年 yaoyao. All rights reserved.
//

#import "DataDeal.h"

@implementation DataDeal
+(NSArray *)readVedioFileName
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    return  [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:[self getPathDocument] error:&error]];
    
}
+(NSString *)getPathDocument
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    return plistPath;
}
+(void)saveRelation:(NSDictionary*)dic
{
    NSString *plistPath = [self getPathWithName];
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:dic];
    [data writeToFile:plistPath atomically:YES];
    
}
+(NSDictionary *)getRelation
{
    NSString *plistPath = [self getPathWithName];
    NSData *data = [NSData dataWithContentsOfFile:plistPath];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (NSString *)getPathWithName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"relation.plist"]];
    return filename;
}
+ (void)dealRelation
{
    NSArray *filename = [DataDeal readVedioFileName];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[DataDeal getRelation]];
    for (NSString *name in filename) {
        BOOL b = NO;
        for (NSString *key in [dic allKeys]) {
            if ([name isEqualToString:key]) {
                b = YES;
                break;
            }
        }
        if (!b) {
            [dic setObject:MyVeadio forKey:name];
        }
    }
    [DataDeal saveRelation:dic];
}
+(void)upDateRelationFileName:(NSString *)file finder:(NSString*)finder
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[DataDeal getRelation]];
    [dic setObject:finder forKey:file];
    [DataDeal saveRelation:dic];
}

+(void)deleteRelation:(NSString *)name
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[DataDeal getRelation]];
    [dic removeObjectForKey:name];
    [DataDeal saveRelation:dic];
}
+(void)deleteFile:(NSString *)name
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *plistPath = [DataDeal getPathName:name];
    BOOL bRet = [fileMgr fileExistsAtPath:plistPath];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:plistPath error:&err];
    }
}
+(NSString *)getPathName:(NSString *)name
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
     NSString *filename=[plistPath1 stringByAppendingPathComponent:name];
    return filename;
}
+(NSArray *)getFinderArray
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:FinderNames] componentsSeparatedByString:@"<,./>"];
}
+(NSMutableArray *)getShouldShowFinderArray
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[DataDeal getFinderArray]];
    BOOL b = [DataDeal getResultWithKey:ShowSecretList];
    if (!b) {
        [arr removeObject:MySecretVeadio];
    }
    return arr;
}
+(void)addFinder:(NSString *)name
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[DataDeal getFinderArray]];
    if (arr == nil) {
        arr = [NSMutableArray array];
    }
    [arr addObject:name];
    NSString *str = [arr componentsJoinedByString:@"<,./>"];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:FinderNames];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)deleteFinder:(NSString *)name
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[DataDeal getFinderArray]];
    if (arr == nil) {
        return;
    }
    [arr removeObject:name];
    NSString *str = [arr componentsJoinedByString:@"<,./>"];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:FinderNames];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray *)getFilesWithFinder:(NSString *)finder
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[DataDeal getRelation]];
    for (NSString *file in [dic allKeys]) {
        NSString *f = [dic objectForKey:file];
        if ([f isEqualToString:finder]) {
            [arr addObject:file];
        }
    }
    return arr;
}
+(BOOL)getResultWithKey:(NSString *)key
{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+ (void)setBoolValue:(BOOL) b Key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
