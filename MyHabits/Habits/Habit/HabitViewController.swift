//
//  ViewController.swift
//  MyHabits
//
//  Created by Сергей Топильский on 22.01.2023.
//
import UIKit
// ViewController предназначен для добавления новой или редактирования имеющейся привычки
class HabitViewController: UIViewController {

    //привычка, соответствующая выбранной ячейке в HabitsViewController
    private lazy var selectedHabit = habitsStore.habits[indexOfSelectedHabit!]

    //описание NavigationBar, зависящее от места открытия ("+" в HabitsViewController - создание новой привычки, "править" в HabitDetailsViewController - исправление имеющейся привычки)
    private lazy var navBarView: NavBarView = {
        let navBarView = NavBarView(frame: .zero)

        navBarView.leftButton.setTitle("Отменить", for: .normal)
        navBarView.leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)

        navBarView.titlelLabel.text = indexOfSelectedHabit != nil ? "Править" : "Создать"

        navBarView.rightButton.setTitle("Сохранить", for: .normal)
        navBarView.rightButton.addTarget(self,
                                         action: #selector(saveButton),
                                         for: .touchUpInside)

        navBarView.translatesAutoresizingMaskIntoConstraints = false
        return navBarView
    }()

    private lazy var nameHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.leftViewMode = .always
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.clearsOnBeginEditing = true
        textField.font = UIFont.systemFont(ofSize: 16)
        //цвет названия соответствует цвету colorPicker, если новая привычка или соответствует цвету выбранной привычки
        textField.textColor = indexOfSelectedHabit != nil ? selectedHabit.color : colorPicker.selectedColor
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var colorHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var colorPicker: UIColorWell = {
        let colorPicker = UIColorWell(frame: .zero)
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = .userOrange
        colorPicker.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        return colorPicker
    }()

    private lazy var timeHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var everyDayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Каждый день в"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "09:00 AM"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .purpleAccent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker(frame: .zero)
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        return timePicker
    }()

    lazy var removeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(removeHabit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setupView()
        //если переход осуществлен из кнопки "править" в HabitDetailsViewController все поля заполняются в соответствии с полями выбранной привычки
        if indexOfSelectedHabit != nil {
            self.editHabitMode()
        }
        self.setupGestures()

    }

    private func editHabitMode() {
        self.nameTextField.text = selectedHabit.name
        self.colorPicker.selectedColor = selectedHabit.color
        self.timePicker.date = selectedHabit.date
        self.timeChanged()
        self.setupRemoveButton()
    }

    //скрытие клавиатуры при нажатии вне ее границ
    private func setupGestures() {
        let tupGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tupGesture)
    }

    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
    }

    private func setupView() {
        self.view.addSubview(navBarView)
        self.view.addSubview(nameHeaderLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(colorHeaderLabel)
        self.view.addSubview(colorPicker)
        self.view.addSubview(timeHeaderLabel)
        self.view.addSubview(everyDayLabel)
        self.view.addSubview(timeLabel)
        self.view.addSubview(timePicker)

        NSLayoutConstraint.activate([
            self.navBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.navBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.navBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.navBarView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07),

            self.nameHeaderLabel.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 21),
            self.nameHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),

            self.nameTextField.topAnchor.constraint(equalTo: nameHeaderLabel.bottomAnchor, constant: 7),
            self.nameTextField.leadingAnchor.constraint(equalTo: nameHeaderLabel.leadingAnchor),
            self.nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),

            self.colorHeaderLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 21),
            self.colorHeaderLabel.leadingAnchor.constraint(equalTo: nameHeaderLabel.leadingAnchor),

            self.colorPicker.topAnchor.constraint(equalTo: colorHeaderLabel.bottomAnchor, constant: 7),
            self.colorPicker.leadingAnchor.constraint(equalTo: nameHeaderLabel.leadingAnchor),
            self.colorPicker.heightAnchor.constraint(equalToConstant: 30),
            self.colorPicker.widthAnchor.constraint(equalToConstant: 30),

            self.timeHeaderLabel.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 21),
            self.timeHeaderLabel.leadingAnchor.constraint(equalTo: nameHeaderLabel.leadingAnchor),

            self.everyDayLabel.topAnchor.constraint(equalTo: timeHeaderLabel.bottomAnchor, constant: 7),
            self.everyDayLabel.leadingAnchor.constraint(equalTo: nameHeaderLabel.leadingAnchor),

            self.timeLabel.topAnchor.constraint(equalTo: everyDayLabel.topAnchor),
            self.timeLabel.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor, constant: 7),

            self.timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            self.timePicker.leadingAnchor.constraint(equalTo: nameHeaderLabel.leadingAnchor)
        ])
    }

    private func setupRemoveButton() {
        self.view.addSubview(removeButton)

        NSLayoutConstraint.activate([
            self.removeButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.removeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    @objc func didTapLeftButton() {
        self.dismiss(animated: true)
    }

    @objc func saveButton() {
        //проверяем наличие введенных данных
        guard let habitName = self.nameTextField.text else {return}
        let habitTime = self.timePicker.date
        guard let habitColor = self.colorPicker.selectedColor else {return}

        let newHabit = Habit(name: habitName,
                             date: habitTime,
                             color: habitColor)

        //обновление данных в привычке, в случае если привычка изменяется
        if indexOfSelectedHabit != nil {
            habitsStore.habits[indexOfSelectedHabit!].name = newHabit.name
            habitsStore.habits[indexOfSelectedHabit!].date = newHabit.date
            habitsStore.habits[indexOfSelectedHabit!].color = newHabit.color
        } else {
        //добавление новой привычки, в случае, если привычка не была выбрана
            habitsStore.habits.append(newHabit)
        }

        //уведомление об изменении данных для обновления данных в таблице на HabitsViewController
        NotificationCenter.default.post(name: NSNotification.Name("habitsStoreChanged"),
                                        object: nil)

        self.dismiss(animated: true)
    }

    //обновление данных в поле timeLabel в зависимости от изменения даты
    @objc private func timeChanged() {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm a"
        timeLabel.text = timeFormat.string(from: timePicker.date)
    }

    @objc private func colorChanged() {
        nameTextField.textColor = colorPicker.selectedColor
    }

    @objc private func removeHabit() {
        let alertController = UIAlertController(title: "Удалить привычку",
                                                message: "Вы хотите удалить привычку \n \(selectedHabit.name)?",
                                                preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Отмeна", style: .cancel) {_ in
            print("Отменено") }

        let removeAction = UIAlertAction(title: "Удалить", style: .destructive) {_ in
            habitsStore.habits.remove(at: indexOfSelectedHabit!)
            alertController.dismiss(animated: true)
            self.dismiss(animated: true)

            NotificationCenter.default.post(name: NSNotification.Name("habitsStoreChanged"),
                                            object: nil)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(removeAction)

        self.present(alertController, animated: true)
    }
}
