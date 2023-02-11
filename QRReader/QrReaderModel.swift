//
//  QrScannedModel.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/03.
//

import Foundation

struct QrScannedItem: Identifiable {
    let id = UUID()
    let devicePk: String
    let selectedItem: SelectedItem
}

struct SelectedItem: Codable{
    let itemId: Int
    let name: String
}

class QrReaderModel: ObservableObject {
    
    @Published var qrScannedItemList: [QrScannedItem] = []
    @Published var selectedItem: SelectedItem = SelectedItem(itemId: 0, name: "")
    @Published var isShowing: Bool = false
    let scanInterval: Double = 1.0
    
    func turnOff() {
        isShowing = false
    }
    
    func turnOn() {
        isShowing = true
    }

    func onFound(_ code: String) {
        appendNotExists(item: QrScannedItem(devicePk: code, selectedItem: selectedItem))
    }
    
    private func appendNotExists(item: QrScannedItem) {
        if !qrScannedItemList.contains(where: { $0.devicePk == item.devicePk }) {
            qrScannedItemList.append(item)
        }
    }
    
    func clearItems() {
        qrScannedItemList.removeAll()
    }
}
