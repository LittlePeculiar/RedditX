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

    func testDownRedditData() {

        let expectation = XCTestExpectation(description: "Download Reddit Data")

        guard let url = URL(string: "https://www.reddit.com/.json") else {
            XCTFail("Invalid URL from string https://www.reddit.com/.json")
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            XCTAssertNotNil(data, "No data was downloaded.")
            expectation.fulfill()
        }

        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }

    func testGetRedditPosts() throws {
        let api = API()
        
        // test constants for making api calls
        XCTAssertEqual(APIUrls.baseURL, "https://www.reddit.com")
        XCTAssertEqual(APIUrls.postURL, "/.json")
        
        // test api call for all posts
        api.fetch(forModel: Children.self, urlString: "") {(results) in
            switch results {
            case .failure(_):
                XCTFail("An error occured while fetching reddit posts.")
            case .success(let posts):
                XCTAssertFalse(posts.children.isEmpty)
            }
            self.wait(for: [self.apiExpectation], timeout: 10.0)
            XCTAssertTrue(self.apiSuccess, "fetch Complete")
        }
    }
    
    func testGetRedditPostsWithSub() throws {
        let api = API()
        
        var sub = ""
        var postURLString = sub.isEmpty ? APIUrls.postURL : "/r/\(sub)" + APIUrls.postURL
        
        // test emtpy string
        if sub.isEmpty {
            XCTAssertEqual(postURLString, "/.json")
        } else {
            XCTAssertEqual(postURLString, "/r/funny/.json")
        }
        
        // test non-emtpy string
        sub = "funny"
        postURLString = sub.isEmpty ? APIUrls.postURL : "/r/\(sub)" + APIUrls.postURL
        if sub.isEmpty {
            XCTAssertEqual(postURLString, "/.json")
        } else {
            XCTAssertEqual(postURLString, "/r/funny/.json")
        }
        
        // test api call for sub posts
        api.fetch(forModel: Children.self, urlString: "") {(results) in
            switch results {
            case .failure(_):
                XCTFail("An error occured while fetching reddit posts.")
            case .success(let posts):
                XCTAssertFalse(posts.children.isEmpty)
            }
            self.wait(for: [self.apiExpectation], timeout: 10.0)
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

        let sub = container.children[0]
        XCTAssertEqual(sub.subreddit, "FAWSL")
    }

}
