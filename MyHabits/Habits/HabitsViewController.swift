//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Сергей Топильский on 16.01.2023.
//
import UIKit
//ViewController предназначен для вывода шкалы прогресса и списка привычек
class HabitsViewController: UIViewController {

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    lazy var habitsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: "ProgressCollectionViewCell")
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitsCollectionViewCell")
        collectionView.backgroundColor = .lightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.setupNavigationBar()
        self.setupHabitsCollectionView()
        //обновление данных таблицы в зависимости от изменения данных в массиве
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadHabits),
                                               name: NSNotification.Name("habitsStoreChanged"),
                                               object: nil)
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Сегодня"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTupAddButton))
        addButton.tintColor = .purpleAccent

        self.navigationItem.rightBarButtonItem = addButton

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navBarBackgroundColor
        self.navigationItem.scrollEdgeAppearance = appearance
    }
    
    private func setupHabitsCollectionView() {
        self.view.addSubview(habitsCollectionView)

        NSLayoutConstraint.activate([
            self.habitsCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            self.habitsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.habitsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.habitsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    //модальное представление HabitViewController для добавления новой привычки. На тот случай если ранее выбиралась другая привычка - обнуляем переменную, хранящую ее индекс.
    @objc func didTupAddButton() {
        indexOfSelectedHabit = nil
        let habitCreateViewController = HabitViewController()
        self.present(habitCreateViewController, animated: true)
    }

    @objc private func reloadHabits() {
        habitsCollectionView.reloadData()
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //первая ячейка отражает прогресс данных за сегодня
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCollectionViewCell", for: indexPath) as! ProgressCollectionViewCell
            let userProgress = habitsStore.todayProgress
            cell.setup(userProgress: userProgress)
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            return cell
        //остальные ячейки отражают информацию о ячейках
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitsCollectionViewCell", for: indexPath) as! HabitCollectionViewCell
            let habit = habitsStore.habits[indexPath.row - 1]
            cell.setup(with: habit, cellIndex: indexPath.row - 1)
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        habitsStore.habits.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        default:
            indexOfSelectedHabit = indexPath.row - 1
            let habitDetailsViewController = HabitDetailsViewController()
            self.navigationController?.pushViewController(habitDetailsViewController, animated: true)
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionView.frame.width - 10, height: 60)
        default:
            return CGSize(width: collectionView.frame.width - 10, height: 130)
        }
    }
}
