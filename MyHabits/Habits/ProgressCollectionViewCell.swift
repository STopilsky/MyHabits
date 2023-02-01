//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Сергей Топильский on 29.01.2023.
//
import UIKit
// Ячейка для отображения дневного прогресса
class ProgressCollectionViewCell: UICollectionViewCell {

    private lazy var userProgress: UIProgressView = {
        let userProgres = UIProgressView(frame: .zero)
        userProgres.progressTintColor = .purpleAccent
        userProgres.translatesAutoresizingMaskIntoConstraints = false
        return userProgres
    }()

    private lazy var leftLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Все получится!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var progressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.contentView.addSubview(userProgress)
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(progressLabel)

        NSLayoutConstraint.activate([
            self.userProgress.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.userProgress.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.userProgress.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.userProgress.heightAnchor.constraint(equalToConstant: 7),

            self.leftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.leftLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),

            self.progressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.progressLabel.bottomAnchor.constraint(equalTo: self.leftLabel.bottomAnchor)
        ])
    }

    func setup (userProgress: Float) {
        self.userProgress.setProgress(userProgress, animated: true)
        self.progressLabel.text = String("\(Int(userProgress*100))%")
    }

    
}
