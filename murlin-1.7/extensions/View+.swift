//
//  View+.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import SwiftUI

/*
    AnyView modifier
 */
extension View {
    func any() -> AnyView {
        AnyView(self)
    }
}

/*
    button style
 */

struct MurlinButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 40)
            .frame(minWidth: 40)
            .padding(4)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(Color.main)
            )
            .padding(4)
            .shadow(radius: 10.0)
       }
}

extension View {
    func button() -> some View {
        modifier(MurlinButton())
    }
}


/*
    gradient background
 */
struct GradientBackground: ViewModifier {
   
    let color: Color
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [color, .white],
                    startPoint: .top,
                    endPoint: .bottomTrailing)
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .background(
                  LinearGradient(
                    colors: [.white, color],
                    startPoint: .top,
                    endPoint: .bottom)
                        .opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                                                    
                        )
                    )
           
       }
       
    
}

extension View {
    func gradientBacking(color: Color = .gray) -> some View {
        modifier(GradientBackground( color: color))
    }
}

/*
    solid background
 */

struct BackgroundView<Content: View>: View {
    let backgroundColor: Color
    let content: () -> Content

    var body: some View {
        ZStack {
            self.backgroundColor.edgesIgnoringSafeArea(.all)
            self.content()
        }
    }
}


struct SwipeToDeleteRow: ViewModifier {
    // action to perform on delete
    var deleteAction: () -> Void
    // width of the delete button. height == height of content
    private let width : CGFloat = 50
    // offset of content
    @State private var offset : CGFloat = 0
    // true if the delete button will stay visible when the user stops dragging
    @State private var isSwiped : Bool = false

    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            // This is the "delete" button. You could put something else here as long as you use
            // contentShape, onTapGesture, and offset extensions
            HStack(spacing: 0) {
                HStack {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 18, height: 24, alignment: .center)
                        .foregroundColor(Color.white)
                }
                .frame(minWidth: width, maxWidth: width, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(Color.red)
                .contentShape(Rectangle())
                .onTapGesture(perform: deleteAction)
                //.offset(x: width)
 
                 HStack {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 18, height: 24, alignment: .center)
                        .foregroundColor(Color.white)
                }
                .frame(minWidth: width, maxWidth: width, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(Color.red)
                .contentShape(Rectangle())
                .onTapGesture(perform: deleteAction)
                //.offset(x: width)
            }
            .offset(x: 2*width)
            
            
            
        }
        .offset(x: offset)
        .contentShape(Rectangle())
        .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
    }
    
    func onChanged(value: DragGesture.Value){
        if value.translation.width < 0 {
            if isSwiped {
                // show the full width of the button when "swiped"
                offset = value.translation.width - 2*width
            } else {
                // offset the content to match the drag translation
                offset = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    // user dragged > 50% of the screen delete
                    deleteAction()
                    isSwiped = false
                    offset = 0
                }
                else if -offset > 2*width {
                    // user dragged enough to show the button, show it when they stop dragging
                    isSwiped = true
                    offset = -2*width
                }
                else {
                    // user did not drag enough, pop the button off the screen
                    isSwiped = false
                    offset = 0
                }
            }
            else{
                // user swiped right, pop the button off the screen
                isSwiped = false
                offset = 0
            }
        }
    }
}
