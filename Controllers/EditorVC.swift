import UIKit

final class EditorVC: UIViewController {

    enum Mode {
        case create
        case edit(Task)
    }

    var onSave: ((String, String, Date, Date, Date) -> Void)?

    private let mode: Mode

    private let titleField = UITextField()
    private let detailsTextView = UITextView()
    private let detailsContainer = UIView()

    private let dateLabel = UILabel()
    private let datePicker = UIDatePicker()

    private let startLabel = UILabel()
    private let endLabel = UILabel()
    private let startPicker = UIDatePicker()
    private let endPicker = UIDatePicker()

    private let viewModel = ListVM()

    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadTasks()
        setupUI()
        setupConstraints()
        setupData()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = {
            switch mode {
            case .create: return "New Task"
            case .edit: return "Edit Task"
            }
        }()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )

        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.borderStyle = .roundedRect
        titleField.placeholder = "Task title"

        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        detailsContainer.layer.borderWidth = 1
        detailsContainer.layer.borderColor = UIColor.systemGray4.cgColor
        detailsContainer.layer.cornerRadius = 10
        detailsContainer.backgroundColor = .secondarySystemBackground

        detailsTextView.translatesAutoresizingMaskIntoConstraints = false
        detailsTextView.font = .systemFont(ofSize: 16)
        detailsTextView.backgroundColor = .clear

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "Ngày làm"
        dateLabel.font = .systemFont(ofSize: 15, weight: .medium)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Calendar.current.startOfDay(for: Date())
        
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.text = "Bắt đầu"
        startLabel.font = .systemFont(ofSize: 15, weight: .medium)

        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.text = "Kết thúc"
        endLabel.font = .systemFont(ofSize: 15, weight: .medium)

        startPicker.translatesAutoresizingMaskIntoConstraints = false
        startPicker.datePickerMode = .time
        startPicker.preferredDatePickerStyle = .wheels
endPicker.translatesAutoresizingMaskIntoConstraints = false
        endPicker.datePickerMode = .time
        endPicker.preferredDatePickerStyle = .wheels

        view.addSubview(titleField)
        view.addSubview(detailsContainer)
        detailsContainer.addSubview(detailsTextView)
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.addSubview(startLabel)
        view.addSubview(startPicker)
        view.addSubview(endLabel)
        view.addSubview(endPicker)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleField.heightAnchor.constraint(equalToConstant: 44),

            detailsContainer.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
            detailsContainer.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            detailsContainer.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            detailsContainer.heightAnchor.constraint(equalToConstant: 120),

            detailsTextView.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 8),
            detailsTextView.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 8),
            detailsTextView.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -8),
            detailsTextView.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: -8),

            dateLabel.topAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),

            datePicker.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

            startLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            startLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            startLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

            startPicker.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 8),
            startPicker.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            startPicker.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

            endLabel.topAnchor.constraint(equalTo: startPicker.bottomAnchor, constant: 12),
            endLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            endLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

            endPicker.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 8),
endPicker.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            endPicker.trailingAnchor.constraint(equalTo: titleField.trailingAnchor)
        ])
    }

    private func setupData() {
        switch mode {
        case .create:
            let now = Date()
            datePicker.date = now
            startPicker.date = now
            endPicker.date = now.addingTimeInterval(3600)
        case .edit(let task):
            titleField.text = task.title
            detailsTextView.text = task.details
            datePicker.date = task.taskDate
            startPicker.date = task.startDate
            endPicker.date = task.endDate
        }
    }

    @objc private func saveTapped() {
        let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let details = detailsTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else { return }

        let selectedDate = datePicker.date
        let startDate = merge(date: selectedDate, time: startPicker.date)
        let endDate = merge(date: selectedDate, time: endPicker.date)

        let today = Calendar.current.startOfDay(for: Date())
        let chosenDay = Calendar.current.startOfDay(for: selectedDate)

        guard chosenDay >= today else {
            showAlert(
                title: "Ngày không hợp lệ",
                message: "Bạn không được chọn ngày cũ trước ngày hiện tại."
            )
            return
        }

        do {
            switch mode {
            case .create:
                try viewModel.addTask(
                    title: title,
                    details: details,
                    taskDate: selectedDate,
                    startDate: startDate,
                    endDate: endDate
                )
            case .edit(let task):
                try viewModel.updateTask(
                    id: task.id,
                    title: title,
                    details: details,
                    taskDate: selectedDate,
                    startDate: startDate,
                    endDate: endDate
                )
            }

            onSave?(title, details, selectedDate, startDate, endDate)
            navigationController?.popViewController(animated: true)

        } catch TaskValidationError.invalidTimeRange {
            showAlert(
                title: "Thời gian không hợp lệ",
                message: "Giờ kết thúc phải lớn hơn giờ bắt đầu."
            )

        } catch TaskValidationError.timeConflict(let conflictTask) {
            showConflictAlert(conflictTask)

        } catch {
            showAlert(
                title: "Lỗi",
                message: "Không thể lưu công việc."
            )
        }
    }

    private func merge(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute
return calendar.date(from: merged) ?? date
    }

    private func showConflictAlert(_ conflictTask: Task) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let message = """
        Bạn đã có lịch trước đó🙂‍↕️. 

        Công việc bị trùng:
        Tên: \(conflictTask.title)
        Ngày: \(dateFormatter.string(from: conflictTask.taskDate))
        Thời gian: \(timeFormatter.string(from: conflictTask.startDate)) - \(timeFormatter.string(from: conflictTask.endDate))
        """

        showAlert(title: "Trùng lịch", message: message)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

