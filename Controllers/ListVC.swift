import UIKit

final class ListVC: UIViewController {

    private let viewModel = ListVM()

    private let segmentedControl = UISegmentedControl(items: [
        TaskFilter.all.title,
        TaskFilter.active.title,
        TaskFilter.completed.title
    ])

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        setupBindings()
        setupActions()
        setupNavigationBar()
        viewModel.loadTasks()
    }

    private func setupUI() {
        title = "TODO"
        view.backgroundColor = .systemBackground

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No tasks yet"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .systemFont(ofSize: 18, weight: .medium)
        emptyLabel.isHidden = true

        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
    }

    private func setupBindings() {
        viewModel.onTasksChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
    }

    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
}

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskTapped)
        )
    }

    private func updateEmptyState() {
        let isEmpty = viewModel.numberOfTasks() == 0
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    @objc private func filterChanged() {
        let filter = TaskFilter(rawValue: segmentedControl.selectedSegmentIndex) ?? .all
        viewModel.setFilter(filter)
    }

    @objc private func addTaskTapped() {
        let editorVC = EditorVC(mode: .create)

        // EditorVC tự xử lý validate + save rồi
        editorVC.onSave = { [weak self] _, _, _, _, _ in
            self?.viewModel.loadTasks()
        }

        navigationController?.pushViewController(editorVC, animated: true)
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfTasks()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskCell.reuseIdentifier,
            for: indexPath
        ) as! TaskCell

        let task = viewModel.task(at: indexPath.row)
        cell.configure(with: task)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleCompletion(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let task = viewModel.task(at: indexPath.row)

        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            let editorVC = EditorVC(mode: .edit(task))

            // EditorVC tự xử lý validate + update rồi
            editorVC.onSave = { [weak self] _, _, _, _, _ in
                self?.viewModel.loadTasks()
            }

            self?.navigationController?.pushViewController(editorVC, animated: true)
            completion(true)
        }

        editAction.backgroundColor = .systemOrange

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.viewModel.deleteTask(at: indexPath.row)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
