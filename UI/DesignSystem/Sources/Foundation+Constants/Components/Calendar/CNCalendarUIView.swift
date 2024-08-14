//
//  CNCalendarUIView.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/12/24.
//

import UIKit
import FSCalendar
import Common
import DesignSystemFoundation

private extension CNCalendarUIView.Metric {
  static let buttonSpacing: CGFloat = 15
  static let headerHorizontalInset: CGFloat = 10
  static let headerHeight: CGFloat = 46
  static let headerAndCalendarSpacing: CGFloat = 24
}

final class CNCalendarUIView: UIView {
  
  // MARK: Properties
  private lazy var calendarView: FSCalendar = .init().then {
    $0.delegate = self
  }
  
  let headerDateFormatter = DateFormatter().then {
    $0.dateFormat = "M월 YYYY"
    $0.locale = Locale(identifier: "ko_kr")
    $0.timeZone = TimeZone(identifier: "KST")
  }
  
  let spacerView: UIView = .init()
  
  private lazy var calendarHeaderView = UIStackView(arrangedSubviews: [
    headerLabel,
    spacerView,
    monthAdjustButtonStackView
  ]).then {
    $0.axis = .horizontal
    $0.distribution = .fill
  }
  
  private lazy var headerLabel = UILabel().then { [weak self] in
    guard let self = self else { return }
    
    $0.font = UIFont.asset(.title1)
    $0.textColor = UIColor.asset(.black)
    $0.text = self.headerDateFormatter.string(from: Date())
    $0.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  private lazy var monthAdjustButtonStackView = UIStackView(arrangedSubviews: [
    leftButton,
    rightButton
  ]).then {
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
    $0.spacing = Metric.buttonSpacing
    $0.alignment = .center
  }
  
  private lazy var leftButton = UIButton().then {
    $0.setImage(UIImage.asset(.leftChevron), for: .normal)
    $0.addTarget(self, action: #selector(tapPreviousMonth), for:  .touchUpInside)
  }
  
  private lazy var rightButton = UIButton().then {
    $0.setImage(UIImage.asset(.rightChevron), for: .normal)
    $0.addTarget(self, action: #selector(tapNextMonth), for: .touchUpInside)
  }
  
  // MARK: Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  @available(*, deprecated)
  required init?(coder: NSCoder) {
    fatalError("NSCoder")
  }
  
  // MARK: Method
  @objc
  private func tapNextMonth() {
    self.calendarView.setCurrentPage(getNextMonth(date: calendarView.currentPage), animated: true)
  }
  
  @objc
  private func tapPreviousMonth() {
    self.calendarView.setCurrentPage(getPreviousMonth(date: calendarView.currentPage), animated: true)
  }
  
  func getNextMonth(date: Date) -> Date {
    return Calendar.current.date(byAdding: .month, value: 1, to: date)!
  }
    
  func getPreviousMonth(date: Date) -> Date {
    return Calendar.current.date(byAdding: .month, value: -1, to: date)!
  }
}

// MARK: Configuration
extension CNCalendarUIView: UIViewConfigurable {
  func configView() {
    
    calendarView.locale = Locale(identifier: "ko_kr")
    
    calendarView.scrollEnabled = false
    calendarView.scope = .month // 월간 달력 설정
    
    // 선택된 날짜 관련 설정
    calendarView.appearance.borderRadius = 0
    
    // 색상 설정
    calendarView.appearance.do {
      $0.weekdayTextColor = UIColor.asset(.gray600)
      
      $0.headerTitleColor = UIColor.asset(.black)
      
      
      $0.todayColor = UIColor.asset(.white)
      
      $0.titleDefaultColor = UIColor.asset(.gray800)
      $0.titleTodayColor = UIColor.asset(.gray800)
      $0.titleSelectionColor = UIColor.asset(.white)
      
      $0.selectionColor = UIColor.asset(.primary500)
      $0.todaySelectionColor = UIColor.asset(.primary500)
      
      $0.borderSelectionColor = .clear
      $0.borderDefaultColor = .clear
      
    }
    
    // Weekday 설정 (요일을 나타내는 첫번째 행 설정)
    calendarView.do {
      $0.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
    }
    
    // 헤더 설정
    calendarView.do {
      $0.appearance.headerMinimumDissolvedAlpha = 0
      $0.headerHeight = 0
    }
    
    // 폰트 설정
    calendarView.appearance.do {
      
      // 날짜별 폰트
      $0.titleFont = UIFont.asset(.body)
      
      // Weekday폰트
      $0.weekdayFont = UIFont.asset(.body)
      
      // 헤더폰트
      $0.headerTitleFont = UIFont.asset(.title1)
    }
  }
  
  func configHierarchy() {
    addSubview(calendarHeaderView)
    addSubview(calendarView)
  }
  
  func configLayout() {
    
    calendarHeaderView.snp.makeConstraints {
      $0.height.equalTo(Metric.headerHeight)
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Metric.headerHorizontalInset)
    }
    calendarView.snp.makeConstraints {
      $0.top.equalTo(calendarHeaderView.snp.bottom).offset(Metric.headerAndCalendarSpacing)
      $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
    }
  }
}

extension CNCalendarUIView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
  
  
  // MARK: FSCalendarDelegate
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    let currentPage = calendarView.currentPage
    
    headerLabel.text = headerDateFormatter.string(from: currentPage)
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    let month = calendar.currentPage
    if !Calendar.current.isDate(date, equalTo: month, toGranularity: .month) {
      return false
    }
    return true
  }
  
  // MARK: FSCalendarDelegateAppearance
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//      let month = calendar.currentPage
//      if !Calendar.current.isDate(date, equalTo: month, toGranularity: .month) {
//          return .clear
//      }
      return nil
  }
}

#Preview {
  CNCalendarUIViewController()
}
