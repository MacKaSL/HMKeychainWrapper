//
//  HMKeychainWrapper.m
//  HMKeychainWrapper
//
//  Created by Himal Madhushan on 7/6/16.
//  Copyright © 2016 Himal Madhushan. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Himal Madhushan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//  https://github.com/MacKaSL
//

#define keychainSaved @"keychainSaved"

#import "HMKeychainWrapper.h"

@implementation HMKeychainWrapper

+ (HMKeychainWrapper *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Keychain


- (void)saveItemInKeyChainForService:(NSString *)serviceName account:(NSString *)accountName secretString:(NSString *)secretStr type:(HMKeychainType)type {
    NSData *secretData;
    if (type == HMKeychainTypeDeviceID) {
        NSString *vendor = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice]identifierForVendor]];
        NSArray *formatted = [vendor componentsSeparatedByString:@">"];
        NSString *formattedString = [formatted objectAtIndex:1];
        formattedString = [formattedString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        formattedString = [formattedString stringByReplacingOccurrencesOfString:@" " withString:@""];
        secretData = [formattedString dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"HMKeychainWrapper - Device ID secret: %@",formattedString);
    } else {
        secretData = [secretStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    NSDictionary *query = @{(id)kSecClass:(id)kSecClassGenericPassword,
                            (id)kSecAttrAccessible:(id)kSecAttrAccessibleAlways,
                            (id)kSecAttrService:serviceName,
                            (id)kSecAttrAccount:accountName,
                            (id)kSecValueData:secretData,
                            };
    
    OSStatus status = SecItemAdd((CFDictionaryRef)query, NULL);
    if (status == noErr) {
        NSLog(@"HMKeychainWrapper - Saved in keychain");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keychainSaved];
    } else {
        NSLog(@"HMKeychainWrapper - Cannot save in keychain or already saved.");
    }
}

- (NSString *)itemSavedInKeychainForService:(NSString *)serviceName account:(NSString *)accountName {
    OSStatus status;
    NSMutableDictionary *keychainItem = [self keychainItemForKey:serviceName service:accountName];
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    CFDictionaryRef result = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    if (status != noErr) {
        return nil;
    }
    NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
    NSData *data = resultDict[(__bridge id)kSecValueData];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSMutableDictionary *)keychainItemForKey:(NSString *)key service:(NSString *)service {
    NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecAttrAccount] = key;
    keychainItem[(__bridge id)kSecAttrService] = service;
    return keychainItem;
}

@end
