//
//  ViewController.swift
//  ExEvenetPopup
//
//  Created by Kant on 2022/07/13.
//

import UIKit

class ViewController: UIViewController {

    let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
    }

    @objc func btnAction() {
        
    }
}

func popUpControl() {
    //[저장 날짜 로드]
    let prefs = UserDefaults.standard
    // getting an NSString
    let saveDate = prefs.string(forKey: "popUpDate")
    print("PopUpControl(myString): \(saveDate ?? "")")


    //[오늘 날짜 구하기]
    var dateValue = ""
    let formatter = DateFormatter()
    let now = Date()
    //[formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    formatter.dateFormat = "yyyy-mm-dd"
    dateValue = formatter.string(from: now)
    UserDefaults.standard.string(forKey: dateValue)
    print("PopUpControl(dateValue): \(dateValue)")


    //[날짜 비교]
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"yyyy-mm-dd"];
    let updateDate = formatter.date(from: dateValue)
    if let updateDate = updateDate {
        print("PopUpControl(updateDate): \(updateDate)")
    }
    let date = formattedDateCompare(toNow: updateDate)
    if let date = date {
        print("PopUpControl(date): \(date)")
    }


    //[기존 날짜 저장해서 내일 날짜랑 비교]
    if saveDate == nil {
        eventPopup()
    } else if Int(date ?? 0) < 0 {
        eventPopup()
    } else if IntegerLiteralConvertible(date ?? 0) == 0 {
        dismiss(animated: false)
    }
}

func formattedDateCompare(toNow date: Date?) -> Int {
    let yMd = DateFormatter()
    yMd.dateFormat = "yyyy-MM-dd"

    var midnight: Date? = nil
    if let date = date {
        midnight = yMd.date(from: yMd.string(from: date))
    }
    let dayDiff = Int(midnight?.timeIntervalSinceNow ?? 0) / (60 * 60 * 24)

    //음수 양수 변환
    return -dayDiff //+ 1;
}
