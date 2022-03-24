//
//  CharactersCoordinator.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation
import UIKit

class CharactersCoordinator: Coordinator {
    let presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    override func start() {
        let charactersViewController = CharactersViewController()
        presenter.pushViewController(charactersViewController, animated: true)
    }
    
    override func finish() {}
}
