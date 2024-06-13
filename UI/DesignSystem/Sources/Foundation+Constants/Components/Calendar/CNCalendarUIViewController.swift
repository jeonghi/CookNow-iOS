//
//  CNCalendarViewController.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/12/24.
//

import UIKit
import DesignSystemFoundation

/// CookNow에서 사용하는 캘린더 입니다.
public final class CNCalendarUIViewController: UIViewController {
  
  private var calendarView: CNCalendarUIView = .init()
  
  // MARK: Life cycle
  
  public override func loadView() {
    view = calendarView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
}


// MARK: Metric
private extension CNCalendarUIViewController {}

#Preview {
  CNCalendarUIViewController()
}
