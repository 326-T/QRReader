//
//  SecondView.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/03.
//

import SwiftUI

struct QrReaderView: View {
    @StateObject var qrReaderModel : QrReaderModel

    var body: some View {
        ZStack {
            // QRコード読み取りView
            QrReaderViewRepresentable()
                .found(r: qrReaderModel.onFound)
                .interval(delay: qrReaderModel.scanInterval)

            VStack {
                Spacer()
                Button("Close") {
                    qrReaderModel.turnOff()
                }.padding()
            }
        }
    }
}
