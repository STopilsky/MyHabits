//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Сергей Топильский on 28.01.2023.
//
import UIKit
// ViewController предназначен для отображения списка дат, в которые была выполнена привычка, а также для перехода к редактированию выбранной привычки
class HabitDetailsViewController: UIViewController {
    //Выбранная привычка передается с помощью индекса indexOfSelectedHabit из HabitsViewController
    private var selectedHabit = habitsStore.habits[indexOfSelectedHabit!]

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "DetailsTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green

        self.setupNavigationBar()
        self.setupTableView()
        //В случае изменения привычки или ее удаления, HabitDetailsViewController скрывается
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(habitHasBeenRemoved),
                                               name: NSNotification.Name("habitsStoreChanged"),
                                               object: nil)
    }

    private func setupNavigationBar() {
        self.navigationItem.title = selectedHabit.name
        self.navigationController?.navigationBar.tintColor = .purpleAccent
        self.navigationController?.navigationBar.prefersLargeTitles = false


        let addButton = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(didTapRightButton))

        self.navigationItem.rightBarButtonItem = addButton

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navBarBackgroundColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedHabit.color]

        self.navigationItem.scrollEdgeAppearance = appearance
    }


    func setupTableView() {
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    // скрытие HabitDetailsViewController
    @objc private func habitHasBeenRemoved() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //модальная презентация HabitViewController
    @objc func didTapRightButton() {
        let habitCreateViewController = HabitViewController()
        self.present(habitCreateViewController, animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Активность"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        habitsStore.dates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell
        cell.setupContent(index: indexPath.row, habit: selectedHabit)
        return cell
    }
}
