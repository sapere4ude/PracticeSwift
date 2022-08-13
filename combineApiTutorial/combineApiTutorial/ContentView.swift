//
//  ContentView.swift
//  combineApiTutorial
//
//  Created by Kant on 2022/08/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {}, label: {
                Text("Todos 호출").foregroundColor(.white)
            })
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
