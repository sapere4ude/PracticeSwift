//
//  Logic.swift
//  ExMVVMPattern
//
//  Created by eileenyou on 2022/05/25.
//

import Foundation

class Service {
    
    let repository = Repository()
    
    var currentModel = Model(currentDateTime: Date())

    func fetchNow(onCompleted: @escaping (Model) -> Void) {
        // Entity -> Model
        repository.fetchNow { [weak self] entity in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM--dd'T'HH:mm'Z'"
            
            guard let now = formatter.date(from: entity.currentDateTime) else { return }
            let model = Model(currentDateTime: now)
            self?.currentModel = model
            
            onCompleted(model)
        }
    }
    
    func moveDay(day: Int) {
        guard let movedDay = Calendar.current.date(byAdding: .day, value: day, to: currentModel.currentDateTime) else {
            return
        }
        currentModel.currentDateTime = movedDay
    }
//
//    func onYesterday(now: Date) -> Date {
//        guard let yesterday = Calendar.current.date(byAdding: .day, value: day, to: now) else {
//            return
//        }
//        return yesterday
//    }
//
//    func onNow() {
//    }
//
//    func onTomorrow(now: Date) -> Date {
//        guard let tomorrow = Calendar.current.date(byAdding: .day, value: day, to: now) else {
//            return now
//        }
//        return tomorrow
//    }
}
