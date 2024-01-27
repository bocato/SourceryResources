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
    func postSomething() async throws
}