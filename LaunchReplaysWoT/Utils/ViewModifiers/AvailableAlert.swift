//
//  AvailableAlert.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 8/8/23.
//

import Foundation
import SwiftUI

@available(macOS 12.0, *)
struct AlertSupportMacOS12Modifier: ViewModifier {
    @Binding var isPresented: Bool
    func body(content: Content) -> some View {
        content
            .alert("You are trying to load the wrong file.", isPresented: $isPresented) {
            Button {
                debugPrint("button ok is pressed")
            } label: {
                Text("Try again!")
            }
        }
    }
}

struct AlertFallbackModifier: ViewModifier {
    @Binding var isPresented: Bool
    func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            Alert(title: Text("You are trying to load the wrong file."))
        }
    }
}

extension View {
    func alertSupportMacOS12(isPresented: Binding<Bool>) -> some View {
        if #available(macOS 12.0, *) {
            return self.modifier(AlertSupportMacOS12Modifier(isPresented: isPresented))
        } else {
            // Fallback on earlier versions
            return self.modifier(AlertFallbackModifier(isPresented: isPresented))
        }
    }
}


