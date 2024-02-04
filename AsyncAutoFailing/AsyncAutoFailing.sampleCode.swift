struct Something {
    let someString: String
}
extension Something {
    static func fixture(
        someString: String = "someString"
    ) -> Self {
        return .init(
            someString: someString
        )
    }
}

enum MyEnum {
    case firstCase
    case secondCase
}

protocol SomeServiceProtocol {
    init(something: String)
    func getSomething(_ id: String) async throws -> Something
    func getEnum() async throws -> MyEnum
    func getDate() async throws -> Date
    func getData() async throws -> Data
    func getURL() async throws -> URL
    func getArray() async throws -> [String]
    func getDictionary() async throws -> [String: String]
    func postSomething() async throws
    func postNoThrow() async
}