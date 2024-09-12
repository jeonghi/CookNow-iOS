//
//  CNCalendarView.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/12/24.
//

import UIKit
import SwiftUI
import FSCalendar
import Common
import DesignSystemFoundation

public struct CNCalendarView: UIViewControllerRepresentable {
  
  @Binding var selectedDate: Date
  
  public init(selection: Binding<Date> = .constant(Date())) {
    _selectedDate = selection
  }
  
  public typealias UIViewControllerType = CNCalendarUIViewController
  
  public func makeUIViewController(context: Context) -> CNCalendarUIViewController {
    let vc = CNCalendarUIViewController()
    vc.selectDate(date: selectedDate)
    return vc
  }
  
  public func updateUIViewController(_ uiViewController: CNCalendarUIViewController, context: Context) {
    uiViewController.delegate = context.coordinator
  }
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  public class Coordinator: NSObject, CNCalendarUIViewDelegate {
    
    private var _parent: CNCalendarView
    
    init(_ parent: CNCalendarView) {
      _parent = parent
    }
    
    func calendar(_ calendar: CNCalendarUIView, selectedDate date: Date) {
      _parent.selectedDate = date
    }
  }
}

#Preview {
  CNCalendarView()
}
