//
//  GetSizeClassModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/23/25.
//


#if os(iOS)
  struct GetSizeClassModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State var currentSizeClass: DeviceStatus = .compact
    func body(content: Content) -> some View {
      content
        .task(id: sizeClass) {
          if let sizeClass {
            switch sizeClass {
            case .compact:
              currentSizeClass = .compact
            case .regular:
              currentSizeClass = .regular
            default:
              currentSizeClass = .compact
            }
          }
        }
        .environment(\.deviceStatus, currentSizeClass)
    }
  }
#endif