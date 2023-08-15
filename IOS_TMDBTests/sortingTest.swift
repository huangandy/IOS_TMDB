//
//  IOS_TMDBTests.swift
//  IOS_TMDBTests
//
//  Created by huangtengwei on 2023/8/11.
//

import XCTest
@testable import IOS_TMDB

final class sortingTests: XCTestCase {
    
    var nowPlayingViewModel: NowPlayingViewModel!
    let testData = [
        Movie(id: -1, title: "a", backdropPath: nil, overview: "", voteAverage: 1.0, voteCount: 1, runtime: nil, releaseDate: "2023-08-11", genres: nil, credits: nil, videos: nil),
        Movie(id: -1, title: "b", backdropPath: nil, overview: "", voteAverage: 2.0, voteCount: 1, runtime: nil, releaseDate: "2023-07-12", genres: nil, credits: nil, videos: nil),
        Movie(id: -1, title: "c", backdropPath: nil, overview: "", voteAverage: 3.0, voteCount: 1, runtime: nil, releaseDate: "2023-06-30", genres: nil, credits: nil, videos: nil),
    ]
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        nowPlayingViewModel = NowPlayingViewModel()
    }

    override func tearDownWithError() throws {
        nowPlayingViewModel = nil
        try super.tearDownWithError()
    }

    func testTitleSort() throws {
        nowPlayingViewModel.results = testData
        nowPlayingViewModel.sortMovies(sortKey: .Title)
        XCTAssertEqual(nowPlayingViewModel.results.count, testData.count, "sort array size not correct")
        
        let result = ["a","b","c"]

        for (index, movie) in nowPlayingViewModel.results.enumerated() {
            XCTAssertEqual(movie.title, result[index], "sort wrong with \(movie) at index: \(index)")
        }
    }

    func testRatingSort() throws {
        nowPlayingViewModel.results = testData
    
        nowPlayingViewModel.sortMovies(sortKey: .Rating)
        XCTAssertEqual(nowPlayingViewModel.results.count, testData.count, "sort array size not correct")
        
        let result = [3.0, 2.0, 1.0]

        for (index, movie) in nowPlayingViewModel.results.enumerated() {
            XCTAssertEqual(movie.voteAverage, result[index], "sort wrong with \(movie) at index: \(index)")
        }
        
    }
    
    func testReleaseDateSort() throws {
        nowPlayingViewModel.results = testData
    
        nowPlayingViewModel.sortMovies(sortKey: .ReleaseDate)
        XCTAssertEqual(nowPlayingViewModel.results.count, testData.count, "sort array size not correct")
        
        let result = ["2023-06-30", "2023-07-12", "2023-08-11"]

        for (index, movie) in nowPlayingViewModel.results.enumerated() {
            XCTAssertEqual(movie.releaseDate, result[index], "sort wrong with \(movie) at index: \(index)")
        }
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
