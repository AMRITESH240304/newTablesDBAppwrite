//
//  TodoView.swift
//  ToDo
//
//  Created by Amritesh Kumar on 12/09/25.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State var isSelected = false
    @State private var isPickerPresented = false
    @State private var loading:Bool = false
    @State private var showthing = "No todo to show"
    var body: some View {
        VStack {
            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            else {
                if viewModel.todos.isEmpty {
                    Text(showthing)
                }
                else{
                    ForEach(viewModel.todos) { todo in
                        CardListView(todo: todo)
                    }
                }
            }
        
            Spacer()

            Button("Pick Document") {
                isPickerPresented = true
            }.fileImporter(
                isPresented: $isPickerPresented,
                allowedContentTypes: [.item],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    print("Picked file: \(urls.first?.absoluteString ?? "")")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        .padding()
        .navigationTitle("Todos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isSelected.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isSelected) {
            AddTodoView(isSelected: $isSelected)
        }
        .onAppear(){
            Task{
                loading = true
                await viewModel.getTodo()
                loading = false
            }
        }
    }
}

#Preview {
    TodoView()
}
