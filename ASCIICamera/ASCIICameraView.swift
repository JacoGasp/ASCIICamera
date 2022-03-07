//
//  ASCIICameraView.swift
//  ASCIICamera
//
//  Created by Jacopo Gasparetto on 07/03/22.
//

import SwiftUI

struct ASCIICameraView: View {
    @ObservedObject var cameraOutput: CameraOutput
    
    var body: some View {
        Text(cameraOutput.text)
            .font(.system(size: 14, design: .monospaced))
            .frame(width: 840, height: 800, alignment: .center)
            ._lineHeightMultiple(0.5)
            
    }
}
