# What are `Stub`s?
**Stub** is a kind of test double that you use to control the outcome of the said dependency.

**Example:**
```swift
struct Post {
    let title: String
    let text: String
}
 
protocol PostsServiceProtocol {
    func fetchAll(then: (Result<[Post], Error>) -> Void)
}
 
final class UserFeedViewModel {
    private let postsService: PostsServiceProtocol
    private(set) var numberOfPosts: Int = 0
     
    init(postsService: PostsServiceProtocol) {
        self.postsService = postsService
    }
     
    func loadData(then: @escaping () -> Void) {
        postsService.fetchAll { [weak self] result in
            let numberOfPosts = (try? result.get())?.count ?? 0
            self?.numberOfPosts = numberOfPosts
            then()
        }
    }
}
```
Considering that you want to test if the **numberOfPosts** changed, you can do something like this:
```swift
final class PostsServiceStub: PostsServiceProtocol {
    var fetchAllResultToBeReturned: Result<[Post], Error> = .success([])
    func fetchAll(then: (Result<[Post], Error>) -> Void) {
        then(fetchAllResultToBeReturned)
    }
}
 
// Usage
final class UserFeedViewModelTests: XCTestCase {
    func test_fetchAll_shouldReturnTheCorrectAmountOfPosts() {
        // Given
        let postsServiceStub = PostsServiceStub()
        let stubbedPosts: [Post] = [
            .init(title: "Post 1", text: "Post Text 1"),
            .init(title: "Post 2", text: "Post Text 2")
        ]
        postsServiceStub.fetchAllResultToBeReturned = .success(stubbedPosts)
        let sut = UserFeedViewModel(postsService: postsServiceStub)
        let initialNumberOfPosts = sut.numberOfPosts
         
        // When
        let loadDataExpectation = expectation(description: "loadDataExpectation")
        sut.loadData {
            loadDataExpectation.fulfill()
        }
        wait(for: [loadDataExpectation], timeout: 1.0)
         
        // Then
        XCTAssertNotEqual(initialNumberOfPosts, sut.numberOfPosts)
    }
}
```

## AsyncAutoStub

Creates a `Stub` based on a dependency protocol, mostly applicable for datasources like services and repositories.
NOTE: it assumes that all models returned have a `fixture` method previously defined.

### Input ⬅️

```swift
enum MyEnum {
    case firstCase
    case secondCase
}

protocol SomeServiceInterface {
    init(something: String)
    func getSomething(_ id: String) async throws -> Something
    func getEnum() async throws -> MyEnum
    func getDate() async throws -> Date
    func getData() async throws -> Data
    func getURL() async throws -> URL
    func getArray() async throws -> [String]
    func getDictionary() async throws -> [String: String]
    func postSomething() async throws
    func postNoThrow() async
}
```

### Output ➡️

```swift
// MARK: - SomeServiceProtocolStub

internal final class SomeServiceStub: SomeServiceProtocol {
    internal init() {}

    // MARK: - getSomething

    internal var getSomethingResultToBeReturned: Result<Something, Error> = .success(.fixture())
    internal func getSomething(_ id: String) async throws -> Something {
        try getSomethingResultToBeReturned.get()
    }

    // MARK: - getEnum

    internal var getEnumResultToBeReturned: Result<MyEnum, Error> = .success(.firstCase)
    internal func getEnum() async throws -> MyEnum {
        try getEnumResultToBeReturned.get()
    }

    // MARK: - getDate

    internal var getDateResultToBeReturned: Result<Date, Error> = .success(.init())
    internal func getDate() async throws -> Date {
        try getDateResultToBeReturned.get()
    }

    // MARK: - getData

    internal var getDataResultToBeReturned: Result<Data, Error> = .success(.init())
    internal func getData() async throws -> Data {
        try getDataResultToBeReturned.get()
    }

    // MARK: - getURL

    internal var getURLResultToBeReturned: Result<URL, Error> = .success(.init(string: "www.test.com").unsafelyUnwrapped)
    internal func getURL() async throws -> URL {
        try getURLResultToBeReturned.get()
    }

    // MARK: - getArray

    internal var getArrayResultToBeReturned: Result<[String], Error> = .success(.init())
    internal func getArray() async throws -> [String] {
        try getArrayResultToBeReturned.get()
    }

    // MARK: - getDictionary

    internal var getDictionaryResultToBeReturned: Result<[String: String], Error> = .success(.init())
    internal func getDictionary() async throws -> [String: String] {
        try getDictionaryResultToBeReturned.get()
    }

    // MARK: - postSomething

    internal var postSomethingResultToBeReturned: Result<Void, Error> = .success(())
    internal func postSomething() async throws {
        try postSomethingResultToBeReturned.get()
    }
}
```