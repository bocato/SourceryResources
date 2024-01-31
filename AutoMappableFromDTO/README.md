### AutoMappableFromDTO

Creates the initializer for class that have a DTO in order to map from DTO to Domain entity.

```swift
// Input ⬅️
struct MyObjectDTO: Decodable {
    let id: String
    let position: Int
    let status: RoundStatusDTO
    let groups: [RoundGroupDTO]
}

struct MyObject: Equatable, Identifiable, AutoMappableFromDTO {
    let id: String
    let position: Int
    let status: RoundStatus
    let groups: [RoundGroup]
}

// Output ➡️
internal extension MyObject {
    init(
        dto: MyObjectDTO
        mapGroupsEntityFromDTO: ([RoundGroupDTO]) -> [RoundGroup]
    ) {
        self.id = dto.id
        self.position = dto.position
        self.status = .init(dto: dto.status)
        self.groups = mapGroupsEntityFromDTO(dto.groups)
    }
}
```