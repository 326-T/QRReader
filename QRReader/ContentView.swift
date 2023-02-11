//
//  ContentView.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var qrReaderModel = QrReaderModel()

    var body: some View {

        VStack {
            VStack {
                Text("スキャンしたデバイス")
                List(qrReaderModel.qrScannedItemList) { item in
                    Text(item.devicePk)
                }
            }.padding()
            
            VStack {
                Button(action: qrReaderModel.turnOn) {
                    Text("QR読み込み")
                    Image(systemName: "camera")
                }
                .sheet(isPresented: $qrReaderModel.isShowing) {
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
