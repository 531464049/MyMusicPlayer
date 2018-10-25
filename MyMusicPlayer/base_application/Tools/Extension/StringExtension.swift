//
//  StringExtension.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/12.
//  Copyright © 2018年 马浩. All rights reserved.
//

import Foundation

extension String {
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str!, strLen, result)
        var md5String = "";
        for i in 0 ..< digestLen {
            let obcStrl = String.init(format: "%02x", result[i]);
            md5String.append(obcStrl);
        }
        free(result);
        return md5String
    }
    //MARK: - 转换富文本NSAttributedString
    func toAttributeStr(font:UIFont,color:UIColor) -> NSAttributedString {
        return self.toAttributeStr(font: font, color: color, aligent: NSTextAlignment.left, lineSpace: 7, keming: 0, breakMode: NSLineBreakMode.byTruncatingTail)
    }
    func toAttributeStr(font:UIFont,color:UIColor,aligent:NSTextAlignment) -> NSAttributedString {
        return self.toAttributeStr(font: font, color: color, aligent: aligent, lineSpace: 7, keming: 0, breakMode: NSLineBreakMode.byTruncatingTail)
    }
    func toAttributeStr(font:UIFont,color:UIColor,aligent:NSTextAlignment,lineSpace:CGFloat) -> NSAttributedString {
        return self.toAttributeStr(font: font, color: color, aligent: aligent, lineSpace: lineSpace, keming: 0, breakMode: NSLineBreakMode.byTruncatingTail)
    }
    func toAttributeStr(font:UIFont,color:UIColor,aligent:NSTextAlignment,lineSpace:CGFloat,keming:CGFloat) -> NSAttributedString {
        return self.toAttributeStr(font: font, color: color, aligent: aligent, lineSpace: lineSpace, keming: keming, breakMode: NSLineBreakMode.byTruncatingTail)
    }
    func toAttributeStr(font:UIFont,color:UIColor,aligent:NSTextAlignment,lineSpace:CGFloat,keming:CGFloat,breakMode:NSLineBreakMode) -> NSAttributedString {
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.lineBreakMode = breakMode
        paraStyle.alignment = aligent
        paraStyle.lineSpacing = lineSpace
        
        let attDic : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:color,NSAttributedStringKey.paragraphStyle:paraStyle,NSAttributedStringKey.kern:keming]
        
        let attributeStr = NSAttributedString.init(string: self, attributes: attDic)
        return attributeStr
    }
    //MARK: - 计算字符串在lab中需要的高度/宽度
    func getHeight(labWidth:CGFloat,font:UIFont,lineSpace:CGFloat,keming:CGFloat) -> CGFloat {
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.alignment = NSTextAlignment.left
        paraStyle.lineSpacing = lineSpace
        
        //切记：在计算高度时，如果设置了lineBreakMode，会出现问题（只返回一行的高度）
        
        let attDic : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font:font,NSAttributedStringKey.paragraphStyle:paraStyle,NSAttributedStringKey.kern:keming]
        return self.getSize(attDic: attDic, baseSize: CGSize(width: labWidth, height: CGFloat(MAXFLOAT))).height
    }

    func getWidth(labHeight:CGFloat,font:UIFont,lineSpace:CGFloat,keming:CGFloat) -> CGFloat {
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.alignment = NSTextAlignment.left
        paraStyle.lineSpacing = lineSpace
        
        let attDic : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font:font,NSAttributedStringKey.paragraphStyle:paraStyle,NSAttributedStringKey.kern:keming]
        return self.getSize(attDic: attDic, baseSize: CGSize(width: CGFloat(MAXFLOAT), height:labHeight)).width
    }
    private func getSize(attDic:[NSAttributedStringKey : Any],baseSize:CGSize) -> CGSize {
        let normalText: NSString = self as NSString
        
        let size = normalText.boundingRect(with: baseSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: attDic, context: nil).size
        
        return size
    }

}



























