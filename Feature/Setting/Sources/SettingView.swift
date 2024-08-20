//
//  SettingView.swift
//  Setting
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import ComposableArchitecture
import Common
import DesignSystem
import DesignSystemFoundation

// MARK: Properties
public struct SettingView: BaseFeatureViewType {
  
  public typealias Core = SettingCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    var isLoading: Bool
    var showingLogoutAlert: Bool
    var showingWithdrawlAlert: Bool
    public init(state: CoreState) {
      isLoading = state.isLoading
      showingLogoutAlert = state.showingLogoutAlert
      showingWithdrawlAlert = state.showingWithdrawlAlert
    }
  }
  
  public init(
    _ store: StoreOf<Core> = .init(
      initialState: Core.State()
    ){
      Core()
    }
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
  
  // MARK: Section Types
  private enum AppInfoSectionType: CaseIterable {
    case versionInfo // 버전 정보
    case qna // 문의하기(Q&A)
    case announcement // 공지사항
  }
  
  private enum UserAuthSectionType: CaseIterable {
    case logout // 로그아웃
    case withdrawl // 회원탈퇴
  }
}

// MARK: Layout
extension SettingView: View {
  
  // MARK: Body
  public var body: some View {
    List {
      // App Info Section
      Section {
        ForEach(AppInfoSectionType.allCases, id: \.self) { section in
          switch section {
          case .versionInfo:
            HStack {
              Text("앱 버전 정보")
              Spacer()
              Text("1.0.0")
            }
            
          case .qna:
            Button(action: {
              openInSafari(urlString: "https://notion.so/qna")
            }) {
              Text("문의하기")
            }
            
          case .announcement:
            Button(action: {
              openInSafari(urlString: "https://notion.so/announcements")
            }) {
              Text("공지사항")
            }
          }
        }
      }
      
      // User Auth Section
      Section {
        ForEach(UserAuthSectionType.allCases, id: \.self) { section in
          switch section {
          case .logout:
            Button(action: {
              viewStore.send(.logoutButtonTapped)
            }) {
              Text("로그아웃")
            }
            
          case .withdrawl:
            Button(action: {
              viewStore.send(.withdrawlButtonTapped)
            }) {
              Text("회원탈퇴")
                .foregroundStyle(Color.asset(.danger500))
            }
          }
        }
      }
    }
    .buttonStyle(BorderlessButtonStyle())
    .scrollContentBackground(.hidden)
    .listStyle(.insetGrouped)
    .foregroundStyle(Color.asset(.gray800))
    .kerning(-0.6)
    .alert(
      isPresented: viewStore.binding(
        get: { $0.showingLogoutAlert },
        send: .dismissLogoutAlert
      )
    ) {
      Alert(
        title: Text("로그아웃"),
        message: Text("정말 로그아웃하시겠습니까?"),
        primaryButton: .destructive(Text("로그아웃"), action: {
          viewStore.send(.logoutConfirmed)
        }),
        secondaryButton: .cancel(Text("취소"))
      )
    }
//    .alert(
//      isPresented: viewStore.binding(
//        get: { $0.showingWithdrawlAlert },
//        send: .dismissWithdrawlAlert
//      )
//    ) {
//      Alert(
//        title: Text("회원탈퇴"),
//        message: Text("정말 회원탈퇴를 진행하시겠습니까?"),
//        primaryButton: .destructive(Text("탈퇴"), action: {
//          viewStore.send(.withdrawlConfirmed)
//        }),
//        secondaryButton: .cancel(Text("취소"))
//      )
//    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.asset(.bgMain))
  }
}

// MARK: Componet
extension SettingView {
  // MARK: Functions
  private func openInSafari(urlString: String) {
    if let url = URL(string: urlString) {
      UIApplication.shared.open(url)
    }
  }
}


#if(DEBUG)
@available(iOS 17.0, *)
#Preview {
  SettingView()
}
#endif
