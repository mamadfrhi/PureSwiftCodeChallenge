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
    let hud = ProgressHUD(title: "Please wait...", theme: .dark)
    // hud means Heads-up Display
    
    // MARK: - Outlets
    @IBOutlet weak var tavleViewCats: UITableView!
    @IBOutlet weak var labelErrorMessage: UILabel!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        setup()
    }

    // MARK: - Setup
    func setup() {
        setupDelegeates()
        [hud].forEach(view.addSubview(_:))
    }
    private
    func setupDelegeates() {
        tavleViewCats.delegate = self
        tavleViewCats.dataSource = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row,
                               from: self)
    }
}

// MARK: - ViewModel Delegate
extension CatsViewController: CatsViewModelViewDelegate {
    func updateScreen() {
        tavleViewCats.isHidden = false
        tavleViewCats.reloadData()
    }
    
    func hud(show: Bool) {
        show ? self.hud.show() : self.hud.hide()
    }
    
    func showError(errorMessage: String) {
        self.hud(show: false)
        tavleViewCats.isHidden = true
        self.labelErrorMessage.text = errorMessage
    }
}
