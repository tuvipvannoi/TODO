import UIKit

final class TaskCell: UITableViewCell {
    static let reuseIdentifier = "TaskCell"

    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let statusImageView = UIImageView()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with task: Task) {
        titleLabel.text = task.title
        detailsLabel.text = task.details.isEmpty ? "No details" : task.details
        dateLabel.text = "Ngày: \(dateFormatter.string(from: task.taskDate))"
        timeLabel.text = "Giờ: \(timeFormatter.string(from: task.startDate)) - \(timeFormatter.string(from: task.endDate))"

        titleLabel.attributedText = nil
        titleLabel.text = task.title

        if task.isCompleted {
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            titleLabel.textColor = .secondaryLabel
            detailsLabel.textColor = .tertiaryLabel
            dateLabel.textColor = .tertiaryLabel
            timeLabel.textColor = .tertiaryLabel
        } else {
            statusImageView.image = UIImage(systemName: "circle")
            titleLabel.textColor = .label
            detailsLabel.textColor = .secondaryLabel
            dateLabel.textColor = .systemOrange
            timeLabel.textColor = .systemBlue
        }
    }

    private func setupUI() {
        selectionStyle = .none

        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.tintColor = .systemBlue
        statusImageView.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 1

        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.font = .systemFont(ofSize: 14)
        detailsLabel.numberOfLines = 2

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 13, weight: .medium)
        dateLabel.numberOfLines = 1

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        timeLabel.numberOfLines = 1

        contentView.addSubview(statusImageView)
        contentView.addSubview(titleLabel)
contentView.addSubview(detailsLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
