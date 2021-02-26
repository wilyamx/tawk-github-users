//
//  UIImage+Extension.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

extension UIImage {
    func inverseImage() -> UIImage? {
        if let beginImage = CIImage(image: self),
           let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            return UIImage(ciImage: filter.outputImage!)
        }
        return nil
    }
}
