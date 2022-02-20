//
//  TextEditView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//
//
// From: Exam ple code for article: https://lostmoa.com/blog/DynamicHeightForTextFieldInSwiftUI/
// https://github.com/LostMoa/SwiftUI-Code-Examples/blob/main/DynamicHeightForTextFieldInSwiftUI/DynamicHeightForTextFieldInSwiftUI.swift
//


import Foundation
import SwiftUI

struct DynamicHeightTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 18)
        textView.text = text
        textView.backgroundColor = UIColor.clear
        
        context.coordinator.textView = textView
        textView.delegate = context.coordinator
        textView.layoutManager.delegate = context.coordinator

        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(dynamicSizeTextField: self)
    }
}

class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate {
    
    var dynamicHeightTextField: DynamicHeightTextField
    
    weak var textView: UITextView?

    
    init(dynamicSizeTextField: DynamicHeightTextField) {
        self.dynamicHeightTextField = dynamicSizeTextField
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.dynamicHeightTextField.text = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            guard let textView = self?.textView else {
                return
            }
            let size = textView.sizeThatFits(textView.bounds.size)
            if self?.dynamicHeightTextField.height != size.height {
                self?.dynamicHeightTextField.height = size.height
            }
        }

    }
}

struct TextEditView: View {

    let placeholder: String
    @Binding var text: String
    @State var textHeight: CGFloat = 0
    
    var textFieldHeight: CGFloat {
        let minHeight: CGFloat = 30
        let maxHeight: CGFloat = 90
        
        if textHeight < minHeight {
            return minHeight
        }
        
        if textHeight > maxHeight {
            return maxHeight
        }
        
        return textHeight
    }

    var body: some View {
        ZStack(alignment: .center) {
           // Color.main.opacity(0.3)
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(UIColor.placeholderText))
            }
            
            DynamicHeightTextField(text: $text, height: $textHeight)
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        
        .frame(height: textFieldHeight)

    }
}
