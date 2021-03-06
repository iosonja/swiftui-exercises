//
//  ContentView.swift
//  Guess the Flag
//
//  Created by Sonja Ek on 23.10.2020.
//
// TODO: one remaining task for challenge day 34
// - And if you tap on the wrong flag? Well, that’s down to you – get creative!


import SwiftUI


struct FlagImage: View {
    var image: String
        
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}


struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria",
                                    "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2) // This picks 3 flags to be shown
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var animationAmount = 0.0  // For button rotation in case of correct answer
    @State private var opacityAmount = 1.0 // For decreasing button's opacity in case of wrong answer
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint:
                            .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.opacityAmount = 0.8
                        self.flagTapped(number)
                    }) {
                        FlagImage(image: (self.countries[number]))
                    }
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animationAmount :
                                                0), axis: (x: 0, y: 1, z: 0))
                    // For button rotation in case of correct answer
                    .opacity(number == self.correctAnswer ? 1 : self.opacityAmount)
                    // For decreasing button's opacity in case of wrong answer
                }
                
                Text("Current score: \(score)")
                    .foregroundColor(.white)
                    .fontWeight(.light)
                Spacer()
            }
        }
        
        // A banner shows after each button press telling whether the answer was correct and the
        // current score
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton:
                    .default(Text("Continue")) {
                    self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer  {
            scoreTitle = "Correct"
            score += 10
            self.animationAmount += 0.0
            
            withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                self.animationAmount = 360  // For button rotation in case of correct answer
            }
        } else {
            scoreTitle = "Wrong! That is the flag of \(countries[number])."
            if score - 2 >= 0 {
                score -= 2
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.animationAmount = 0.0
        withAnimation(.easeInOut) {
            self.opacityAmount = 1.0 // For decreasing button's opacity in case of wrong answer
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
