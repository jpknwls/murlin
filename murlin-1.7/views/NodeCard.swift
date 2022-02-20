//
//  NodeCard.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import SwiftUI
import RealmSwift

/*
    node card
        views
            - title
            - note
            - backlinks
            - updated date
            
    
        actions
            - expand
            - visit
            
        
 */
struct NodeCard: View {
    let node: NodeProjection
    
    let visit: () -> ()

    

    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    title
                    Spacer()
                }
                note
            }
       
            .foregroundColor(.white)
            .padding(4)
            .background(
                Color.main.opacity(0.6)
            )
            .onTapGesture {
                visit()
            }
            .modifier(SwipeToDeleteRow(deleteAction: {}))
            

       
        
    }
    
    var title: some View {
        Text(node.title)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .padding(4)
    }
    var note: some View {
        Text(node.note)
            .font(.system(size: 14, weight: .medium))
            .grayscale(0.7)
            .padding(2)
    }
    var links: some View {
        EmptyView() //node.outgoing
    }
}
