//
//  FortuneWheelView.swift
//  wheel
//
//  Created by Aleksandr Khrebtov on 07.09.2024.
//


import SwiftUI

struct FortuneWheelView: View {
    @Binding var segments: [Segment]
    @State private var rotation: Double = 0
    @Environment(\.colorScheme) var colorScheme
    private let spinDuration: Double = 3 // Длительность анимации вращения
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(segments.indices, id: \.self) { index in
                    let segmentCount = segments.count
                    let segmentAngle = 360.0 / Double(segmentCount)
                    let startAngle = Angle.degrees(segmentAngle * Double(index))
                    let endAngle = Angle.degrees(segmentAngle * Double(index + 1))
                    let midAngle = startAngle + (endAngle - startAngle) / 2
                    
                    // Создание сегмента
                    createSegmentPath(geometry: geometry, startAngle: startAngle, endAngle: endAngle, color: segments[index].color)
                    
                    Text(segments[index].label)
                        .font(.system(size: 21, weight: .bold))
                        .foregroundColor(.black)
                        .shadow(color: .white, radius: 1, x: 0, y: 0)
                        .offset(x: geometry.size.width / 4)
                        .rotationEffect(-midAngle)
                        .zIndex(1.0)
                }
                .rotationEffect(.degrees(rotation))
                
                // Стрелка указателя
                Triangle()
                    .fill(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(180))
                    .offset(y: -geometry.size.width / 2 - 20)
            }
            .onTapGesture {
                spinWheel()
            }
        }
        .padding()
    }
    
    // Функция для создания пути сегмента
    private func createSegmentPath(geometry: GeometryProxy, startAngle: Angle, endAngle: Angle, color: Color) -> some View {
        Path { path in
            path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
            path.addArc(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                        radius: geometry.size.width / 2,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false)
            path.closeSubpath()
        }
        .fill(color)
    }
    
    private func spinWheel() {
        let randomRotation = Double.random(in: 720...1440)
        
        withAnimation(.easeOut(duration: spinDuration)) {
            rotation += randomRotation
        }
    }
}
#Preview {
    ContentView()
}
