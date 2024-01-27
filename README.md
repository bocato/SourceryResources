# SourceryTemplates

Place to hold stencil templates to be used in Sourcery.

## Available Templates

### AutoMappableFromDTO
Creates the initializer for class that have a DTO in order to map from DTO to Domain entity.
```swift
// Input ⬅️
struct RoundDTO: Decodable {
    let id: String
    let position: Int
    let status: RoundStatusDTO
    let groups: [RoundGroupDTO]
}

struct Round: Equatable, Identifiable, AutoMappableFromDTO {
    let id: String
    let position: Int
    let status: RoundStatus
    let groups: [RoundGroup]
}

// Output ➡️
extension Round {
    init(
        dto: RoundDTO
        mapGroupsEntityFromDTO: ([RoundGroupDTO]) -> [RoundGroup]
    ) {
        self.id = dto.id
        self.position = dto.position
        self.status = .init(dto: dto.status)
        self.groups = mapGroupsEntityFromDTO(dto.groups)
    }
}
```

### AutoFixture
Creates special initializer `fixture` to simplify testing when mocking objects.
```swift
// Input ⬅️
enum MyEnum {
    case firstCase
    case secondCase
}

struct MyModel: AutoFixture {
    let anInt: Int
    let anUInt: UInt
    let aFloat: Float
    let aDouble: Double
    let aBool: Bool
    let aString: String
    let aCharacter: Character
    let anArray: Array
    let anArray2: [Int]
    let aDictionary: Dictionary
    let aDictionary2: [String: String]
    let aSet: Set
    let aDate: Date
    let aData: Data
    let anURL: URL
    let aSomething: Something
    let anEnum: MyEnum
}

// Output ➡️
#if DEBUG
extension MyModel {
    static func fixture(
        anInt: Int = 0, 
        anUInt: UInt = 0, 
        aFloat: Float = 0, 
        aDouble: Double = 0, 
        aBool: Bool = false, 
        aString: String = "aString", 
        aCharacter: Character = "", 
        anArray: Array = .fixture(), 
        anArray2: [Int] = .init(), 
        aDictionary: Dictionary = .fixture(), 
        aDictionary2: [String: String] = .init(), 
        aSet: Set = .fixture(), 
        aDate: Date = .distantFuture, 
        aData: Data = .init(), 
        anURL: URL = .init(), 
        aSomething: Something = .fixture(), 
        anEnum: MyEnum = .firstCase
    ) -> Self {
        return .init(
            anInt: anInt, 
            anUInt: anUInt, 
            aFloat: aFloat, 
            aDouble: aDouble, 
            aBool: aBool, 
            aString: aString, 
            aCharacter: aCharacter, 
            anArray: anArray, 
            anArray2: anArray2, 
            aDictionary: aDictionary, 
            aDictionary2: aDictionary2, 
            aSet: aSet, 
            aDate: aDate, 
            aData: aData, 
            anURL: anURL, 
            aSomething: aSomething, 
            anEnum: anEnum
        )
    }
}
#endif
```

## AsyncAutoStub
Creates a `Stub` based on a dependency protocol, mostly applicable for datasources like services and repositories.
NOTE: it assumes that all models returned have a `fixture` method previously defined.
```swift
// Input ⬅️
enum MyEnum {
    case firstCase
    case secondCase
}

protocol SomeServiceProtocol {
    func getSomething(_ id: String) async throws -> Something
    func getEnum() async throws -> MyEnum
    func getDate() async throws -> Date
    func getData() async throws -> Data
    func getURL() async throws -> URL
    func getArray() async throws -> [String]
    func getDictionary() async throws -> [String: String]
    func postSomething() async throws
}

// Output ➡️
#if DEBUG
public final class SomeServiceStub: SomeServiceProtocol {
    public init() {}

    public var getSomethingResultToBeReturned: Result<Something, Error> = .success(.fixture())
    public func getSomething(_ id: String) async throws -> Something {
        try getSomethingResultToBeReturned.get()
    }

    public var getEnumResultToBeReturned: Result<MyEnum, Error> = .success(.firstCase)
    public func getEnum() async throws -> MyEnum {
        try getEnumResultToBeReturned.get()
    }

    public var getDateResultToBeReturned: Result<Date, Error> = .success(.init())
    public func getDate() async throws -> Date {
        try getDateResultToBeReturned.get()
    }

    public var getDataResultToBeReturned: Result<Data, Error> = .success(.init())
    public func getData() async throws -> Data {
        try getDataResultToBeReturned.get()
    }

    public var getURLResultToBeReturned: Result<URL, Error> = .success(.init())
    public func getURL() async throws -> URL {
        try getURLResultToBeReturned.get()
    }

    public var getArrayResultToBeReturned: Result<[String], Error> = .success(.init())
    public func getArray() async throws -> [String] {
        try getArrayResultToBeReturned.get()
    }

    public var getDictionaryResultToBeReturned: Result<[String: String], Error> = .success(.init())
    public func getDictionary() async throws -> [String: String] {
        try getDictionaryResultToBeReturned.get()
    }

    public var postSomethingResultToBeReturned: Result<Void, Error> = .success(())
    public func postSomething() async throws {
        try postSomethingResultToBeReturned.get()
    }
}
#endif
```

## AsyncAutoFailing
Creates a `Failing` based on a dependency protocol.
NOTE: it assumes that all models returned have a `fixture` method previously defined.
```swift
// Input ⬅️
enum MyEnum {
    case firstCase
    case secondCase
}

protocol SomeServiceProtocol {
    func getSomething(_ id: String) async throws -> Something
    func getEnum() async throws -> MyEnum
    func getDate() async throws -> Date
    func getData() async throws -> Data
    func getURL() async throws -> URL
    func getArray() async throws -> [String]
    func getDictionary() async throws -> [String: String]
    func postSomething() async throws
}

// Output ➡️
#if DEBUG
import XCTestDynamicOverlay

public struct SomeServiceFailing: SomeServiceProtocol {
    public init() {}

    public func getSomething(_ id: String) async throws -> Something {
        XCTFail("\(#function) is not implemented.")
        return .fixture()
    }

    public func getEnum() async throws -> MyEnum {
        XCTFail("\(#function) is not implemented.")
        return .firstCase
    }

    public func getDate() async throws -> Date {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    public func getData() async throws -> Data {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    public func getURL() async throws -> URL {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    public func getArray() async throws -> [String] {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    public func getDictionary() async throws -> [String: String] {
        XCTFail("\(#function) is not implemented.")
        return .init()
    }

    public func postSomething() async throws {
        XCTFail("\(#function) is not implemented.")
    }
}
#endif
```
