//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Amritesh Kumar on 12/09/25.
//

import Appwrite
import Foundation

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoDataModel] = []
    @Published var todo: String = ""

    private let client: Client
    private let databases: TablesDB
    private let databaseId: String
    private let tableId: String

    init() {
        self.client = Client()
            .setEndpoint("https://fra.cloud.appwrite.io/v1")
            .setProject("")

        self.databases = TablesDB(client)
        self.databaseId = ""
        self.tableId = "todolist"
    }

    func addTodo() async {
        do {
            let row = try await databases.createRow(
                databaseId: databaseId,
                tableId: tableId,
                rowId: "unique()",
                data: [
                    "todo": todo,
                    "isCompleted": false,
                    "time": Date().iso8601String,
                ]
            )

            let newTodo = TodoDataModel(
                id: row.id,
                todo: row.data["todo"]!.value as! String,
                isCompleted: row.data["isCompleted"]!.value as! Bool,
                time: Date.from(iso8601: row.data["time"]!.value as! String)!
            )

            self.todos.append(newTodo)
        } catch {
            print("❌ Error adding todo:", error.localizedDescription)
        }
    }

    func getTodo() async {
        do {
            let result = try await databases.listRows(
                databaseId: databaseId,
                tableId: tableId
            )

            let loadedtodos: [TodoDataModel] = result.rows.compactMap { row in
                guard let todoText = row.data["todo"]?.value as? String,
                    let isCompleted = row.data["isCompleted"]?.value as? Bool,
                    let timeString = row.data["time"]?.value as? String,
                    let time = Date.from(iso8601: timeString)
                else {
                    return nil
                }

                return TodoDataModel(
                    id: row.id,
                    todo: todoText,
                    isCompleted: isCompleted,
                    time: time
                )
            }
            DispatchQueue.main.async {
                self.todos = loadedtodos
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteTodo(_ id: TodoDataModel.ID) async {
        guard let deleteIndex = todos.firstIndex(where: { $0.id == id }) else {
            return
        }
        todos.remove(at: deleteIndex)
        do{
            let _ = try await databases.deleteRow(
                databaseId: databaseId,
                tableId: tableId,
                rowId: id
            )
        } catch {
            print(error.localizedDescription)
        }
        
    }

    func completedTodo(_ id: TodoDataModel.ID) async {
        guard let completeIndex = todos.firstIndex(where: { $0.id == id })
        else { return }
        todos[completeIndex].isCompleted.toggle()
        do{
            let _ = try await databases.updateRow(
                databaseId: databaseId,
                tableId: tableId,
                rowId: id,
                data: ["isCompleted": todos[completeIndex].isCompleted]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Date {
    /// ISO8601 string with fractional seconds (e.g. "2025-09-14T12:34:56.789Z")
    var iso8601String: String {
        Self.iso8601Formatter.string(from: self)
    }

    /// Parse ISO8601 string (works with/without fractional seconds)
    static func from(iso8601 string: String) -> Date? {
        return iso8601Formatter.date(from: string)
    }

    private static let iso8601Formatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        // include fractional seconds for precision. If you don't want them, remove the fractional option.
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()
}
