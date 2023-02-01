//
//  NavBarView.swift
//  MyHabits
//
//  Created by Сергей Топильский on 28.01.2023.
//
import UIKit
// NavigationBar для модальной презентации ViewControllers
class NavBarView: UIView {

    lazy var leftButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.purpleAccent, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.purpleAccent, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var titlelLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .navBarBackgroundColor
        self.setupNavBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupNavBar() {
        self.addSubview(leftButton)
        self.addSubview(titlelLabel)
        self.addSubview(rightButton)

        NSLayoutConstraint.activate([
            self.leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),

            self.titlelLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titlelLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),

            self.rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.rightButton.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor),
        ])
    }
}
