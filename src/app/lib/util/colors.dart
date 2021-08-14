import 'package:flutter/material.dart';

/// テーマカラー
const int ume = 0xffb40926; // 赤：梅
const int tachibana = 0xffd7ad10; // 橙：橘
const int kiku = 0xffffef20; // 黄：菊
const int wakakusa = 0xff29905e; // 緑：若草
const int asagao = 0xff2e6a87; // 青：朝顔
const int sumire = 0xff692755; // 紫：すみれ
const int momo = 0xffd35871; // 桃：桃
const int unohana = 0xfffcfaf5; // 白：卯の花
const int kurumi = 0xffc38458; // 茶：胡桃
const defaultColor = 0xff6d888c; // デフォルトカラー
// const defaultColor = 0xff8aa2a9; // デフォルトカラー

/// テーマカラーのenum
enum ThemeColor {
  ume,
  tachibana,
  kiku,
  wakakusa,
  asagao,
  sumire,
  momo,
  kurumi,
  defaultColor,
}

/// テーマカラー拡張
extension ThemeColorExtension on ThemeColor {
  /// 色のゲッター
  Color get color {
    switch (this) {
      case ThemeColor.ume:
        return Color(ume);
      case ThemeColor.tachibana:
        return Color(tachibana);
      case ThemeColor.kiku:
        return Color(kiku);
      case ThemeColor.wakakusa:
        return Color(wakakusa);
      case ThemeColor.asagao:
        return Color(asagao);
      case ThemeColor.sumire:
        return Color(sumire);
      case ThemeColor.momo:
        return Color(momo);
      case ThemeColor.kurumi:
        return Color(kurumi);
      default:
        return Color(defaultColor);
    }
  }

  /// 色名のゲッター
  String get name {
    switch (this) {
      case ThemeColor.ume:
        return 'Ume';
      case ThemeColor.tachibana:
        return 'Tachibana';
      case ThemeColor.kiku:
        return 'Kiku';
      case ThemeColor.wakakusa:
        return 'Wakakusa';
      case ThemeColor.asagao:
        return 'Asagao';
      case ThemeColor.sumire:
        return 'Sumire';
      case ThemeColor.momo:
        return 'Momo';
      case ThemeColor.kurumi:
        return 'Kurumi';
      default:
        return 'Default color';
    }
  }

  /// カラーコードから色名を取得する
  static String getName(int color) {
    switch (color) {
      case ume:
        return 'Ume';
      case tachibana:
        return 'Tachibana';
      case kiku:
        return 'Kiku';
      case wakakusa:
        return 'Wakakusa';
      case asagao:
        return 'Asagao';
      case sumire:
        return 'Sumire';
      case momo:
        return 'Momo';
      case kurumi:
        return 'Kurumi';
      default:
        return 'Default color';
    }
  }
}

/// パーツの色
const int dividerColor = 0xffe1e4e4; // 区切り線
