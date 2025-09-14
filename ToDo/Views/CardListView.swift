//
//  CardListView.swift
//  ToDo
//
//  Created by Amritesh Kumar on 12/09/25.
//

import SwiftUI

struct CardListView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    let todo: TodoDataModel

    var body: some View {
        HStack {
            Button(
                action: {
                    Task {
                        await viewModel.completedTodo(todo.id)
                    }
                }
            ) {
                Image(
                    systemName: todo.isCompleted
                        ? "checkmark.circle.fill" : "circle"
                )
                .foregroundColor(todo.isCompleted ? .green : .gray)
            }

            VStack(alignment: .leading) {
                Text(todo.todo)
                    .font(.headline)
                    .strikethrough(todo.isCompleted, color: .black)

                Text(todo.time, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                Task {
                    await viewModel.deleteTodo(todo.id)
                }
            }) {
                Image(systemName: "trash")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6))
        )
        .shadow(radius: 1)
    }
}
