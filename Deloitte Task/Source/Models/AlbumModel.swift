//
//  AlbumModel.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import Foundation
struct AlbumModel: Codable {
    var artistId: Int
    var artistName: String
    var collectionName: String
    var collectionViewUrl: String
    var artworkUrl60: String
    var artworkUrl100: String
    var collectionPrice: Double?
    var trackCount: Int
    var copyright: String
    var country: String
    var currency: String
    var releaseDate: String
    var primaryGenreName: String

}
