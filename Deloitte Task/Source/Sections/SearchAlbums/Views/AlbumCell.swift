//
//  AlbumCell.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    public static let reuseIdentifier = "AlbumCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func render(props: AlbumModel) {
        self.loadImage(url: props.artworkUrl60)
    }
    
    private func loadImage(url: String) {
        
        imageView.image = UIImage(imageLiteralResourceName: "placeholder")
        
        ImageManager.shared.getImage(forKey: url) { imageResult in
            switch imageResult {
            case let .success(image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(imageLiteralResourceName: "image_error")
                }
                print("Error: Failed to get image \(url): \(error)")
            }
        }
    }
}
