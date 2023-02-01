//
//  DetailsTableViewCell.swift
//  MyHabits
//
//  Created by Сергей Топильский on 31.01.2023.
//
import UIKit
// Ячейка для отображения дат с момента установки приложения и отметок об исполнении привычки
class DetailsTableViewCell: UITableViewCell {

    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var trackedMark: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.tintColor = .purpleAccent
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContentView() {
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.trackedMark)

        NSLayoutConstraint.activate([
            self.dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.trackedMark.leadingAnchor, constant: -15),

            self.trackedMark.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.trackedMark.heightAnchor.constraint(equalToConstant: 20),
            self.trackedMark.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }

    func setupContent(index: Int, habit: Habit) {
        //отображаем массив дат в обратной последовательности
        let date = habitsStore.dates[habitsStore.dates.count - (index + 1)]
        //форматируем дату
        let dayformatter = DateFormatter()
        dayformatter.dateStyle = .short
        dayformatter.timeStyle = .none
        dayformatter.locale = Locale(identifier: "ru_RU")
        dayformatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
        //определяем диапазоны дат для отображания в виде "сегодня", "вчера", "позавчера"
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = today - (60*60*24)
        let theDayBeforeYesterday = yesterday - (60*60*24)
        let tomorrow = today + (60*60*24)

        let dateString = dayformatter.string(from: date)

        switch date {
        case today...tomorrow:
            self.dateLabel.text = "Сегодня"
        case yesterday...today:
            self.dateLabel.text = "Вчера"
        case theDayBeforeYesterday...yesterday:
            self.dateLabel.text = "Позавчера"
        default:
            self.dateLabel.text = dateString
        }

        if habitsStore.habit(habit, isTrackedIn: date) {
            trackedMark.image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        } else {
            return
        }
    }
}
