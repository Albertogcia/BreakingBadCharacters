//
//  CharacterDetailsViewController.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import UIKit

class CharacterDetailsViewController: UIViewController {

    let viewModel: CharacterDetailsViewModel

    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CharacterDetailsViewController: CharacterDetailsViewDelegate {}
