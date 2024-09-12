//
//  RefrigeratorHomeView.swift
//  Refrigerator
//
//  Created by 쩡화니 on 8/16/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation
import Domain
import Common
import ComposableArchitecture

// MARK: Properties
public struct RefrigeratorHomeView: BaseFeatureViewType {
  
  public typealias Core = RefrigeratorHomeCore
  public let store: StoreOf<Core>
  public typealias StorageType = Core.StorageType
  public typealias RefrigeratorStatus = Core.RefrigeratorStatus
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  
  @State private var isIconVisible: Bool = true
  
  public struct ViewState: Equatable {
    
    var isOpenFloatingButton: Bool
    var categories: [IngredientCategory]
    var filteredIngredients: [IngredientStorage]
    
    var expiredSoonIngredients: [IngredientStorage]
    var selectedStorageType: StorageType
    var refrigeratorStatus: RefrigeratorStatus
    var isShaking: Bool
    var currStatus: RefrigeratorStatus
    var isLoading: Bool
    var selectedIngredients: Set<IngredientStorage.ID>
    var scrollToIngredientId: IngredientStorage.ID?
    
    public init(state: CoreState) {
      categories = state.categories
      isOpenFloatingButton = state.isOpenFloatingButton
      filteredIngredients = state.filteredIngredients
      selectedStorageType = state.selectedStorageType
      refrigeratorStatus = state.refrigeratorStatus
      isShaking = state.isShaking
      currStatus = state.refrigeratorStatus
      isLoading = state.isLoading
      expiredSoonIngredients = state.expiredSoonIngredientStorages
      selectedIngredients = state.selectedIngredients
      scrollToIngredientId = state.scrollToIngredientID
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
  
  private enum Metric {
    static let refrigeratorBackgroundWidthRatio: CGFloat = 273/375
    static let rotatation: CGFloat = 1
    static let animationTimeInterval: CGFloat = 0.3
  }
}


extension RefrigeratorHomeView: View {
  public var body: some View {
    VStack(spacing: 1) {
      topBarView()
      contentView()
        .vTop()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.asset(.bgMain))
    .ignoresSafeArea(edges: [.horizontal])
    .applyIf(viewStore.isOpenFloatingButton) {
      $0.overlay {
        Color.black.opacity(0.6)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .applyIf(viewStore.filteredIngredients.count > 0){
      $0.overlay(alignment: .bottomTrailing) {
        floattingButtonView()
          .padding()
      }
    }
    .kerning(-0.6) // 자간 -0.6
    .cnLoading(viewStore.isLoading)
    .onAppear { viewStore.send(.onAppear) }
    .onDisappear { viewStore.send(.onDisappear) }
  }
}

extension RefrigeratorHomeView {
  
  @ViewBuilder
  private func topBarView() -> some View {
    VStack(spacing: 15) {
      
//      if(isIconVisible) {
        infoBoxView()
          .padding(.horizontal, 20)
//      }
      
      if case .expiredSoon(_, _) = viewStore.currStatus {
        expireSoonIngredientsScrollView()
          .padding(.horizontal, 20)
      }
      
      if viewStore.currStatus != .empty {
        storageTypeSegmentControl()
      }
    }
    .background(
      Divider()
        .vBottom()
        .background(Color.asset(.white))
    )
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    
    /// 보관된 재료가 없다면 냉장고 배경 보여주기
    if(viewStore.currStatus == .empty) {
      backgroundView()
    } else {
      /// 재료가 있다면 재료 그리드 보여주기
      ScrollViewReader { proxy in
        ScrollView(.vertical, showsIndicators: true) {
          
          scrollObservableView()
          ingredientGridView()
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
          
        }
        .onChange(of: viewStore.scrollToIngredientId) { _, newValue in
          withAnimation {
            proxy.scrollTo(newValue, anchor: .center)
          }
        }
        .onPreferenceChange(ScrollOffsetKey.self) { offset in
          withAnimation(.easeInOut) {
            isIconVisible = offset > -100
          }
        }
      }
    }
  }
  
  private func scrollObservableView() -> some View {
    GeometryReader { proxy in
      let offsetY = proxy.frame(in: .global).origin.y
      Color.clear
        .preference(
          key: ScrollOffsetKey.self,
          value: offsetY
        )
    }
    .frame(height: 0)
  }
  
  /// 배경 뷰
  private func backgroundView() -> some View {
    GeometryReader { geo in
      
      let width = geo.size.width * Metric.refrigeratorBackgroundWidthRatio
      
      let centerX = geo.size.width / 2
      let centerY = geo.size.height / 2
      
      Button(action: { viewStore.send(.refrigeratorTapped) }) {
        Image.asset(.refrigerator)
          .renderingMode(.original)
          .resizable()
          .scaledToFit()
          .frame(width: width)
          .position(x: centerX, y: centerY)
          .rotationEffect(viewStore.isShaking ? .degrees(-Metric.rotatation) : .degrees(Metric.rotatation))
          .animation(
            Animation.easeInOut(duration: Metric.animationTimeInterval)
              .repeatForever(autoreverses: true),
            value: viewStore.isShaking
          )
      }
    }
  }
  
  /// 박스뷰
  
  @ViewBuilder
  private func infoBoxView() -> some View {
    
    let type = viewStore.refrigeratorStatus
    
    if case let .expiredSoon(dday, count) = type {
      infoBoxContentView(for: type)
        .overlay(alignment: .trailing){
          Text("Day\(displayDday(for: dday)) \(count)건")
            .font(.asset(.bodyBold1))
            .foregroundStyle(Color.asset(.white))
            .padding(.trailing, 15)
        }
    } else {
      infoBoxContentView(for: type)
    }
  }
  
  private func displayDday(for dday: Int) -> String {
    if dday < 0 {
      return "+\(abs(dday))" // 디데이가 지난 경우 + 기호와 함께 표시
    } else {
      return "-\(dday)" // 디데이가 남은 경우 그냥 표시
    }
  }
  
  private func infoBoxContentView(for type: RefrigeratorStatus) -> some View {
    CNInfomationBox(
      icon: type.icon,
      infoText: type.infoText,
      style: type.style
    )
  }
  
  /// 마감 기한 임박 재료 뷰
  private func expireSoonIngredientsScrollView() -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 7) {
        ForEach(viewStore.expiredSoonIngredients, id: \.self) { item in
          makeExpireSoonIngredientScrollItemView(for: item)
        }
      }
    }
    .frame(height: 66)
  }
  
  private func makeExpireSoonIngredientScrollItemView(for item: IngredientStorage) -> some View {
    Group {
      if case let .expiredSoon(dday) = item.status {
        VStack(spacing: 4) {
          Button(action: {viewStore.send(.scrollTo(item.id))}) {
            ZStack {
              Color.clear
              CNAsyncImage(item.ingredient.imageUrl)
                .padding(6)
            }
            .frame(width: 42, height: 42)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
              Circle()
                .stroke(Color.asset(.danger500), lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .padding(1)
            }
          }
          Text("Day\(displayDday(for: dday))")
        }
        .font(.asset(.caption))
      }
    }
  }
}

extension RefrigeratorHomeView {
  
  /// 보관된 재료 목록 그리드 뷰
  private func ingredientGridView() -> some View {
    
    let gridItems: [GridItem] = .init(repeating: .init(.flexible(), spacing: 18.33, alignment: .center), count: 4)
    
    return LazyVGrid(columns: gridItems, spacing: 10){
      
      // 재료 추가 버튼 그리드 아이템
      newIngredientGridItemView()
      
      // 재료 그리드 아이템
      ForEach(viewStore.filteredIngredients, id: \.self) { item in
        ingredientGridItemView(for: item)
          .id(item.id)
      }
    }
  }
  
  /// 보관된 재료 그리드 아티템 뷰
  
  private func ingredientGridItemView(for item: IngredientStorage) -> some View {
    
    let bgColor: ColorAsset
    let strokeColor: ColorAsset
    var image: ImageAsset? = nil
    
    if viewStore.selectedIngredients.contains(item.id) {
      bgColor = .primary200
      strokeColor = .primary700
    } else if case .expiredSoon = item.status {
      bgColor = .white
      strokeColor = .danger500
      image = .infoBoxIconBomb
    } else {
      bgColor = .white
      strokeColor = .clear
    }
    
    return makeGridItemView(title: item.ingredient.name) {
      Button(action: {viewStore.send(.selectIngredient(item.id))}) {
        ZStack {
          bgColor.toColor()
          CNAsyncImage(item.ingredient.imageUrl)
            .padding(5)
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay {
          RoundedRectangle(cornerRadius: 6)
            .stroke(strokeColor.toColor(), lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        }
        .overlay(alignment: .topTrailing) {
          image?.toImage()
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(strokeColor.toColor())
            .frame(width: 22, height: 22)
            .padding(5)
        }
      }
    }
  }
  
  private func newIngredientGridItemView() -> some View {
    makeGridItemView(title: "재료 추가") {
      Button(action: {viewStore.send(.refrigeratorTapped)}) {
        ZStack {
          Color.asset(.white)
          Image(systemName: "plus")
            .resizable()
            .foregroundStyle(Color.asset(.primary500))
            .frame(width: 16, height: 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
      }
    }
  }
  
  
  /// 그리드 아이템 컨테이너
  private func makeGridItemView<Content: View>(
    title: String,
    @ViewBuilder view: @escaping () -> Content
  ) -> some View {
    VStack(spacing: 6) {
      view()
      Text(title)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .foregroundStyle(Color.asset(.gray800))
    }
    .font(.asset(.bodyBold1))
  }
  
  /// 보관 유형 필터
  private func storageTypeSegmentControl() -> some View {
    CNSegmentControl(
      segments: [StorageType.refrigerator, StorageType.freezer, StorageType.roomTemperature],
      selected: viewStore.binding(
        get: \.selectedStorageType,
        send: CoreAction.selectStorageType
      ),
      scrollable: false
    ) { item in
      VStack(spacing: 5) {
        if(isIconVisible) {
          Image.asset(item.icon)
            .renderingMode(.template)
        }
        Text(item.title)
      }
      .padding(.bottom, 5)
    }
    .font(.asset(.body3))
    .frame(maxWidth: .infinity)
    .frame(height: isIconVisible ? 68 : 48)
  }
  
  
  private func floattingButtonView() -> some View {
    CNFloattingButton(
      mainButtonView: mainButton(),
      buttons: [
        makeSubButton(title: "수정"),
        makeSubButton(title: "레시피"),
        makeSubButton(title: "삭제")
      ],
      isOpen: viewStore.binding(
        get: \.isOpenFloatingButton,
        send: CoreAction.isOpenFloatingButton
      )
    )
  }
  
  private func mainButton() -> some View {
    Circle()
      .fill(Color.asset(.primary900))
      .overlay {
        Text("\(viewStore.selectedIngredients.count)")
          .foregroundStyle(Color.asset(.white))
          .font(.body)
      }
      .frame(width: 56, height: 56)
      .shadow(color: .black.opacity(0.14), radius: 5, y: 4)
  }
  
  private func makeSubButton(title: String, action: (() -> Void)? = nil) -> some View {
    Button(action: {
      action?()
    }) {
      Circle()
        .fill(Color.asset(.primary700))
        .frame(width: 56, height: 56)
        .overlay {
          Text(title)
            .foregroundStyle(Color.asset(.white))
            .font(.caption)
        }
        .shadow(color: .black.opacity(0.14), radius: 5, y: 4)
    }
  }
}

extension RefrigeratorHomeView.StorageType {
  
  var title: String {
    switch self {
    case .freezer:
      return "냉동"
    case .refrigerator:
      return "냉장"
    case .roomTemperature:
      return "실온"
    }
  }
  
  var icon: ImageAsset {
    switch self {
    case .freezer:
      return .myfreigerIconStoragetypeFreeze
    case .refrigerator:
      return .myfreigerIconStoragetypeCold
    case .roomTemperature:
      return .myfreigerIconStoragetypeRoom
    }
  }
}

private extension RefrigeratorHomeView.RefrigeratorStatus {
  
  var icon: ImageAsset {
    switch self {
    case .empty:
      return .infoboxIconQuestionBox
    case .wellStocked:
      return .infoBoxIconLeaf
    case .expiredSoon:
      return .infoBoxIconBomb
    case .expiredWarning:
      return .infoBoxIconBigEye
    }
  }
  
  var infoText: String {
    switch self {
    case .empty:
      return "아래의 냉장고를 선택해 재료를 채워주세요!"
    case .wellStocked:
      return "재료가 잘 관리되고 있어요!"
    case .expiredSoon:
      return "소비 마감 기한이 다가오고 있어요!"
    case .expiredWarning:
      return "슬슬 소비 마감 기한을 신경써주세요!"
    }
  }
  
  var style: CNInfomationBox.Style {
    switch self {
    case .empty, .wellStocked:
      return .success
    case .expiredSoon:
      return .danger
    case .expiredWarning:
      return .warning
    }
  }
}

struct ScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}


#if(DEBUG)
@available(iOS 17.0, *)
#Preview {
  RefrigeratorHomeView()
}
#endif
