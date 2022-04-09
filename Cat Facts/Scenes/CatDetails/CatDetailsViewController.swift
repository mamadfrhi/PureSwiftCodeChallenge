//
//  CatDetailViewController.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import UIKit

class CatDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var cat: Cat?
    weak var catsVC: UIViewController?
    
    // MARK: - Outlets
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(with: self.cat!) // TODO: Take care of force unwrap
    }

    // MARK: - Setup
    private
    func setupView(with cat: Cat) {
        let catViewType = CatViewData(cat: cat)
        self.factLabel.text = "Fact is " + catViewType.text
        self.createdAtLabel.text = "Created At " + catViewType.createdAt
        self.idLabel.text = "The id is " + catViewType._id
    }

    // MARK: - Actions
    @IBAction func deletePressed(_ sender: Any) {
        deleCatFromLocal()
    }
}

// MARK: - VM
// Codes below should be written in viewModel
extension CatDetailsViewController {
    func deleCatFromLocal() {
        guard let catsVC = self.catsVC as? CatsViewController,
              let id = self.cat?._id else {
            return
        }
        catsVC.viewModel.delete(text: id)
    }
}
// it would be great to change this class to an independet module
// not a child of Cats module

// It needs to have a viewModel and
// a CoreDataClass which can delete the cat
