//
//  BuildingSelectionModel.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/04.
//

import Foundation

struct SelectionItem: Identifiable {
    let id = UUID()
    let itemId: Int
    let name: String
}

class SelectionModel: ObservableObject {
    
    @Published var selectionItemList: [SelectionItem] = [
        SelectionItem(itemId: 1, name: "選択肢1"),
        SelectionItem(itemId: 2, name: "選択肢2"),
        SelectionItem(itemId: 3, name: "選択肢3")
    ]
}
