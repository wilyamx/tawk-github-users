//
//  TWKCacheManager.swift
//  Github-Users
//
//  Created by William S. Rena on 3/1/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKCacheManager {
    static let shared = TWKCacheManager()
    
    public lazy var imageCache = NSCache<NSString, UIImage>()
    
    // https://blewjy.github.io/ios/swift/4/basic/2019/02/27/image-caching-in-swift-4.html
    // https://betterprogramming.pub/cache-images-in-a-uicollectionview-using-nscache-in-swift-5-b70ebf090521
    
    init() {
        let urlCache = URLCache(
            memoryCapacity: 4 * 1024 * 1024,
            diskCapacity: 300 * 1024 * 1024,
            diskPath: nil)
        URLCache.shared = urlCache
    }
}
