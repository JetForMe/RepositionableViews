//
//  ObjectMenuCommands.swift
//
//  Created by Rick Mann on 2024-02-02.
//

import SwiftUI



struct
ObjectMenuCommands : Commands
{
	var	menuName			:	String			=	"Object"
	
	var
	body: some Commands
	{
		CommandMenu(self.menuName)
		{
			Button("Bring to Front")
			{
				self.bringToFrontCommand?()
			}
			Button("Send to Back")
			{
				self.sendToBackCommand?()
			}
		}
	}
    
	@FocusedValue(\.bringToFrontCommand)	private	var		bringToFrontCommand
	@FocusedValue(\.sendToBackCommand)		private	var		sendToBackCommand
}


struct
BringToFrontCommandKey : FocusedValueKey
{
	typealias Value		=	() -> Void
}

struct
SendToBackCommandKey : FocusedValueKey
{
	typealias Value		=	() -> Void
}

extension
FocusedValues
{
	var
	bringToFrontCommand: BringToFrontCommandKey.Value?
	{
		get { self[BringToFrontCommandKey.self] }
		set { self[BringToFrontCommandKey.self] = newValue }
	}
	
	var
	sendToBackCommand: SendToBackCommandKey.Value?
	{
		get { self[SendToBackCommandKey.self] }
		set { self[SendToBackCommandKey.self] = newValue }
	}
}


extension
View
{
	func
	onBringToFront(perform: @escaping () -> ())
		-> some View
	{
		self.focusedSceneValue(\.bringToFrontCommand, perform)
	}
	
	func
	onSendToBack(perform: @escaping () -> ())
		-> some View
	{
		self.focusedSceneValue(\.sendToBackCommand, perform)
	}
}
