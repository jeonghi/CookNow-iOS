# CookNow iOS

## 📱 프로젝트 개요

CookNow는 사용자의 냉장고 재료를 관리하고 요리 레시피를 추천해주는 iOS 애플리케이션입니다. TCA(The Composable Architecture)를 기반으로 한 모듈화된 아키텍처와 SwiftUI를 활용하여 개발되었습니다.

## 🏗️ 기술 스택

- **아키텍처**: TCA (The Composable Architecture)
- **UI**: SwiftUI
- **의존성 관리**: Tuist
- **네트워킹**: Alamofire + 자체 개발 CNNetwork 모듈
- **인증**: Firebase Authentication
- **이미지 처리**: Kingfisher
- **UI 컴포넌트**:
  - SnapKit
  - Lottie
  - FloatingButton
  - FSCalendar
  - PopupView

## 💻 기술적 하이라이트

### 1. 고도화된 네트워크 레이어 설계

```swift
protocol NetworkType: AnyObject {
  associatedtype Target: TargetType
  func responseData<R: Decodable>(_ target: Target,
                                 _ responseType: R.Type,
                                 logging: Bool) async throws -> R
  // ...
}

public final class Network<Target: TargetType>: NetworkType {
  // 비동기 처리를 위한 async/await 지원
  public func responseData<R>(_ target: Target,
                            _ responseType: R.Type,
                            logging: Bool = true) async throws -> R where R : Decodable {
    // ...
  }
}
```

- **세션 타입별 분리**: API와 인증 서버의 세션을 독립적으로 관리
- **에러 처리 체계화**: 클라이언트, API, 인증 서버 에러를 명확히 구분
- **비동기 처리 최적화**: async/await를 활용한 현대적인 비동기 처리

### 2. 정교한 에러 처리 시스템

```swift
enum CNNetworkError: Error {
  case ClientFailed(reason: ClientFailureReason, errorMessage: String?)
  case ApiFailed(reason: ApiFailureReason, errorInfo: ApiErrorInfo?)
  case AuthFailed(reason: AuthFailureReason, errorInfo: AuthErrorInfo?)
}

extension CNNetworkError {
  var isApiFailed: Bool {
    if case .ApiFailed = self { return true }
    return false
  }

  func isInvalidTokenError() -> Bool {
    if case .ApiFailed = self, getApiError().reason == .Unauthorized {
      return true
    }
    // ...
  }
}
```

- **에러 타입 세분화**: 클라이언트/API/인증 에러를 명확히 구분
- **토큰 관리**: 토큰 만료 시 자동 갱신 로직 구현
- **디버그 로깅**: 상세한 에러 정보와 로깅 지원

### 3. 모듈화된 아키텍처

```swift
public protocol BaseFeatureViewType {
  associatedtype Core: Reducer
  typealias CoreState = Core.State
  typealias CoreAction = Core.Action
  associatedtype ViewState: Equatable
  var store: StoreOf<Core> { get }
  var viewStore: ViewStore<ViewState, CoreAction> { get }
}
```

- **Feature 모듈화**: 각 기능을 독립적인 모듈로 분리
- **상태 관리**: TCA를 활용한 예측 가능한 상태 관리
- **의존성 주입**: 모듈 간 결합도 최소화

### 4. 체계적인 디자인 시스템

```swift
public extension StateButtonStyle {
  static func primary(_ buttonSize: ButtonSize) -> StateButtonStyle {
    StateButtonStyle(buttonSize: buttonSize)
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .white,
          background: .primary500,
          border: .clear
        ),
        for: .normal
      )
      // ... 다른 상태별 스타일 정의
  }
}

public extension ButtonSize {
  static let `default` = ButtonSize(width: .infinity, height: 48)
  static let done = `default`
  static let big = ButtonSize(width: 32, height: 32)
  static let medium = ButtonSize(width: 24, height: 24)
}
```

- **컴포넌트 시스템**: 재사용 가능한 UI 컴포넌트 라이브러리
  - 버튼, 검색바, 시트 등 기본 컴포넌트
  - 상태별 스타일 정의 (normal, pressed, disabled, progress)
  - 크기별 변형 지원
- **색상 시스템**: 체계적인 색상 팔레트
  - Primary (100-900)
  - Success (300-700)
  - Info (300-700)
  - Warning (300-700)
  - Danger (300-700)
- **타이포그래피**: 일관된 폰트 시스템
  - Body, Title 등 용도별 폰트 스타일
  - 자간(-0.6) 등 세부 조정

### 5. 고급 UI 컴포넌트 구현

```swift
extension IngredientInputFormView: View {
  public var body: some View {
    VStack {
      // ...
      .cnSheet(
        item: viewStore.binding(
          get: \.dateSelectionSheetState,
          send: CoreAction.updateDateSelectionSheetState
        )
      ) { _ in
        IfLetStore(
          store.scope(
            state: \.dateSelectionSheetState,
            action: CoreAction.dateSelectionSheetAction
          )
        ) { store in
          DateSelectionSheetView(store)
        }
      }
    }
  }
}
```

- **재사용 가능한 컴포넌트**: 공통 UI 컴포넌트 추상화
- **반응형 UI**: SwiftUI의 선언적 UI 패턴 활용
- **상태 기반 렌더링**: ViewState를 통한 효율적인 UI 업데이트

## 🎯 주요 Pain Points & Technical Challenges

### 1. 네트워크 레이어 설계 및 에러 처리

**문제점**:

- API 서버와 인증 서버의 에러 응답 형식이 상이
- 네트워크 요청 실패 시 적절한 에러 처리 필요
- 토큰 만료 시 자동 갱신 로직 구현 필요

**해결 과정**:

- CNNetwork 모듈 개발
  - API 타입별 에러 처리 로직 분리
  - 세션 타입별 인터셉터 구현
  - 비동기 처리를 위한 async/await 지원
- 에러 핸들링 체계 구축
  - 클라이언트 에러 (ClientFailed)
  - API 서버 에러 (ApiFailed)
  - 인증 서버 에러 (AuthFailed)

### 2. 모듈화된 아키텍처 설계

**문제점**:

- 기능 간 의존성 관리의 복잡성
- 모듈 간 통신의 비효율성
- 빌드 시간 증가

**해결 과정**:

- Tuist를 활용한 모듈 기반 프로젝트 구조 설계
  - Feature: 사용자 인터페이스 및 비즈니스 로직
  - Domain: 핵심 비즈니스 로직
  - Core: 공통 기능 (네트워킹 등)
  - Common: 공통 유틸리티
- TCA를 활용한 상태 관리
  - Reducer를 통한 비즈니스 로직 캡슐화
  - ViewState를 통한 UI 상태 관리

### 3. 디자인 시스템 구축

**문제점**:

- 일관된 UI/UX 제공의 어려움
- 컴포넌트 재사용성 저하
- 디자인 변경 시 유지보수 비용 증가

**해결 과정**:

- DesignSystem 모듈 개발
  - 기본 컴포넌트 라이브러리 구축
  - 색상/타이포그래피 시스템 정의
  - 상태별 스타일 가이드라인 수립
- DesignSystemFoundation 모듈 개발
  - 컴포넌트 기본 구조 정의
  - 확장 가능한 인터페이스 설계
  - 테마 시스템 구현

## 💡 기술적 신념 & 학습 철학

"기술은 문제 해결을 위한 도구일 뿐"이라는 신념을 가지고 있습니다. 새로운 기술이나 프레임워크를 도입할 때는 항상 '왜'라는 질문을 먼저 던지고, 실제 문제 해결에 도움이 되는지 검증합니다. 또한, 코드의 품질과 유지보수성을 최우선으로 생각하며, 지속적인 리팩토링과 개선을 통해 더 나은 코드를 만들어가고 있습니다.

## 🔄 지속적 개선

- 주간 코드 리뷰
- 정기적인 성능 모니터링
- 사용자 피드백 기반 기능 개선
- 기술 부채 관리 및 리팩토링
