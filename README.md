# SourceryTemplates

Place to hold stencil templates to be used in Sourcery.

## Available Templates

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
_Based on `Protocol Mock` template from `Łukasz Kuczborski`_

### Input ⬅️

```swift
enum MyEnum {
    case firstCase
    case secondCase
}

protocol SomethingRepositoryInterface {
    init(input: String)
    func fetchSomething(_ id: String) async throws -> Something
    func getEnum() async throws -> MyEnum
    func getDate() async throws -> Date
    func getData() async throws -> Data
    func fetchURL() async throws -> URL
    func fetchArray() async throws -> [String]
    func fetchDictionary() async throws -> [String: String]
    func saveSomething(stringParam: String, intParam: Int, somethingParam: Something) async throws
    func saveSomethingNoThrow(_ data: Data) async
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
    
   // MARK: - fetchSomething

    internal var fetchSomethingCallsCount = 0
    internal var fetchSomethingCalled: Bool {
        fetchSomethingCallsCount > 0
    }
    internal var fetchSomethingReceivedId: String?
    internal var fetchSomethingReceivedInvocations: [String] = []

    internal func fetchSomething(_ id: String) async throws -> Something {
        fetchSomethingCallsCount += 1
        fetchSomethingReceivedId = id
        fetchSomethingReceivedInvocations.append(id)
        return .fixture()
    }
    
   // MARK: - getEnum

    internal var getEnumCallsCount = 0
    internal var getEnumCalled: Bool {
        getEnumCallsCount > 0
    }

    internal func getEnum() async throws -> MyEnum {
        getEnumCallsCount += 1
        return .firstCase
    }
    
   // MARK: - getDate

    internal var getDateCallsCount = 0
    internal var getDateCalled: Bool {
        getDateCallsCount > 0
    }

    internal func getDate() async throws -> Date {
        getDateCallsCount += 1
        return .init()
    }
    
   // MARK: - getData

    internal var getDataCallsCount = 0
    internal var getDataCalled: Bool {
        getDataCallsCount > 0
    }

    internal func getData() async throws -> Data {
        getDataCallsCount += 1
        return .init()
    }
    
   // MARK: - fetchURL

    internal var fetchURLCallsCount = 0
    internal var fetchURLCalled: Bool {
        fetchURLCallsCount > 0
    }

    internal func fetchURL() async throws -> URL {
        fetchURLCallsCount += 1
        return .init(string:"www.test.com").unsafelyUnwrapped
    }
    
   // MARK: - fetchArray

    internal var fetchArrayCallsCount = 0
    internal var fetchArrayCalled: Bool {
        fetchArrayCallsCount > 0
    }

    internal func fetchArray() async throws -> [String] {
        fetchArrayCallsCount += 1
        return .init()
    }
    
   // MARK: - fetchDictionary

    internal var fetchDictionaryCallsCount = 0
    internal var fetchDictionaryCalled: Bool {
        fetchDictionaryCallsCount > 0
    }

    internal func fetchDictionary() async throws -> [String: String] {
        fetchDictionaryCallsCount += 1
        return .init()
    }
    
   // MARK: - saveSomething

    internal var saveSomethingStringParamIntParamSomethingParamCallsCount = 0
    internal var saveSomethingStringParamIntParamSomethingParamCalled: Bool {
        saveSomethingStringParamIntParamSomethingParamCallsCount > 0
    }
    internal var saveSomethingStringParamIntParamSomethingParamReceivedArguments: (stringParam: String, intParam: Int, somethingParam: Something)?
    internal var saveSomethingStringParamIntParamSomethingParamReceivedInvocations: [(stringParam: String, intParam: Int, somethingParam: Something)] = []

    internal func saveSomething(stringParam: String, intParam: Int, somethingParam: Something) async throws {
        saveSomethingStringParamIntParamSomethingParamCallsCount += 1
        saveSomethingStringParamIntParamSomethingParamReceivedArguments = (stringParam: stringParam, intParam: intParam, somethingParam: somethingParam)
        saveSomethingStringParamIntParamSomethingParamReceivedInvocations.append((stringParam: stringParam, intParam: intParam, somethingParam: somethingParam))
    }
    
   // MARK: - saveSomethingNoThrow

    internal var saveSomethingNoThrowCallsCount = 0
    internal var saveSomethingNoThrowCalled: Bool {
        saveSomethingNoThrowCallsCount > 0
    }
    internal var saveSomethingNoThrowReceivedData: Data?
    internal var saveSomethingNoThrowReceivedInvocations: [Data] = []

    internal func saveSomethingNoThrow(_ data: Data) async {
        saveSomethingNoThrowCallsCount += 1
        saveSomethingNoThrowReceivedData = data
        saveSomethingNoThrowReceivedInvocations.append(data)
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

internal final class SomethingRepositorySpyingStub: SomethingRepositoryInterface {

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
    
   // MARK: - fetchSomething

    internal var fetchSomethingResultToBeReturned: Result<Something, Error> = .success(.fixture())
    internal var fetchSomethingCallsCount = 0
    internal var fetchSomethingCalled: Bool {
        fetchSomethingCallsCount > 0
    }
    internal var fetchSomethingReceivedId: String?
    internal var fetchSomethingReceivedInvocations: [String] = []

    internal func fetchSomething(_ id: String) async throws -> Something {
        fetchSomethingCallsCount += 1
        fetchSomethingReceivedId = id
        fetchSomethingReceivedInvocations.append(id)
        return try fetchSomethingResultToBeReturned.get()
    }
    
   // MARK: - getEnum

    internal var getEnumResultToBeReturned: Result<MyEnum, Error> = .success(.firstCase)
    internal var getEnumCallsCount = 0
    internal var getEnumCalled: Bool {
        getEnumCallsCount > 0
    }

    internal func getEnum() async throws -> MyEnum {
        getEnumCallsCount += 1
        return try getEnumResultToBeReturned.get()
    }
    
   // MARK: - getDate

    internal var getDateResultToBeReturned: Result<Date, Error> = .success(.init())
    internal var getDateCallsCount = 0
    internal var getDateCalled: Bool {
        getDateCallsCount > 0
    }

    internal func getDate() async throws -> Date {
        getDateCallsCount += 1
        return try getDateResultToBeReturned.get()
    }
    
   // MARK: - getData

    internal var getDataResultToBeReturned: Result<Data, Error> = .success(.init())
    internal var getDataCallsCount = 0
    internal var getDataCalled: Bool {
        getDataCallsCount > 0
    }

    internal func getData() async throws -> Data {
        getDataCallsCount += 1
        return try getDataResultToBeReturned.get()
    }
    
   // MARK: - fetchURL

    internal var fetchURLResultToBeReturned: Result<URL, Error> = .success(.init(string:"www.test.com").unsafelyUnwrapped)
    internal var fetchURLCallsCount = 0
    internal var fetchURLCalled: Bool {
        fetchURLCallsCount > 0
    }

    internal func fetchURL() async throws -> URL {
        fetchURLCallsCount += 1
        return try fetchURLResultToBeReturned.get()
    }
    
   // MARK: - fetchArray

    internal var fetchArrayResultToBeReturned: Result<[String], Error> = .success(.init())
    internal var fetchArrayCallsCount = 0
    internal var fetchArrayCalled: Bool {
        fetchArrayCallsCount > 0
    }

    internal func fetchArray() async throws -> [String] {
        fetchArrayCallsCount += 1
        return try fetchArrayResultToBeReturned.get()
    }
    
   // MARK: - fetchDictionary

    internal var fetchDictionaryResultToBeReturned: Result<[String: String], Error> = .success(.init())
    internal var fetchDictionaryCallsCount = 0
    internal var fetchDictionaryCalled: Bool {
        fetchDictionaryCallsCount > 0
    }

    internal func fetchDictionary() async throws -> [String: String] {
        fetchDictionaryCallsCount += 1
        return try fetchDictionaryResultToBeReturned.get()
    }
    
   // MARK: - saveSomething

    internal var saveSomethingResultToBeReturned: Result<Void, Error> = .success(())
    internal var saveSomethingStringParamIntParamSomethingParamCallsCount = 0
    internal var saveSomethingStringParamIntParamSomethingParamCalled: Bool {
        saveSomethingStringParamIntParamSomethingParamCallsCount > 0
    }
    internal var saveSomethingStringParamIntParamSomethingParamReceivedArguments: (stringParam: String, intParam: Int, somethingParam: Something)?
    internal var saveSomethingStringParamIntParamSomethingParamReceivedInvocations: [(stringParam: String, intParam: Int, somethingParam: Something)] = []

    internal func saveSomething(stringParam: String, intParam: Int, somethingParam: Something) async throws {
        saveSomethingStringParamIntParamSomethingParamCallsCount += 1
        saveSomethingStringParamIntParamSomethingParamReceivedArguments = (stringParam: stringParam, intParam: intParam, somethingParam: somethingParam)
        saveSomethingStringParamIntParamSomethingParamReceivedInvocations.append((stringParam: stringParam, intParam: intParam, somethingParam: somethingParam))
        return try saveSomethingResultToBeReturned.get()
    }
    
   // MARK: - saveSomethingNoThrow

    internal var saveSomethingNoThrowResultToBeReturned: Result<Void, Error> = .success(())
    internal var saveSomethingNoThrowCallsCount = 0
    internal var saveSomethingNoThrowCalled: Bool {
        saveSomethingNoThrowCallsCount > 0
    }
    internal var saveSomethingNoThrowReceivedData: Data?
    internal var saveSomethingNoThrowReceivedInvocations: [Data] = []

    internal func saveSomethingNoThrow(_ data: Data) async {
        saveSomethingNoThrowCallsCount += 1
        saveSomethingNoThrowReceivedData = data
        saveSomethingNoThrowReceivedInvocations.append(data)
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

protocol SomethingRepositoryInterface {
    init(input: String)
    init(something: String) throws
    func fetchSomething(_ id: String) async throws -> Something
    func getEnum() async throws -> MyEnum
    func getDate() async throws -> Date
    func getData() async throws -> Data
    func fetchURL() async throws -> URL
    func fetchArray() async throws -> [String]
    func fetchDictionary() async throws -> [String: String]
    func saveSomething(stringParam: String, intParam: Int, somethingParam: Something) async throws
    func saveSomethingNoThrow(_ data: Data) async
}
```

### Output ➡️

```swift

// MARK: - SomethingRepositoryInterfaceStub

internal final class SomethingRepositoryStub: SomethingRepositoryInterface {
    internal init() {}

    // MARK: - init

    internal var initResultToBeReturned: Result<Void, Error> = .success(())
    internal func init(something: String) {
        try initResultToBeReturned.get()
    }

    // MARK: - fetchSomething

    internal var fetchSomethingResultToBeReturned: Result<Something, Error> = .success(.fixture())
    internal func fetchSomething(_ id: String) async throws -> Something {
        try fetchSomethingResultToBeReturned.get()
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

    // MARK: - fetchURL

    internal var fetchURLResultToBeReturned: Result<URL, Error> = .success(.init(string:"www.test.com").unsafelyUnwrapped)
    internal func fetchURL() async throws -> URL {
        try fetchURLResultToBeReturned.get()
    }

    // MARK: - fetchArray

    internal var fetchArrayResultToBeReturned: Result<[String], Error> = .success(.init())
    internal func fetchArray() async throws -> [String] {
        try fetchArrayResultToBeReturned.get()
    }

    // MARK: - fetchDictionary

    internal var fetchDictionaryResultToBeReturned: Result<[String: String], Error> = .success(.init())
    internal func fetchDictionary() async throws -> [String: String] {
        try fetchDictionaryResultToBeReturned.get()
    }

    // MARK: - saveSomething

    internal var saveSomethingResultToBeReturned: Result<Void, Error> = .success(())
    internal func saveSomething(stringParam: String, intParam: Int, somethingParam: Something) async throws {
        try saveSomethingResultToBeReturned.get()
    }

    // MARK: - saveSomethingNoThrow

    internal func saveSomethingNoThrow(_ data: Data) async {}
}
```
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
extension MyObject {
    init(dto: MyObjectDTO) {
        self.id = dto.id
        self.position = dto.position
        self.status = .init(dto: dto.status)
        self.groups = .init(dto: dto.groups)
    }
}
```
### TCAFeature - Reducer Protocol
Creates a TCA Scaffold from a specification struct, based on the Reducer protocol versions of the library.
*NOTE*: Based on @tgrapperon’s work from the `Composable Feature` template.

#### Definitions and Options
1. The selected struct is only used as a specification for the TCAFeature and should be deleted after generation
2. All specification structs should contain `// sourcery: describesTCAFeature` annotation
3. In case the specification contains other TCAFeatures as properties (i.e. Composition),
// it should containt // sourcery: containsComposition` annotation 

#### Example 1: Simple Feature (No Composition)
```swift
// Input ⬅️
// sourcery: describesTCAFeature
struct SimpleFeature: Equatable {
    var name: String = ""
    var description: String? = nil
    var numberOfItems: Int = 0
}

// Output ➡️
import ComposableArchitecture
import Dependencies
import SwiftUI

// MARK: - State

extension SimpleFeature {
    internal struct State: Equatable {
        internal var name: String
        internal var description: String?
        internal var numberOfItems: Int

        internal init(
            name: String = "", 
            description: String? = nil, 
            numberOfItems: Int = 0
        ) {
            self.name = name
            self.description = description
            self.numberOfItems = numberOfItems
        }
    }
}

// MARK: - Actions

extension SimpleFeature {
    internal enum Action: Equatable {
        case placeholder
    }
}

// MARK: - Reducer

internal struct SimpleFeature: Reducer {
    // MARK: - Dependencies

    @Dependency(\.fireAndForget) var fireAndForget

    // MARK: - Reducer

    internal func reduce(
        into state: inout State,
        action: Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .placeholder:
            return .none
        }
    }
}

// MARK: - Scene

extension SimpleFeature {
    internal struct Scene: View {
        let store: StoreOf<SimpleFeature>

        internal init(store: StoreOf<SimpleFeature>) {
            self.store = store
        }

        internal var body: some View {
            ZStack {
                Text("SimpleFeatureScene")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: Preview
struct SimpleFeatureScene_Previews: PreviewProvider {
    static var previews: some View {
        SimpleFeature.Scene(
            store: .init(
                initialState: SimpleFeature.State(),
                reducer: { EmptyReducer() }
            )
        )
    }
}
```

#### Example 2: Feature with Composition
```swift
struct Child1: Reducer {
    struct State: Equatable {}
    enum Action: Equatable {}
    func reduce(into state: inout State, action: Action) -> Effect<Action> { .none }
}

struct Child2: Reducer {
    struct State: Equatable {}
    enum Action: Equatable {}
    func reduce(into state: inout State, action: Action) -> Effect<Action> { .none }
}

// sourcery: describesTCAFeature
// sourcery: containsComposition
struct ComposedFeature: Equatable {
    var name: String = ""
    var description: String? = nil
    var numberOfItems: Int = 0
    var child: Child1.State = .init()
    var optionalChild: Child2.State? = nil
}

// Output ➡️
import ComposableArchitecture
import Dependencies
import SwiftUI

// MARK: - State

extension ComposedFeature {
    internal struct State: Equatable {
        internal var name: String
        internal var description: String?
        internal var numberOfItems: Int
        internal var child: Child1.State
        internal var optionalChild: Child2.State?

        internal init(
            name: String = "", 
            description: String? = nil, 
            numberOfItems: Int = 0, 
            child: Child1.State = .init(), 
            optionalChild: Child2.State? = nil
        ) {
            self.name = name
            self.description = description
            self.numberOfItems = numberOfItems
            self.child = child
            self.optionalChild = optionalChild
        }
    }
}

// MARK: - Actions

extension ComposedFeature {
    internal enum Action: Equatable {
        case placeholder
        case child(Child1.Action)
        case optionalChild(Child2.Action)
    }
}

// MARK: - Reducer

internal struct ComposedFeature: Reducer {
    // MARK: - Dependencies

    @Dependency(\.fireAndForget) var fireAndForget

    // MARK: - Composition

    var body: some ReducerOf<ComposedFeature> {
        Reduce(reduceCore(into:action:))
            .ifLet(
                \.optionalChild,
                 action: /Action.optionalChild,
                 then: { Child2() }
            )
            Scope(
                state: \.child,
                action: /Action.child,
                child: Child1.State() }
            )
    }

    // MARK: - Core Reducer

    internal func reduceCore(
        into state: inout State,
        action: Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .placeholder:
            return .none
        case let .child(childAction):
            return reduceChild1.State(
                into: &state,
                action: childAction
            )
        case let .optionalChild(optionalChildAction):
            return reduceChild2.State?(
                into: &state,
                action: optionalChildAction
            )
        }
    }

    // MARK: - Child Reducer

    internal func reduceChild1(
        into state: inout State,
        action: Child1Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        default: return .none // TODO: remove default` case
        }
    }

    // MARK: - OptionalChild Reducer

    internal func reduceChild2(
        into state: inout State,
        action: Child2Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        default: return .none // TODO: remove default` case
        }
    }

}

// MARK: - Scene

extension ComposedFeature {
    internal struct Scene: View {
        let store: StoreOf<ComposedFeature>

        internal init(store: StoreOf<ComposedFeature>) {
            self.store = store
        }

        internal var body: some View {
            ZStack {
                Text("ComposedFeatureScene")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: Preview
struct ComposedFeatureScene_Previews: PreviewProvider {
    static var previews: some View {
        ComposedFeature.Scene(
            store: .init(
                initialState: ComposedFeature.State(),
                reducer: { EmptyReducer() }
            )
        )
    }
}
```