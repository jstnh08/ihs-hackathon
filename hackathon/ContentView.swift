//
//  ContentView.swift
//  hackathon
//
//  Created by Justin Hudacsko on 1/16/24.
//

import SwiftUI
import ConfettiSwiftUI


struct SheetView: View {
    @State var drinkAmount = 0.0
    @Binding var isPresented: Bool
    @Binding var mlDrunk: Int
    @Binding var confettiTrigger: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("How Much Did You Drink?")
                .font(.title)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .bold()
            
            Text("Adjust the slider to select the amount of liquid you drank in the current sitting.")
            
            let answers: [(range: Range<Int>, message: String)] = [
                (0..<16, "Just a couple sips"),
                (16..<32, "A decent amount"),
                (32..<48, "A quarter bottle"),
                (48..<64, "A half bottle"),
                (64..<95, "Most of the bottle"),
                (95..<101, "The WHOLE THING!")
            ]
            
            Slider (
                value: $drinkAmount,
                in: 0...100,
                step: 5
            ) {
                Text("spe")
            } minimumValueLabel: {
                Text("-")
                    .bold()
            } maximumValueLabel: {
                Text("+")
                    .bold()
            }
            .padding(.top, 30)
            
            ForEach(answers, id: \.message) { answer in
                if answer.range.contains(Int(drinkAmount)) {
                    Text("\(answer.message) (\(Int(drinkAmount*6)) mL)")
                        .bold()
                }
            }
            
            Button(action: {
                if mlDrunk < 2200 && mlDrunk+Int(drinkAmount*6) > 2200 {
                    confettiTrigger += 1
                }
                withAnimation {
                    mlDrunk += Int(drinkAmount*6)
                }
                
                isPresented = false
            }) {
                RoundedRectangle(cornerRadius: 30.0)
                    .fill(.blue.opacity(0.5))
                    .frame(height: 60)
                    .overlay(
                        Text("Submit")
                            .font(.title3.lowercaseSmallCaps())
                            .bold()
                    )
                    .padding([.horizontal, .top], 25)
            }
        }
        .padding([.horizontal, .top], 30)
        .padding(.bottom, 10)
        .foregroundStyle(.white)
    }
}

struct ContentView: View {
    @State var mlDrunk = 0
    @State var isPresented = false
    var mlNeeded = 2200
    @State private var confettiTrigger = 0
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 20) {
                let amount = Int(round(Double(mlDrunk)/Double(mlNeeded) * 100))
                
                HStack(alignment: .top, spacing: 20) {
                    Image(systemName: "drop")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .fontWeight(.thin)
                        .overlay(
                            ZStack {
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .clipShape(ClipShape(amount: CGFloat(amount)/100))
                                    .padding()
                                    .foregroundStyle(.blue.opacity(0.5))
                                
                                Text("\(amount)%")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .fontDesign(.monospaced)
                                    .padding(.top, 10)
                            }
                                .padding(.top, 15)
                            
                        )
                        .foregroundStyle(.blue.opacity(0.5))
                    
                    let motivations: [(range: Range<Int>, message: String)] = [
                        (0..<20, "Time to Start"),
                        (20..<50, "Keep Pushing"),
                        (50..<80, "Don't Stop"),
                        (80..<100, "Almost There"),
                        (100..<1000, "You Finished"),
                        (1000..<5000, "stop drinking u gonna die")
                    ]
                    
                    VStack {
                        ForEach(motivations, id: \.message) { motivation in
                            if motivation.range.contains(amount) {
                                Text("\(motivation.message), Justin!")
                                    .font(.title2)
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                        }
                        
                        Text("Goal: ")
                            .fontWeight(.semibold)
                        + Text("\(mlDrunk) / \(mlNeeded) mL")
                        
                        Text(mlDrunk > mlNeeded ? "You've completed your goal- but don't stop now! Keep pushing!" : "Make sure to drink water every hour to stay hydrated & reach your goal!")
                            .font(.footnote)
                            .italic()
                            .padding(.top, 5)
                    }
                    .padding(.vertical)
                }
                
                Divider()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                    )
                    .padding()
                
                Text("Select Your Water Bottle")
                    .font(.title2)
                    .bold()
                
                let drinks = [18, 20, 24, 32]
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 50) {
                        ForEach(drinks, id: \.self) { drink in
                            Button(action: {
                                isPresented = true
                            }) {
                                VStack(alignment: .leading) {
                                    ZStack {
                                        Image("\(drink) Ounce")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 250)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(.blue)
                                            .opacity(0.25)
                                    )
                                    .overlay(
                                        ZStack(alignment: .topLeading) {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top))
                                                .opacity(0.25)
                                        }
                                    )
                                    
                                    Text("\(drink) Ounce")
                                        .font(.callout.lowercaseSmallCaps())
                                        .bold()
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                }
                                .sheet(isPresented: $isPresented) {
                                    SheetView(
                                        isPresented: $isPresented, mlDrunk: $mlDrunk, confettiTrigger: $confettiTrigger
                                    )
                                        .presentationDetents([.fraction(0.43)])
                                        .presentationDragIndicator(.visible)
                                }
                                .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1.1 : 0.9)
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 20)
            }
            .confettiCannon(counter: $confettiTrigger, num: 75, radius: 500.0)
            .preferredColorScheme(.dark)
            .padding()
            .padding([.horizontal, .top], 13)
        } header: {
            HStack {
                Text("HydroHelper")
                    .font(.largeTitle.lowercaseSmallCaps())
                    .bold()
                    .fontDesign(.rounded)
                
                Spacer()
                
                Image(systemName: "gearshape.fill")
                    .imageScale(.large)
            }
            .shadow(radius: 2)
            .frame(maxWidth: .infinity)
            .padding(18)
            .padding(.horizontal)
            .padding(.bottom, 5)
            .background(.blue.opacity(0.5))
        }
    }
}

struct ClipShape: Shape {
    var amount: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(CGRect(
            x: 0,
            y: rect.height * (1 - amount),
            width: rect.width,
            height: rect.height * amount)
        )
        return path
    }
}

#Preview {
    ContentView()
}
