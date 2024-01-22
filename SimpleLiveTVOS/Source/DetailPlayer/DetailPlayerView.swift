//
//  DetailPlayerView.swift
//  SimpleLiveTVOS
//
//  Created by pc on 2023/12/12.
//

import SwiftUI
import KSPlayer
import AVKit


struct DetailPlayerView: View {
    
    @EnvironmentObject var roomInfoViewModel: RoomInfoStore
    @EnvironmentObject var favoriteStore: FavoriteStore
    
    public var didExitView: (Bool, String) -> Void = {_, _ in}
    
    
    var body: some View {
        if roomInfoViewModel.currentPlayURL == nil {
            VStack {
                ProgressView()
            }
            .frame(width: 1920, height: 1080)
            .background(.ultraThickMaterial)
        }else {
            KSVideoPlayer(coordinator: roomInfoViewModel.playerCoordinator, url:roomInfoViewModel.currentPlayURL ?? URL(string: "")!, options: roomInfoViewModel.option)
                .background(Color.black)
                .onAppear {
                    roomInfoViewModel.playerCoordinator.playerLayer?.play()
                    roomInfoViewModel.setPlayerDelegate()
                    roomInfoViewModel.getDanmuInfo()
                }
                .overlay {
                    ZStack {
                        PlayerControlView()
                            .environmentObject(roomInfoViewModel)
                            .zIndex(2)
                            .frame(width: 1920, height: 1080)
                            .opacity(roomInfoViewModel.showControlView ? 1 : 0)
                            .safeAreaPadding(.all)
                        VStack {
                            if roomInfoViewModel.danmuSettingModel.danmuAreaIndex >= 3 {
                                Spacer()
                            }
                            DanmuView(coordinator: roomInfoViewModel.danmuCoordinator, height: roomInfoViewModel.danmuSettingModel.getDanmuArea().0)
                                .zIndex(1)
                                .frame(width: 1920, height: roomInfoViewModel.danmuSettingModel.getDanmuArea().0)
                                .opacity(roomInfoViewModel.danmuSettingModel.showDanmu ? 1 : 0)
                                .environmentObject(roomInfoViewModel.danmuSettingModel)
                                .environmentObject(favoriteStore)
                            if roomInfoViewModel.danmuSettingModel.danmuAreaIndex < 3 {
                                Spacer()
                            }
                        }
                    }
            }
            .onDisappear {
                roomInfoViewModel.disConnectSocket()
            }
            .onExitCommand(perform: {
                if roomInfoViewModel.showControlView == true {
                    roomInfoViewModel.showControlView = false
                }else {
                    didExitView(false, "")
                }
            })
        }
    }
}



