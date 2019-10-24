import 'session.dart';

class Strings {
  static String t(word) {
    String lang = session.getString('language') ?? 'ru';
    return v[lang][word];
  }

  static final Map v = {
    'ru': {
      'login': 'Логин',
      'signIn': 'Войти',
      'signInCap': 'ВОЙТИ',
      'forgotPass': "Забыли пароль?",
      'email': 'Эл. почта',
      'password': 'Пароль',
      'invalidPassword': 'Неверный пароль',
      'submit': 'Отправить',
      'invalidLogin': 'Неверный логин',
      'logout': 'Выйти',
      'noData': 'Нет данных',
      'dateAndTime': 'Дата и время',
      'ready': 'Готово',
      'dateFrom': 'Дата с',
      'dateTo': 'Дата по',
      'send': 'Отправить',
      'fillField': 'Заполните поле',
      'agro_helper': 'Агро помощник',
      'posts': 'Статьи',
      'save': 'Сохранить',
      'saved': 'Сохранено',
      'saveds': 'Сохраненные',
      'categories': 'Категории',
      'notFound': 'Ничего не найдено',
      'aboutUs': 'О нас',
      'siteKVS': 'Сайт СПТССК «КВС»'
    },
    'ky': {
      'login': 'Логин',
      'signInCap': 'КИРҮҮ',
      'signIn': 'Кирүү',
      'forgotPass': "Парольду унуттуңузбу?",
      'email': 'Эл. почта',
      'password': 'Пароль',
      'invalidPassword': 'Пароль туура эмес',
      'invalidLogin': 'Логин туура эмес',
      'submit': 'Жөнөтүү',
      'logout': 'Чыгуу',
      'noData': 'Маалымат жок',
      'dateAndTime': 'Дата жана убакыт',
      'ready': 'Даяр',
      'from': 'Башы',
      'to': 'Аягы',
      'dateFrom': 'Дата (башы)',
      'dateTo': 'Дата (аягы)',
      'send': 'Жөнөтүү',
      'fillField': 'Маалымат киргизиңиз',
      'agro_helper': 'Агро жардамчы',
      'posts': 'Макалалар',
      'save': 'Сактоо',
      'saved': 'Сакталды',
      'saveds': 'Сакталгандар',
      'categories': 'Категориялар',
      'notFound': 'Эчнерсе табылбады',
      'aboutUs': 'Биз жөнүндө',
      'siteKVS': 'Сайт СПТССК «КВС»'
    }
  };
}
