//
//  UIImageView+Extension.m
//  newDemo
//
//  Created by duxiaoqiang on 16/5/20.
//  Copyright © 2016年 炫嘉科技. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)
- (void)setImageWithImageUrlArray:(NSArray *)imageUrlArr
{
    if (imageUrlArr.count < 3) {
        self.image = [UIImage imageNamed:@"v3_contact_classiconrounded"];
        return;
    }
    
    if (imageUrlArr.count > 9) {
        imageUrlArr = [imageUrlArr subarrayWithRange:NSMakeRange(0, 9)];
    }
    
    self.backgroundColor = [UIColor redColor];
    if (self.layer.cornerRadius == 0) {
        self.layer.cornerRadius = 6;
    }
    
    if ([[imageUrlArr firstObject] isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *tArr = [NSMutableArray array];
        for (NSDictionary *dic in imageUrlArr) {
            [tArr addObject:[dic objectForKey:@"img"]];
        }
        imageUrlArr = tArr;
    }
    
    NSMutableArray *tImageArr = [NSMutableArray array];
    for (NSString *urlStr in imageUrlArr) {
        //先填充占位图
        [tImageArr addObject:[UIImage imageNamed:@"Placeholder-figure-big"]];
        
       // UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlStr] ?: [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//        if (cacheImage) {
//            [tImageArr replaceObjectAtIndex:[imageUrlArr indexOfObject:urlStr] withObject:cacheImage];
//        }else{
//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                
//            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                if (finished && image) {
//                    [tImageArr replaceObjectAtIndex:[imageUrlArr indexOfObject:urlStr] withObject:image];
//                    [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
//                    [self drawHeaderImageViewWithImageArr:tImageArr];
//                }
//            }];
        //}
    }
    [self drawHeaderImageViewWithImageArr:tImageArr];
}

- (void)drawHeaderImageViewWithImageArr:(NSArray *)imageArr
{
    CGFloat left_right_top_bottom = 3;
    CGFloat center = 1.3 * self.bounds.size.width / 40.f;
    
    NSMutableArray *tRectArr = [NSMutableArray array];
    if (imageArr.count < 5) {
        //三、四张
        CGFloat imageW = (self.bounds.size.width - left_right_top_bottom * 2 - center) / 2;
        
        for (NSInteger i = imageArr.count - 1; i >= 0; i --) {
            if (i == 0 && imageArr.count == 3) {
                CGRect rect = CGRectMake((self.bounds.size.width - imageW) / 2,
                                         left_right_top_bottom,
                                         imageW,
                                         imageW
                                         );
                [tRectArr addObject:[NSValue valueWithCGRect:rect]];
            }else{
                CGRect rect = CGRectMake(left_right_top_bottom + (i % 2) * (imageW + center),
                                         (i > imageArr.count - 3) ? left_right_top_bottom + center + imageW : left_right_top_bottom,
                                         imageW,
                                         imageW
                                         );
                [tRectArr addObject:[NSValue valueWithCGRect:rect]];
            }
        }
    }else if (imageArr.count == 5 || imageArr.count == 6){
        //五、六张
        CGFloat imageW = (self.bounds.size.width - left_right_top_bottom * 2 - center * 2) / 3;
        
        for (NSInteger i = imageArr.count - 1; i >= 0; i --) {
            CGRect rect = CGRectZero;
            if (i > imageArr.count - 4) {
                rect = CGRectMake(left_right_top_bottom + (i - (imageArr.count - 3)) * (imageW + center),
                                  (self.bounds.size.width - center - 2 * imageW) / 2 + imageW + center,
                                  imageW,
                                  imageW
                                  );
            }else{
                if (imageArr.count == 5) {
                    rect = CGRectMake((self.bounds.size.width - 2 * imageW - center) / 2 + i * (imageW + center),
                                      (self.bounds.size.width - 2 * imageW - center) / 2,
                                      imageW,
                                      imageW
                                      );
                }else{
                    rect = CGRectMake(left_right_top_bottom + i * (imageW + center),
                                      (self.bounds.size.width - 2 * imageW - center) / 2,
                                      imageW,
                                      imageW
                                      );
                }
                
            }
            [tRectArr addObject:[NSValue valueWithCGRect:rect]];
        }
    }else{
        //七张到九张
        CGFloat imageW = (self.bounds.size.width - left_right_top_bottom * 2 - center * 2) / 3;
        
        for (NSInteger i = imageArr.count - 1; i >= 0; i --) {
            CGRect rect = CGRectZero;
            if (i == 0 && imageArr.count != 9) {
                switch (imageArr.count) {
                    case 7:
                    {
                        rect = CGRectMake((self.bounds.size.width - imageW) / 2, left_right_top_bottom, imageW, imageW);
                    }
                        break;
                    case 8:
                    {
                        rect = CGRectMake((self.bounds.size.width - imageW * 2 - center) / 2, left_right_top_bottom, imageW, imageW);
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }else if (i == 1 && imageArr.count == 8){
                rect = CGRectMake((self.bounds.size.width - imageW * 2 - center) / 2 + imageW + center, left_right_top_bottom, imageW, imageW);
            }else{
                NSInteger lie = i > imageArr.count - 7 ? (i - (imageArr.count - 6)) % 3 : i;
                NSInteger hang = (i - (imageArr.count - 9)) / 3;
                rect = CGRectMake(left_right_top_bottom + lie * (imageW + center), left_right_top_bottom + hang * (imageW + center), imageW, imageW);
            }
            [tRectArr addObject:[NSValue valueWithCGRect:rect]];
        }
    }
    
    NSArray *imageRectArr = [[tRectArr reverseObjectEnumerator] allObjects];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    for (int i = 0; i < imageArr.count; i ++) {
        UIImage *image = [imageArr objectAtIndex:i];
        CGRect rect = [[imageRectArr objectAtIndex:i] CGRectValue];
        [image drawInRect:rect];
    }
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.image = im;
}

@end
