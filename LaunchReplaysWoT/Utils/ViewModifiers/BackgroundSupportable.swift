//
//  BackgroundSupportable.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 8/9/23.
//

import Foundation
import SwiftUI

extension View {
    func mainBackgroundSupportable() -> some View {
        if #available(macOS 12.0, *) {
            return self.modifier(mainBackgroundSupportableModifier())
        }else {
            return self.modifier(mainBackgroundFallbackModifier())
        }
    }
}

struct mainBackgroundFallbackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(Color.mainBackground)
    }
}

@available(macOS 12.0, *)
struct mainBackgroundSupportableModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background {
            Color.mainBackground
        }
    }
}

