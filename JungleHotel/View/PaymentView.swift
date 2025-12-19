//
//  PaymentView.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

import SwiftUI

struct PaymentView: View {
//    below state is for navigation link -- help to move to successscreen connect line 148
    @State var navigateToSuccessScreenVar : Bool = false
    @State var showAlert: Bool = false
    @State var navigationEnable:Bool = false
    @State var isLoginAlready:Bool = false
    @State var userModelPay:UserModel? = nil
    @State var showLoginPopup: Bool = false
    @State var showCompleteView: Bool = false
    
    private let db = Firestore.firestore()
    
    @State var creditCardNumber: String = ""
    var hotelModelPayment: HotelModel
    var roomPayment: Room
    var checkinDatePayment: Date
    var checkoutDatePayment: Date
    @State private var radioBtnSelected: Bool = false
    @State private var isPromotionsChecked: Bool = true
    @FocusState private var isKeyboardFocused: Bool
    
    @State  var numNight: Int = 1
    @State  var pricePerNight: Int64 = 0
    //    tuple below return 2 value (total,discount)
    func totalFunc() ->(String,String) {
        let totalPrice:Int64 = pricePerNight * Int64(numNight)
        let discountPrice:Int64 = totalPrice - totalPrice * 5 / 100
        return ("\(totalPrice.formatted())","\(discountPrice.formatted())")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    //    private func formatTime(_ date: Date) -> String {
    //        let formatter = DateFormatter()
    //        formatter.dateStyle = .none
    //        formatter.timeStyle = .short
    //        return formatter.string(from: date)
    //    }
    //
    var body: some View {
        NavigationStack{
            
        ScrollView{
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Information Payment")
                    .font(.title3)
                    .fontWeight(.bold)
                CheckinCompView(
                    checkInDate: formatDate(checkinDatePayment),
                    checkOutDate: formatDate(checkoutDatePayment),
                    nights: numNight)
                
                //                smallBoxComp(title: "Jungle Hotel", text: "Date check in and out", bgColor: Color.white)
                //
                //                smallBoxComp(title: "", text: "We price match on all hotels", bgColor: Color(hex: "#BFF4BE"))
                HotelSummaryCompView(
                    hotelImage: roomPayment.roomImage.first ?? "",
                    hotelName: roomPayment.roomName,
                    rating: Int(roomPayment.roomRating),
                    reviewScore: 0.0,
                    reviewCount: 0,
                    address: hotelModelPayment.address,
                )
                BigBoxComp(
                    //pay now
                    topTitle: "Room price",
                    topValue:  totalFunc().1,
                    //pay later
                    bottomText: "",
                    bottomValue: totalFunc().0,
                    bgColor: Color(hex: "#F5F5F5"),
                    paymentCondition: "Pay Now", paymentConditionBelow: "Pay Later"
                    
                )
                smallBoxComp(title: "", text: "Service fee: You will be charged on 16 November 2025\n\nIncluded in total price: City tax 1%, Tax 7%, Service charge 10%\n\nYour currency selections affect the prices charged or displayed to you under these terms", bgColor: Color(hex: "#ffffff"))
                
                smallBoxComp(title: "", text: "We have only 4 rooms left", bgColor: Color(hex: "#BFF4BE"))
            
                CheckBoxView(
                    text: "I agree receive update and promotions about Jungle Hotel.",
                    isChecked: $isPromotionsChecked,
                    
                ) {
                    
                }
                BillingAddressView()
                //    we bring pass datat fron payment method component credit card number and bring value here
                
                //cardnumber from payment methos biding
                
                //passdata cardnumber and puit it in creditcardNumber var in payment view
                PaymentMethodComp(cardNumber: $creditCardNumber, isKeyboardFocused: $isKeyboardFocused)
                
                
                let bookingData: [String: Any] = [
                    "checkinDate": formatDate(checkinDatePayment),
                    "checkoutDate": formatDate(checkoutDatePayment),
                    "pricePerNight": pricePerNight,
                    "totalPrice": pricePerNight * Int64(numNight),
                ]
                
                //connect data to sucessful screen
                NavigationLink(
                    destination: SuccessBookView(
                     bookingData: bookingData,
                    ),
                    isActive: $navigateToSuccessScreenVar
                ) {
                    EmptyView()
                }
                //end navigation link
                
                //submit button book now
                ButtonCompView(textBtn: "Book Now",action: {
                    
                    if creditCardNumber.isEmpty {
                        print("Please enter your credit card number")
                        showAlert = true
                        return
                    }else{
                        
                        
                        // start code connect firebase booking after successfull payment
                        
                        // Save user data save to Firestore
                        let now = Timestamp(date: Date())
                       
                        
                        db.collection("booking").document(Auth.auth().currentUser!.uid).setData(bookingData, merge: true) { err in
                            //                            isLoading = false
                            
                            if let err = err {
                                //                                errorMessage = "Account created but failed to save profile: \(err.localizedDescription)"
                                print("❌ Firestore Error: \(err.localizedDescription)")
                                return
                            }
                            navigateToSuccessScreenVar = true
//                            move to sucesful screen pass data from here to sucessfulscreen
                            
                            print("✅ User profile saved to Firestore successfully")
                            // Dismiss the sign-up view on success
                            //                            dismiss()
                        }
               
        
                        //end connect fire base
                        
                        if userModelPay?.id == nil {
                            isLoginAlready = false
                            showLoginPopup = true
                        }else{
                            isLoginAlready = true
                            showCompleteView = true
                        }
                    }
                } )
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Validation Error"),
                        message: Text("Please enter your credit card number"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
            }// end vstack
            .padding(.top, 20)
            .padding(.horizontal, 10)
        }//close scroll view
        .onAppear{
            for family in UIFont.familyNames.sorted() {
                print("Family: \(family)")
                let names = UIFont.fontNames(forFamilyName: family)
                for name in names {
                    print("   → \(name)")
                }
            }
    }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        // hide scroll bar from scrool view
        .onTapGesture {
            isKeyboardFocused = false
        }
        .fullScreenCover(isPresented: $showLoginPopup) {
            PopUpLoginView()
        }
        .fullScreenCover(isPresented: $showCompleteView) {
            CompleteView()
        }
    }
    }//close view
       
}

#Preview {
    // Lightweight mock types and data for preview to avoid initializer mismatches
//    struct MockHotelModel {
//        var id: UUID
//        var name: String
//        var address: String
//    }
//
//    struct MockRoom {
//        var roomImage: [String]
//        var roomName: String
//        var roomAvailbility: Int
//        var roomDetail: String
//        var roomPrice: Int64
//        var roomRating: Int64
//    }
//
//    // Create mock values used only for the preview
//    let mockHotel = MockHotelModel(
//        id: UUID(),
//        name: "Jungle Hotel",
//        address: "123 Jungle Ave, Rainforest"
//    )
//
//    let mockRoom = MockRoom(
//        roomImage: ["sample_room_image"],
//        roomName: "Deluxe Jungle Suite",
//        roomAvailbility: 4,
//        roomDetail: "Spacious room with canopy views and complimentary breakfast.",
//        roomPrice: 12000,
//        roomRating: 5
//    )
//
//    // Bridge mock types to the view's expected types by constructing minimal values
//    // that satisfy the properties PaymentView actually uses.
//    // Since PaymentView expects HotelModel and Room, we recreate minimal instances
//    // using the same property names via local extensions only in preview scope.
//
//    // If HotelModel and Room are available here, create them using minimal values.
//    // Otherwise, provide fallback adapters.
//
//    // Adapter helpers to convert mock structs into the expected types
//    func makeHotelModel(from mock: MockHotelModel) -> HotelModel {
//        // Attempt to use a memberwise initializer if available; otherwise provide a minimal stub.
//        // Replace with the correct initializer if your model differs.
//        return HotelModel(id: mock.id, name: mock.name, address: mock.address)
//    }
//
//    func makeRoom(from mock: MockRoom) -> Room {
//        // Replace with the correct initializer if your model differs.
//        return Room(
//            roomImage: mock.roomImage,
//            roomName: mock.roomName,
//            roomAvailbility: mock.roomAvailbility,
//            roomDetail: mock.roomDetail,
//            roomPrice: mock.roomPrice,
//            roomRating: mock.roomRating
//        )
//    }
//
//    return PaymentView(
//        hotelModelPayment: makeHotelModel(from: mockHotel),
//        roomPayment: makeRoom(from: mockRoom),
//        checkinDatePayment: Date(),
//        checkoutDatePayment: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
//        numNight: 2,
//        pricePerNight: 12000
//    )
}

