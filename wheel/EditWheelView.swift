//
//  EditWheelView.swift
//  wheel
//
//  Created by Aleksandr Khrebtov on 07.09.2024.
//

import SwiftUI


struct EditWheelView: View {
    @Binding var segments: [Segment]
    
    let availableColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan, .brown, .gray]
    
   
    
    let maxLabelLength: Int = 10 // Максимальная длина текста
    @State private var goalEnabled: Bool = false // Стейт для тумблера
    
    var body: some View {
        VStack {
            List {
                ForEach(segments.indices, id: \.self) { index in
                    HStack {
                        TextField("", text: $segments[index].label)
                            .onChange(of: segments[index].label) { oldValue, newValue in
                                if newValue.count > maxLabelLength {
                                    segments[index].label = String(newValue.prefix(maxLabelLength))
                                }
                            }
                        
                        ColorPicker("", selection: $segments[index].color, supportsOpacity: false)
                        
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
            HStack {
                //кнопка сброса
                Button(action: selectFood, label: {
                    Text("Food")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                } )
               
            }
        //    .padding(.horizontal)
            
       //     Spacer()
            
            HStack {
                //кнопка сброса
                Button(action: resetSegments, label: {
                    Text("Reset")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                } )
                .frame(maxWidth: .infinity, alignment: .leading )
                
                //тумблер
                Toggle("Goal", isOn: $goalEnabled)
                    .padding(.leading, 60 )
                    .padding(.trailing, 10)
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
            
            
        }
        
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
    
 
    // Функция сброса сегментов к исходным значениям
        private func resetSegments() {
            segments = defaultSegments
        }
    private func selectFood() {
        segments = foodSegments
    }
}
#Preview {
    ContentView()
}
