//
//  RefrigeratorHomeCore.swift
//  Refrigerator
//
//  Created by 쩡화니 on 8/18/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Domain

public struct RefrigeratorHomeCore: Reducer {
  
  // MARK: Dependencies
  @Dependency(\.ingredientService) private var ingredientService
  
  // MARK: Constructor
  public init() {
    
  }
  
  public typealias StorageType = Domain.StorageType
  
  // MARK: State
  public struct State {
    
    var isLoading: Bool = false
    var categories: [IngredientCategory] = []
    var ingredientStorages: [IngredientStorage] = []
    var selectedStorageType: StorageType = .refrigerator
    var isOpenFloatingButton: Bool = false
    var scrollToIngredientID: IngredientStorage.ID? = nil // 스크롤할 ID를 저장

    
    // 선택된 보관 유형에 맞는 재료
    var filteredIngredients: [IngredientStorage] {
      ingredientStorages
        .filter {
          $0.storageType == selectedStorageType
        }
        .sorted { $0.expirationDate < $1.expirationDate }
    }
    
    var selectedIngredients: Set<IngredientStorage.ID> = []

    // 냉장고 상태 결정 로직
    var refrigeratorStatus: RefrigeratorStatus {
      if ingredientStorages.isEmpty {
        return .empty
      } else if !expiredSoonIngredientStorages.isEmpty {
        let soonestIngredient = expiredSoonIngredientStorages.first!
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: soonestIngredient.expirationDate).day ?? 0
        return .expiredSoon(dday: daysLeft, count: expiredSoonIngredientStorages.count)
      } else if !expiredWarningIngredientStorages.isEmpty {
        return .expiredWarning
      } else {
        return .wellStocked
      }
    }
    
    // 만료 임박 재료 (3일 이내)
    var expiredSoonIngredientStorages: [IngredientStorage] {
      ingredientStorages.filter {
        $0.status == .expiredSoon(dday: Calendar.current.dateComponents([.day], from: Date(), to: $0.expirationDate).day ?? 0)
      }
      .sorted { $0.expirationDate < $1.expirationDate }
    }
    
    // 마감 기한 신경 필요 재료 (3~5일 사이)
    var expiredWarningIngredientStorages: [IngredientStorage] {
      ingredientStorages.filter {
        $0.status == .expiredWarning
      }
    }
    
    // 애니메이션 관련 상태
    var isShaking: Bool = false
    var timerRunning: Bool = false
    
    public init(
      isLoading: Bool = false
    ) {
      self.isLoading = isLoading
    }
  }
  
  public enum RefrigeratorStatus: Hashable {
    case empty // 냉장고 채워주세요(관리되고 있는 재료가 없음)
    case wellStocked // 재료가 잘 관리되고 있음
    case expiredWarning // 마감기한을 신경써야함
    case expiredSoon(dday: Int, count: Int) // 만료일이 다가와요
  }
  
  // MARK: Action
  public enum Action: Hashable {
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    // MARK: View defined Action
    case refrigeratorTapped // 냉장고 탭 함
    case isOpenFloatingButton(Bool)
    case selectStorageType(StorageType)
    case updateMyIngredients([IngredientStorage])
    case selectIngredient(IngredientStorage.ID)
    case scrollTo(IngredientStorage.ID)
    
    // MARK: 애니메이션
    case startTimer
    case stopTimer
    case timerTicked
    
    // MARK: Networking
    case requestGetMyIngredients
  }
  
  // MARK: Reduce
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
        // MARK: Life Cycle
      case .onAppear:
        return .run { send in
          await send(.requestGetMyIngredients)
          await send(.startTimer)
        }
      case .onDisappear:
        return .run { send in
          await send(.stopTimer)
        }
      case .onLoad:
        return .none
      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
        // MARK: View defined Action
      case .refrigeratorTapped:
        return .none
      case .isOpenFloatingButton(let isOpen):
        state.isOpenFloatingButton = isOpen
        return .none
      case .selectStorageType(let selected):
        state.selectedStorageType = selected
        return .none
      case .updateMyIngredients(let updated):
        state.ingredientStorages = updated
        return .none
      case .selectIngredient(let ingredientId):
          // Set에 이미 해당 ID가 있는지 확인
          if state.selectedIngredients.contains(ingredientId) {
              // 이미 있으면 제거
              state.selectedIngredients.remove(ingredientId)
          } else {
              // 없으면 추가
              state.selectedIngredients.insert(ingredientId)
          }
        return .none
        
      case .scrollTo(let ingredientId):
        guard let ingredient = state.ingredientStorages.first(where: { $0.id == ingredientId
        }) else {
          return .none
        }
        state.selectedStorageType = ingredient.storageType
        state.scrollToIngredientID = ingredientId
        return .none
        
        // MARK: 애니메이션
      case .startTimer:
        state.timerRunning = true
        return .run { send in
          await withTaskCancellation(id: Action.startTimer.self) {
            for await _ in Timer.publish(every: 0.3, on: .main, in: .common).autoconnect().values {
              await send(.timerTicked)
            }
          }
        }
        .cancellable(id: Action.startTimer.self, cancelInFlight: true)
        
      case .stopTimer:
        state.timerRunning = false
        return .cancel(id: Action.startTimer.self)
        
      case .timerTicked:
        state.isShaking.toggle()
        return .none
        
        // MARK: Networking
      case .requestGetMyIngredients:
        return .run { send in
          await send(.isLoading(true))
          do {
            let result = try await ingredientService.getMyIngredients()
            await send(.updateMyIngredients(result))
            await send(.isLoading(false))
          } catch {
            
          }
        }
        .cancellable(id: Action.requestGetMyIngredients.self, cancelInFlight: true)
      }
    }
  }
}


// MARK: IngredientStorage 확장
extension IngredientStorage {
  
  // 재료 상태 계산
  var status: IngredientStatus {
    let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
    if daysLeft <= 3 {
      return .expiredSoon(dday: daysLeft)
    } else if daysLeft > 3 && daysLeft <= 5 {
      return .expiredWarning
    } else {
      return .wellStocked
    }
  }
  
  enum IngredientStatus: Equatable {
    case wellStocked // 재료가 잘 관리되고 있음
    case expiredWarning // 마감 기한을 신경써야 함 (3~5일 남음)
    case expiredSoon(dday: Int) // 만료일이 다가옴 (3일 이하 남음)
  }
}
