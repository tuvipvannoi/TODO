import Foundation

final class TaskStorage: TaskStorageServicing {
    private let key = "saved_tasks"

    func loadTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Load error: \(error)")
            return []
        }
    }

    func saveTasks(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save error: \(error)")
        }
    }
}
