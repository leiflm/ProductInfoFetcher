//
//  main.m
//  ProductInfoFetcher
//
//  Created by Leif Middelschulte on 04.12.12.
//  Copyright (c) 2012 Leif Middelschulte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfo.h"

ProductInfo *getProductInfo(NSInteger ean)
{
    ProductInfo *prod = nil;
    @autoreleasepool {
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://www.barcoo.com/de/w/%ld", ean];
        NSURL *url = [[NSURL alloc]initWithString:urlString];
        NSError *err = nil;
        NSXMLDocument *doc = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyHTML error:&err];
        if (!doc) {
            NSLog(@"Error: %@", [err localizedDescription]);
            return prod;
        }
        NSString *xpathProductNames = @"//*[@id='baseInfo']/div[2]/h1";
        NSString *xpathImageURLs = @"//*[@id='baseInfo']/div[1]/div/img/@src";
        NSString *productName = [[[doc nodesForXPath:xpathProductNames error:&err] lastObject] stringValue];
        NSString *productImageUrl = [[[doc nodesForXPath:xpathImageURLs error:&err] lastObject] stringValue];
        prod = [[ProductInfo alloc] init];
        prod.name = productName;
        prod.imageUrl = productImageUrl;
    }
    return prod;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        if (argc < 2) {
            NSLog(@"%s EAN", argv[0]);
            return -1;
        }
        NSString *ean = [[NSString alloc] initWithCString:argv[1] encoding:NSASCIIStringEncoding];
        ProductInfo *p = getProductInfo([ean integerValue]);
        if (!p)
            return -2;
        NSLog(@"Name: %@\n", [p name]);
        NSLog(@"ImageURL: %@\n", [p imageUrl]);
    }
    return 0;
}

