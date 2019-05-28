//
//  YearsViewController.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 27/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit

class YearsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var years: [Int] = {
        var years: [Int] = []
        for y in Date(timeIntervalSince1970: 0).year...Date().year {
            years.append(y)
        }
        years = years.sorted(by: { $0 > $1 })
        
        return years
    }()
    
    var selectedYear: Int = Date().year
    var completion: (Int) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let index = years.index(of: selectedYear) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDataSource
extension YearsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = "\(years[indexPath.row])"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension YearsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        completion(years[indexPath.row])
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    func presentYearsViewController(selectedYear: Int, sourceView: UIView?, completion: @escaping (Int) -> Void) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "years") as! YearsViewController
        
        viewController.selectedYear = selectedYear
        viewController.completion = completion
        
        if let sourceView = sourceView {
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 220)
            viewController.popoverPresentationController?.permittedArrowDirections = .up
            viewController.popoverPresentationController?.delegate = self
            viewController.popoverPresentationController?.sourceView = sourceView
            viewController.popoverPresentationController?.sourceRect = sourceView.bounds
            viewController.popoverPresentationController?.presentedView?.backgroundColor = UIColor.white
        }
        
        present(viewController, animated: true, completion: nil)
    }
}


// MARK: - UIPopoverPresentationControllerDelegate
extension UIViewController: UIPopoverPresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
