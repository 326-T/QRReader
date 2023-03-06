//
//  QrScannedModel.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/03.
//

import Foundation

struct QrScannedItem: Identifiable {
    let id = UUID()
    let name: String
}

class QrReaderModel: ObservableObject {
    
    @Published var qrScannedItemList: [QrScannedItem] = []
    @Published var show: Bool = false
    
    public func appendNotExists(item: String) {
        if !qrScannedItemList.contains(where: { $0.name == item }) {
            qrScannedItemList.append(QrScannedItem(name: item))
        }
    }
    
    public func clearItems() {
        qrScannedItemList.removeAll()
    }
    
    public func turnOn() {
        show = true
    }
    
    public func turnOff() {
        show = false
    }
}
