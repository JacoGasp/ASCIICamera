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
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
