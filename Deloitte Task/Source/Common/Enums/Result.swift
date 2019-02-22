//
//  Result.swift
//  Deloitte Task
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import Foundation

enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}
