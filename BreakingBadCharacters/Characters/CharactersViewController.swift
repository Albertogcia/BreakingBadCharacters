//
//  CharactersViewController.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import UIKit

private let CHARACTER_CELL_IDENTIFIER = "CharacterCell"

class CharactersViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var noDataLabel: UILabel!

    let viewModel: CharactersViewModel

    init(viewModel: CharactersViewModel) {
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
        viewModel.fetchAllCharacters()
    }

    private func configureView() {
        title = NSLocalizedString("characters_title", comment: "")
        //
        noDataLabel.text = NSLocalizedString("characters_no_data_message", comment: "")
        //
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        //
        tableView.register(UINib(nibName: CHARACTER_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: CHARACTER_CELL_IDENTIFIER)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.insetsContentViewsToSafeArea = false
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.numberOfRows(in: section) != 0 else { return nil }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .primaryColor
        //
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0)
        //
        if section == 0 {
            label.text = NSLocalizedString("characters_breaking_back_section_header_title", comment: "").uppercased()
        }
        if section == 1 {
            label.text = NSLocalizedString("characters_better_call_saul_section_header_title", comment: "").uppercased()
        }
        //
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel.numberOfRows(in: section) != 0 else { return 0 }
        if section == 1 || section == 0{
            return 50.0
        }
        return 0.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CHARACTER_CELL_IDENTIFIER, for: indexPath) as? CharacterCell, let character = viewModel.character(at: indexPath) {
            cell.character = character
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.viewModel.filterCharactersBy(searchBar.text)
    }
}

extension CharactersViewController: CharactersViewDelegate {
    func charactersFetched() {
        activityIndicator.isHidden = true
        self.noDataLabel.isHidden = viewModel.hasData
        tableView.reloadData()
        
    }

    func errorFetchingCharacters(error: Error) {
        activityIndicator.isHidden = true
        let alert = UIAlertController(title: NSLocalizedString("global_error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: NSLocalizedString("global_ok", comment: ""), style: .default, handler: nil)
        alert.addAction(acceptAction)
        present(alert, animated: true, completion: nil)
    }
}
