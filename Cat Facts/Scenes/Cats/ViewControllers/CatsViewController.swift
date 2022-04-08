//
//  CatsViewController.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

class CatsViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: CatsViewModel! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var catsTableView: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        setup()
    }

    // MARK: - Setup
    func setup() {
        self.title = viewModel.titleText
        catsTableView.delegate = self
        catsTableView.dataSource = self
    }

    // MARK: - Actions
    @IBAction func add(_ sender: Any) {
        viewModel.add()
    }
}

// MARK: - TableView Delegate & DataSource
extension CatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.itemFor(row: indexPath.item)
    }
}

// MARK: - ViewModel Delegate
extension CatsViewController: CatsViewModelViewDelegate {
    func updateScreen() {
        catsTableView.reloadData()
    }
}
