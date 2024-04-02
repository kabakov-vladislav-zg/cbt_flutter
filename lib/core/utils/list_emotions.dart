import 'package:flutter/material.dart';

class SectionEmotions {
  SectionEmotions({
    required this.name,
    required this.color,
    required this.list,
  });

  String name;
  
  Color color;
  
  List<String> list;
}

List<SectionEmotions> listEmotions = [
  SectionEmotions(
    name: 'Гнев',
    color: Colors.red,
    list: [
      'Бешенство',
      'Ярость',
      'Ненависть',
      'Истерия',
      'Злость',
      'Раздражение',
      'Презрение',
      'Негодование',
      'Обида',
      'Ревность',
      'Уязвленность',
      'Досада',
      'Зависть',
      'Неприязнь',
      'Возмущение',
      'Отвращение',
    ],
  ),
  SectionEmotions(
    name: 'Страх',
    color: Colors.green,
    list: [
      'Ужас',
      'Отчаяние',
      'Испуг',
      'Оцепенение',
      'Подозрение',
      'Тревога',
      'Ошарашенность',
      'Беспокойство',
      'Унижение',
      'Замешательство',
      'Растерянность',
      'Стыд',
      'Вина',
      'Сомнение',
      'Застенчивость',
      'Опасение',
      'Смущение',
      'Сломленность',
      'Подвох',
      'Ошеломленность',
      'Надменность',
    ],
  ),
  SectionEmotions(
    name: 'Грусть',
    color: Colors.blue,
    list: [
      'Горечь',
      'Тоска',
      'Скорбь',
      'Лень',
      'Жалость',
      'Отрешенность',
      'Отчаяние',
      'Беспомощность',
      'Душевная боль',
      'Безнадежность',
      'Отчужденность',
      'Разочарование',
      'Потрясение',
      'Скука',
      'Безисходность',
      'Печаль',
      'Загнанность',
    ],
  ),
  SectionEmotions(
    name: 'Радость',
    color: Colors.orange,
    list: [
      'Счастье',
      'Восторг',
      'Ликование',
      'Приподнятость',
      'Оживление',
      'Умиротворение',
      'Увлечение',
      'Интерес',
      'Забота',
      'Ожидание',
      'Возбуждение',
      'Предвкушение',
      'Надежда',
      'Любопытство',
      'Освобождение',
      'Принятие',
      'Нетерпение',
      'Вера',
      'Изумление',
    ],
  ),
  SectionEmotions(
    name: 'Любовь',
    color: Colors.pink,
    list: [
      'Нежность',
      'Теплота',
      'Сочувствие',
      'Блаженство',
      'Доверие',
      'Безопасность',
      'Благодарность',
      'Спокойствие',
      'Симпатия',
      'Идентичность',
      'Гордость',
      'Восхищение',
      'Уважение',
      'Самоценность',
      'Влюбленность',
      'Любовь к себе',
      'Очарованность',
      'Смирение',
      'Искренность',
      'Дружелюбие',
      'Доброта',
      'Взаимовыручка',
    ],
  ),
];
