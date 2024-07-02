//
//  Settings+Templates.swift
//  CookNow_iOSManifests
//
//  Created by 쩡화니 on 6/1/24.
//

import Foundation
import ProjectDescription

extension ProjectDescription.Settings {
  
  public static var projectSettings: Self {
    .settings(
      base: SettingsDictionary()
        .localizationPrefersStringCatalogs(true)
        .useCompilerToExtractSwiftStrings(true),
      configurations: BuildEnvironment.allCases.map(\.projectConfiguration)
    )
  }
  
  public static var targetSettings: Self {
    .settings(
      base: [
        "OTHER_LDFLAGS": .string("-ObjC"),
      ],
      configurations: BuildEnvironment.allCases.map(\.targetConfiguration)
    )
  }
}

public extension SettingsDictionary {
  
  /// 로컬라이제이션 String 카탈로그 선호 설정
  func localizationPrefersStringCatalogs(_ enabled: Bool) -> SettingsDictionary {
    merging(["LOCALIZATION_PREFERS_STRING_CATALOGS": SettingValue(booleanLiteral: enabled)])
  }
  
  /// Swift 문자열 추출을 위한 컴파일러 사용 설정
  func useCompilerToExtractSwiftStrings(_ enabled: Bool) -> SettingsDictionary {
      merging(["SWIFT_EMIT_LOC_STRINGS": SettingValue(booleanLiteral: enabled)])
  }
  
  /// 기타 설정을 통합
  func integrateSettings(_ settings: [String: SettingValue]) -> SettingsDictionary {
      merging(settings)
  }
}
