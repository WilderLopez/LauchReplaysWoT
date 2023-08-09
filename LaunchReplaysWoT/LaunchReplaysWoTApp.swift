//
//  LaunchReplaysWoTApp.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import SwiftUI

@main
struct LaunchReplaysWoTApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .frame(width: 360, height: 600, alignment: .center)
                .mainBackgroundSupportable()
            
        }.windowResizabilityContentSize()
        .commands {
            AboutAppCommand()
        }
    }
}

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
