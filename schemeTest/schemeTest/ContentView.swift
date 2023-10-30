//
//  ContentView.swift
//  schemeTest
//
//  Created by Kant on 10/30/23.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            
//    #if SCHEMETESTA
//            Text("타겟 A입니다.")
//    #elseif SCHEMETESTB
//            Text("타겟 B입니다.")
//    #else
//            Text("그외 입니다.")
//    #endif
//            
//        }
//        .padding()
//    }
    
struct ContentView: View {
    #if DEBUG
    let isNextButtonDisabled = false
    #elseif QA
    let isNextButtonDisabled = true
    #elseif RELEASE
    let isNextButtonDisabled = true
    #endif
    
    let hostURL = Bundle.main.infoDictionary?["HOST_URL"] as? String
    
    var body: some View {
        VStack {
            Button("패스 인증 완료됨") {
                // to do someting
            }.disabled(isNextButtonDisabled)
            
            Text("\(hostURL ?? "")")
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
