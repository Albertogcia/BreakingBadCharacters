//
//  CharacterDetailsViewController.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import UIKit

class CharacterDetailsViewController: UIViewController {

    @IBOutlet var nameTitleLabel: UILabel!
    @IBOutlet var nameValueLabel: UILabel!
    //
    @IBOutlet var actorNameTitleLabel: UILabel!
    @IBOutlet var actorNameValueLabel: UILabel!
    //
    @IBOutlet var ageTitleLabel: UILabel!
    @IBOutlet var ageValueLabel: UILabel!
    //
    @IBOutlet var breakingBadSeasonsAppearanceTitleLabel: UILabel!
    @IBOutlet var breakingBadSeasonsAppearanceValueLabel: UILabel!
    //
    @IBOutlet var betterCallSaulAppearanceTitleLabel: UILabel!
    @IBOutlet var betterCallSaulAppearanceValueLabel: UILabel!
    //
    @IBOutlet var quotesTitleLabel: UILabel!
    @IBOutlet var quotesStackView: UIStackView!
    @IBOutlet var quotesActivityIndicator: UIActivityIndicatorView!

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
        configureView()
        viewModel.getCharacterQuotes()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func configureView() {
        nameTitleLabel.text = NSLocalizedString("details_name_title", comment: "")
        nameValueLabel.text = viewModel.nameValue
        //
        actorNameTitleLabel.text = NSLocalizedString("details_actor_name_title", comment: "")
        actorNameValueLabel.text = viewModel.actorNameValue
        //
        ageTitleLabel.text = NSLocalizedString("details_age_title", comment: "")
        ageValueLabel.text = viewModel.ageValue
        //
        breakingBadSeasonsAppearanceTitleLabel.text = NSLocalizedString("details_breaking_bad_appearance_title", comment: "")
        breakingBadSeasonsAppearanceValueLabel.text = viewModel.breakingBadSeasonsAppearanceValue
        //
        betterCallSaulAppearanceTitleLabel.text = NSLocalizedString("details_better_call_saul_appearance_title", comment: "")
        betterCallSaulAppearanceValueLabel.text = viewModel.betterCallSaulSeasonsAppearanceValue
        //
        quotesTitleLabel.text = NSLocalizedString("details_quote_title", comment: "")
    }
}

extension CharacterDetailsViewController: CharacterDetailsViewDelegate {
    func quotesFetched() {
        quotesActivityIndicator.removeFromSuperview()
        if viewModel.isQuotesEmpty() {
            quotesStackView.addArrangedSubview(labelWith(text: NSLocalizedString("details_no_quotes", comment: "")))
        }
        else {
            for i in 0 ..< viewModel.numberOfQuotes() {
                let quote = viewModel.getQuoteFor(index: i)
                quotesStackView.addArrangedSubview(labelWith(text: quote.quote))
            }
        }
    }

    private func labelWith(text: String?) -> UILabel {
        let label = UILabel()
        label.textColor = .primaryColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = text
        label.numberOfLines = 0
        return label
    }
}
