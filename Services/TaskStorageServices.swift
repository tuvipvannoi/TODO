import Foundation

protocol TaskStorageServicing {
    func loadTasks() -> [Task]
    func saveTasks(_ tasks: [Task])
}
