//
//  LoadingStackView.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 8/9/23.
//

import SwiftUI

struct LoadingStatusView: View {
    var status: ProcessStatus
    
    var body: some View {
        VStack {
            switch status {
            case .initial:
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.yellow)
                
            case .loading:
                ProgressView()
                
            case .done:
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                
            case .failed:
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.red)
            }
        }.frame(height: 40)
    }

}

struct LoadingStatusView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoadingStatusView(status: .initial)
            LoadingStatusView(status: .loading)
            LoadingStatusView(status: .done)
            LoadingStatusView(status: .failed)
            
        }
    }
}
