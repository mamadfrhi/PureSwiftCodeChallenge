//
//  CatsViewController.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

class CatsVC: UIViewController {
    
    // MARK: Properties
    var viewModel: CatsVM! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    private let hud = ProgressHUD(title: "Please wait...", theme: .dark)
    // hud means Heads-up Display
    
    // MARK: Outlets
    @IBOutlet weak var tableViewCats: UITableView!
    @IBOutlet weak var labelErrorMessage: UILabel!
    
    // MARK: UIViewController
    override func loadView() {
        super.loadView()
        viewModel.start()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: Setup
    private func setup() {
        setupDelegeates()
        [hud].forEach(view.addSubview(_:)) // add HUD on VC
    }
    private func setupDelegeates() {
        tableViewCats.delegate = self
        tableViewCats.dataSource = self
    }

    // MARK: Actions
    @IBAction func add(_ sender: Any) {
        viewModel.add()
    }
}

// MARK: - TableView Delegate & DataSource
extension CatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.itemFor(row: indexPath.item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row, from: self)
    }
}

// MARK: - ViewModel Delegate
extension CatsVC: CatsViewModelViewDelegate {
    func selectedCatRow() -> Int {
        tableViewCats.indexPathForSelectedRow?.row ?? 0
    }
    
    func updateScreen() {
        tableViewCats.isHidden = false
        tableViewCats.reloadData()
    }
    
    func hud(show: Bool) {
        show ? hud.show() : hud.hide()
    }
    
    func showError(errorMessage: String) {
        // Show error label & hide tableView
        hud(show: false)
        tableViewCats.isHidden = true
        labelErrorMessage.isHidden = false
        labelErrorMessage.text = errorMessage
        
        UIView.animate(withDuration: 3) {
            self.labelErrorMessage.alpha = 0
        } completion: {_ in
            // reset views
            self.labelErrorMessage.isHidden = true
            self.tableViewCats.isHidden = false
            self.labelErrorMessage.alpha = 1
        }
    }
}
