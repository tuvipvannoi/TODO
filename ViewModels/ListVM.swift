import Foundation

enum TaskFilter: Int {
    case all
    case active
    case completed

    var title: String {
        switch self {
        case .all: return "All"
        case .active: return "Active"
        case .completed: return "Completed"
        }
    }
}

enum TaskValidationError: Error {
    case invalidTimeRange
    case timeConflict(conflictTask: Task)
}

final class ListVM {
    private let storage: TaskStorageServicing
    private(set) var tasks: [Task] = []
    private(set) var selectedFilter: TaskFilter = .all

    var onTasksChanged: (() -> Void)?

    init(storage: TaskStorageServicing = TaskStorage()) {
        self.storage = storage
    }

    func loadTasks() {
        tasks = storage.loadTasks()
        sortTasks()
        onTasksChanged?()
    }

    func setFilter(_ filter: TaskFilter) {
        selectedFilter = filter
        onTasksChanged?()
    }

    func filteredTasks() -> [Task] {
        switch selectedFilter {
        case .all:
            return tasks
        case .active:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter { $0.isCompleted }
        }
    }

    func numberOfTasks() -> Int {
        filteredTasks().count
    }

    func task(at index: Int) -> Task {
        filteredTasks()[index]
    }

    func addTask(title: String,
                 details: String,
                 taskDate: Date,
                 startDate: Date,
                 endDate: Date) throws {

        guard endDate > startDate else {
            throw TaskValidationError.invalidTimeRange
        }

        if let conflict = findConflict(
            excluding: nil,
            taskDate: taskDate,
            startDate: startDate,
            endDate: endDate
        ) {
            throw TaskValidationError.timeConflict(conflictTask: conflict)
        }

        let newTask = Task(
            title: title,
            details: details,
            taskDate: taskDate,
            startDate: startDate,
            endDate: endDate
        )

        tasks.append(newTask)
        sortTasks()
        persist()
    }

    func updateTask(id: UUID,
                    title: String,
                    details: String,
                    taskDate: Date,
                    startDate: Date,
                    endDate: Date) throws {

        guard endDate > startDate else {
            throw TaskValidationError.invalidTimeRange
        }

        if let conflict = findConflict(
            excluding: id,
            taskDate: taskDate,
            startDate: startDate,
            endDate: endDate
        ) {
            throw TaskValidationError.timeConflict(conflictTask: conflict)
        }

        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }

        tasks[index].title = title
        tasks[index].details = details
        tasks[index].taskDate = taskDate
        tasks[index].startDate = startDate
        tasks[index].endDate = endDate
sortTasks()
        persist()
    }

    func deleteTask(at filteredIndex: Int) {
        let filtered = filteredTasks()
        guard filtered.indices.contains(filteredIndex) else { return }

        let task = filtered[filteredIndex]
        guard let actualIndex = tasks.firstIndex(of: task) else { return }

        tasks.remove(at: actualIndex)
        persist()
    }

    func toggleCompletion(at filteredIndex: Int) {
        let filtered = filteredTasks()
        guard filtered.indices.contains(filteredIndex) else { return }

        let task = filtered[filteredIndex]
        guard let actualIndex = tasks.firstIndex(of: task) else { return }

        tasks[actualIndex].isCompleted.toggle()
        persist()
    }

    private func persist() {
        storage.saveTasks(tasks)
        onTasksChanged?()
    }

    private func sortTasks() {
        tasks.sort {
            if Calendar.current.isDate($0.taskDate, inSameDayAs: $1.taskDate) {
                return $0.startDate < $1.startDate
            }
            return $0.taskDate < $1.taskDate
        }
    }

    private func findConflict(excluding taskID: UUID?,
                              taskDate: Date,
                              startDate: Date,
                              endDate: Date) -> Task? {

        for task in tasks {
            if let taskID, task.id == taskID {
                continue
            }

            let sameDay = Calendar.current.isDate(task.taskDate, inSameDayAs: taskDate)
            if !sameDay { continue }

            let hasOverlap = startDate < task.endDate && endDate > task.startDate
            if hasOverlap {
                return task
            }
        }

        return nil
    }
}
