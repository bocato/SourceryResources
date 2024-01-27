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
### Input ⬅️
```swift
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
```

### Output ➡️
```swift
#if DEBUG
public final class SomeServiceStub: SomeServiceProtocol {
    public init() {}

    // MARK: - getSomething

    public var getSomethingResultToBeReturned: Result<Something, Error> = .success(.fixture())
    public func getSomething(_ id: String) async throws -> Something {
        try getSomethingResultToBeReturned.get()
    }

    // MARK: - getEnum

    public var getEnumResultToBeReturned: Result<MyEnum, Error> = .success(.firstCase)
    public func getEnum() async throws -> MyEnum {
        try getEnumResultToBeReturned.get()
    }

    // MARK: - getDate

    public var getDateResultToBeReturned: Result<Date, Error> = .success(.init())
    public func getDate() async throws -> Date {
        try getDateResultToBeReturned.get()
    }

    // MARK: - getData

    public var getDataResultToBeReturned: Result<Data, Error> = .success(.init())
    public func getData() async throws -> Data {
        try getDataResultToBeReturned.get()
    }

    // MARK: - getURL

    public var getURLResultToBeReturned: Result<URL, Error> = .success(.init())
    public func getURL() async throws -> URL {
        try getURLResultToBeReturned.get()
    }

    // MARK: - getArray

    public var getArrayResultToBeReturned: Result<[String], Error> = .success(.init())
    public func getArray() async throws -> [String] {
        try getArrayResultToBeReturned.get()
    }

    // MARK: - getDictionary

    public var getDictionaryResultToBeReturned: Result<[String: String], Error> = .success(.init())
    public func getDictionary() async throws -> [String: String] {
        try getDictionaryResultToBeReturned.get()
    }

    // MARK: - postSomething

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
### Input ⬅️
```swift
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
```

### Output ➡️
```swift
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

## AsyncAutoSpy
Generates `Spy`s based on a dependency protocol, mostly applicable for datasources like services and repositories.
NOTE: it assumes that all models returned have a `fixture` method previously defined.
*Based on `Protocol Mock` template from `Łukasz Kuczborski`*
### Input ⬅️
```swift
enum SomeEnum {
    case firstCase
    case secondCase
}

protocol SomethingRepositoryInterface {
    init(input: String)
    func fetchSomethingWithID(_ id: String) async throws -> Something
    func fetchArrayOfSomething() async throws -> [Something]
    func fetchArrayOfSomeEnum() async throws -> [SomeEnum]
    func postSomething(stringParam: String, intParam: Int, somethingParam: Something) async throws
}
```

### Output ➡️
```swift

// MARK: - SomethingRepositoryInterfaceSpy

public final class  SomethingRepositoryInterfaceSpy: SomethingRepositoryInterface {
    
   // MARK: - init

    public var initInputReceivedInput: String?
    public var initInputReceivedInvocations: [String] = []
    public var initInputClosure: ((String) -> Void)?

    required init(input: String) {
        initInputReceivedInput = input
        initInputReceivedInvocations.append(input)
        initInputClosure?(input)
    }
    
   // MARK: - fetchSomethingWithID

    public var fetchSomethingWithIDCallsCount = 0
    public var fetchSomethingWithIDCalled: Bool {
        fetchSomethingWithIDCallsCount > 0
    }
    public var fetchSomethingWithIDReceivedId: String?
    public var fetchSomethingWithIDReceivedInvocations: [String] = []

    public func fetchSomethingWithID(_ id: String) throws -> Something {
        fetchSomethingWithIDCallsCount += 1
        fetchSomethingWithIDReceivedId = id
        fetchSomethingWithIDReceivedInvocations.append(id)
        return .fixture()
    }
    
   // MARK: - fetchArrayOfSomething

    public var fetchArrayOfSomethingCallsCount = 0
    public var fetchArrayOfSomethingCalled: Bool {
        fetchArrayOfSomethingCallsCount > 0
    }

    public func fetchArrayOfSomething() throws -> [Something] {
        fetchArrayOfSomethingCallsCount += 1
        return .init()
    }
    
   // MARK: - fetchArrayOfSomeEnum

    public var fetchArrayOfSomeEnumCallsCount = 0
    public var fetchArrayOfSomeEnumCalled: Bool {
        fetchArrayOfSomeEnumCallsCount > 0
    }

    public func fetchArrayOfSomeEnum() throws -> [SomeEnum] {
        fetchArrayOfSomeEnumCallsCount += 1
        return .init()
    }
    
   // MARK: - postSomething

    public var postSomethingStringParamIntParamSomethingParamCallsCount = 0
    public var postSomethingStringParamIntParamSomethingParamCalled: Bool {
        postSomethingStringParamIntParamSomethingParamCallsCount > 0
    }
    public var postSomethingStringParamIntParamSomethingParamReceivedArguments: (stringParam: String, intParam: Int, somethingParam: Something)?
    public var postSomethingStringParamIntParamSomethingParamReceivedInvocations: [(stringParam: String, intParam: Int, somethingParam: Something)] = []

    public func postSomething(stringParam: String, intParam: Int, somethingParam: Something) throws {
        postSomethingStringParamIntParamSomethingParamCallsCount += 1
        postSomethingStringParamIntParamSomethingParamReceivedArguments = (stringParam: stringParam, intParam: intParam, somethingParam: somethingParam)
        postSomethingStringParamIntParamSomethingParamReceivedInvocations.append((stringParam: stringParam, intParam: intParam, somethingParam: somethingParam))
    }
}
```

## AsyncAutoSpyingStub
Generates `Test Doubles` that serve as `Spy` and `Stub` based on a dependency protocol, mostly applicable for datasources like services and repositories.
NOTE: it assumes that all models returned have a `fixture` method previously defined.
*Based on `Protocol Mock` template from `Łukasz Kuczborski``
### Input ⬅️
```swift
enum SomeEnum {
    case firstCase
    case secondCase
}

protocol SomethingRepositoryInterface {
    init(input: String)
    func fetchSomethingWithID(_ id: String) async throws -> Something
    func fetchArrayOfSomething() async throws -> [Something]
    func fetchArrayOfSomeEnum() async throws -> [SomeEnum]
    func postSomething(stringParam: String, intParam: Int, somethingParam: Something) async throws
}
```

### Output ➡️
```swift
// MARK: - SomethingRepositoryInterfaceSpyingStub

public final class  SomethingRepositoryInterfaceSpyingStub: SomethingRepositoryInterface {
    
   // MARK: - init

    public var initInputResultToBeReturned: Result<SomethingRepositoryInterface, Error> = .success(.fixture())
    public var initInputReceivedInput: String?
    public var initInputReceivedInvocations: [String] = []
    public var initInputClosure: ((String) -> Void)?

    required init(input: String) {
        initInputReceivedInput = input
        initInputReceivedInvocations.append(input)
        initInputClosure?(input)
    }
    
   // MARK: - fetchSomethingWithID

    public var fetchSomethingWithIDResultToBeReturned: Result<Something, Error> = .success(.fixture())
    public var fetchSomethingWithIDCallsCount = 0
    public var fetchSomethingWithIDCalled: Bool {
        fetchSomethingWithIDCallsCount > 0
    }
    public var fetchSomethingWithIDReceivedId: String?
    public var fetchSomethingWithIDReceivedInvocations: [String] = []

    public func fetchSomethingWithID(_ id: String) throws -> Something {
        fetchSomethingWithIDCallsCount += 1
        fetchSomethingWithIDReceivedId = id
        fetchSomethingWithIDReceivedInvocations.append(id)
        return try fetchSomethingWithIDResultToBeReturned.get()
    }
    
   // MARK: - fetchArrayOfSomething

    public var fetchArrayOfSomethingResultToBeReturned: Result<[Something], Error> = .success(.init())
    public var fetchArrayOfSomethingCallsCount = 0
    public var fetchArrayOfSomethingCalled: Bool {
        fetchArrayOfSomethingCallsCount > 0
    }

    public func fetchArrayOfSomething() throws -> [Something] {
        fetchArrayOfSomethingCallsCount += 1
        return try fetchArrayOfSomethingResultToBeReturned.get()
    }
    
   // MARK: - fetchArrayOfSomeEnum

    public var fetchArrayOfSomeEnumResultToBeReturned: Result<[SomeEnum], Error> = .success(.init())
    public var fetchArrayOfSomeEnumCallsCount = 0
    public var fetchArrayOfSomeEnumCalled: Bool {
        fetchArrayOfSomeEnumCallsCount > 0
    }

    public func fetchArrayOfSomeEnum() throws -> [SomeEnum] {
        fetchArrayOfSomeEnumCallsCount += 1
        return try fetchArrayOfSomeEnumResultToBeReturned.get()
    }
    
   // MARK: - postSomething

    public var postSomethingStringParamIntParamSomethingParamResultToBeReturned: Result<Void, Error> = .success(.fixture())
    public var postSomethingStringParamIntParamSomethingParamCallsCount = 0
    public var postSomethingStringParamIntParamSomethingParamCalled: Bool {
        postSomethingStringParamIntParamSomethingParamCallsCount > 0
    }
    public var postSomethingStringParamIntParamSomethingParamReceivedArguments: (stringParam: String, intParam: Int, somethingParam: Something)?
    public var postSomethingStringParamIntParamSomethingParamReceivedInvocations: [(stringParam: String, intParam: Int, somethingParam: Something)] = []

    public func postSomething(stringParam: String, intParam: Int, somethingParam: Something) throws {
        postSomethingStringParamIntParamSomethingParamCallsCount += 1
        postSomethingStringParamIntParamSomethingParamReceivedArguments = (stringParam: stringParam, intParam: intParam, somethingParam: somethingParam)
        postSomethingStringParamIntParamSomethingParamReceivedInvocations.append((stringParam: stringParam, intParam: intParam, somethingParam: somethingParam))
    }
}
```