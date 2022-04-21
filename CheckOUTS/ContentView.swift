//
//  ContentView.swift
//  CheckOUTS
//
//  Created by Justin Trubela
//

import SwiftUI

struct ContentView: View {
    // View states
    @State var homeScreenView = true
    @State var statsScreenView = false
    @State var gameView = false
    @State var whatsMyOutScreenView = false
    @State var hitOutScreenView = false
    @State var checkoutViewMissed = false
    @State var practiceView = false
    @State var cricketView = false
    @State var loginMenuView = false
    
    // Alerts
    @State private var outSuccessAlert = false
    @State private var noOutFailureAlert = false
    @State private var scoreNotPossible = false
    var scoreNotPossibleErrorMessage = "Score not possible try again"
    var errorMessage = "No Out for this number"
    @State private var outTitle = ""
    @State private var noOutTitle = ""
    
    
    func succesfulOut(){
        outSuccessAlert = true
    }
    
    func checkoutSuccess (){
        outSuccessAlert.toggle()
    }
    
    // Keyboard Modifiers
    @FocusState private var amountIsFocused: Bool
    
    
    // JSON files
    let Checkout1: Checkout = Bundle().decode("CheckoutOption1.json")
    let Checkout2: Checkout = Bundle().decode("CheckoutOption2.json")
    let Checkout3: Checkout = Bundle().decode("CheckoutOption3.json")
    
    //Constant Data
    let validOuts = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,
                     26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
                     51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,
                     76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,
                     101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,
                     120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,
                     141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,160,161,164,167,170]
    
    let invalidOuts = [169,168,166,165,163,162,159]
    
    @State private var practiceNumbers = ["T1", "D1", "S1","T2", "D2", "S2","T3", "D3", "S3","T4", "D4", "S4","T5", "D5", "S5","T6", "D6", "S6","T7", "D7", "S7","T8", "D8", "S8","T9", "D9", "S9","T10", "D10", "S10","T11", "D11", "S11","T12", "D12", "S12","T13", "D13", "S13","T14","D14", "S14","T15", "D15", "S15","T16", "D16", "S16","T17", "D17","S17","T18", "D18", "S18","T19", "D19", "S19","T20", "D20", "S20", "DB", "SB"].shuffled()
    
    
    
    //Login Variables
    @State private var username = ""
    @State private var password = ""
    
    
    
    //Whats my out variables
    @State private var thisOut = 106
    @State private var currentTurnPoints = 0
    
    //Whats my out
    func getOut() {
        if player1Turn{
            thisOut = player1Points
        }
        else{
            thisOut = player2Points
        }
    }
    
    
    //Play 501
    //Home
    var calculationButtons = [" + ", "0", " * "]
    @State private var player1Turn = true
    @State private var player1Name = "Home"
    @State private var player1Points = 501
    @State private var player1Scores = []
    //Away
    @State private var player2Turn = false
    @State private var player2Name = "Away"
    @State private var player2Points = 501
    @State private var player2Scores = []
    //Other
    @State private var currentScore = 0
    @State private var lastScore = 0
    @State private var calculationString = "0"
    @State private var undoLastTurn = 0
    
    func changeTurns(){
        //Changes LED Status for player in 501 game
        player1Turn.toggle()
        player2Turn.toggle()
    }
    func undoTurn() {
        //UNDOING LAST TURN FOR PLAYER
        //While player?'s turn and player? has scored more than 1 turn prior
        //set calc string to 0
        //get last turns points
        //deduct last turns points from total points earned for stats sheet
        //deduct 3 darts from total darts thrown
        //add back the points that were taken away from last round
        //put the last turns points in the calculation bar
        //remove the last turns points from the list of points
        changeTurns()
        calculationString = "0"
        
        if player1Turn && player1Scores.count > 0 && player1Points != 501{
            let endOfPlayer1Scores = player1Scores.count-1
            totalPointsEarnedHome -=  endOfPlayer1Scores
            dartsThrownHome -= 3
            player1Points += player1Scores[endOfPlayer1Scores] as! Int
            calculationString = "\(player1Scores[player1Scores.count-1])"
            player1Scores.removeLast()
            changeTurns()
        }
        else if player2Turn && player2Scores.count > 0 && player2Points != 501{
            let endOfPlayer2Scores = player2Scores.count-1
            totalPointsEarnedAway -=  endOfPlayer2Scores
            dartsThrownAway -= 3
            player2Points += player2Scores[endOfPlayer2Scores] as! Int
            calculationString = "\(player2Scores[player2Scores.count-1])"
            player2Scores.removeLast()
            changeTurns()
        }
        changeTurns()
    }
    func restartGame(){
        //Restart game points 501
        //Empty player1 & player2 point arrays
        //Reset calculation string
        player1Points = 501
        player2Points = 501
        player1Scores.removeAll()
        player2Scores.removeAll()
        resetCalculationString()
    }
    func resetCalculationString(){
        calculationString = "0"
    }
    
    func appendToCalculationString(text: String){
        if calculationString == "0"{
            calculationString = ""
            calculationString += "\(text)"
        }
        else{
            calculationString += "\(text)"
        }
    }
    
    
    
    //Cricket variables
    //Home
    @State private var player1CRICKETPoints = 0
    //Away
    @State private var player2CRICKETpoints = 0
    
    //------------------------------------------------------------------------------------------------------------
    //                          STATISTICS VARIABLES/FUNCTIONS/COMPUTED PROPERTIES
    //------------------------------------------------------------------------------------------------------------
    //Home
    @State private var dartsThrownHome = 0
    @State private var ThreeDartAverageHome = 0.0
    @State private var highestTurnHome = 0
    @State private var attemptsAtOutHome = 0
    @State private var totalPointsEarnedHome = 0
    @State private var dartsThrownAtOutHome = 0
    //Away
    @State private var dartsThrownAway = 0
    @State private var ThreeDartAverageAway = 0.0
    @State private var highestTurnAway = 0
    @State private var attemptsAtOutAway = 0
    @State private var totalPointsEarnedAway = 0
    @State private var dartsThrownAtOutAway = 0
    //Other
    func checkHighestScore(_ : Int){
        // Update new highest turn score for player?
        if player1Turn && currentScore > highestTurnHome {
            highestTurnHome = currentScore
        }
        if player2Turn && currentScore > highestTurnAway {
            highestTurnAway = currentScore
        }
    }
    
    var calculate3DartAverageHome: String {
        dartsThrownHome > 0 ? "\((totalPointsEarnedHome/dartsThrownHome)*3) PPR" : "0.0 PPR"
    }
    var calculate3DartAverageAway: String {
        dartsThrownAway > 0 ? "\((totalPointsEarnedAway/dartsThrownAway)*3) PPR" : "0.0 PPR"
    }
    
    var calculateOutAverage: String {
        if (player1Turn){
            if (attemptsAtOutHome > 0) {
                return "\(attemptsAtOutHome/dartsThrownAtOutHome) %"
            }
        }
        else if (player2Turn) {
            if (attemptsAtOutAway > 0){
                return "\(attemptsAtOutAway/dartsThrownAtOutAway) %"
            }
        }
        return "0.0 %"
    }
    
    
    //Practice game variables
    @State private var practiceHits = 0
    @State private var practiceMisses = 0
    @State private var practiceAttempts = 0
    @State private var practice_HighestHit = 0
    @State private var currentPracticeNumber = 0
    
    var randNum = Int.random(in: 1..<62)
    
    var getPracticeNumber: String {
        return practiceNumbers[randNum]
    }
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.black,.gray]),
                startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            if homeScreenView{
                VStack{
                    HStack{
                        Button("Log in"){
                            homeScreenView.toggle()
                            loginMenuView.toggle()
                        }
                        .padding(30)
                        
                        Spacer()
                        
                        Button("Today's Stats"){
                            homeScreenView.toggle()
                            statsScreenView.toggle()
                        }
                        .padding(30)
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text("iPlay Darts")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        TextField("Enter Player 1 Name", text: $player1Name)
                            .MakeTextFieldEntry()
                            .shadow(color: .blue, radius: 10, x: 8, y: 2)
                        
                        TextField("Enter Player 2 Name", text: $player2Name)
                            .MakeTextFieldEntry()
                            .shadow(color: .blue, radius: 10, x: 8, y: 2)
                        
                    }.padding(10)
                    Spacer()
                    Spacer()
                    VStack{
                        Button("What's My Out?"){
                            whatsMyOutScreenView = true
                            checkoutViewMissed = false
                            homeScreenView = false
                            gameView = false
                            practiceView = false
                        }
                        .MakeWhiteButton()
                        
                        HStack{
                            Button("501"){
                                whatsMyOutScreenView = false
                                checkoutViewMissed = false
                                homeScreenView = false
                                gameView = true
                            }
                            .MakeWhiteButton()
                            
                            Button("Cricket"){
                                homeScreenView = false
                                cricketView = true
                            }
                            .MakeWhiteButton()
                        }
                        Button("Practice Game"){
                            whatsMyOutScreenView = false
                            checkoutViewMissed = false
                            homeScreenView = false
                            gameView = false
                            practiceView = true
                        }
                        .MakeWhiteButton()
                        
                    }
                    .foregroundColor(.black)
                    .font(.title)
                    Spacer()
                }
            }
            else if loginMenuView{
                VStack{
                    HStack{
                        Button("Main Menu"){
                            homeScreenView = true
                            loginMenuView = false
                        }.padding(30)
                        Spacer()
                        Button("New User"){
                            
                        }.padding(30)
                    }
                    
                    Spacer()
                    
                    Text("Welcome Back!").font(.largeTitle.bold()).foregroundColor(Color.white)
                    
                    
                    
                    TextField("Enter Email Address", text: $username)
                        .MakeTextFieldEntry()
                        .shadow(color: .white, radius: 10, x: 8, y: 2)
                    TextField("Enter Password", text: $password)
                        .MakeTextFieldEntry()
                        .shadow(color: .white, radius: 10, x: 8, y: 2)
                    
                    
                    HStack{
                        Spacer()
                        Spacer()
                        Button(){
                            
                        } label: {
                            Text("Forgot Password")
                        }
                        Spacer()

                        Button(){
                            player1Name = "Justin"
                            homeScreenView.toggle()
                            loginMenuView.toggle()
                        }label: {
                            Text("Login")
                        }
                        .MakeGreenButton()
                        Spacer()
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                }
            }
            else if statsScreenView{
                VStack{
                    HStack{
                        Button("Play 501"){
                            statsScreenView.toggle()
                            gameView.toggle()
                        }.padding(30)
                        Spacer()
                        Button("Main Menu"){
                            statsScreenView.toggle()
                            homeScreenView.toggle()
                        }.padding(30)
                    }
                    Spacer()
                    Text("Today's Statistics").foregroundColor(.white).font(.title.bold())
                    Spacer()
                    VStack{
                        Spacer()
                        //501 STATISTICS
                        Section{
                            HStack{
                                Spacer()
                                //Home
                                Section{
                                    VStack{
                                        Text("\(player1Name)").foregroundColor(.yellow).font(.title3.bold())
                                        //Darts thrown
                                        Text("Darts thrown: \(dartsThrownHome)")
                                        //Highest Turn
                                        Text("Highest Turn: \(highestTurnHome)")
                                        //3 Dart Average
                                        Text("3 Dart Avg.: \(calculate3DartAverageHome)")
                                        //Check Out Percentage
                                        Text("Checkout %: \(calculateOutAverage)")
                                    }
                                }
                                Spacer()
                                //Away
                                Section{
                                    VStack{
                                        Text("\(player2Name)").foregroundColor(.yellow).font(.title3.bold())
                                        //Darts thrown
                                        Text("Darts thrown: \(dartsThrownAway)")
                                        //Highest Turn
                                        Text("Highest Turn: \(highestTurnAway)")
                                        //3 Dart Average
                                        Text("3 Dart Avg.: \(calculate3DartAverageAway)")
                                        //Check Out Percentage
                                        Text("Checkout %: \(calculateOutAverage)")
                                    }
                                }
                                Spacer()
                            }
                        } header: {
                            Text("501").font(.title2)
                        }
                        Spacer()
                        //CRICKET STATISTICS
                        Section{
                            Text("Under Construction").foregroundColor(.red)
                        } header: {
                            Text("Cricket").font(.title2)
                        }
                        Spacer()
                        //PRACTICE STATISTICS
                        Section{

                            Text("Attempts: \(practiceAttempts)")
                            Text("Attempts Hit: \(practiceHits)")
                            Text("Attempts Missed: \(practiceMisses)")
                        } header: {
                            Text("Practice").font(.title2)
                        }
                        Spacer()
                    }.foregroundColor(.white)
                }
            }
            else if gameView {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button("Quit"){
                            player1Points = 501
                            player2Points = 501
                            gameView = false
                            homeScreenView = true
                            calculationString = "0"
                        }
                        Spacer()
                        Button("Main Menu"){
                            homeScreenView = true
                            gameView = false
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    //------------------PLAYER1&2 SCORES/NAMES + LEDS--------------------
                    Section{
                        HStack{
                            Spacer()
                            //Player 1&2 score
                            VStack{
                                HStack{
                                    Spacer()
                                    VStack{
                                        Button(){
                                            player1Turn.toggle()
                                            player2Turn.toggle()
                                        } label: {
                                            Image(player1Turn ? "LEDOn" : "LEDOff")
                                                .resizable()
                                                .frame(width: 40, height: 40, alignment: .center)
                                        }
                                        Text("\(player1Name)").foregroundColor(.white).font(.title3)
                                    }
                                    Spacer()
                                    Button(){
                                        restartGame()
                                    } label: {
                                        Image(systemName: "arrow.triangle.2.circlepath.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .tint(.green)
                                        
                                    }
                                    Spacer()
                                    VStack{
                                        Button(){
                                            player1Turn.toggle()
                                            player2Turn.toggle()
                                        } label: {
                                            Image(player2Turn ? "LEDOn" : "LEDOff")
                                                .resizable()
                                                .frame(width: 40, height: 40, alignment: .center)
                                        }
                                        Text("\(player2Name)")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    VStack{
                                        
                                        
                                        Text("\(player1Points)")
                                            .MakePlayerPointsBox()
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    VStack{
                                        
                                        
                                        Text("\(player2Points)")
                                            .MakePlayerPointsBox()
                                    }
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                    //-------------------------CALCULATION STRING------------------------
                    Section{
                        HStack{
                            
                            Text("\(calculationString)")
                                .MakeCalculationStringBox()
                            Button("C"){
                                calculationString = "0"
                            }
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    //--------------------------CALC BUTTONS-----------------------------
                    Section{
                        VStack{
                            Spacer()
                            HStack{
                                ForEach(7..<10) { number in
                                    Button {
                                        appendToCalculationString(text: "\(String(number))")
                                    } label : {
                                        Text("\(String(number))")
                                            .MakeNumberButtonBackground()
                                    }
                                }
                            }
                            HStack{
                                ForEach(4..<7) { number in
                                    Button {
                                        appendToCalculationString(text: "\(String(number))")
                                    } label : {
                                        Text("\(String(number))")
                                            .MakeNumberButtonBackground()
                                    }
                                }
                            }
                            HStack{
                                ForEach(1..<4) { number in
                                    Button {
                                        appendToCalculationString(text: "\(String(number))")
                                    } label : {
                                        Text("\(String(number))")
                                            .MakeNumberButtonBackground()
                                    }
                                }
                            }
                            HStack{
                                ForEach(0..<3) { button in
                                    Button {
                                        appendToCalculationString(text: "\(calculationButtons[button])")
                                    } label : {
                                        Text("\(calculationButtons[button])")
                                            .MakeNumberButtonBackground()
                                    }
                                }
                            }

                            //----------------------ENTER AND BACK BUTTON------------------------
                            Section{
                                HStack{
                                    Button(){
                                        let expn = NSExpression(format:"\(calculationString)")
                                        currentScore = expn.expressionValue(with: nil, context: nil)as! Int
                                        
                                        if currentScore > 180 {
                                            scoreNotPossible = true
                                        }
                                        else{
                                            lastScore = currentScore
                                            checkHighestScore(currentScore)
                                            
                                            if player1Turn == true{
                                                player1Scores.append(currentScore)
                                                player1Points = player1Points - currentScore
                                                dartsThrownHome += 3
                                                totalPointsEarnedHome += currentScore
                                                
                                            }
                                            if player2Turn == true {
                                                player2Points =  player2Points - currentScore
                                                player2Scores.append(currentScore)
                                                dartsThrownAway += 3
                                                totalPointsEarnedAway += currentScore
                                                
                                            }
                                            calculationString = "0"
                                            currentScore = 0
                                            undoLastTurn = 0
                                            changeTurns()
                                        }
                                        
                                    } label: {
                                        Text("Enter").foregroundColor(.green)
                                    }
                                    .frame(width: 240, height: 80, alignment: .center)
                                    .MakeEnterAndClearButtonBackground()
                                    .alert(scoreNotPossibleErrorMessage, isPresented: $scoreNotPossible) {
                                        Button("Continue", action: resetCalculationString)
                                    }
                                    
                                    Button(){
                                        undoTurn()
                                    } label: {
                                        VStack{
                                            Image(systemName: "arrow.uturn.backward")
                                            Text("Undo Last Turn")
                                                .font(.caption)
                                        }
                                    }
                                    .frame(width: 120, height: 80, alignment: .center)
                                    .MakeEnterAndClearButtonBackground()
                                }
                            }
                            Spacer()
                        }
                    }
                    .font(.largeTitle).foregroundColor(.black)
                    Spacer()
                    //-----------WHATS MY OUT QUIT/HOME/WHATSMYOUT/MENU BUTTONS----------
                    Section{
                        HStack{
                            Button("What's My Out?"){
                                getOut()
                                whatsMyOutScreenView = true
                                checkoutViewMissed = false
                                homeScreenView = false
                                gameView = false
                                practiceView = false
                            }.MakeButtonWhite()
                        }
                    }
                }
            }
            else if whatsMyOutScreenView{
                VStack{
                    //-------------------------ENTER SCORE TEXTFIELD---------------------
                    Section{
                        VStack{
                            Spacer()
                            TextField("Enter Score", value: $thisOut, format: .number)
                                .MakeRoundedSquareBackground()
                                .frame(width: 100, height: 10, alignment: .center)
                                .padding(20)
                                .foregroundColor(.black)
                                .font(.largeTitle.weight(.heavy))
                                .keyboardType(.numberPad)
                                .focused($amountIsFocused)
                                .frame(width: 150, height: 30, alignment: .center).padding()
                            Text("Remaining")
                                .foregroundColor(.white)
                                .font(.title2)
                                .frame(width: 250, height: 5, alignment: .center)
                            Spacer()
                        }
                    }
                    Spacer()
                    //-------------------------HIT OR MISS BUTTONS-----------------------
                    Section{
                        HStack {
                            Spacer()
                            Button {
                                //SHOW ALERT
                                outSuccessAlert = true
                            } label: {
                                Image("Hit")
                            }.shadow(radius: 20)
                            Spacer()
                            Button{
                                checkoutViewMissed = true
                                whatsMyOutScreenView = false
                                currentTurnPoints = 0
                            } label: {
                                Image("Miss")
                            }.shadow(radius: 20)
                            Spacer()
                        }.padding(25)
                    }
                    Spacer()
                    //------------------------------OPTIONS------------------------------
                    Section{
                        VStack{
                            Spacer()
                            Section{
                                OutText(text: "\(Checkout1.checkoutOptions.first?["\(thisOut)"]?.out ?? "")")
                            } header: {
                                OptionText(text: "     Option 1:")
                            }
                            Spacer()
                            Section{
                                OutText(text: "\(Checkout2.checkoutOptions.first?["\(thisOut)"]?.out ?? "")")
                            } header: {
                                OptionText(text: "     Option 2:")
                            }
                            Spacer()
                            Section{
                                OutText(text: "\(Checkout3.checkoutOptions.first?["\(thisOut)"]?.out ?? "")")
                            } header: {
                                OptionText(text: "     Option 3:")
                            }
                            Spacer()
                        }.MakeRoundedSquareBackground().padding(5)
                    }
                    //-------------------------WHATS MY OUT BUTTONS----------------------
                    Spacer()
                    Spacer()
                    Section{
                        HStack {
                            Button("New Out"){
                                whatsMyOutScreenView = false
                                hitOutScreenView = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                            .shadow(radius: 10)
                            Button("Back to 501"){
                                whatsMyOutScreenView = false
                                checkoutViewMissed = false
                                homeScreenView = false
                                gameView = true
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.black)
                            .tint(Color.white)
                            .shadow(radius: 10)
                            Button("Main Menu"){
                                whatsMyOutScreenView = false
                                checkoutViewMissed = false
                                homeScreenView = true
                                gameView = false
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .tint(.red)
                            .shadow(radius: 10)
                        }.foregroundColor(.black).font(.title2)
                    }
                    Spacer()
                    Spacer()
                    //-------------------------WHATS MY OUT BUTTONS----------------------
                }.alert(outTitle, isPresented: $outSuccessAlert) {
                    Button("Continue"){}
                } message: {
                    Text("Nice Shot\n Added to your stats")
                }.keyboardType(.numberPad)
            }
            else if hitOutScreenView{
                ZStack {
                    RadialGradient(stops: [
                        .init(color: Color(red: 0.0 , green: 0.5, blue: 0.0) , location: 0.3),
                        .init(color: .black, location: 0.7),
                    ],   center: .center, startRadius: 0, endRadius: 350).ignoresSafeArea()
                    VStack {
                        VStack{
                            //--------------------------ENTER THE OUT-------------------------
                            Section{
                                TextField("Enter", value: $thisOut, format: .number)
                                    .padding()
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .background(.thinMaterial)
                                    .frame(width: 100, height: 50, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .keyboardType(.numberPad)
                                    .focused($amountIsFocused)
                            } header: {
                                Text("Enter new out").font(.largeTitle)
                            }
                            //------------------------GET NEW OUT BUTTON----------------------
                            Section{
                                Button("Get New Out"){
                                    if thisOut > 170
                                        || thisOut <= 1
                                        || thisOut == invalidOuts[0]
                                        || thisOut == invalidOuts[1]
                                        || thisOut == invalidOuts[2]
                                        || thisOut == invalidOuts[3]
                                        || thisOut == invalidOuts[4]
                                        || thisOut == invalidOuts[5]
                                        || thisOut == invalidOuts[6]
                                    {
                                        noOutFailureAlert = true
                                        noOutTitle = "No out for this number. Try again"
                                    }
                                    else{
                                        whatsMyOutScreenView = true
                                        hitOutScreenView = false
                                    }
                                }.buttonStyle(.borderedProminent)
                                    .font(.title)
                                    .cornerRadius(20).font(.title3).tint(.black).frame(width: 200, height: 60, alignment: .center)
                            }
                        }
                    }
                }.alert(noOutTitle, isPresented: $noOutFailureAlert) {
                    Button("Continue"){
                        hitOutScreenView = true
                    }
                }
            }
            else if practiceView{
                VStack{
                    //-------------------------TITLE---------------------------
                    Section{
                        VStack{
                            Text("Practice Game")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    //--------------------HIT NUMBER PROMPT--------------------
                    Section{
                        VStack{
                            Text("Hit \(getPracticeNumber)")
                                .MakePracticeNumberWindow()
                        }
                    }
                    Spacer()
                    //--------------------HITS/MISS BUTTONS--------------------
                    Section{
                        HStack {
                            Spacer()
                            Button {
                                practiceNumbers.shuffle()
                                practiceHits += 1
                            } label: {
                                Image("Hit")
                            }.shadow(radius: 20)
                            
                            Spacer()
                            Button{
                                practiceNumbers.shuffle()
                                practiceMisses += 1
                            } label: {
                                Image("Miss")
                            }.shadow(radius: 20)
                            Spacer()
                        }
                    }
                    Spacer()
                    //--------------------ROUND STATISTICS---------------------
                    Section{
                        VStack{
                            HStack{
                                Spacer()
                                Text("Hit:  \(practiceHits)  ").font(.title.bold()).foregroundColor(.green)
                                Spacer()
                                Text("      Missed: \(practiceMisses)").font(.title.bold())
                                Spacer()
                            }
                            .font(.title3).foregroundColor(.green)
                            
                            Text("Hits/Misses: \(practiceHits)/\(practiceMisses)")
                                .font(.title.bold()).foregroundColor(.black)
                        }
                        Spacer()
                    }
                    //-----------------------MENU BUTTON-----------------------
                    Section{
                        Button("Main Menu"){
                            homeScreenView = true
                            practiceView = false
                        }
                        .MakeButtonWhite()
                    }
                    .foregroundColor(.black).font(.title2)
                }
                Spacer()
            }
            else if checkoutViewMissed{
                ZStack {
                    RadialGradient(stops: [
                        .init(color: Color(red: 0.5 , green: 0.0, blue: 0.0) , location: 0.3),
                        .init(color: .black, location: 0.7),
                    ],   center: .center, startRadius: 0, endRadius: 350).ignoresSafeArea()
                    VStack(spacing: 50){
                        Spacer()
                        //-----------------------TITLE-------------------------
                        Section{
                            Text("CHECKOUT MISSED")
                                .foregroundColor(.white)
                                .padding()
                                .fixedSize()
                                .font(.largeTitle)
                        }
                        Spacer()
                        //---------------ENTER POINTS FOR TURN-----------------
                        //---------------------TEXTFIELD-----------------------
                        Section{
                            VStack {
                                Section{
                                    TextField("Enter points scored on this turn", value: $currentTurnPoints, format: .number)
                                        .padding()
                                        .foregroundColor(.black)
                                        .font(.title2)
                                        .background(.thinMaterial)
                                        .frame(width: 100, height: 50, alignment: .center)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .keyboardType(.numberPad)
                                        .focused($amountIsFocused)
                                } header: {
                                    Text("Enter points scored on this turn").foregroundColor(.white)
                                }
                                
                            }.MakeCapsuledBackground()
                        }
                        Spacer()
                        //---------------GET NEW OUT BUTTON--------------------
                        Section{
                            VStack {
                                Button("Get New Out", role: .destructive){
                                    thisOut = thisOut-currentTurnPoints
                                    whatsMyOutScreenView = true
                                    checkoutViewMissed = false
                                }
                                .buttonStyle(.borderedProminent)
                                .font(.title)
                                .padding(40)
                            }.foregroundColor(.white).font(.title2).fixedSize()
                        }
                        Spacer()
                    }
                }
            }
            else if cricketView{
                //------------------PLAYER1&2 SCORES/NAMES + LEDS--------------------
                VStack{
                    Section{
                        HStack{
                            Spacer()
                            //Player 1&2 score
                            VStack{
                                HStack{
                                    Spacer()
                                    VStack{
                                        Button(){
                                            player1Turn.toggle()
                                            player2Turn.toggle()
                                        } label: {
                                            Image(player1Turn ? "LEDOn" : "LEDOff")
                                                .resizable()
                                                .frame(width: 40, height: 40, alignment: .center)
                                        }
                                        Text("\(player1Name)")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                    Spacer()
                                    Button(){
                                        restartGame()
                                    } label: {
                                        Image(systemName: "arrow.triangle.2.circlepath.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .tint(.green)
                                        
                                    }
                                    Spacer()
                                    VStack{
                                        Button(){
                                            changeTurns()
                                        } label: {
                                            Image(player2Turn ? "LEDOn" : "LEDOff")
                                                .resizable()
                                                .frame(width: 40, height: 40, alignment: .center)
                                        }
                                        Text("\(player2Name)")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                    Spacer()
                                }
                                //Player Points
                                Section{
                                    HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(player1CRICKETPoints)")
                                                .MakeCricketPointText()
                                        }
                                        Spacer()
                                        VStack{
                                            Text("\(player2CRICKETpoints)")
                                                .MakeCricketPointText()
                                        }
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    // Buttons and Number
                    Section{
                        //Row 1 - 20
                        HStack{
                            ForEach(1..<4){ image in
                                Button(){
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                            Text("20").padding(10)
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                        }.padding(20)
                        //Row 2 - 19
                        HStack{
                            
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                            Text("19").padding(10)
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                        }.padding(20)
                        //Row 3 - 18
                        HStack{
                            
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                            Text("18").padding(10)
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                        }.padding(20)
                        //Row 4 - 17
                        HStack{
                            
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                            Text("17").padding(10)
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                        }.padding(20)
                        //Row 5 - 16
                        HStack{
                            
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                            Text("16").padding(10)
                            ForEach(1..<4){ image in
                                Button(){
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                        }.padding(20)
                        //Row 6 - 15
                        HStack{
                            
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                            Text("15").padding(10)
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                        }.padding(20)
                        //Row 7 - B
                        HStack{
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                            Text("B").padding(10)
                            ForEach(1..<4){ image in
                                Button(){
                                    
                                } label: {
                                    Image(player2Turn ? "LEDOn" : "LEDOff")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                }
                            }
                        }.padding(20)
                    }
                    
                    
                    HStack{
                        Button(){
                            cricketView = false
                            homeScreenView = true
                        } label: {
                            Text("Main Menu")
                        }
                    }
                    
                }
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done"){
                    amountIsFocused = false
                }
            }
        }
    }
}


struct OptionText: View {
    var text: String        //takes in some text
    
    var body: some View {
        Text(text)          //uses that text in some Text and applies modifiers to it
            .font(.subheadline.bold()).italic()
            .frame(minWidth: 50, idealWidth: .infinity, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .leading)
    }
}

struct OutText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .frame(width: 250, height: 30, alignment: .center)
            .foregroundColor(.black)
            .font(.system(size: 40.0))
    }
}

struct SquareBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(5)
    }
}
extension View {
    func MakeRoundedSquareBackground() -> some View {
        modifier(SquareBackground())
    }
}

struct CapsuleBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(50)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 160))
    }
}
extension View {
    func MakeCapsuledBackground() -> some View {
        modifier(CapsuleBackground())
    }
}

struct NumberButtonBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 120, height: 80, alignment: .center)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 10)
    }
}
extension View {
    func MakeNumberButtonBackground() -> some View {
        modifier(NumberButtonBackground())
    }
}


struct EnterAndClearButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .font(.title.bold())
            .foregroundColor(.red)
            .tint(.white)
            .shadow(radius: 10)
            .padding(5)
    }
}
extension View {
    func MakeEnterAndClearButtonBackground() -> some View {
        modifier(EnterAndClearButton())
    }
}

struct TextEntryField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(width: 375, height: 50, alignment: .center)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.title2)
            .padding(5)
    }
}
extension View {
    func MakeTextFieldEntry() -> some View {
        modifier(TextEntryField())
    }
}

struct WhiteButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .shadow(radius: 10)
            .padding(10)
    }
}

extension View {
    func MakeWhiteButton() -> some View {
        modifier(WhiteButton())
    }
}

struct GreenButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .shadow(radius: 10)
            .padding(10)
            .foregroundColor(Color.white)
    }
}
extension View {
    func MakeGreenButton() -> some View {
        modifier(GreenButton())
    }
}


struct PlayerPointsBox: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 150, height: 75, alignment: .center)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .font(.largeTitle.bold())
    }
}
extension View {
    func MakePlayerPointsBox() -> some View {
        modifier(PlayerPointsBox())
    }
}

struct CalculationStringBox: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 275, maxHeight: 75)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.largeTitle)
            .foregroundColor(.black)
            .shadow(radius: 10)
        
    }
}
extension View {
    func MakeCalculationStringBox() -> some View {
        modifier(CalculationStringBox())
    }
}

struct PracticeNumberWindow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 320, maxHeight: 75)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .font(.largeTitle)
            .foregroundColor(.black)
            .shadow(radius: 10)
    }
}
extension View {
    func MakePracticeNumberWindow() -> some View {
        modifier(PracticeNumberWindow())
    }
}

struct CricketPointText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 150, height: 75, alignment: .center)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .font(.largeTitle.bold())
    }
}
extension View {
    func MakeCricketPointText() -> some View {
        modifier(CricketPointText())
    }
}

struct ButtonWhite: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundColor(.black)
            .shadow(radius: 10)
    }
}
extension View {
    func MakeButtonWhite() -> some View {
        modifier(ButtonWhite())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
/*
 Text("testing")
 .onAppear {
 let result: Checkout = Bundle().decode("CheckoutOption1.json")
 print("\n----> result: \(result) ")
 print("\n----> checkoutOptions1: \(result.checkoutOptions1) ")
 print("\n----> first: \(result.checkoutOptions1.first) ")
 print("\n----> 170: \(result.checkoutOptions1.first?["170"]) ")
 print("\n----> 170 out: \(result.checkoutOptions1.first?["170"]?.out) ")
 }
 */
