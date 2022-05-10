//
//  ViewController.swift
//  ExUtility
//
//  Created by eileenyou on 2022/05/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    // 텍스트 입력이 가능한 걸로 바꿔야함
    @IBOutlet weak var moneyFormatLabel: UITextField!
    @IBOutlet weak var dateTodayLabel1: UITextField!
    @IBOutlet weak var dateTodayLabel2: UITextField!
    @IBOutlet weak var dateReviewLabel: UITextField!
    @IBOutlet weak var dateYesterdayLabel: UITextField!
    @IBOutlet weak var fileLengthLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        label.text = KantUtil.shared.integerToMoneyFormat(value: 3000)
//        label.text = KantUtil.shared.dateTodayString()
//        label.text = KantUtil.shared.dateTodayString(fromDate: Date() as NSDate)
//        label.text = KantUtil.shared.dateReviewString(fromDate: Date() as NSDate)
//        label.text = KantUtil.shared.dateYesterdayString()
//        label.text = KantUtil.shared.fileLengthToString(seconds: 8653)
    }
    
    @IBAction func moneyFormatBtnClick(_ sender: Any) {
            moneyFormatLabel.text =
            KantUtil.shared.integerToMoneyFormat(value:Int(moneyFormatLabel.text!)!)
    }
    @IBAction func dateToday1BtnClick(_ sender: Any) {
        dateTodayLabel1.text = KantUtil.shared.dateTodayString()
    }
    @IBAction func dateToday2BtnClick(_ sender: Any) {
        dateTodayLabel2.text = KantUtil.shared.dateTodayString(fromDate: Date() as NSDate)
    }
    @IBAction func dateReviewBtnClick(_ sender: Any) {
        dateReviewLabel.text = KantUtil.shared.dateReviewString(fromDate: Date() as NSDate)
    }
    @IBAction func dateYesterdayBtnClick(_ sender: Any) {
        dateYesterdayLabel.text = KantUtil.shared.dateYesterdayString()
    }
    @IBAction func fileLengthBtnClick(_ sender: Any) {
        fileLengthLabel.text = KantUtil.shared.fileLengthToString(seconds: Double(fileLengthLabel.text!)!)
    }
}

