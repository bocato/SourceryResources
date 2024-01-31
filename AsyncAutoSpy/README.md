# What are `Spy`s?
**Spy** is a test double that you can use to **inspect the properties of a dependency** used by the **SUT** (*System Under Test*).

**Example:**
```swift
struct User: Equatable {
    let name: String
    let password: String
}
 
protocol UserServiceProtocol {
    func login(_ user: User, then: (Result<Void, Error>) -> Void)
}
protocol SafeStorageProtocol {
    func storeUserData(_ user: User)
}
 
final class LoginViewModel {
    private let userService: UserServiceProtocol
    private let safeStorage: SafeStorageProtocol
     
    init(
        userService: UserServiceProtocol,
        safeStorage: SafeStorageProtocol
    ) {
        self.userService = userService
        self.safeStorage = safeStorage
    }
     
    func performLoginForUser(_ user: User) {
        userService.login(user) { [weak self] result in
            switch result {
            case .success:
                self?.saveLastUser(user)
            case let .failure(error):
                // do something with the error
                debugPrint(error)
            }
        }
    }
     
    private func saveLastUser(_ data: User) {
        safeStorage.storeUserData(data)
    }
}
```
To verify that the last user logged in was properly saved, we can use a **Spy** like shown below:
```swift
final class UserServiceStub: UserServiceProtocol {
    var loginResultToBeReturned: Result<Void, Error> = .success(())
    func login(_ user: User, then: (Result<Void, Error>) -> Void) {
        then(loginResultToBeReturned)
    }
}
 
final class SafeStorageSpy: SafeStorageProtocol {
    private(set) var storeUserDataCalled = false
    private(set) var userPassed: User?
    func storeUserData(_ user: User) {
        storeUserDataCalled = true
        userPassed = user
    }
     
}
 
// Usage
final class LoginViewModelTests: XCTestCase {
    func test_fetchAll_shouldReturnTheCorrectAmountOfPosts() {
        // Given
        let userServiceStub = UserServiceStub()
        userServiceStub.loginResultToBeReturned = .success(())
        let safeStorageSpy = SafeStorageSpy()
        let sut = LoginViewModel(
            userService: userServiceStub,
            safeStorage: safeStorageSpy
        )
        let userMock = User(name: "name", password: "password")
         
        // When
        sut.performLoginForUser(userMock)
         
        // Then
        XCTAssertTrue(safeStorageSpy.storeUserDataCalled)
        XCTAssertEqual(userMock, safeStorageSpy.userPassed)
    }
}
```

# AsyncAutoSpy

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