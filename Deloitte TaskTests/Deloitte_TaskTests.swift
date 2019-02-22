//
//  Deloitte_TaskTests.swift
//  Deloitte TaskTests
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 Andrii Andreiev. All rights reserved.
//

import XCTest
@testable import Deloitte_Task

class Deloitte_TaskTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testDownloadImageSuccess() {
        let realImageURL = "https://upload.wikimedia.org/wikipedia/commons/3/30/Googlelogo.png"
        let promise = expectation(description: "Image dounloaded")
        
        NetworkService.downloadImage(imageUrl: realImageURL) { img in
            guard img != nil else {
                XCTFail("Error: Image wasn`t loaded")
                return
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDownloadImageFail() {
        let failImageURL = "https://upload.wikimedia.org/"
        let promise = expectation(description: "can`t dounload image")
        
        NetworkService.downloadImage(imageUrl: failImageURL){ img in
            guard img == nil else {
                XCTFail("Error: Where did u get this image?")
                return
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetAlbumsSuccess() {
        let goodSearchExample = "jack johnson"
        let promise = expectation(description: "Albums data downloaded")
        
        NetworkService.getAlbums(searchString: goodSearchExample){ result in
            switch result {
            case .success(let albums):
                guard albums.count > 0 else {
                    XCTFail("Error: no search results for \(goodSearchExample)")
                    return
                }
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetAlbumsFail() {
        let badSearchExample = "aslkdfjlaskdhjglasjkhdlfkasjdflkajsfdlkj"
        let promise = expectation(description: "Search results are empty")
        
        NetworkService.getAlbums(searchString: badSearchExample){ result in
            switch result {
            case .success(let albums):
                guard albums.count == 0 else {
                    XCTFail("Error: not empty search results for \(badSearchExample)")
                    return
                }
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
