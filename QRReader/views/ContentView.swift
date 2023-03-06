//
//  ContentView.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/02.
//

import SwiftUI

struct ContentView: View {
    @StateObject var qrReaderModel: QrReaderModel = QrReaderModel()
    @StateObject var d42RackModel: D42RackModel = D42RackModel()
    @StateObject var d42DeviceModel: D42DeviceModel = D42DeviceModel()
    @State private var rackScanning: Bool = true
    @State private var deviceScanning: Bool = false

    var body: some View {

        VStack {
            VStack {
                Text("ラック情報").padding()
                Text(d42RackModel.d42rack.name).padding()
                Button(action: qrReaderModel.turnOn) {
                    Text("ラックQR読み込み")
                    Image(systemName: "camera")
                }
                .sheet(isPresented: $qrReaderModel.show && $rackScanning, onDismiss: fetchD42Rack) {
                    QrReaderView(qrReaderModel: qrReaderModel)
                }
            }.padding()
            
            VStack {
                Text("デバイス情報")
                List(d42DeviceModel.getNameList()) { item in
                    Text(item.name)
                }
                Button(action: qrReaderModel.turnOn) {
                    Text("デバイスQR読み込み")
                    Image(systemName: "camera")
                }
                .sheet(isPresented: $qrReaderModel.show && $deviceScanning, onDismiss: fetchD42Device) {
                    QrReaderView(qrReaderModel: qrReaderModel)
                }
            }.padding()
            
            VStack {
                Button(action: reset) {
                    Text("リセット")
                    Image(systemName: "trash")
                }
            }.padding()
        }
    }
    
    func fetchD42Rack() {
        if (!qrReaderModel.qrScannedItemList.isEmpty){
            d42RackModel.fetchData(knNumber: qrReaderModel.qrScannedItemList[0].name)
            rackScanning = false
            deviceScanning = true
        }
    }
    
    func fetchD42Device() {
        if (!qrReaderModel.qrScannedItemList.isEmpty){
            var knNumberList: [String] = []
            for qrScannedItem in qrReaderModel.qrScannedItemList {
                knNumberList.append(qrScannedItem.name)
            }
            d42DeviceModel.fetchData(knNumberList: knNumberList)
        }
    }
    
    func reset() {
        qrReaderModel.removeAll()
        d42RackModel.reset()
        d42DeviceModel.removeAll()
        rackScanning = true
        deviceScanning = false
    }
}
