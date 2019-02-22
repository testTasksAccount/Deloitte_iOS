//
//  ImageManagerOperation.swift
//  Deloitte Task
//
//  Created by admin on 22/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import UIKit
class ImageManagerOperation: Operation {
    
    private let imageKey: String
    private let completion: ImageManager.ResultHandler
    
    init(imageKey: String,
         completion: @escaping ImageManager.ResultHandler) {
        self.imageKey = imageKey
        self.completion = completion
    }
    
    override func main() {
        ImageCache.shared.getImage(forKey: imageKey) { image in
            if let image = image {
                self.completion(.success(image))
                return
            }
            
            NetworkService.downloadImage(imageUrl: self.imageKey) { image in
                if let image = image {
                    self.completion(.success(image))
                    ImageCache.shared.store(image, forKey: self.imageKey)
                    return
                }
                
                self.completion(.failure(ImageManager.ImageManagerError.incompatibleImage))
            }
        }
    }
}
