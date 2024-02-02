
# What are `Failing`s?
**Failings** are a special type of **<u>Dummy</u>** that fails your test if the dependency was not set or should not be called by that scenario.

This kind of **Double** is possible with techniques that expose **XCTFail** outside of test targets. In our project, we can get that by importing [XCTestDynamicOverlay](https://github.com/pointfreeco/xctest-dynamic-overlay).

For more detailed info we suggest you to check [this](https://www.pointfree.co/episodes/ep138-better-test-dependencies-exhaustivity) and [this](https://www.pointfree.co/episodes/ep139-better-test-dependencies-failability) episodes on [PointFree.co](https://www.pointfree.co).

**Example:**
```swift
protocol NetworkingProtocol {
    func getData(from url: URL, then completion: @escaping (Result<Data?, Error>) -> Void)
}
 
import XCTestDynamicOverlay
 
struct FailingNetwork: NetworkingProtocol {
    func getData(from url: URL, then completion: @escaping (Result<Data?, Error>) -> Void) {
        XCTFail("getData(from:then:) was not implemented!")
    }
}
```

This can come in hand when writing tests after the code is already in place, since you can just set the dependencies as **Failing**, then go into a flow like TDD, and refactoring cycles on you test case.
This way you will know the code and add tests to it without having to spend a lot of time trying to understand the logic before testing.

This technique can be also helpful when applying the "common" TDD flow.

# AsyncAutoFailing
Creates a `Failing` based on a dependency protocol.
NOTE: it assumes that all models returned have a `fixture` method previously defined.

### Input ⬅️

```swift
enum MyEnum {
    case firstCase
    case secondCase
}

protocol SomeServiceProtocol {
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

import XCTestDynamicOverlay

// MARK: - SomeServiceProtocolFailing

internal struct SomeServiceFailing: SomeServiceProtocol {
    internal init() {}

    required init(something: String) {
        XCTFail("\(#function) is not implemented.")
    }

    internal func getSomething(_ id: String) async throws -> Something {
        XCTFail("\(#function) is not implemented.")
        return .fixture()
    }

    internal func getEnum() async throws -> MyEnum {
        XCTFail("\(#function) is not implemented.")
        return .firstCase
    }

    internal func getDate() async throws -> Date {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    internal func getData() async throws -> Data {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    internal func getURL() async throws -> URL {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    internal func getArray() async throws -> [String] {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    internal func getDictionary() async throws -> [String: String] {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    internal func postSomething() async throws {
        XCTFail("\(#function) is not implemented.")
    }

    internal func postNoThrow() async {
        XCTFail("\(#function) is not implemented.")
    }
}
```