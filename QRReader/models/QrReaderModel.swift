//
//  QrScannedModel.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/03.
//

import Foundation

class QrReaderModel: ObservableObject {
    
    @Published var qrScannedItemList: [ListItem] = []
    @Published var show: Bool = false
    
    public func appendNotExists(item: String) {
        if !qrScannedItemList.contains(where: { $0.name == item }) {
            qrScannedItemList.append(ListItem(name: item))
        }
    }
    
    public func removeAll() {
        qrScannedItemList.removeAll()
    }
    
    public func turnOn() {
        show = true
    }
    
    public func turnOff() {
        show = false
    }
}
