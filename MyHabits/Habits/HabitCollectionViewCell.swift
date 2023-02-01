//
//  HabitsCollectionViewCell.swift
//  MyHabits
//
//  Created by Сергей Топильский on 24.01.2023.
//
import UIKit
// Ячейка с информацией о привычке
class HabitCollectionViewCell: UICollectionViewCell {

    var habit: Habit!

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var counterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var checkBoxButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.contentMode = .scaleToFill
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .white
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(counterLabel)
        self.contentView.addSubview(checkBoxButton)

        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.checkBoxButton.leadingAnchor, constant: -20),

            self.timeLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 4),
            self.timeLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),

            self.counterLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.counterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),

            self.checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.checkBoxButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.checkBoxButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            self.checkBoxButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }

    //функция заполнения ячейки данными из массива добавленных привычек
    func setup (with habit: Habit, cellIndex: Int) {
        self.habit = habit

        self.nameLabel.text = habit.name
        self.nameLabel.textColor = habit.color

        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm a"
        self.timeLabel.text = "Каждый день в \(timeFormat.string(from: habit.date))"

        self.checkBoxButton.tintColor = habit.color
        self.checkBoxButton.setImage(
            UIImage(systemName: (habit.isAlreadyTakenToday ?
                                 "checkmark.circle.fill"
                                 : "circle"),
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)),
            for: .normal)

        self.counterLabel.text = "Счётчик \(habit.trackDates.count)"
    }

    //функция изменяет значение в массиве данных привычки, содержащем информацию о датах ее выполнения и в зависимости от наличия текущей даты в указанном массиве задает изображение чек-боксу
    @objc private func didTapCheckbox() {
        if habit.isAlreadyTakenToday {
            self.habit.trackDates.removeLast()
        } else {
            habitsStore.track(habit)
        }
        self.checkBoxButton.setImage(
            UIImage(systemName: (habit.isAlreadyTakenToday ?
                                 "checkmark.circle.fill"
                                 : "circle"),
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)),
            for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name("habitsStoreChanged"),
                                        object: nil)
    }
}
