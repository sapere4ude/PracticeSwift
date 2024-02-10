//
//  Protocol_oriented_programmingTests.swift
//  Protocol-oriented-programmingTests
//
//  Created by Kant on 12/12/23.
//

import XCTest
@testable import Protocol_oriented_programming

final class Protocol_oriented_programmingTests: XCTestCase {

    private var sut: UserViewModel!
    private var userService: MockUserService!
    private var output: MockUserViewOutput!
    
    override func setUpWithError() throws {
        output = MockUserViewOutput()
        userService = MockUserService()
        sut = UserViewModel(userService: userService)
        sut.output = output
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        userService = nil
        try super.tearDownWithError()
    }

    func test_updateView_onAPISuccess_showsImageAndEamil() throws {
        // given
        let user = User(id: 1, email: "me@gmail.com", avatar: "https://www.picsum.com/2")
        userService.fetchUserMockResult = .success(user)
        // when
        sut.fetchUser()
        // then
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray[0].email, "me@gmail.com")
        XCTAssertEqual(output.updateViewArray[0].imageUrl, "https://www.picsum.com/2")
    }
    
    func test_updateView_onAPIFailure_showsErrorImageAndDefaultNoUserFoundText() throws {
        // given
        userService.fetchUserMockResult = .failure(NSError())
        // when
        sut.fetchUser()
        // then
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray[0].email, "No user found")
        XCTAssertEqual(output.updateViewArray[0].imageUrl, "https://cdn1.iconfinder.com/data/icons/user-fill-icons-set/144/User003_Error-512.png")
    }
}

class MockUserService: UserService {
    var fetchUserMockResult: Result<User, Error>?
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        if let result = fetchUserMockResult {
            completion(result)
        }
    }
}

class MockUserViewOutput: UserViewModelOutput {
    
    var updateViewArray: [(imageUrl: String, email: String)] = []
    
    func updateView(imageUrl: String, email: String) {
        updateViewArray.append((imageUrl, email))
    }
}
