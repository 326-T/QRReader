//
//  QrCodeScannerView.swift
//  QRReader
//
//  Created by 竹田 恭 on 2023/01/03.
//

import SwiftUI
import AVFoundation

struct QrReaderViewRepresentable: UIViewRepresentable {

    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    typealias UIViewType = CameraPreview

    private let session = AVCaptureSession()
    private let delegate = QrReaderDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()

    func interval(delay: Double) -> QrReaderViewRepresentable {
        delegate.scanInterval = delay
        return self
    }

    func found(r: @escaping (String) -> Void) -> QrReaderViewRepresentable {
        delegate.onResult = r
        return self
    }

    func setupCamera(_ uiView: CameraPreview) {
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if let input = try? AVCaptureDeviceInput(device: backCamera) {
                session.sessionPreset = .photo

                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)

                    metadataOutput.metadataObjectTypes = supportedBarcodeTypes
                    metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                }
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)

                uiView.layer.addSublayer(previewLayer)
                uiView.previewLayer = previewLayer

                session.startRunning()
            }
        }
    }

    private func checkCameraAuthorizationStatus(_ uiView: CameraPreview) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized {
            setupCamera(uiView)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        self.setupCamera(uiView)
                    }
                }
            }
        }
    }
    
    static func dismantleUIView(_ uiView: CameraPreview, coordinator: ()) {
        uiView.session.stopRunning()
    }
    
    func makeUIView(context: UIViewRepresentableContext<QrReaderViewRepresentable>) -> QrReaderViewRepresentable.UIViewType {
        let cameraView = CameraPreview(session: session)

        checkCameraAuthorizationStatus(cameraView)

        return cameraView
    }

    func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<QrReaderViewRepresentable>) {
        uiView.session.startRunning()
    }
}
