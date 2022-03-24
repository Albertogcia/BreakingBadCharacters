//
//  AppCoordinator.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let navigationController = UINavigationController()

        let charactersCoordinator = CharactersCoordinator(presenter: navigationController)
        addChildCoordinator(charactersCoordinator)
        charactersCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    override func finish() {}
}
