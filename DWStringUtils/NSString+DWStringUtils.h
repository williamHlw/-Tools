//
//  NSString+DWStringUtils.h
//  RegExp
//
//  Created by Wicky on 17/1/8.
//  Copyright © 2017年 Wicky. All rights reserved.
//

/**
 DWStringUtils
 NSString工具类
 
 version 1.0.0
 提供生成连续相同字符组成的指定长度字符串api
 提供根据字体及限制尺寸返回文本尺寸api
 提供以指定长度生成随机字符串的api
 提供文件名序数修复api
 
 version 1.0.1
 添加汉字转拼音api
 添加正则匹配结果api
 
 version 1.0.2
 添加数组按拼音排序方法
 */

#import <UIKit/UIKit.h>

@interface NSString (DWStringUtils)

///转拼音后的字符串
@property (nonatomic ,copy) NSString * pinyinString;

///生成由N个元字符串组成的字符串
/**
 metaString     元字符串，组成字符串的元素
 count          元字符串的个数
 */
+(NSString *)stringWithMetaString:(NSString *)metaString count:(NSUInteger)count;

///根据字号及尺寸限制返回文本尺寸
-(CGSize)stringSizeWithFont:(UIFont *)font
                 widthLimit:(CGFloat)widthLimit
                heightLimit:(CGFloat)heightLimit;

///以长度生成随机字符串，字符串有大小写字母及数字组成
+(NSString *)stringWithRandomCharacterWithLength:(NSUInteger)length;

///给文件名添加序数（文件名重复时使用）
-(NSString *)dw_FixFileNameStringWithIndex:(NSUInteger)idx;

///汉字转拼音（是否需要空格）
-(NSString *)dw_TransferChineseToPinYinWithWhiteSpace:(BOOL)needWhiteSpace;

///返回整串字符串中符合正则的结果集
-(NSArray <NSTextCheckingResult *> *)dw_RangesConfirmToPattern:(NSString *)pattern;

///符合正则的子串集
-(NSArray <NSString *> *)dw_SubStringConfirmToPattern:(NSString *)pattern;

///将数组内字符串以拼音排序
+(NSMutableArray *)dw_SortedStringsInPinyin:(NSArray <NSString *>*)strings;
@end
