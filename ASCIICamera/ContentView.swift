//
//  ContentView.swift
//  ASCIICamera
//
//  Created by Jacopo Gasparetto on 06/03/22.
//

import SwiftUI

struct ContentView: View {
    @State private var camera = CameraHandler()
    var body: some View {
        ASCIICameraView(cameraOutput: camera.cameraOutput)
            .onAppear(perform: camera.startSession)
            .onDisappear(perform: camera.stopSession)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
