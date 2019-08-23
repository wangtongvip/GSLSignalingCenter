//
//  NSString+GSLAddition.h
//  GSLKit
//
//  Created by wangtong on 2019/5/31.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GSLAddition)

- (NSString *)stringValue;

+ (NSString *)nonEmptyString:(id)obj;

- (BOOL)isContentString:(NSString *)string;

- (BOOL)hasPrefixWithString:(NSString *)string;

- (BOOL)hasSuffixWithString:(NSString *)string;

/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 *Parses a URLString and a baseURL, return absolute URL.
 */
+ (NSString *)URLWithString:(NSString *)URLString relativeToURL:(NSString *)baseURL;

/**
 * Parses a URL query string into a dictionary where the values are arrays.
 */
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 * Parses a URL, adds urlEncoded query parameters to its query, and re-encodes it as a new URL.
 *
 * This method encodes keys and values of query using [NSString urlEncoded] and calls
 * stringByAddingQueryDictionary with the resulting dictionary.
 *
 * @throw NSInvalidArgumentException If any value or key does not respond to urlEncoded.
 */
- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query;

/**
 * Returns a URL Encoded String
 */
- (NSString*)urlEncoded;

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString* sha1Hash;

@end

NS_ASSUME_NONNULL_END
