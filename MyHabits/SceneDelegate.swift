//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by Сергей Топильский on 16.01.2023.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = createTabBarController()
        self.window?.makeKeyAndVisible()

        func createTabBarController() -> UITabBarController {

            let tabBarController = UITabBarController()
            UITabBar.appearance().backgroundColor = .navBarBackgroundColor
            tabBarController.tabBar.tintColor = .purpleAccent

            let habitsViewController = HabitsViewController()
            let habitsNavBarController = UINavigationController(rootViewController: habitsViewController)
            habitsNavBarController.tabBarItem = UITabBarItem(title: "привычки",
                                                             image: UIImage(named: "HabitsBarButtonItem"),
                                                             tag: 0)

            let infoViewController = InfoViewController()
            let infoNavBarController = UINavigationController(rootViewController: infoViewController)
            infoNavBarController.tabBarItem = UITabBarItem(title: "информация",
                                                           image: UIImage(systemName: "info.circle.fill"),
                                                           tag: 1)
            tabBarController.viewControllers = [habitsNavBarController, infoNavBarController]
            return tabBarController
        }
    }
}
