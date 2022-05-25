//
//  ViewModel.swift
//  ExMVVMPattern
//
//  Created by eileenyou on 2022/05/25.
//

import Foundation

class ViewModel {
    var onUpdated: () -> Void = {}
    
    var dateTimeString: String = "Loading.." // 화면에 보여져야할 값, View를 위한 Model > ViewModel
    {
        didSet {
            onUpdated()
        }
    }
    let service = Service()
    
    private func dateToString(date: Date) {
        let formatter = DateFormatter() 
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        dateTimeString = formatter.string(from: date)
    }
    
    func reload() {
        // Model -> ViewModel
        service.fetchNow { [weak self] model in
            guard let self = self else { return }
            let dateString = self.dateToString(date: model.currentDateTime)
            self.dateTimeString = dateString
        }
    }
    
    func moveDay(day: Int) {
        service.moveDay(day: day)
        dateTimeString = dateToString(date: service.currentModel.currentDateTime)
    }
}
