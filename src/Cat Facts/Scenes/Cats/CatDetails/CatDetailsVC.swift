//
//  CatDetailViewController.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import UIKit

class CatDetailsVC: UIViewController {
    
    // MARK: Properties
    var cat: Cat?
    weak var parentVC: UIViewController?
    
    // MARK: Outlets
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(with: self.cat!) // TODO: Take care of force unwrap
    }

    // MARK: Setup
    private
    func setupView(with cat: Cat) {
        let catViewType = CatViewData(cat: cat)
        self.factLabel.text = "Fact is " + catViewType.text
        self.createdAtLabel.text = "Created at " + catViewType.createdAt
        self.idLabel.text = "The id is " + catViewType._id
    }

    // MARK: Actions
    @IBAction func deletePressed(_ sender: Any) {
        deleCatFromLocal()
    }
}

// MARK: - VM
// Codes below should be written in viewModel

extension CatDetailsVC {
    func deleCatFromLocal() {
        guard let catsVC = self.parentVC as? CatsVC else {
            return
        }
        catsVC.viewModel.delete()
        self.navigationController?.popViewController(animated: true)
    }
}

// it would be great to change this class to an independet module
// not a child of Cats module, because now it's tightly coupled with its parent

