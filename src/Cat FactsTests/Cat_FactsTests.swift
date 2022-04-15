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
        
        // Test time convertor (in catView wrapper)
        let isoTimeStamp = "2022-04-10T16:16:36.940Z"    // input
        let dateStringFromisoTimeStamp = "2022-04-10" // output
        let factTextInp = "A good cat." // input
        let factTextOut = "a good cat." // output

        let cat = Cat(_id: "id234-234", text: factTextInp, createdAt: isoTimeStamp)
        let catView = CatViewData(cat: cat)
        
        
        // time conversion
        XCTAssertEqual(catView.createdAt, dateStringFromisoTimeStamp)
        // test cat id
        XCTAssertEqual(catView._id, cat._id)
        // fact text
        XCTAssertEqual(catView.text, factTextOut)
        XCTAssertNotEqual(catView.text, cat.text)
        
    }
    
    func testCatsViewModel() {
        // - given - SUT
        let api = ApiClient(configuration: URLSessionConfiguration.default)
        let coreData = CoreDataManager()
        let catsServices = CatsServices(apiClient: api,
                                        coreDataManager: coreData)
        let catsViewModel = CatsVM(service: catsServices)
        // MARK: VM Test
        // - when - start
        catsViewModel.start()
        
        // - then -
        XCTAssertEqual(catsViewModel.catsContainer?.cats.count,
                       catsViewModel.catsContainer?.catsNSManagedObjects.count)
        
        // - when - save
        let cat = Cat(_id: "y5Tgd4Gfsj64",
                      text: "A good cat.",
                      createdAt: "2022-04-10T16:16:36.940Z")
        catsViewModel.saveNewCat(cat: cat)
        // - then - save
        XCTAssertEqual(catsViewModel.catsContainer?.cats.count,
                       catsViewModel.catsContainer?.catsNSManagedObjects.count)
        
        // - when - remove
        var lastRow = giveLastRow(catViewModel: catsViewModel)
        catsViewModel.remove(at: lastRow)
        // - then - remove
        // check if corresponded item of cat array will reflect in NSObject or not!
        XCTAssertEqual(catsViewModel.catsContainer?.cats.count,
                       catsViewModel.catsContainer?.catsNSManagedObjects.count)
        // - then - remove
        XCTAssertEqual(catsViewModel.catsContainer?.cats.count,
                       catsViewModel.numberOfItems())
        
        // MARK:- Table View tests
        // - given - SUT
        lastRow = giveLastRow(catViewModel: catsViewModel)
        let vmCell = catsViewModel.itemFor(row: lastRow)
        let catVC = makeCatsVC(catsViewModel: catsViewModel)
        
        // - when - cell for row at
        var actualCell = catVC.tableViewCats.dataSource?.tableView(catVC.tableViewCats, cellForRowAt: IndexPath(row: lastRow, section: 0))
        // - then - cell for row at
        XCTAssertNotNil(actualCell)
        // check text label
        XCTAssertEqual(actualCell?.textLabel?.text, vmCell.textLabel?.text)
        // check detail label
        XCTAssertEqual(actualCell?.detailTextLabel?.text, vmCell.detailTextLabel?.text)
        
        // - when - save new cat
        catsViewModel.saveNewCat(cat: cat)
        let catView = CatViewData(cat: cat)
        lastRow = giveLastRow(catViewModel: catsViewModel)
        actualCell = catVC.tableViewCats.dataSource?.tableView(catVC.tableViewCats, cellForRowAt: IndexPath(row: lastRow, section: 0))
        
        // - then - save new cat
        // check text label
        XCTAssertEqual(actualCell?.textLabel?.text, catView._id)
        // check detail label
        XCTAssertEqual(actualCell?.detailTextLabel?.text, catView.createdAt)
        
        // delete recently added cat for testing
        // to prevent local storage gets dirty
        catsViewModel.delete()
    }
    
    // MARK: Helpers
    
    func makeCatsVC(catsViewModel: CatsVM) -> CatsVC {
        let catsStoryboard = UIStoryboard(name: "Cats", bundle: nil)
        let catsVC: CatsVC = catsStoryboard.instantiateViewController(withIdentifier: "Cats") as! CatsVC
        catsVC.viewModel = catsViewModel
        // Trigger view load and viewDidLoad()
        _ = catsVC.view
        return catsVC
    }
    
    func giveLastRow(catViewModel: CatsVM) -> Int {
        IndexPath(row: (catViewModel.catsContainer?.cats.count)!-1, section: 0).row
    }
}
