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