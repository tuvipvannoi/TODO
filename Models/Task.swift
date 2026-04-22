import Foundation

struct Task: Codable, Equatable {
    let id: UUID
    var title: String
    var details: String
    var isCompleted: Bool
    var taskDate: Date
    var startDate: Date
    var endDate: Date
    let createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        details: String = "",
        isCompleted: Bool = false,
        taskDate: Date = Date(),
        startDate: Date = Date(),
        endDate: Date = Date().addingTimeInterval(3600),
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
        self.taskDate = taskDate
        self.startDate = startDate
        self.endDate = endDate
        self.createdAt = createdAt
    }
}
