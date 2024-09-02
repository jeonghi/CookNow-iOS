//
//  ClientFailureReason.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation

/// 클라이언트 에러 종류
public enum ClientFailureReason {
  
  /// 기타 에러
  case Unknown
  
  /// 사용자의 취소 액션 등
  case Cancelled
  
  /// API 요청에 사용할 토큰이 없음
  case TokenNotFound
  
  /// 지원되지 않는 기능
  case NotSupported
  
  /// 잘못된 파라미터
  case BadParameter
  
  /// 업로드 사이즈 초과
  case ExceedUploadSizeLimit
  
  /// type casting 실패
  case CastingFailed
  
  /// 정상적으로 실행할 수 없는 상태
  case IllegalState
}
