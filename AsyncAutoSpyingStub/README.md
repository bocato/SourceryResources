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

    internal var postSomethingStringParamIntParamSomethingParamResultToBeReturned: Result<Void, Error> = .success(())
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
