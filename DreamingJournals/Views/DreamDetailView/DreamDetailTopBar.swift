//
//  DreamDetailTopBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailTopBar: View {
    var body: some View {
        return HStack(alignment : .center,spacing : .medium){
            BackButton()
            Spacer()
            SaveButton()
        }
    }
}

private struct SaveButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    @State var message = ""
    
    var body: some View{
        Button(action:saveDream){
            Text(dream.isNewDream ?  "Save" : "Update")
                .foregroundColor(.main1)
                .font(.primaryLarge)
                .padding(.trailing, .medium)
        }.buttonStyle(PlainButtonStyle())
            .alert(isPresented: $showAlert, content: InvalidSaveAlert)
    }
    
    func saveDream(){
        mediumFeedback()
        self.showAlert = false
        let dreamService = DreamService(managedObjectContext: self.moc)
        do {
            try dreamService.saveDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidSave(error: let message) {
            self.message = message
            self.showAlert = true
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    func InvalidSaveAlert() -> Alert{
        Alert(title: Text(self.dream.isNewDream ? "Invalid Save" : "Invalid Update"), message: Text(self.message), dismissButton: .default(Text("OK")))
    }
}


private struct BackButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    
    var body: some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left").foregroundColor(.accent2)
                .padding(.vertical, .small)
                .padding(.horizontal, .medium)
        }.alert(isPresented: $showAlert, content: unsavedChangesAlert)
    }
    
    func backButtonPress(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        keyboardObserver.dismissKeyboard()
        if dreamService.checkForChanges(dream){
            self.showAlert = true
        }else{
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func unsavedChangesAlert() -> Alert {
        Alert(title: Text("Unsaved Changes"), message: Text("You have made changes without saving!"), primaryButton: .destructive(Text("Discard"), action:{
            self.presentationMode.wrappedValue.dismiss()
        }), secondaryButton: .cancel())
    }
}
