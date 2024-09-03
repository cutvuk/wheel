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

struct EditWheelView: View {
    @Binding var segments: [Segment]
    
    let availableColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan, .brown, .gray]
    let maxLabelLength: Int = 10 // Максимальная длина текста
    
    var body: some View {
        VStack {
            List {
                ForEach(segments.indices, id: \.self) { index in
                    HStack {
                        TextField("Label \(index + 1)", text: $segments[index].label)
                            .onChange(of: segments[index].label) { oldValue, newValue in
                                if newValue.count > maxLabelLength {
                                    segments[index].label = String(newValue.prefix(maxLabelLength))
                                }
                            }
                          
                        ColorPicker("", selection: $segments[index].color, supportsOpacity: false)
                            .onChange(of: segments[index].color) {oldColor, newColor in
                                updateAdjacentColors(index: index, newColor: newColor)
                            }
                            .labelsHidden() //без этого девайдер обрезан
                        
                    }
                    
       
                    
                }
                
                .onDelete(perform: deleteSegments)
                .onMove(perform: moveSegments)
                
                if segments.count < 10 {
                    Button(action: addSegment) {
                        Text("Add Segment")
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("Edit Wheel")
    }
    
    private func deleteSegments(at offsets: IndexSet) {
        segments.remove(atOffsets: offsets)
    }
    
    private func moveSegments(from source: IndexSet, to destination: Int) {
        segments.move(fromOffsets: source, toOffset: destination)
    }
    
    private func addSegment() {
        let newColor = availableColors.first { color in
            !segments.contains { $0.color == color }
        } ?? .gray
        let newSegment = Segment(label: "New", color: newColor)
        segments.append(newSegment)
    }
    
    private func updateAdjacentColors(index: Int, newColor: Color) {
        let count = segments.count
        let prevIndex = (index - 1 + count) % count
        let nextIndex = (index + 1) % count
        
        if segments[prevIndex].color == newColor {
            segments[prevIndex].color = availableColors.first { $0 != newColor && $0 != segments[nextIndex].color } ?? .gray
        }
        if segments[nextIndex].color == newColor {
            segments[nextIndex].color = availableColors.first { $0 != newColor && $0 != segments[prevIndex].color } ?? .gray
        }
    }
}

// Расширение для генерации случайного цвета
extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}

// Отображения колесо фортуны и его редактирования
struct ContentView: View {
    @State private var segments: [Segment] = [
        Segment(label: "Chicken", color: .red),
        Segment(label: "Fish", color: .green),
    ]
    
    var body: some View {
        TabView {
            FortuneWheelView(segments: $segments)
                .tabItem {
                    Label("Wheel", systemImage: "circle.grid.cross")
                }
            
            EditWheelView(segments: $segments)
                .tabItem {
                    Label("Edit", systemImage: "pencil")
                }
            
        }
        .accentColor(.green)
    }
}

// Основная структура приложения
@main
struct FortuneWheelApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
