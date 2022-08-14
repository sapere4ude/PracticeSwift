//
//  ContentView.swift
//  combineApiTutorial
//
//  Created by Kant on 2022/08/13.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    
    init() {
        self._viewModel = StateObject.init(wrappedValue: ViewModel())
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.viewModel.fetchTodos()
            }, label: {
                Text("Todos 호출").foregroundColor(.white)
            })
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
            
            Button(action: {
                self.viewModel.fetchPosts()
            }, label: {
                Text("Posts 호출").foregroundColor(.white)
            })
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
            
            Button(action: {
                self.viewModel.fetchTodosAndPosts()
            }, label: {
                Text("Todos + Posts 동시 호출").foregroundColor(.white)
            })
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
            
            Button(action: {
                self.viewModel.fetchTodosAndThenPosts()
            }, label: {
                Text("Todos 호출 후 응답으로 Posts 호출").foregroundColor(.white)
            })
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
            
            Button(action: {
                self.viewModel.fetchTodosAndPostsApiCallConditionally()
            }, label: {
                Text("Todos 호출 후 응답결과에 따라 Posts 호출").foregroundColor(.white)
            })
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
            
            Button(action: {
                self.viewModel.fetchTodosAndApiCallConditionally()
            }, label: {
                Text("Todos 호출 후 응답결과에 따라 호출 API 분기처리").foregroundColor(.white)
            })
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
