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
    var alertState: CNAlertState?
    public init(state: CoreState) {
      isLoading = state.isLoading
      alertState = state.alertState
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
          makeAppInfoSectionList(section)
        }
      }
      
      // User Auth Section
      Section {
        ForEach(UserAuthSectionType.allCases, id: \.self) { section in
          makeUserAuthSectionList(section)
        }
      }
    }
    .buttonStyle(BorderlessButtonStyle())
    .scrollContentBackground(.hidden)
    .listStyle(.insetGrouped)
    .foregroundStyle(Color.asset(.gray800))
    .font(.asset(.body3))
    .kerning(-0.6)
    .cnAlert(
      viewStore.binding(
        get: \.alertState,
        send: CoreAction.updateAlertState
      )
    )
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
  
  @ViewBuilder
  private func makeAppInfoSectionList(_ type: AppInfoSectionType) -> some View {
    switch type {
    case .versionInfo:
      HStack {
        Text("앱 버전 정보")
        Spacer()
        Text("1.0.0")
      }
      
    case .qna:
      NavigationLink(destination: CNWebView(Constants.csWebUrl)) {
        Text("고객센터")
      }
      
    case .announcement:
      NavigationLink(destination: CNWebView(Constants.tosWebUrl)) {
        Text("약관 및 정책")
      }
    }
  }
  
  @ViewBuilder
  private func makeUserAuthSectionList(_ type: UserAuthSectionType) -> some View {
    switch type {
    case .logout:
      Button(action: {
        let alertState: CNAlertState = .init(
          title: "로그아웃하시겠습니까?",
          description: "로그아웃시 로그인화면으로 돌아갑니다",
          primaryButton: .init(label: "확인", action: {viewStore.send(.logoutButtonTapped)}),
          secondaryButton: .init(label: "취소", action: {viewStore.send(.cancelAlert)})
        )
        viewStore.send(.updateAlertState(alertState))
      }) {
        Text("로그아웃")
      }
      
    case .withdrawl:
      Button(action: {
        let alertState: CNAlertState = .init(
          title: "회원탈퇴하시겠습니까?",
          description: "탈퇴시 모든 정보가 초기화됩니다",
          primaryButton: .init(label: "탈퇴", action: {viewStore.send(.withdrawlButtonTapped)}),
          secondaryButton: .init(label: "취소", action: {viewStore.send(.cancelAlert)})
        )
        viewStore.send(.updateAlertState(alertState))
      }) {
        Text("회원탈퇴")
          .foregroundStyle(Color.asset(.danger500))
      }
    }
  }
}


#if(DEBUG)
@available(iOS 17.0, *)
#Preview {
  SettingView()
}
#endif
