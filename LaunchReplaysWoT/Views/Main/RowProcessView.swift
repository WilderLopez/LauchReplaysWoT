//
//  RowProcessView.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 8/9/23.
//

import SwiftUI

struct RowProcessView: View {
    var process: ProcessModel
    var body: some View {
        HStack {
           Text(process.getInfo())
               .multilineTextAlignment(.leading)
               .frame(minWidth: 30, maxWidth: .infinity, alignment: .leading)
           
           Spacer()
           
           LoadingStatusView(status: process.status)
       }
       .padding(5)
       .frame(maxWidth: 350, alignment: .center)
       .background(Color.primary.colorInvert())
       .cornerRadius(10)
       .shadow(color: .gray, radius: 2, x: 0, y: 1)
    }
}

struct RowProcessView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 15) {
            RowProcessView(process: ProcessModel(type: .wine, status: .done, path: ""))
            RowProcessView(process: ProcessModel(type: .executable, status: .done, path: ""))
            RowProcessView(process: ProcessModel(type: .replay, status: .loading, path: ""))
        }.padding()
    }
}
