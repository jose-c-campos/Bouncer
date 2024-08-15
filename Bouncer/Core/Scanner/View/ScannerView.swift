//
//  ScannerView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/13/24.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String = "Scan a QR Code to get started"
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    self.isPresentingScanner = false
                }
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(scannedCode)
            
            Button("Scan QR Code") {
                self.isPresentingScanner = true
            }
            .sheet(isPresented: $isPresentingScanner) {
                self.scannerSheet
            }
        }
    }
}

#Preview {
    ScannerView()
}
