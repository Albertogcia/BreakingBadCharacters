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

    lazy var remoteDataManager: RemoteDataManager = {
        let sessionAPI = SessionAPI()
        return URLSessionImp(session: sessionAPI)
    }()

    lazy var localDataManager: LocalDataManager = {
        CoreDataImp()
    }()

    lazy var dataManager: DataManager = {
        DataManager(remoteDataManager: remoteDataManager, localDataManager: localDataManager)
    }()

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .primaryColor

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .secondaryColor

        let navigationController = UINavigationController()

        let charactersCoordinator = CharactersCoordinator(presenter: navigationController, charactersDataManager: dataManager, characterDetailsDataManager: dataManager)
        addChildCoordinator(charactersCoordinator)
        charactersCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    override func finish() {}
}
