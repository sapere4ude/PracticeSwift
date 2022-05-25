//
//  ViewController.swift
//  ExMVVMPattern
//
//  Created by eileenyou on 2022/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var datetimeLabel: UILabel!
    
    @IBAction func onYesterday() {
        viewModel.moveDay(day: -1)
    }
    
    @IBAction func onNow() {
        datetimeLabel.text = "Loading.."
        
        viewModel.reload()
    }
    
    @IBAction func onTomorrow() {
        viewModel.moveDay(day: 1)
    }
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.datetimeLabel?.text = self?.viewModel.dateTimeString
            }
        }
        
        viewModel.reload()
    }
    
    
}

