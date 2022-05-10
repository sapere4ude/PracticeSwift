//
//  KantUtil.swift
//  ExUtility
//
//  Created by eileenyou on 2022/05/10.
//

import Foundation
import UIKit

class KantUtil {
    static let shared = KantUtil()
    
    func integerToMoneyFormat(value: Int) -> String? {
        var formatedValue: NSNumber?
        formatedValue = NSNumber(value: value)
        guard let formatedValue = formatedValue else {
            return nil
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        return currencyFormatter.string(from: formatedValue)
    }

    func dateTodayString() -> String? {
        let formatter = DateFormatter();
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }
    
    func dateTodayString(fromDate: NSDate) -> String? {
        let formatter = DateFormatter();
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: fromDate as Date)
    }
    
    func dateReviewString(fromDate: NSDate) -> String? {
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: fromDate as Date)
    }
    
    func dateYesterdayString() -> String? {
        var calendar = Calendar(identifier: .gregorian)
        var addingComponents = DateComponents()
        addingComponents.day = -1
        let yesterdayDate = calendar.date(byAdding: addingComponents, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        if let yesterdayDate = yesterdayDate {
            return formatter.string(from: yesterdayDate)
        }
        return nil
    }
    
    func dateString(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date as Date)
    }
    
    func dateStringWithMilliseconds(milliseconds: NSNumber) -> String? {
        let interval = TimeInterval(milliseconds.doubleValue / 1000)
        let date = Date(timeIntervalSince1970: interval)

        return dateString(date: date as Date)
    }
    
    func fileLengthToString(seconds: Double) -> String {
        let nHour = Int(seconds / 3600)
        let interval = seconds - Double(nHour * 3600)
        let nMin = Int(interval / 60)
        let nSec = Int(interval.truncatingRemainder(dividingBy: 60.0))
        
        var fileLength = ""
        
        if(nHour > 0){
            fileLength = "\(nHour)시간"
        }
        if(nMin > 0){
            fileLength += "\(nMin)분"
        }
        if(nSec > 0){
            fileLength += "\(nSec)초"
        }
        
        return fileLength
    }
}
