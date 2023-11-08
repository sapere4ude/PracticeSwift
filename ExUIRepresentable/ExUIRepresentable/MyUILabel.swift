//
//  UITextFieldWrapper.swift
//  ExUIRepresentable
//
//  Created by Kant on 11/8/23.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI 에서 UIKit 을 사용하는 방법
struct MyUILabel: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
    }
}

// MARK: - Coordinator 사용방법
struct MyTableView: UIViewRepresentable {
    
    @Binding var isShowing: Bool
    
    func makeUIView(context: Context) -> UITableView {
        UITableView()
    }
    
    // Context 를 정의한 문서를 찾아보니 이렇게 정의해주고 있다.
    // A context structure containing information about the current state of the system.
    func updateUIView(_ uiView: UITableView, context: Context) {
        guard self.isShowing else { return }
        uiView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        uiView.delegate = context.coordinator
        uiView.dataSource = context.coordinator
    }
    
    // Coordinator 는 delegate 와 같은 역할을 한다고 생각하면 된다.
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        var dataSource = (0...10).map(String.init(_:))
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            self.dataSource.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = self.dataSource[indexPath.row]
            return cell
        }
    }
}


