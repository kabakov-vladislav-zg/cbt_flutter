import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Emotions {
  Emotions() : map = _getMap();

  final Map<String, EmotionDesc> map;
  List<SectionEmotions> get sections => _listEmotions;

  static Map<String, EmotionDesc> _getMap() {
    Map<String, EmotionDesc> map = {};
    for (final SectionEmotions section in _listEmotions) {
      for (final String emotion in section.list) {
        map[emotion] = EmotionDesc(
          name: emotion,
          section: section.section,
          color: section.color,
          help: section.help,
        );
      }
    }
    return map;
  }
}

class SectionEmotions {
  const SectionEmotions({
    required this.section,
    required this.color,
    required this.list,
    required this.help,
  });

  final String section;
  
  final Color color;

  final List<String> help;
  
  final List<String> list;
}

class EmotionDesc {
  const EmotionDesc({
    required this.name,
    required this.section,
    required this.color,
    required this.help,
  });

  final String name;

  final String section;
  
  final Color color;

  final List<String> help;
}

const _listEmotions = [
  SectionEmotions(
    section: 'Гнев',
    color: Colors.red,
    help: [
      'легкая усталость',
      'чувство грусти',
      'тяжесть во всем теле',
      'слезы в глазах',
      'ком в горле',
      'губы дрожат',
      'рыдание',
      'ощущение глубокой тоски',
      'эмоциональное измождение',
      'желание умереть',
    ],
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
    section: 'Страх',
    color: Colors.green,
    help: [
      'легкая усталость',
      'чувство грусти',
      'тяжесть во всем теле',
      'слезы в глазах',
      'ком в горле',
      'губы дрожат',
      'рыдание',
      'ощущение глубокой тоски',
      'эмоциональное измождение',
      'желание умереть',
    ],
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
    section: 'Грусть',
    color: Colors.blue,
    help: [
      'легкая усталость',
      'чувство грусти',
      'тяжесть во всем теле',
      'слезы в глазах',
      'ком в горле',
      'губы дрожат',
      'рыдание',
      'ощущение глубокой тоски',
      'эмоциональное измождение',
      'желание умереть',
    ],
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
    section: 'Радость',
    color: Colors.orange,
    help: [
      'легкая усталость',
      'чувство грусти',
      'тяжесть во всем теле',
      'слезы в глазах',
      'ком в горле',
      'губы дрожат',
      'рыдание',
      'ощущение глубокой тоски',
      'эмоциональное измождение',
      'желание умереть',
    ],
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
    section: 'Любовь',
    color: Colors.pink,
    help: [
      'легкая усталость',
      'чувство грусти',
      'тяжесть во всем теле',
      'слезы в глазах',
      'ком в горле',
      'губы дрожат',
      'рыдание',
      'ощущение глубокой тоски',
      'эмоциональное измождение',
      'желание умереть',
    ],
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
