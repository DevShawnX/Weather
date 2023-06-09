//
//  CacheImage.swift
//  Weather
//
//  Created by Shawn on 6/9/23.
//

import Foundation
import UIKit

class CacheImage {
    static let shared = CacheImage()
    private let cache = NSCache<NSString, UIImage>()
    
    func getImageCache(key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(image: UIImage, key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeImage(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAllImages() {
        cache.removeAllObjects()
    }
}
