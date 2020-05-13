//
//  CustomTextView.swift
//  DreamBook
//
//  Created by moesmoesie on 11/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct CustomTextField : View {
    @State var height : CGFloat = 0
    @Binding var text : String
    @Binding var focus : Bool
    let textColor : UIColor
    let backgroundColor : UIColor
    let placeholder : String
    let tintColor : UIColor
    let font : UIFont
    let onReturn : (UITextField) -> Bool
    
    init(text : Binding<String>, placeholder : String, focus : Binding<Bool> = .constant(false), textColor : UIColor = .white,
         backgroundColor : UIColor = .clear, tintColor : UIColor = .systemBlue, font : UIFont = UIFont.preferredFont(forTextStyle: .body), onReturn : @escaping (UITextField) -> Bool = {_ in true}) {
        self._text = text
        self._focus = focus
        self.placeholder = placeholder
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.font = font
        self.onReturn = onReturn
    }
    
    var body: some View{
        GeometryReader{ geo in
            self.content(width: geo.size.width)
        }.frame(height : self.height)
    }
    
    private func content(width : CGFloat) -> some View{
        ZStack(alignment: .topLeading){
            if text.isEmpty{
                Text(placeholder).font(.body).opacity(0.2).foregroundColor(.white)
            }
            UICustomTextField(text: self.$text, width: width, height: self.$height, focus: $focus, onReturn: onReturn, make: self.make)
        }
    }
    
    
    private func make(coordinator: UICustomTextField.Coordinator) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = coordinator
        textField.backgroundColor = self.backgroundColor
        textField.tintColor = self.tintColor
        textField.textColor = self.textColor
        textField.font = self.font
        textField.returnKeyType = .done
        textField.addTarget(coordinator,
            action: #selector(coordinator.textFieldDidChange),
            for: .editingChanged)
        return textField
    }
}


private struct UICustomTextField : UIViewRepresentable{
    @Binding var text : String
    let width : CGFloat
    @Binding var height : CGFloat
    @Binding var focus : Bool
    let onReturn : (UITextField) -> Bool

    
    let make: (Coordinator) -> UIViewType
    
    func makeUIView(context: Context) -> UITextField {
        make(context.coordinator)
    }

    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.height = uiView.sizeThatFits(CGSize(width: self.width, height: .infinity)).height
        }
        
        if focus && !uiView.isFocused{
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> UICustomTextField.Coordinator {
        return Coordinator($text,$focus,onReturn: onReturn)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate{
        @Binding var text : String
        @Binding var focus : Bool
        let onReturn : (UITextField) -> Bool

        init(_ text : Binding<String>, _ focus : Binding <Bool>, onReturn : @escaping (UITextField) -> Bool) {
            self._text = text
            self._focus = focus
            self.onReturn = onReturn
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            text = textField.text ?? ""
         }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturn(textField)
        }
    }
}