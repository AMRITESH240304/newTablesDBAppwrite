//
//  AddTodoView.swift
//  ToDo
//
//  Created by Amritesh Kumar on 12/09/25.
//

import SwiftUI

struct AddTodoView: View {
    @EnvironmentObject var viewModel:TodoViewModel
    @Binding var isSelected:Bool
    var body: some View {
        VStack{
            Form{
                TextField("Enter Todo", text: $viewModel.todo)
            }
            
            Button(action:{
                Task{
                    await viewModel.addTodo()
                    isSelected.toggle()
                    viewModel.todo = ""
                }
            }){
                Text("save")
            }
        }
    }
}
