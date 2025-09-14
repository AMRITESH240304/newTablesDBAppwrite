//
//  TodoDataModel.swift
//  ToDo
//
//  Created by Amritesh Kumar on 12/09/25.
//

import Foundation

struct TodoDataModel:Identifiable,Codable{
    var id: String
    var todo:String
    var isCompleted: Bool
    var time:Date
}
