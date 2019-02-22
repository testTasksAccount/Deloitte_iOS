//
//  Feed.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import Foundation

struct Feed<T: Codable>: Codable {
    var results: [T]
}
