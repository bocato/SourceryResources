struct Child1: Reducer {
    struct State: Equatable {}
    enum Action: Equatable {}
    func reduce(into state: inout State, action: Action) -> Effect<Action> { .none }
}

struct Child2: Reducer {
    struct State: Equatable {}
    enum Action: Equatable {}
    func reduce(into state: inout State, action: Action) -> Effect<Action> { .none }
}

// sourcery: describesTCAFeature
struct SimpleFeature: Equatable {
    var name: String = ""
    var description: String? = nil
    var numberOfItems: Int = 0
}

// sourcery: describesTCAFeature
// sourcery: containsComposition
struct ComposedFeature: Equatable {
    var name: String = ""
    var description: String? = nil
    var numberOfItems: Int = 0
    var child: Child1.State = .init()
    var optionalChild: Child2.State? = nil
}

// Notes:
// 1. The selected struct is only used as a specification for the TCAFeature 
// and should be deleted after generation
// 2. All specification structs should contain `// sourcery: describesTCAFeature` annotation
// 3. In case the specification contains other TCAFeatures as properties (i.e. Composition),
// it should containt // sourcery: containsComposition` annotation 