# SourceryTemplates

Place to hold stencil templates to be used in Sourcery.

## Available Templates

### AutoMappableFromDTO

Creates the initializer for class that have a DTO in order to map from DTO to Domain entity.

```swift
// Input ⬅️
struct MyObjectDTO: Decodable {
    let id: String
    let position: Int
    let status: RoundStatusDTO
    let groups: [RoundGroupDTO]
}

struct MyObject: Equatable, Identifiable, AutoMappableFromDTO {
    let id: String
    let position: Int
    let status: RoundStatus
    let groups: [RoundGroup]
}

// Output ➡️
internal extension MyObject {
    init(
        dto: MyObjectDTO
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
internal extension MyModel {
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

    internal var getURLResultToBeReturned: Result<URL, Error> = .success(.init())
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

import XCTestDynamicOverlay

// MARK: - SomeServiceProtocolFailing

internal struct SomeServiceFailing: SomeServiceProtocol {
    internal init() {}

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
}
```

## AsyncAutoSpy

Generates `Spy`s based on a dependency protocol, mostly applicable for datasources like services and repositories.
NOTE: it assumes that all models returned have a `fixture` method previously defined.
_Based on `Protocol Mock` template from `Łukasz Kuczborski`_

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
internal final class SomethingRepositorySpy: SomethingRepositoryInterface {

    internal init() {}
    
   // MARK: - init

    internal var initInputReceivedInput: String?
    internal var initInputReceivedInvocations: [String] = []
    internal var initInputClosure: ((String) -> Void)?

    required init(input: String) {
        initInputReceivedInput = input
        initInputReceivedInvocations.append(input)
        initInputClosure?(input)
    }
    
   // MARK: - fetchSomethingWithID

    internal var fetchSomethingWithIDCallsCount = 0
    internal var fetchSomethingWithIDCalled: Bool {
        fetchSomethingWithIDCallsCount > 0
    }
    internal var fetchSomethingWithIDReceivedId: String?
    internal var fetchSomethingWithIDReceivedInvocations: [String] = []

    internal func fetchSomethingWithID(_ id: String) throws -> Something {
        fetchSomethingWithIDCallsCount += 1
        fetchSomethingWithIDReceivedId = id
        fetchSomethingWithIDReceivedInvocations.append(id)
        return .fixture()
    }
    
   // MARK: - fetchArrayOfSomething

    internal var fetchArrayOfSomethingCallsCount = 0
    internal var fetchArrayOfSomethingCalled: Bool {
        fetchArrayOfSomethingCallsCount > 0
    }

    internal func fetchArrayOfSomething() throws -> [Something] {
        fetchArrayOfSomethingCallsCount += 1
        return .init()
    }
    
   // MARK: - fetchArrayOfSomeEnum

    internal var fetchArrayOfSomeEnumCallsCount = 0
    internal var fetchArrayOfSomeEnumCalled: Bool {
        fetchArrayOfSomeEnumCallsCount > 0
    }

    internal func fetchArrayOfSomeEnum() throws -> [SomeEnum] {
        fetchArrayOfSomeEnumCallsCount += 1
        return .init()
    }
    
   // MARK: - postSomething

    internal var postSomethingStringParamIntParamSomethingParamCallsCount = 0
    internal var postSomethingStringParamIntParamSomethingParamCalled: Bool {
        postSomethingStringParamIntParamSomethingParamCallsCount > 0
    }
    internal var postSomethingStringParamIntParamSomethingParamReceivedArguments: (stringParam: String, intParam: Int, somethingParam: Something)?
    internal var postSomethingStringParamIntParamSomethingParamReceivedInvocations: [(stringParam: String, intParam: Int, somethingParam: Something)] = []

    internal func postSomething(stringParam: String, intParam: Int, somethingParam: Something) throws {
        postSomethingStringParamIntParamSomethingParamCallsCount += 1
        postSomethingStringParamIntParamSomethingParamReceivedArguments = (stringParam: stringParam, intParam: intParam, somethingParam: somethingParam)
        postSomethingStringParamIntParamSomethingParamReceivedInvocations.append((stringParam: stringParam, intParam: intParam, somethingParam: somethingParam))
    }
}
```

## AsyncAutoSpyingStub

Generates `Test Doubles` that serve as `Spy` and `Stub` based on a dependency protocol, mostly applicable for datasources like services and repositories.
NOTE: it assumes that all models returned have a `fixture` method previously defined.
\*Based on `Protocol Mock` template from `Łukasz Kuczborski``

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

internal final class  SomethingRepositorySpyingStub: SomethingRepositoryInterface {

    internal init() {}
    
   // MARK: - init

    internal var initInputResultToBeReturned: Result<SomethingRepositoryInterface, Error> = .success(.fixture())
    internal var initInputReceivedInput: String?
    internal var initInputReceivedInvocations: [String] = []
    internal var initInputClosure: ((String) -> Void)?

    required init(input: String) {
        initInputReceivedInput = input
        initInputReceivedInvocations.append(input)
        initInputClosure?(input)
    }
    
   // MARK: - fetchSomethingWithID

    internal var fetchSomethingWithIDResultToBeReturned: Result<Something, Error> = .success(.fixture())
    internal var fetchSomethingWithIDCallsCount = 0
    internal var fetchSomethingWithIDCalled: Bool {
        fetchSomethingWithIDCallsCount > 0
    }
    internal var fetchSomethingWithIDReceivedId: String?
    internal var fetchSomethingWithIDReceivedInvocations: [String] = []

    internal func fetchSomethingWithID(_ id: String) throws -> Something {
        fetchSomethingWithIDCallsCount += 1
        fetchSomethingWithIDReceivedId = id
        fetchSomethingWithIDReceivedInvocations.append(id)
        return try fetchSomethingWithIDResultToBeReturned.get()
    }
    
   // MARK: - fetchArrayOfSomething

    internal var fetchArrayOfSomethingResultToBeReturned: Result<[Something], Error> = .success(.init())
    internal var fetchArrayOfSomethingCallsCount = 0
    internal var fetchArrayOfSomethingCalled: Bool {
        fetchArrayOfSomethingCallsCount > 0
    }

    internal func fetchArrayOfSomething() throws -> [Something] {
        fetchArrayOfSomethingCallsCount += 1
        return try fetchArrayOfSomethingResultToBeReturned.get()
    }
    
   // MARK: - fetchArrayOfSomeEnum

    internal var fetchArrayOfSomeEnumResultToBeReturned: Result<[SomeEnum], Error> = .success(.init())
    internal var fetchArrayOfSomeEnumCallsCount = 0
    internal var fetchArrayOfSomeEnumCalled: Bool {
        fetchArrayOfSomeEnumCallsCount > 0
    }

    internal func fetchArrayOfSomeEnum() throws -> [SomeEnum] {
        fetchArrayOfSomeEnumCallsCount += 1
        return try fetchArrayOfSomeEnumResultToBeReturned.get()
    }
    
   // MARK: - postSomething

    internal var postSomethingStringParamIntParamSomethingParamResultToBeReturned: Result<Void, Error> = .success(.fixture())
    internal var postSomethingStringParamIntParamSomethingParamCallsCount = 0
    internal var postSomethingStringParamIntParamSomethingParamCalled: Bool {
        postSomethingStringParamIntParamSomethingParamCallsCount > 0
    }
    internal var postSomethingStringParamIntParamSomethingParamReceivedArguments: (stringParam: String, intParam: Int, somethingParam: Something)?
    internal var postSomethingStringParamIntParamSomethingParamReceivedInvocations: [(stringParam: String, intParam: Int, somethingParam: Something)] = []

    internal func postSomething(stringParam: String, intParam: Int, somethingParam: Something) throws {
        postSomethingStringParamIntParamSomethingParamCallsCount += 1
        postSomethingStringParamIntParamSomethingParamReceivedArguments = (stringParam: stringParam, intParam: intParam, somethingParam: somethingParam)
        postSomethingStringParamIntParamSomethingParamReceivedInvocations.append((stringParam: stringParam, intParam: intParam, somethingParam: somethingParam))
    }
}
```
