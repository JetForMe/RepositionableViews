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
				self.bringToFrontCommand?.1()
			}
			.disabled(self.bringToFrontCommand?.0 ?? false)
			
			Button("Send to Back")
			{
				self.sendToBackCommand?.1()
			}
			.disabled(self.sendToBackCommand?.0 ?? false)
		}
	}
    
	@FocusedValue(\.bringToFrontCommand)	private	var		bringToFrontCommand
	@FocusedValue(\.sendToBackCommand)		private	var		sendToBackCommand
}


struct
BringToFrontCommandKey : FocusedValueKey
{
	typealias Value		=	(Bool, () -> Void)
}

struct
SendToBackCommandKey : FocusedValueKey
{
	typealias Value		=	(Bool, () -> Void)
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
//	onBringToFront(disabled: @autoclosure () -> Bool, perform: @escaping () -> ())	//	TODO: Make disabled an autoclosure
	onBringToFront(disabled: Bool = false, perform: @escaping () -> ())	//	TODO: Make disabled an autoclosure
		-> some View
	{
		self.focusedSceneValue(\.bringToFrontCommand, (disabled, perform))
	}
	
	func
	onSendToBack(disabled: Bool = false, perform: @escaping () -> ())
		-> some View
	{
		self.focusedSceneValue(\.sendToBackCommand, (disabled, perform))
	}
}
