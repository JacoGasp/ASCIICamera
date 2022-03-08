//
//  ASCIICameraView.swift
//  ASCIICamera
//
//  Created by Jacopo Gasparetto on 07/03/22.
//

import SwiftUI
import Cocoa

struct ASCIICameraView: View {
    @ObservedObject var cameraOutput: CameraOutput
    let densities = [
        "=======--------:::::::::........                  ",
        "=========--------:::::::::........                ",
        "++=========--------:::::::::........              ",
        "++++========---------:::::::::........            ",
        "++++++========---------:::::::::........          ",
        "++++++++=========--------:::::::::........        ",
        "*+++++++++=========--------:::::::::........      ",
        "***+++++++++=========--------:::::::::........    ",
        "******++++++++=========--------:::::::::........  ",
        "********++++++++=========--------:::::::::........",
        "#*********++++++++=========--------:::::::::......",
        "###*********++++++++=========--------:::::::::....",
        "#####********+++++++++=========--------:::::::::..",
        "#######********+++++++++=========--------:::::::::",
        "#########*********++++++++=========--------:::::::",
        "%%#########********+++++++++========---------:::::",
        "%%%%#########********+++++++++=========--------:::",
        "%%%%%%#########********+++++++++=========--------:",
        "%%%%%%%%#########*********++++++++========--------",
        "@@%%%%%%%%#########********+++++++++========------",
        "@@@@%%%%%%%%#########*********++++++++========----",
        "@@@@@@%%%%%%%%#########********+++++++++=========-",
        "@@@@@@@@%%%%%%%%#########********+++++++++========",
        "@@@@@@@@@@%%%%%%%%#########*********++++++++======",
        "@@@@@@@@@@@@%%%%%%%%#########********+++++++++====",
        "¶@ØÆMåBNÊßÔR#8Q&mÃ0À$GXZA5ñk2S%±3Fz¢yÝCJf1t7ªLc¿+?(r/¤²!*;\"^:,'.` ",
        "╬╠╫╋║╉╩┣╦╂╳╇╈┠╚┃╃┻╅┳┡┢┹╀╧┱╙┗┞┇┸┋┯┰┖╲╱┎╘━┭┕┍┅╾│┬┉╰╭╸└┆╺┊─╌┄┈╴╶",
        "█▉▇▓▊▆▅▌▚▞▀▒▐▍▃▖▂░▁▏",
        "◙◘■▩●▦▣◚◛◕▨▧◉▤◐◒▮◍◑▼▪◤▬◗◭◖◈◎◮◊◫▰◄◯□▯▷▫▽◹△◁▸▭◅▵◌▱▹▿◠◃◦◟◞◜",
        "ぽぼゑぜぬあおゆぎゐはせぢがきぱびほげばゟぁたかぞぷれひずどらさでけぉちごえすゎにづぇとょついこぐうぅぃくっしへゞゝ゚゙"
    ]
    
    @State private var selectedDensity = "%%#########********+++++++++========---------:::::"
    
    var body: some View {
        VStack{
            Form {
                Section {
                    Picker("Density Distribution", selection: $selectedDensity) {
                        ForEach(densities, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }.padding(8)
            TextWithAttributes(attributedString: formatText(cameraOutput.text))
                .onChange(of: selectedDensity, perform: { newValue in
                    cameraOutput.density = Array(newValue)
                })
        }
    }
    
    func formatText(_ text: String) -> NSAttributedString {
        let formattedText = NSMutableAttributedString(string: text)
        let range = text.startIndex ..< text.endIndex
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.5
        paragraphStyle.alignment = .center
        formattedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(range, in: text))
        return formattedText
    }
}


class FormattedLabelView : NSView {
    private var label = NSTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.isEditable = false
        label.autoresizingMask = [.width, .height]
        label.maximumNumberOfLines = -1
        label.backgroundColor = .clear
        label.font = NSFont(name: "Courier", size: 14)
        
        label.isBordered = false
        self.addSubview(label)
        self.autoresizesSubviews = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setString(_ attributedString: NSAttributedString) {
        self.label.attributedStringValue = attributedString
    }
}

struct TextWithAttributes: NSViewRepresentable {
    var attributedString: NSAttributedString
    
    func makeNSView(context: Context) -> FormattedLabelView {
        let view = FormattedLabelView(frame: .zero)
        return view
    }
    
    func updateNSView(_ nsView: FormattedLabelView, context: Context) {
        nsView.setString(attributedString)
    }
}
