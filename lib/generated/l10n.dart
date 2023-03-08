// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Форма для измениие или добавление!`
  String get form_dialog {
    return Intl.message(
      'Форма для измениие или добавление!',
      name: 'form_dialog',
      desc: '',
      args: [],
    );
  }

  /// `Наименование`
  String get name {
    return Intl.message(
      'Наименование',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Описание`
  String get description {
    return Intl.message(
      'Описание',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Изменить`
  String get edit {
    return Intl.message(
      'Изменить',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Удалить`
  String get delete {
    return Intl.message(
      'Удалить',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить`
  String get save {
    return Intl.message(
      'Сохранить',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Отмена`
  String get cancel {
    return Intl.message(
      'Отмена',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Каталог`
  String get catalog {
    return Intl.message(
      'Каталог',
      name: 'catalog',
      desc: '',
      args: [],
    );
  }

  /// `Родитель`
  String get parent {
    return Intl.message(
      'Родитель',
      name: 'parent',
      desc: '',
      args: [],
    );
  }

  /// `Добавить`
  String get add {
    return Intl.message(
      'Добавить',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Просим заплнить поля`
  String get validate {
    return Intl.message(
      'Просим заплнить поля',
      name: 'validate',
      desc: '',
      args: [],
    );
  }

  /// `Каталог`
  String get catalog_page_name {
    return Intl.message(
      'Каталог',
      name: 'catalog_page_name',
      desc: '',
      args: [],
    );
  }

  /// `Продукты`
  String get product_page_name {
    return Intl.message(
      'Продукты',
      name: 'product_page_name',
      desc: '',
      args: [],
    );
  }

  /// `Хотите удалить ?`
  String get wanttoremove {
    return Intl.message(
      'Хотите удалить ?',
      name: 'wanttoremove',
      desc: '',
      args: [],
    );
  }

  /// `Продукты`
  String get product {
    return Intl.message(
      'Продукты',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Харак-ка`
  String get characteristic {
    return Intl.message(
      'Харак-ка',
      name: 'characteristic',
      desc: '',
      args: [],
    );
  }

  /// `характеристики`
  String get characteristics {
    return Intl.message(
      'характеристики',
      name: 'characteristics',
      desc: '',
      args: [],
    );
  }

  /// `Значение`
  String get valuename {
    return Intl.message(
      'Значение',
      name: 'valuename',
      desc: '',
      args: [],
    );
  }

  /// `Курс валют`
  String get exchange {
    return Intl.message(
      'Курс валют',
      name: 'exchange',
      desc: '',
      args: [],
    );
  }

  /// `Валюта`
  String get rate {
    return Intl.message(
      'Валюта',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Курс`
  String get valuerate {
    return Intl.message(
      'Курс',
      name: 'valuerate',
      desc: '',
      args: [],
    );
  }

  /// `Дата`
  String get date {
    return Intl.message(
      'Дата',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Основное`
  String get main {
    return Intl.message(
      'Основное',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  /// `Цены`
  String get price {
    return Intl.message(
      'Цены',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Цена в `
  String get priceUE {
    return Intl.message(
      'Цена в ',
      name: 'priceUE',
      desc: '',
      args: [],
    );
  }

  /// `Сум`
  String get sum {
    return Intl.message(
      'Сум',
      name: 'sum',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
