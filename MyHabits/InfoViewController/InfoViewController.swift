//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Сергей Топильский on 16.01.2023.
//
import UIKit
//ViewController предназначен для информации о привычках
class InfoViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setupNavigationBar()
        self.setupTableView()
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Информация"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navBarBackgroundColor
        self.navigationItem.scrollEdgeAppearance = appearance

    }

    private func setupTableView() {
        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        habitStages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        var content = cell.defaultContentConfiguration()
        content.text = habitStages[indexPath.row]


        if indexPath.row == 0 {
            content.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        else {
            content.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }


        cell.contentConfiguration = content

        return cell
    }
}
