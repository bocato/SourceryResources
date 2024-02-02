### AutoMappableFromDTO

Creates the initializer for class that have a DTO in order to map from DTO to Domain entity.

```swift
// Input ⬅️
import Foundation

enum Status {
    case idle
    case completed
}

struct ListItem {
    let value: String
}

struct MyObject {
    let id: String
    let intValue: Int
    let status: Status
    let stringList: [String]
    let itemsList: [ListItem]
}

// Output ➡️

internal extension ListItem {
    init(
        dto: ListItemDTO
    ) {
        self.value = dto.value
    }
}

internal extension MyObject {
    init(
        dto: MyObjectDTO,
        mapStringListFromDTO: ([String]) -> [String],
        mapItemsListEntityFromDTO: ([ListItemDTO]) -> [ListItem]
    ) {
        self.id = dto.id
        self.intValue = dto.intValue
        self.status = .init(dto: dto.status)
        self.stringList = mapStringListFromDTO(dto.stringList)
        self.itemsList = mapItemsListEntityFromDTO(dto.itemsList)
    }
}

internal extension Status {
    init(dto: StatusDTO)
        switch dto {
        case .idle: self = .idle
        case .completed: self = .completed
        }
    }
}
```