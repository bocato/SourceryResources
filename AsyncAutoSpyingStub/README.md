## What are `SpyingStub`s?
SpyingStub is a Test Double that combines the functionalities of a Stub and a Spy.

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
