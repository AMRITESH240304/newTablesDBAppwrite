//
//  ContentView.swift
//  ToDo
//
//  Created by Amritesh Kumar on 12/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var todoViewModel = TodoViewModel()
    var body: some View {
        NavigationStack {
            TodoView()
                .environmentObject(todoViewModel)
        }
    }
}

