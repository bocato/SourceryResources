# What are `Fixtures`?

**Fixtures** are basically custom initializers to simpify the construction of objects needed for our tests.

It's main objective is to **provide consistency to the test scenario/setup**.
> Test fixture refers to the fixed state used as a baseline for running tests in software testing. The purpose of a test fixture is to ensure that there is a well known and fixed environment in which tests are run so that results are repeatable. Some people call this the test context.

**Example:**
```swift
struct User {
    let id: Int
    let name: String
    let lastName: String
    let nickname: String?
}
 
protocol ProfileViewModelProtocol {
    func getUserName() -> String
}
 
final class ProfileViewModel: ProfileViewModelProtocol {
    private let user: User
    init(user: User) {
        self.user = user
    }  
     
    func getUserName() -> String {
        guard let nickname = user.nickname else { return user.name }
        return nickname
    }
}
 
final class ProfileViewModelTests: XCTestCase {
    // Without fixtures
    func test_getUserName_whenNickNameIsNotNil_itShouldReturnNickname_1() {
        // Given
        let userMock: User = .init(
            id: 1,
            name: "my_name",
            lastName: "last_name",
            nickname: "Zé"
        )
        let sut = ProfileViewModel(user: userMock)
        // When
        let returnedValue = sut.getUserName()
        // Then
        XCTAssertEqual(returnedValue, userMock.nickname)
    }
}
```
Let’s assume that the **User** struct has even more properties, but your tests are interested only on the **nickname** property.
You could use a <u>fixture</u> to make it clear what is being tested, while also simplifying your test…

The fixture for **User**, could be this:
```swift
extension User {
    static func fixture(
        id: Int = 1,
        name: String = "my_name",
        lastName: String = "last_name",
        nickname: String? = nil
    ) -> User {
        return .init(
            id: id,
            name: name,
            lastName: lastName,
            nickname: nickname
        )
    }
}
```
After creating the fixture, our test can be refactored to:
```swift
final class ProfileViewModelTests: XCTestCase {
    func test_getUserName_whenNickNameIsNotNil_itShouldReturnNickname_1() {
        // Given
        let userMock: User = .fixture(nickname: "Zé")
        let sut = ProfileViewModel(user: userMock)
        // When
        let returnedValue = sut.getUserName()
        // Then
        XCTAssertEqual(returnedValue, userMock.nickname)
    }
}
```

# `AutoFixture`

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