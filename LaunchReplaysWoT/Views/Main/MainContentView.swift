//
//  ContentView.swift
//  LaunchReplaysWoT
//
//  Created by Wilder López on 7/8/23.
//

import SwiftUI

struct MainContentView: View {
    
    @State var vm : ProcessManager = .init()
    @State private var processStack : [ProcessModel] = []
        
    @State private var currentFailedProcess: ProcessModel = .init()
    @State private var currentNewReplayProcess: ProcessModel = .init()
    
    @State private var showDropAreaWhenFails = false
    
    @State private var idProcessHovered : UUID = .init()
    
    @State private var selectedRegion : GameRegion = .EU
    
    @State private var isProcessRunning = false
    
    var body: some View {
        VStack(spacing: 15) {
            RegionView
            ProcessStackView
            
            if showDropAreaWhenFails {
                MissingFileArea
            } else {
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
    
    //MARK: Launch Replay Area
    var LaunchReplayButton: some View {
        Button {
            //play replay
            vm.launchReplay()
        } label: {
            HStack(spacing: 10){
                Text("Launch replay")
                if isProcessRunning {
                    ProgressView()
                }
                else {
                    Image(systemName: "play.fill")
                }
            }
            .foregroundColor(.white)
            .font(.title2)
            .padding()
            .background(
                Color.accentColor.opacity(isProcessRunning ? 0.7 : 1)
            )
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .disabled(isProcessRunning)

    }
    
    //MARK: Process Stack View
    var ProcessStackView: some View {
        ForEach(processStack, id: \.id) { process in
            RowProcessView(process: process)
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
            VStack(alignment: .leading, spacing: 5){
                Text("Add a new replay file here")
                    .font(.body)
                    .foregroundColor(.accentColor)
                
                DragAndDropView(currentProcess: $currentNewReplayProcess)
                    .onChange(of: currentNewReplayProcess) { newValue in
                        guard let stringUrl = newValue.path else {
                            debugPrint("Url is nil for dropped/searched file.")
                            return
                        }
                        vm.updateProcessWith(newPath: stringUrl)
                    }
            }
            
            //FileInfo
            
            Spacer()
            
            LaunchReplayButton
        }
    }
    
    //MARK: Missing File Area
    var MissingFileArea: some View {
        VStack (spacing: 5) {
            Text("Try to add the missing file: \(currentFailedProcess.type.getInfo())")
                .font(.body)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            
            DragAndDropView(currentProcess: $currentFailedProcess)
                .onChange(of: currentFailedProcess) { newValue in
                    vm.currentProcessFailed?.path = newValue.path
                    vm.checkFirstProcessToDone()
                }
            Spacer()
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
            .frame(width: 360, height: 600, alignment: .center)
            .mainBackgroundSupportable()
    }
}
