//
//  ImageManager.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import UIKit

class ImageManager {
    
    private let processingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    enum ImageManagerError: Error {
        case incompatibleImage
    }
    
    enum Result {
        case success(UIImage)
        case failure(ImageManagerError)
        //case cancelled
    }
    
    typealias ResultHandler = (Result) -> Void
    
    private init() {}
    
    public static let shared: ImageManager = {
        let instance = ImageManager()
        return instance
    }()
    
    func getImage(forKey key: String,
                  completion: @escaping ResultHandler) {
        
        let operation = ImageManagerOperation(imageKey: key, completion: completion)
        self.processingQueue.addOperation(operation)
    }
    
}
