//
//  ContentView.swift
//  CustomButton
//
//  Created by Prahlad Dhungana on 2025-05-09.
//

import SwiftUI

public enum Icon {
    case left(String)
    case right(String)
}

enum `Type` {
    case `default`(Color)
    case outline(Color)
    case plain
}

struct ButtonData {
    let title: String
    let color: Color
    let icon: Icon?
    let type: `Type`
}

struct InnerView: View {
    let data: ButtonData
    
    var body: some View {
      let label =  Label {
            Text(data.title)
              .foregroundColor(data.color)
        } icon: {
            data.icon.flatMap { icon in
                switch icon {
                case .left(let name), .right(let name):
                    Image(systemName: name)
                        .renderingMode(.template)
                        .foregroundStyle(data.color)
                }
            }
        }
        .padding()
        
        if let icon = data.icon {
            label.labelStyle(.custom(spacing: 5, icon: icon))
        } else { label }
    }
}

struct ButtonView: View {
    let data: ButtonData
    
    var body: some View {
        let innerView = InnerView(data: data)

        switch data.type {
        case .default(let color):
            innerView
                .background(color)
                .cornerRadius(.infinity)
        case .outline(let color):
            innerView
                .background(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(color, lineWidth: 2)
            )
        case .plain:
            innerView
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello world")
    }
}

extension LabelStyle where Self == ButtonStyle {
    @MainActor public static func custom(spacing: CGFloat = 5.0, icon: Icon) -> ButtonStyle {
        ButtonStyle(spacing: spacing, icon: icon)
    }
}

public struct ButtonStyle: LabelStyle {
    let spacing: CGFloat
    let icon: Icon

    public init(spacing: CGFloat, icon: Icon) {
        self.spacing = spacing
        self.icon = icon
    }

    public func makeBody(configuration: Configuration) -> some View {
        switch icon {
        case .left:
            HStack(spacing: spacing) {
                configuration.icon
                configuration.title
            }
        case .right:
            HStack(spacing: spacing) {
                configuration.title
                configuration.icon
            }
        }
    }
}


#Preview {
    VStack(spacing: 20) {
        Group {
            ButtonView(data: .init(title: "plain", color: .blue, icon: nil, type: .plain))
            
            ButtonView(data: .init(title: "plain left icon", color: .blue, icon: .left("square.and.pencil"), type: .plain))
            
            ButtonView(data: .init(title: "plain right icon", color: .blue, icon: .right("square.and.pencil"), type: .plain))
        }
        
        Group {
            ButtonView(data: .init(title: "default", color: .white, icon: nil, type: .default(.blue)))
            
            ButtonView(data: .init(title: "default left icon", color: .white, icon: .left("square.and.pencil"), type: .default(.blue)))
            
            ButtonView(data: .init(title: "default right icon", color: .white, icon: .right("square.and.pencil"), type: .default(.blue)))
        }
        
        Group {
            ButtonView(data: .init(title: "outline", color: .blue, icon: nil, type: .outline(.blue)))
            ButtonView(data: .init(title: "outline left icon", color: .blue, icon: .left("square.and.pencil"), type: .outline(.blue)))
            ButtonView(data: .init(title: "outline right icon", color: .blue, icon: .right("square.and.pencil"), type: .outline(.blue)))

        }
        Spacer()
    }
}
