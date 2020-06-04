//
//  DreamListHeader.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct HomeDreamListHeaderView : View {
    @Environment(\.colorScheme) var colorScheme
    let hasDreams : Bool
    var body: some View{
        let headerHeight = UIScreen.main.bounds.height / 2
        
        return
            ZStack(alignment:.bottom){
                Sky(mainHeight: headerHeight)
                Mountains(height: headerHeight)
                if hasDreams{
                    FilterButton()
                        .frame(maxWidth : .infinity, alignment: .trailing)
                        .padding(.trailing, .medium)
                }
            }.frame(height  : headerHeight, alignment: .bottom)
    }
}

private struct FilterButton : View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var filterObserver : FilterObserver
    @EnvironmentObject var keyboardObserver : KeyboardObserver

    @State var showFilterSheet  = false
    var body: some View{
        Button(action: {
            mediumFeedback()
            self.showFilterSheet = true
        }){
            HStack{
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(filterObserver.filters.isEmpty ? .main2 : .main1)
                Text("Filter")
                    .foregroundColor(filterObserver.filters.isEmpty ? .main2 : .main1)
            }
        }
        .padding(.horizontal, .medium)
        .padding(.vertical,.small)
        .background(filterObserver.filters.isEmpty ? Color.background1 : .accent1)
        .cornerRadius(.medium)
        .primaryShadow()
        .sheet(isPresented: self.$showFilterSheet){
            HomeFilterSheet(initialFilters: self.$filterObserver.filters)
                .environment(\.managedObjectContext, self.managedObjectContext)
                .environmentObject(self.keyboardObserver)
        }
    }
}


private struct Sky : View {
    @Environment(\.colorScheme) var colorScheme
    let mainHeight : CGFloat
    var body: some View{
        let totalHeight = mainHeight * 10
        let isDarkmode = colorScheme == .dark
        return LinearGradient(
            gradient: Gradient.skyGradient(darkMode: isDarkmode,
                                           totalHeight: totalHeight,
                                           mainHeight: mainHeight),
            startPoint: .bottom,
            endPoint: .top)
            .frame(height : totalHeight)
    }
}

private struct Mountains : View {
    let height : CGFloat
    var body: some View{
        Image("art1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth:UIScreen.main.bounds.width)
    }
}

struct DreamListHeader_Previews: PreviewProvider {
    static var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            VStack {
                HomeDreamListHeaderView(hasDreams: true)
                    .environment(\.managedObjectContext, context)
                Spacer()
            }
        }
    }
}