//
//  RedditXTests.swift
//  RedditXTests
//
//  Created by Gina Mullins on 9/18/20.
//

import XCTest
@testable import RedditX

class RedditXTests: XCTestCase {
    private var apiExpectation :XCTestExpectation!
    private var apiSuccess: Bool!

    override func setUpWithError() throws {
        apiExpectation = XCTestExpectation(description: "fetch Complete")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHomeViewInit() {
        let homeVC = HomeVC(viewModel: HomeVM(api: API()))
        XCTAssertNotNil(homeVC)
    }
    
    func testDetailViewInit() {
        let detailVC = PostDetailVC(viewModel: PostDetailVM(reddit: Reddit()))
        XCTAssertNotNil(detailVC)
    }

    func testGetRedditPosts() throws {
        let api = API()
        
        // test constants for making api calls
        XCTAssertEqual(Constants.baseURL, "https://www.reddit.com")
        XCTAssertEqual(Constants.postURL, "/.json")
        
        // test api call for all posts
        api.fetchRedditPosts(subreddit: "") {(results) in
            self.wait(for: [self.apiExpectation], timeout: 60.0)
            XCTAssertTrue(self.apiSuccess, "fetch Complete")
        }
    }
    
    func testGetRedditPostsWithSub() throws {
        let api = API()
        
        var sub = ""
        var postURLString = sub.isEmpty ? Constants.postURL : "/r/\(sub)" + Constants.postURL
        
        // test emtpy string
        if sub.isEmpty {
            XCTAssertEqual(postURLString, "/.json")
        } else {
            XCTAssertEqual(postURLString, "/r/funny/.json")
        }
        
        // test non-emtpy string
        sub = "funny"
        postURLString = sub.isEmpty ? Constants.postURL : "/r/\(sub)" + Constants.postURL
        if sub.isEmpty {
            XCTAssertEqual(postURLString, "/.json")
        } else {
            XCTAssertEqual(postURLString, "/r/funny/.json")
        }
        
        // test api call for sub posts
        api.fetchRedditPosts(subreddit: sub) {(results) in
            self.wait(for: [self.apiExpectation], timeout: 60.0)
            XCTAssertTrue(self.apiSuccess, "fetch Complete")
        }
    }
    
    func testParseJson() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Reddit", withExtension: "json") else {
            XCTFail("Missing file: Reddit.json")
            return
        }
        
        guard let json = try? Data(contentsOf: url) else {
            XCTFail("noData")
            return
        }
        guard let container = try? JSONDecoder().decode(Children.self, from: json) else {
            XCTFail("serializationError")
            return
        }
        XCTAssertFalse(container.children.isEmpty)
    }

}
