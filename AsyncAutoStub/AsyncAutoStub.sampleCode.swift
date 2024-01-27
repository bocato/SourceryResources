protocol SomeServiceProtocol {
    func getSomething(_ id: String) async throws -> Something
    func postSomething() async throws
}

protocol SomeServiceInterface {
    func getSomething(_ id: String) async throws -> Something
    func postSomething() async throws
}
