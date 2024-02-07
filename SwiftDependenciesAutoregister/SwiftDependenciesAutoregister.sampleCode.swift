// sourcery: swiftDepAutoregister
protocol SomeDependencyProtocol {
    func doSomething() async throws -> String 
}

// sourcery: swiftDepAutoregister
struct SomeDependencyStruct {
    let doSomething: () async throws -> String 
}

struct DoNotRegister {
    func doSomething() async throws -> String 
}