import 'package:injectable/injectable.dart';

@lazySingleton
class Corruptions {
  Corruptions() : map = _getMap();

  final Map<String, Corruption> map;
  List<Corruption> get list => _listCorruptions;

  static Map<String, Corruption> _getMap() {
    Map<String, Corruption> map = {};
    for (final Corruption corruption in _listCorruptions) {
      map[corruption.name] = corruption;
    }
    return map;
  }
}

class Corruption {
  const Corruption({
    required this.name,
    required this.desc,
  });

  final String name;
  
  final String desc;
}

const _listCorruptions = [
  Corruption(
    name: 'Максимализм',
    desc: 'Человек видит все в черных или белых тонах. Например: известный политик, потерпевший неудачу на выборах, говорит: «Так как я потерян для правительства, то я — полный «ноль»». Круглый отличник, получивший на экзамене «2», решил: «Я — законченный неудачник».',
  ),
  Corruption(
    name: 'Общий вывод из единичных фактов',
    desc: 'Пугливый юноша, собрав все свое мужество, пригласил девушку на свидание. Когда она отказалась, найдя свидание преждевременным, он решил: «Мне никогда не скажут: «да», если я приглашу кого-нибудь на свидание. Никакая девушка не захочет встречаться со мной. Я буду одинок всю жизнь». В его нарушенной системе познания сложилась следующая цепочка выводов: она отвергла сейчас — она будет так поступать всегда — и все женщины будут поступать так, на сто процентов.',
  ),
  Corruption(
    name: 'Психологическая фильтрация событий',
    desc: 'Человек выдергивает негативные детали из сложившейся ситуации и воспринимает их, как результат происшедшего. Например: студент пишет контрольный тест, где, как он твердо знает, из 100 вопросов на 17 ответил неправильно. Он постоянно думает об этих 17 и приходит к выводу, что за тест он получит «неудовлетворительно», и его выгонят из института.',
  ),
  Corruption(
    name: 'Дисквалификация положительного',
    desc: 'Дисквалификация положительного (ДП) — одна из самых разрушительных форм когнитивных нарушений. Человек может рассматривать себя через стекло, на котором написано: «Я — второсортный», и, выдергивая из всего отрицательные детали, получает подтверждение: «Я всегда так думал». Самая худшая сторона ДП — полное отрицание, неспособность оценить хорошие вещи.',
  ),
  Corruption(
    name: 'Скачущие умозаключения',
    desc: 'Больной произвольно перескакивает к отрицательным умозаключениям при осмыслении ситуации, факты которой довольно далеки от полученных выводов. Есть два вида скачущих умозаключений: «незнание предшествующего» (НП) и «ошибка в предсказании судьбы» (ОПС). — НП — это ощущение, что другие люди свысока смотрят на тебя, когда в действительности их гнетут собственные проблемы. Заметить что-либо другое они просто не в состоянии.',
  ),
  Corruption(
    name: 'Преувеличение и преуменьшение',
    desc: 'Первое обычно происходит, когда видишь собственные ошибки и преувеличиваешь их значимость: «Боже, я ошибся! Как ужасно! Моя репутация загублена!» Больной, преувеличивающий свои промахи, видит, что его ошибкам нет конца, и они уже кажутся настолько гигантскими, что малейшие негативные факты превращаются в монстров. Когда же больной думает о своих успехах, то смотрит на них в «бинокль с обратной стороны», и все становится незначительным, мелким.',
  ),
  Corruption(
    name: 'Выводы, основанные на эмоциях',
    desc: 'Индивидуум воспринимает свои эмоции, как очевидный факт. Его логика такова: «Если я чувствую себя как неудачник — значит неудачи имеют место». Это заключение ошибочно, так как чувства отражают мысли, если последние нарушены, то эмоциональная реакция не соответствует фактам. Например, выводы, основанные на эмоциях, включают конструкции, подобные таким, как: «Я чувствую вину, следовательно я сделал что-то плохое», «Я впал в прострацию, и значит мои проблемы сложно разрешимы».',
  ),
  Corruption(
    name: '«Можно было бы»',
    desc: 'Говоря себе «А все-таки я смог бы» или «Я должен был бы сделать это», человек чувствует обиду, его гнетет не сделанное им. Хотя больной и перестает чувствовать апатию, он впадает в депрессию из-за невозможности что-то теперь изменить. Альберт Эллис назвал подобные действия «должнонанизмом», а я — «можно было бы» попытаться повлиять на жизнь.',
  ),
  Corruption(
    name: 'Ярлыки',
    desc: 'Ярлыком назовем созданное полностью на отрицательных фактах как самопредставление, самоимидж, так и мнение о посторонних. Он является экстремальной формой общего вывода из единичных фактов. Философское подтверждение этого утверждения — сентенция о том, что «лицо человека — его ошибки». Но навешивание ярлыков является прекрасной возможностью запутываться в них каждый раз, когда описываешь свои промахи. Например, промахнувшись по воротам, можно сказать: «Я рожден, чтобы проигрывать», вместо «У меня был неудачный удар». То есть, допуская ошибку, думаешь: «Я неудачник», а не: «Я допустил ошибку».',
  ),
  Corruption(
    name: 'Принятие ответственности за независящие от тебя события',
    desc: 'Это расстройство — мать всех комплексов. Приписывая ответственность за негативные факты всегда, когда нет для этого и малейшего повода, человек все относит на счет своих промахов и ошибок, решив, что он не соответствует миру. Например, когда пациентка не смогла быстро включиться в лечение, я подумал: «Я, наверное, слабый терапевт.',
  ),
];
