//
//  ContentView.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/02.
//

import SwiftUI

struct ContentView: View {
    @StateObject var qrReaderModel: QrReaderModel = QrReaderModel()

    var body: some View {

        VStack {
            VStack {
                Text("スキャンしたデバイス")
                List(qrReaderModel.qrScannedItemList) { item in
                    Text(item.name)
                }
            }.padding()
            
            VStack {
                Button(action: qrReaderModel.turnOn) {
                    Text("QR読み込み")
                    Image(systemName: "camera")
                }
                .sheet(isPresented: $qrReaderModel.show) {
                    QrReaderView(qrReaderModel: qrReaderModel)
                }.padding()
                Button(action: qrReaderModel.clearItems) {
                    Text("リセット")
                    Image(systemName: "trash")
                }.padding()
            }
            .padding()
        }
    }
}
