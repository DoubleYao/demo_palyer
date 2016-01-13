//
//  DataDeal.h
//  Player
//
//  Created by yaoyao on 14-11-25.
//  Copyright (c) 2014年 yaoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FirstComeIn @"FirstComeIn"
#define MyVeadio @"我的视频"
#define MySecretVeadio @"加密列表"
#define NewCreateFinder @"新建"
#define FinderNames @"FinderNames"
//文件存储规则：plist文件 文件名是键 文件夹为值
@interface DataDeal : NSObject
+(NSArray *)readVedioFileName;
+(NSString *)getPathDocument;
+(void)saveRelation:(NSDictionary*)dic;
+(NSDictionary *)getRelation;
+ (NSString *)getPathWithName;
+ (void)dealRelation;
+(void)upDateRelationFileName:(NSString *)file finder:(NSString*)finder;
+(void)deleteRelation:(NSString *)name;
+(void)deleteFile:(NSString *)name;
+(NSString *)getPathName:(NSString *)name;
+(NSArray *)getFinderArray;
+(NSMutableArray *)getShouldShowFinderArray;
+(void)addFinder:(NSString *)name;
+(void)deleteFinder:(NSString *)name;
+(NSArray *)getFilesWithFinder:(NSString *)finder;


#define GestureRecognizerOpration @"GestureRecognizerOpration"
#define AutoPlayNext @"AutoPlayNext"
#define ShowSecretList @"ShowSecretList"
#define WiFiTransfer @"WiFiTransfer"
+(BOOL)getResultWithKey:(NSString *)key;
+ (void)setBoolValue:(BOOL) b Key:(NSString *)key;

#define NotificationShowSecretList @"NotificationShowSecretList"

@end
