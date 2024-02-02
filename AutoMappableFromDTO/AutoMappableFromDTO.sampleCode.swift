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
