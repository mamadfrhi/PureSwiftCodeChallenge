//
//  Cat_FactsTests.swift
//  Cat FactsTests
//
//  Created by iMamad on 4/10/22.
//

import XCTest
@testable import Cat_Facts

class Cat_FactsTests: XCTestCase {
    
    func testCatViewData() {
        
        // Test time convertor
        let isoTimeStamp = "2022-04-10T16:16:36.940Z"
        let dateStringFromisoTimeStamp = "2022-04-10"
        
        let cat = Cat(_id: "id234-234",
                      text: "A good cat.",
                      createdAt: isoTimeStamp)
        let catView = CatViewData(cat: cat)
        XCTAssertEqual(catView.createdAt, dateStringFromisoTimeStamp)
        
        // Test cat fact text
        XCTAssertEqual(catView.text, cat.text)
        
        // test cat id
        XCTAssertEqual(catView._id, cat._id)
    }
    
    func testCatsViewModel() {
        // prepare
        let api = ApiClient(configuration: URLSessionConfiguration.default)
        let coreData = CoreDataManager()
        let catsServices = CatsServices(apiClient: api,
                                        coreDataManager: coreData)
        let catsViewModel = CatsViewModel(service: catsServices)
        catsViewModel.start()
        
        // MARK: cats & CoreDataObjects count
        XCTAssertEqual(catsViewModel.cats.count,
                       catsViewModel.catsNSManagedObjects?.count)
        
        // save a cat
        let cat = Cat(_id: "idZZZZZ",
                      text: "A good cat.",
                      createdAt: "2022-04-10T16:16:36.940Z")
        catsViewModel.saveNewCat(cat: cat)
        XCTAssertEqual(catsViewModel.cats.count,
                          catsViewModel.catsNSManagedObjects?.count)
        
        // remove recently added cat
        var lastRow = giveLastRow(catViewModel: catsViewModel)
        catsViewModel.remove(at: lastRow)
        XCTAssertEqual(catsViewModel.cats.count,
                          catsViewModel.catsNSManagedObjects?.count)
        
        // MARK:- Table View
        // rows
        XCTAssertEqual(catsViewModel.cats.count,
                       catsViewModel.numberOfItems())
        // MARK: test VM cell maker with uitableviewCell itself
        lastRow = giveLastRow(catViewModel: catsViewModel)
        let vmCell = catsViewModel.itemFor(row: lastRow)
        let catVC = makeCatsVC(catsViewModel: catsViewModel)
        var actualCell = catVC.tableViewCats.dataSource?.tableView(catVC.tableViewCats, cellForRowAt: IndexPath(row: lastRow, section: 0))
        
        XCTAssertNotNil(actualCell)
        // check text label
        XCTAssertEqual(actualCell?.textLabel?.text, vmCell.textLabel?.text)
        // check detail label
        XCTAssertEqual(actualCell?.detailTextLabel?.text, vmCell.detailTextLabel?.text)
        
        // MARK: check cell texts with new added cat
        catsViewModel.saveNewCat(cat: cat)
        lastRow = giveLastRow(catViewModel: catsViewModel)
        actualCell = catVC.tableViewCats.dataSource?.tableView(catVC.tableViewCats, cellForRowAt: IndexPath(row: lastRow, section: 0))
        let catView = CatViewData(cat: cat)
        // check text label
        XCTAssertEqual(actualCell?.textLabel?.text, catView._id)
        // check detail label
        XCTAssertEqual(actualCell?.detailTextLabel?.text, catView.createdAt)
        
        // delete recently added cat for testing
        // to prevent local storage gets dirty
        catsViewModel.delete()
    }
    
    // MARK: Helpers
    
    func makeCatsVC(catsViewModel: CatsViewModel) -> CatsViewController {
        let catsStoryboard = UIStoryboard(name: "Cats", bundle: nil)
        let catsVC: CatsViewController = catsStoryboard.instantiateViewController(withIdentifier: "Cats") as! CatsViewController
        catsVC.viewModel = catsViewModel
        // Trigger view load and viewDidLoad()
        _ = catsVC.view
        return catsVC
    }
    
    func giveLastRow(catViewModel: CatsViewModel) -> Int {
        IndexPath(row: catViewModel.cats.count-1, section: 0).row
    }
}
