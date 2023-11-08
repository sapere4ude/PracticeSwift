//
//  ContentView.swift
//  ExUIRepresentable
//
//  Created by Kant on 11/8/23.
//

import SwiftUI

struct ContentView: View {
    @State var text: String
    var body: some View {
        VStack {
            MyUILabel(text: $text)
        }
        .padding()
    }
}

#Preview {
    ContentView(text: "Hello UIRepresentable!")
}
