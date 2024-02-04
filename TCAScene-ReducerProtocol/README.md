### TCAFeature - Reducer Protocol
Creates a TCA Scaffold from a specification struct, based on the Reducer protocol versions of the library.
*NOTE*: Based on @tgrapperon’s work from the `Composable Feature` template.

#### Definitions and Options
1. The selected struct is only used as a specification for the TCAFeature and should be deleted after generation
2. All specification structs should contain `// sourcery: describesTCAFeature` annotation
3. In case the specification contains other TCAFeatures as properties (i.e. Composition),
// it should containt // sourcery: containsComposition` annotation 

#### Example 1: Simple Feature (No Composition)
```swift
// Input ⬅️
// sourcery: describesTCAFeature
struct SimpleFeature: Equatable {
    var name: String = ""
    var description: String? = nil
    var numberOfItems: Int = 0
}

// Output ➡️
import ComposableArchitecture
import Dependencies
import SwiftUI

// MARK: - State

extension SimpleFeature {
    internal struct State: Equatable {
        internal var name: String
        internal var description: String?
        internal var numberOfItems: Int

        internal init(
            name: String = "", 
            description: String? = nil, 
            numberOfItems: Int = 0
        ) {
            self.name = name
            self.description = description
            self.numberOfItems = numberOfItems
        }
    }
}

// MARK: - Actions

extension SimpleFeature {
    internal enum Action: Equatable {
        case placeholder
    }
}

// MARK: - Reducer

internal struct SimpleFeature: Reducer {
    // MARK: - Dependencies

    @Dependency(\.fireAndForget) var fireAndForget

    // MARK: - Reducer

    internal func reduce(
        into state: inout State,
        action: Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .placeholder:
            return .none
        }
    }
}

// MARK: - Scene

extension SimpleFeature {
    internal struct Scene: View {
        let store: StoreOf<SimpleFeature>

        internal init(store: StoreOf<SimpleFeature>) {
            self.store = store
        }

        internal var body: some View {
            ZStack {
                Text("SimpleFeatureScene")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: Preview
struct SimpleFeatureScene_Previews: PreviewProvider {
    static var previews: some View {
        SimpleFeature.Scene(
            store: .init(
                initialState: SimpleFeature.State(),
                reducer: { EmptyReducer() }
            )
        )
    }
}
```

#### Example 2: Feature with Composition
```swift
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
// sourcery: containsComposition
struct ComposedFeature: Equatable {
    var name: String = ""
    var description: String? = nil
    var numberOfItems: Int = 0
    var child: Child1.State = .init()
    var optionalChild: Child2.State? = nil
}

// Output ➡️
import ComposableArchitecture
import Dependencies
import SwiftUI

// MARK: - State

extension ComposedFeature {
    internal struct State: Equatable {
        internal var name: String
        internal var description: String?
        internal var numberOfItems: Int
        internal var child: Child1.State
        internal var optionalChild: Child2.State?

        internal init(
            name: String = "", 
            description: String? = nil, 
            numberOfItems: Int = 0, 
            child: Child1.State = .init(), 
            optionalChild: Child2.State? = nil
        ) {
            self.name = name
            self.description = description
            self.numberOfItems = numberOfItems
            self.child = child
            self.optionalChild = optionalChild
        }
    }
}

// MARK: - Actions

extension ComposedFeature {
    internal enum Action: Equatable {
        case placeholder
        case child(Child1.Action)
        case optionalChild(Child2.Action)
    }
}

// MARK: - Reducer

internal struct ComposedFeature: Reducer {
    // MARK: - Dependencies

    @Dependency(\.fireAndForget) var fireAndForget

    // MARK: - Composition

    var body: some ReducerOf<ComposedFeature> {
        Reduce(reduceCore(into:action:))
            .ifLet(
                \.optionalChild,
                 action: /Action.optionalChild,
                 then: { Child2() }
            )
            Scope(
                state: \.child,
                action: /Action.child,
                child: Child1.State() }
            )
    }

    // MARK: - Core Reducer

    internal func reduceCore(
        into state: inout State,
        action: Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .placeholder:
            return .none
        case let .child(childAction):
            return reduceChild1.State(
                into: &state,
                action: childAction
            )
        case let .optionalChild(optionalChildAction):
            return reduceChild2.State?(
                into: &state,
                action: optionalChildAction
            )
        }
    }

    // MARK: - Child Reducer

    internal func reduceChild1(
        into state: inout State,
        action: Child1Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        default: return .none // TODO: remove default` case
        }
    }

    // MARK: - OptionalChild Reducer

    internal func reduceChild2(
        into state: inout State,
        action: Child2Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        default: return .none // TODO: remove default` case
        }
    }

}

// MARK: - Scene

extension ComposedFeature {
    internal struct Scene: View {
        let store: StoreOf<ComposedFeature>

        internal init(store: StoreOf<ComposedFeature>) {
            self.store = store
        }

        internal var body: some View {
            ZStack {
                Text("ComposedFeatureScene")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: Preview
struct ComposedFeatureScene_Previews: PreviewProvider {
    static var previews: some View {
        ComposedFeature.Scene(
            store: .init(
                initialState: ComposedFeature.State(),
                reducer: { EmptyReducer() }
            )
        )
    }
}
```