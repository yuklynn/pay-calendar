import 'package:flutter/material.dart';

/// デフォルトカラー
const defaultColor = 0xff6d888c;
// const defaultColor = 0xff8aa2a9;

/// 赤
const int ume = 0xffb40926; // 梅
/// 橙
const int tachibana = 0xffd7ad10; // 橘
/// 黄
const int kiku = 0xffffef20; // 菊
/// 緑
const int wakakusa = 0xff29905e; // 若草
/// 青
const int asagao = 0xff2e6a87; // 朝顔
/// 紫
const int sumire = 0xff692755; // すみれ
/// 桃
const int momo = 0xffd35871; // 桃
/// 白
const int unohana = 0xfffcfaf5; // 卯の花
/// 茶
const int kurumi = 0xffc38458; // 胡桃

enum FlowerColor {
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

extension FlowerColorExtension on FlowerColor {
  Color get color {
    switch (this) {
      case FlowerColor.ume:
        return Color(ume);
      case FlowerColor.tachibana:
        return Color(tachibana);
      case FlowerColor.kiku:
        return Color(kiku);
      case FlowerColor.wakakusa:
        return Color(wakakusa);
      case FlowerColor.asagao:
        return Color(asagao);
      case FlowerColor.sumire:
        return Color(sumire);
      case FlowerColor.momo:
        return Color(momo);
      case FlowerColor.kurumi:
        return Color(kurumi);
      default:
        return Color(defaultColor);
    }
  }

  String get name {
    switch (this) {
      case FlowerColor.ume:
        return 'Ume';
      case FlowerColor.tachibana:
        return 'Tachibana';
      case FlowerColor.kiku:
        return 'Kiku';
      case FlowerColor.wakakusa:
        return 'Wakakusa';
      case FlowerColor.asagao:
        return 'Asagao';
      case FlowerColor.sumire:
        return 'Sumire';
      case FlowerColor.momo:
        return 'Momo';
      case FlowerColor.kurumi:
        return 'Kurumi';
      default:
        return 'Default color';
    }
  }

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

const int dividerColor = 0xffe1e4e4;
// const int dividerColor = 0xffc0c6c9;
