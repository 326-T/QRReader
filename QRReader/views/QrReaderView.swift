//
//  QrReaderView.swift
//  QRReader
//
//  Created by 竹田恭 on 2023/03/05.
//

import SwiftUI

struct QrReaderView: View {
    var qrReaderModel: QrReaderModel
    
    var body: some View {

        VStack {
            QrReaderViewRepresentable()
                .onFound(lambda: qrReaderModel.appendNotExists)
                .edgesIgnoringSafeArea(.all)
        }
        .onDisappear {
            qrReaderModel.turnOff()
        }
    }
}
