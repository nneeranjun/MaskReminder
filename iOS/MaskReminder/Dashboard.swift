//
//  Dashboard.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 11/13/20.
//

import SwiftUI
import SwiftUICharts

struct Dashboard: View {
    
    @State private var hasClaimedReward = false
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    let data = ["Streak", "Total"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack() {
                    if !hasClaimedReward {
                        Button("Did you wear your mask today?") {
                            print("yes")
                        }.padding()
                        .foregroundColor(.blue)
                        .background(Color(.systemGray6))
                        .cornerRadius(30)
                        .padding(.bottom, 20)
                    }
                }
                LazyVGrid(columns: columns, alignment: .leading, spacing: 100) {
                    ForEach(data, id: \.self) { item in
                        VStack {
                            Text(item)
                            Text("5")
                                .font(.title)
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Your Dashboard")
            .navigationBarItems(trailing:
                Image(systemName: "person.circle.fill")
                    .font(.title)
            )
            .padding()
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
