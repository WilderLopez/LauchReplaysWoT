//
//  AboutAppCommand.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 8/9/23.
//

import Foundation
import SwiftUI

struct AboutAppCommand: Commands {
    var body: some Commands {
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
