//
//  UIImageView+Extension.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func load(url: URL,
              completion: @escaping (UIImage) -> Void) {
        
        let cache = TWKCacheManager.shared.imageCache
        let key = url.absoluteString as NSString
        if let image = cache.object(forKey: key) {
            self.image = image
            completion(image)
            return
        }
        
        guard TWKNetworkManager.shared.isConnectedToNetwork() else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DebugInfoKey.cache.log(info: "Couldn't download image from \(url.absoluteURL) :: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: key)
                DebugInfoKey.cache.log(info: "Image cached from \(key)")
                completion(image)
            }

        }.resume()
        
    }
}
