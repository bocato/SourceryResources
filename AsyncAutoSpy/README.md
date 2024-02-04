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