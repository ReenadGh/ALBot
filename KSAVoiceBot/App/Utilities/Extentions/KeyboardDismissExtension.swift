//
//  KeyboardDismissExtension.swift
//  EmployeeID
//
//  Created by Mohamed Hashem on 19/03/2023.
//

import Foundation
import SwiftUI
import UIKit
import Combine

enum All {
    static let gestures = all(of: Gestures.self)

    private static func all<CI>(of _: CI.Type) -> CI.AllCases where CI: CaseIterable {
        return CI.allCases
    }
}

enum Gestures: Hashable, CaseIterable {
    case tap, longPress, drag, magnification, rotation
}

protocol ValueGesture: Gesture where Value: Equatable {
    func onChanged(_ action: @escaping (Value) -> Void) -> _ChangedGesture<Self>
}
extension LongPressGesture: ValueGesture {}
extension DragGesture: ValueGesture {}
extension MagnificationGesture: ValueGesture {}
extension RotationGesture: ValueGesture {}

extension Gestures {
    @discardableResult
    func apply<V>(to view: V, perform voidAction: @escaping () -> Void) -> AnyView where V: View {

        func highPrio<G>(
             gesture: G
        ) -> AnyView where G: ValueGesture {
            view.highPriorityGesture(
                gesture.onChanged { value in
                    _ = value
                    voidAction()
                }
            ).eraseToAnyView()
        }

        switch self {
        case .tap:
            // not `highPriorityGesture` since tapping is a common gesture, e.g. wanna allow users
            // to easily tap on a TextField in another cell in the case of a list of TextFields / Form
            return view.gesture(TapGesture().onEnded(voidAction)).eraseToAnyView()
        case .longPress: return highPrio(gesture: LongPressGesture())
        case .drag: return highPrio(gesture: DragGesture())
        case .magnification: return highPrio(gesture: MagnificationGesture())
        case .rotation: return highPrio(gesture: RotationGesture())
        }

    }
}

struct DismissingKeyboard: ViewModifier {

    var gestures: [Gestures] = Gestures.allCases

    dynamic func body(content: Content) -> some View {
        let action = {
            let forcing = true
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.endEditing(forcing)
        }

        return gestures.reduce(content.eraseToAnyView()) { $1.apply(to: $0, perform: action) }
    }
}


public extension View {
    
    @inlinable
    func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        body(&result)
        return result
    }
    
    /// Wraps view inside `AnyView`
    func embedInAnyView() -> AnyView {
        AnyView( self )
    }
    
    /// Wraps view inside `AnyView`
    func eraseToAnyView() -> AnyView { embedInAnyView() }
    
    /// Wraps view inside `NavigationView`
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
    
    /// Apply 1 of the modifiers based on condition.
    @ViewBuilder func apply1of2ModifierOnCondition<M1: ViewModifier, M2: ViewModifier>
        (on condition: Bool, trueCase: M1, falseCase: M2) -> some View {
        if condition {
            modifier(trueCase)
        } else {
            modifier(falseCase)
        }
    }
    
    /// Apply modifier if condition matches, otherwise do nothing.
    @ViewBuilder func applyModifierOnCondition<M: ViewModifier>
        (on condition: Bool, trueCase: M) -> some View {
        if condition {
            modifier(trueCase)
        }
    }
    
    /// Apply modifier if condition is true, otherwise returns itself.
    @ViewBuilder func applyModifierOnConditionOrReturnSelf<M: ViewModifier>
        (on condition: Bool, trueCase: M) -> some View {
        if condition {
            modifier(trueCase)
        } else {
            self
        }
    }
    
    @inlinable
    @ViewBuilder func hidden(_ isHidden: Bool) -> some View {
        if isHidden {
            hidden()
        } else {
            self
        }
    }
    
    /// Performed if device has iOS.
    func iOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(iOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    /// Performed if device has macOS.
    func macOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(macOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    /// Performed if device has tvOS.
    func tvOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(tvOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    /// Performed if device has watchOS.
    func watchOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(watchOS)
        return modifier(self)
        #else
        return self
        #endif
    }
        
}

extension View {
    dynamic func dismissKeyboard(on gestures: [Gestures] = Gestures.allCases) -> some View {
        return ModifiedContent(content: self, modifier: DismissingKeyboard(gestures: gestures))
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


extension View {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}



struct KeyboardResponsiveModifier: ViewModifier {
  @State private var offset: CGFloat = 0

  func body(content: Content) -> some View {
    content
      .padding(.bottom, offset)
      .onAppear {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
          let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
          let height = value.height
          let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
          self.offset = height - (bottomInset ?? 0)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
          self.offset = 0
        }
    }
  }
}

extension View {
  func keyboardResponsive() -> ModifiedContent<Self, KeyboardResponsiveModifier> {
    return modifier(KeyboardResponsiveModifier())
  }
}

public class KeyboardInfo: ObservableObject {

    public static var shared = KeyboardInfo()

    @Published public var height: CGFloat = 0

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardChanged(notification: Notification) {
        if notification.name == UIApplication.keyboardWillHideNotification {
            self.height = 0
        } else {
            self.height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
        }
    }

}

struct KeyboardAware: ViewModifier {
    @ObservedObject private var keyboard = KeyboardInfo.shared

    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.keyboard.height)
            .edgesIgnoringSafeArea(self.keyboard.height > 0 ? .bottom : [])
            .animation(.easeOut , value: 1)
    }
}

extension View {
    public func keyboardAware() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAware())
    }
}
