//
//  CatsViewController.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

class CatsViewController: UIViewController {
    
    var viewModel: CatsViewModel?
    
    init(viewModel: CatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
