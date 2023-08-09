//
//  ContentView.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm : ProcessManager = .init()
    @State var processStack : [ProcessModel] = []
        
    @State var currentFailedProcess: ProcessModel = .init()
    @State var currentNewReplayProcess: ProcessModel = .init()
    
    @State var showDropAreaWhenFails = false
    
    @State var idProcessHovered : UUID = .init()
    
    @State var selectedRegion : GameRegion = .EU
    
    @State var isProcessRunning = false
    
    var body: some View {
        VStack(spacing: 20) {
            RegionView
            ProcessStackView
            
            Spacer()
            
            if showDropAreaWhenFails {
                MissingFileArea
            }else {
                ReplayArea
            }
        }
        .padding()
        .onReceive(vm.$processStack) { processStack in
            self.processStack = processStack
        }
        .onReceive(vm.$currentProcessFailed) { failedProcess in
            withAnimation(.easeInOut) {
                showDropAreaWhenFails = failedProcess != nil
            }
            
            if let failedProcess = failedProcess {
                currentFailedProcess = failedProcess
            }
        }
        .onReceive(vm.$isProcessRunning) { isRunning in
            self.isProcessRunning = isRunning
        }
    }
    
    //MARK: Method Area
    func RowView(process: ProcessModel) -> some View {
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
    
    func LoadingStatusView(status: ProcessStatus) -> some View {
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
    
    //MARK: Launch Replay Area
    var LaunchReplayButton: some View {
        Button {
            //play replay
            vm.launchReplay()
        } label: {
            HStack{
                Text("Launch replay")
                Image(systemName: "play.fill")
            }
                .foregroundColor(.white)
                .font(.title2)
                .padding()
                .background(
                    Color.accentColor.opacity(isProcessRunning ? 0.5 : 1)
                )
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .disabled(isProcessRunning)

    }
    
    //MARK: Process Stack View
    var ProcessStackView: some View {
        ForEach(processStack, id: \.id) { process in
            RowView(process: process)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.accentColor, lineWidth: idProcessHovered == process.id ? 3 : 0))
                .transition(.opacity)
                .onHover { isHover in
                    withAnimation(.default) {
                        if isHover {
                            idProcessHovered = process.id
                        }else {
                            idProcessHovered = .init()
                        }
                    }
                }
                .onTapGesture {
                    debugPrint("tapped proccess: \(process.type) - \(process.status)")
                    
                    //select action for current process
                    vm.doAction(for: process)
                }
                .onAppear{
                    withAnimation(.default) {
                        vm.chageRegion(selectedRegion)
//                            vm.doAction(for: process)
                    }
                }
                
        }
    }
    
    //MARK: Region View
    var RegionView: some View {
        VStack {
            Picker("Choose your Region", selection: $selectedRegion) {
                Text("Europe").tag(GameRegion.EU)
                Text("North America").tag(GameRegion.NA)
                Text("Russia").tag(GameRegion.RU)
                Text("Asia").tag(GameRegion.ASIA)
            }.pickerStyle(.menu)
        }
        .onChange(of: selectedRegion) { newRegion in
            withAnimation(.easeInOut){
                vm.chageRegion(newRegion)
            }
        }
    }
    
    //MARK: Replay Area
    var ReplayArea: some View {
        VStack(spacing: 30){
            //new replay
            VStack(spacing: 0){
                Text("Add a new replay file here")
                    .font(.body)
                    .foregroundColor(.accentColor)
                
                DragAndDropView(currentProcess: $currentNewReplayProcess)
                    .onChange(of: currentNewReplayProcess) { newValue in
                        vm.currentProcessFailed?.path = newValue.path
                    }
            }
            
            LaunchReplayButton
        }
    }
    
    //MARK: Missing File Area
    var MissingFileArea: some View {
        VStack (spacing: 0) {
            Text("Try to add the missing file: \(currentFailedProcess.type.getInfo())")
                .font(.body)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            
            DragAndDropView(currentProcess: $currentFailedProcess)
                .onChange(of: currentFailedProcess) { newValue in
                    vm.currentProcessFailed?.path = newValue.path
                    vm.checkFirstProcessToDone()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 500, height: 600, alignment: .center)
            .mainBackgroundSupportable()
    }
}
