//
//  ViewController.swift
//  ExTableViewStyleTest
//
//  Created by Kant on 2022/03/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let genre: [String] = ["발라드", "댄스", "힙합", "락", "재즈"]
    private let singer: [String] = ["성시경", "윤하", "에픽하이", "블랙핑크", "박보람"]
    
    private let sections: [String] = ["장르", "가수"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var tableView: UITableView = {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight), style: .insetGrouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return genre.count
        } else if section == 1 {
            return singer.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(genre[indexPath.row])"
            cell.backgroundColor = UIColor.systemPink
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(singer[indexPath.row])"
        } else {
            return UITableViewCell()
        }
        return cell
    }
}

