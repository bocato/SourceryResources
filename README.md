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
```

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

## AsyncAutoStub
Creates a stub from based on a dependency protocol, mostly applicable for datasources like services and repositories.
NOTE: it assumes that all models returned have a `fixture` method previously defined.
```swift
// Input ⬅️
protocol SomeServiceProtocol {
    func getSomething(_ id: String) async throws -> Something
    func postSomething() async throws
}

// Output ➡️
#if DEBUG
public final class SomeServiceStub: SomeServiceInterface {
    public init() {}

    public var getSomethingResultToBeReturned: Result<Something, Error> = .success(.fixture())
    public func getSomething(_ id: String) async throws -> Something {
        try getSomethingResultToBeReturned.get()
    }

    public var postSomethingResultToBeReturned: Result<Void, Error> = .success(())
    public func postSomething() async throws {
        try postSomethingResultToBeReturned.get()
    }
}
#endif
