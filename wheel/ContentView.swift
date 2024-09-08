//
//  ContentView.swift
//  wheel
//
//  Created by Aleksandr Khrebtov on 29.08.2024.
//


import SwiftUI

struct Segment: Identifiable {
    var id = UUID()
    var label: String
    var color: Color
}
let defaultSegments: [Segment] = [
    Segment(label: "Chicken", color: .red),
    Segment(label: "Fish", color: .green),
]
let foodSegments: [Segment] = [
    Segment(label: "Pizza", color: .red),
    Segment(label: "Sushi", color: .green),
    Segment(label: "Burger", color: .blue),
    Segment(label: "Doner", color: .orange),
    Segment(label: "Wok", color: .yellow),
]


// Форма стрелки 
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}



// Отображения колесо фортуны и его редактирования
struct ContentView: View {
    @State private var segments: [Segment] = defaultSegments
    
    var body: some View {
        //нормальынй таббар
//        TabView {
//            FortuneWheelView(segments: $segments)
//                .tabItem {
//                    Label("Wheel", systemImage: "circle.grid.cross")
//                }
//            
//            
//            
//            EditWheelView(segments: $segments)
//                .tabItem {
//                    Label("Edit", systemImage: "pencil")
//                }
//            
//        }
//        обратный таб бар шоб не переключать
        TabView {
            EditWheelView(segments: $segments)
                .tabItem {
                    Label("Wheel", systemImage: "circle.grid.cross")
                }
            
            
            
            FortuneWheelView(segments: $segments)
                .tabItem {
                    Label("Edit", systemImage: "pencil")
                }
            
        }
        .accentColor(.green)
    }
    
}



#Preview {
    ContentView()
}
