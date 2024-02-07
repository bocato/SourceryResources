### SwiftDependencies Auto-Registration
Generates code that automates the registration of dependencies using the [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) library. It identifies protocols and structs marked with the `swiftDepAutoregister` annotation, automatically registering them for dependency injection.

#### Definitions and Options
All specification structs or protocols that you intend on registering should contain `// sourcery: swiftDepAutoregister` annotation

### Input ⬅️
```swift
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
```

### Output ➡️
```swift

// MARK: - Dependency Injection 

import Dependencies 
import XCTestDynamicOverlay

internal enum SomeDependencyDependencyKey: TestDependencyKey {
    static var testValue: SomeDependencyProtocol {
        #if DEBUG
        return SomeDependencyFailing()
        #else
        fatalError("`testValue` should not be acessed on non DEBUG builds.")
        #endif
    }
}

internal extension DependencyValues {
    var someDependency: SomeDependencyProtocol {
        get { self[SomeDependencyDependencyKey.self] }
        set { self[SomeDependencyDependencyKey.self] = newValue }
    }
}

// MARK: - Dependency Injection 

import Dependencies 

extension SomeDependencyStruct: TestDependencyKey {
    internal static var testValue: SomeDependencyStruct {
        return .init(
            doSomething: unimplemented()
        )
    }
}

internal extension DependencyValues {
    var : SomeDependencyStruct {
        get { self[SomeDependencyStruct.self] }
        set { self[SomeDependencyStruct.self] = newValue }
    }
}
```
