//
//  SettingView.swift
//  Setting
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation

public struct SettingView {
  
  // MARK: State Management
  @State private var showingLogoutAlert = false
  @State private var showingWithdrawlAlert = false
  @State private var sheetType: UserAuthSectionType?
  
  // MARK: Properties
  private let appVersion = "1.0.0"
  
  // MARK: Constructor
  public init() {
    
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

extension SettingView: View {
  public var body: some View {
    List {
      Section {
        ForEach(AppInfoSectionType.allCases, id: \.self) { section in
          switch section {
          case .versionInfo:
            HStack {
              Text("앱 버전 정보")
              Spacer()
              Text(appVersion)
            }
            
            
          case .qna:
            Button(action: {
              // Show Q&A page in Safari
              openInSafari(urlString: "https://notion.so/qna")
            }) {
              Text("문의하기")
            }
          case .announcement:
            Button(action: {
              // Show Announcements page in Safari
              openInSafari(urlString: "https://notion.so/announcements")
            }) {
              Text("공지사항")
            }
          }
        } //: ForEach
      } //: Section
      
      Section {
        ForEach(UserAuthSectionType.allCases, id: \.self) { section in
          switch section {
          case .logout:
            Button(action: {
              // Show logout alert
              showingLogoutAlert = true
            }) {
              Text("로그아웃")
            }
          case .withdrawl:
            Button(action: {
              // Show withdrawl alert
              showingWithdrawlAlert = true
            }) {
              Text("회원탈퇴")
                .foregroundStyle(Color.asset(.danger500))
              
            }
          }
        }
      } //: Section
      
    } //: List
    .scrollContentBackground(.hidden)
    .listStyle(.insetGrouped)
    .foregroundStyle(Color.asset(.gray800))
    .kerning(-0.5)
    .alert(isPresented: $showingLogoutAlert) {
      Alert(
        title: Text("로그아웃"),
        message: Text("정말 로그아웃하시겠습니까?"),
        primaryButton: .destructive(Text("로그아웃"), action: {
          // 로그아웃 처리 로직
          handleLogout()
        }),
        secondaryButton: .cancel(Text("취소"))
      )
    }
    .alert(isPresented: $showingWithdrawlAlert) {
      Alert(
        title: Text("회원탈퇴"),
        message: Text("정말 회원탈퇴를 진행하시겠습니까?"),
        primaryButton: .destructive(Text("탈퇴"), action: {
          // 회원탈퇴 처리 로직
          handleWithdrawl()
        }),
        secondaryButton: .cancel(Text("취소"))
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.asset(.bgMain))
  }
}

extension SettingView {
  
  private func handleLogout() {
    // 로그아웃 처리 로직
    print("User logged out")
  }
  
  private func handleWithdrawl() {
    // 회원탈퇴 처리 로직
    print("User account withdrawn")
  }
  
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
