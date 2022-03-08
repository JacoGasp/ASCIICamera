//
//  ASCIICameraApp.swift
//  ASCIICamera
//
//  Created by Jacopo Gasparetto on 06/03/22.
//

import SwiftUI

@main
struct ASCIICameraApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
