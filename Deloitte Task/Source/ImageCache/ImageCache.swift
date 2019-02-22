//
//  ImageCache.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    private let memoryCache = NSCache<NSString, AnyObject>()
    
    private init() {}
    
    public static let shared: ImageCache = {
        let instance = ImageCache()
        return instance
    }()
    
    func store(_ image: UIImage,
               forKey key: String,
               completionHandler: (() -> Void)? = nil) {
        
        self.memoryCache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(forKey key: String,
                  completionHandler: ((UIImage?) -> Void)?) {
        
        guard let completionHandler = completionHandler else {
            return
        }
        
        let image = self.memoryCache.object(forKey: key as NSString) as? UIImage
        completionHandler(image)
    }
}
