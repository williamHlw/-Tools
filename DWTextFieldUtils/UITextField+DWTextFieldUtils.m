//
//  UITextField+DWTextFieldUtils.m
//  DWTextField
//
//  Created by Wicky on 2016/11/21.
//  Copyright © 2016年 Wicky. All rights reserved.
//

#import "UITextField+DWTextFieldUtils.h"
#import <objc/runtime.h>

@implementation UITextField (DWTextFieldUtils)
-(BOOL)dw_ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSAssert(self.componentsLength.count, @"To use this Method 'dw_ShouldChangeCharactersInRange:replacementString:' you should make sure setting the property of 'componetsLength!'");
    ///获取目标字符串
    string = [self.text stringByReplacingCharactersInRange:range withString:string];
    
    ///获取目标字符串对应的无分隔符字符串
    string = [self absoluteNoSeperatorString:string];
    
    ///获取最大长度
    __block NSInteger limitL = 0;
    
    [self.componentsLength enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        limitL += obj.integerValue;
    }];
    
    ///如果长度超过最大则默认返回，取消本次输入
    if (string.length > limitL) {
        return NO;
    }
    
    ///否则处理字符串至带分隔符字符串
    string = [self handleSeperatorStringWithString:string];
    
    ///强行改变textField
    self.text = string;
    
    ///因为已经强行改变，所以此处无需再次改变，必须为NO
    return NO;
}

/**
 在指定位置为字符串添加分隔符
 */
-(NSString *)string:(NSString *)string insertSeperatorAtIndex:(NSInteger)index
{
    return [string stringByReplacingCharactersInRange:NSMakeRange(index, 0) withString:self.componentsSeparator];
}

/**
 获取无分隔符的字符串
 */
-(NSString *)absoluteNoSeperatorString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:self.componentsSeparator withString:@""];
}

/**
 处理纯字符串至以分隔符分隔的字符串
 */
-(NSString *)handleSeperatorStringWithString:(NSString *)string
{
    ///获取分隔数组并排除最后一位
    NSMutableArray * numArr = self.componentsLength.mutableCopy;
    [numArr removeLastObject];
    
    ///获取限制长度
    __block NSInteger limitL = 0;
    [numArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        limitL += obj.integerValue;
    }];
    
    ///循环处理
    int count = (int)numArr.count;
    while (count > 0) {
        
        ///如果超过限制长度则处理字符串
        if (string.length > limitL) {
            int index = count;
            
            ///获取需要处理的坐标并倒序处理
            while (index) {
                __block NSInteger length = 0;
                [numArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx < index) {
                        length += obj.integerValue;
                    }
                }];
                string = [self string:string insertSeperatorAtIndex:length];
                index --;
            }
            ///若进入此判断则跳出循环
            break;
        }
        
        ///未进入判断则缩减限制长度
        limitL -= [numArr.lastObject integerValue];
        count --;
        [numArr removeLastObject];
    }
    return string;
}

-(NSMutableArray *)componentsLength
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setComponentsLength:(NSMutableArray *)componentsLength
{
    objc_setAssociatedObject(self, @selector(componentsLength), componentsLength, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)componentsSeparator
{
    NSString * separator = objc_getAssociatedObject(self, _cmd);
    if (separator == nil) {
        separator = @" ";
        objc_setAssociatedObject(self, _cmd, separator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return separator;
}

-(void)setComponentsSeparator:(NSString *)componentsSeperator
{
    objc_setAssociatedObject(self, @selector(componentsSeparator), componentsSeperator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)absoluteString
{
    return [self absoluteNoSeperatorString:self.text];
}
@end
