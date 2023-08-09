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
            ContentView()
                .frame(width: 500, height: 600, alignment: .center)
                .mainBackgroundSupportable()
            
        }.windowResizabilityContentSize()
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Launch Replays - WoT") {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options:
                        [NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                            string: "Made with ❤️ by wle_iGhost",
                            attributes: [
                                NSAttributedString.Key.font: NSFont.boldSystemFont(
                        ofSize: NSFont.smallSystemFontSize)
                            ]
                        ),
                         NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© 2023 Always Blue It Solutions"
                        ]
                    )
                }
            }
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
