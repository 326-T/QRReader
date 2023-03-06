//
//  SecondView.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/03.
//

import SwiftUI
import AVFoundation

struct QrReaderViewRepresentable: UIViewControllerRepresentable {
    private var qrReaderDelegate: QrReaderDelegate = QrReaderDelegate()
    
    func onFound(lambda: @escaping (String) -> Void) -> QrReaderViewRepresentable {
        qrReaderDelegate.onFound = lambda
        return self
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<QrReaderViewRepresentable>) -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.layer.addSublayer(qrReaderDelegate.videoPreviewLayer)
        qrReaderDelegate.videoPreviewLayer.frame = viewController.view.layer.frame
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<QrReaderViewRepresentable>) {
        qrReaderDelegate.videoPreviewLayer.frame = uiViewController.view.layer.frame
    }
}


