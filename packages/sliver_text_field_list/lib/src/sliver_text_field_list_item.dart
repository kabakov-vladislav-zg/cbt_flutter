part of 'sliver_text_field_list.dart';

class SliverTextFieldListItem extends Equatable {
  SliverTextFieldListItem({
    required String text,
    required VoidCallback onChange,
    required void Function(String uuid, { String? text }) onDelete,
  }) : _onChangeCallback = onChange,
       _onDeleteCallback = onDelete {
    textController = TextEditingController(text: _getText(text));
    textController.addListener(_onChange);
    focusNode = FocusNode();
    focusNode.addListener(_onFocus);
    uuid = const Uuid().v1();
  }

  late final TextEditingController textController;
  late final FocusNode focusNode;
  late final String uuid;
  final VoidCallback _onChangeCallback;
  final void Function(String uuid, { String? text }) _onDeleteCallback;
  static const String _invisibleChar = '\u200B';

  static String _getText(String value) {
    if (value.startsWith(_invisibleChar)) {
      return value;
    } else {
      return _invisibleChar + value;
    }
  }

  bool isEmpty() {
    return text.trim() == _invisibleChar;
  }

  int get selection => textController.selection.start;
  set selection(int offset) => textController.selection = TextSelection.collapsed(offset: offset);

  String get text => textController.text;
  set text(String value) => textController.text = _getText(value);
  String get clearText => text.replaceAll(_invisibleChar, '').trim();

  void _requestDelete(String uuid, [String? text]) {
    Future.delayed(const Duration(seconds: 0))
      .then((_) => _onDeleteCallback(uuid, text: text));
  }

  void _onChange() {
    if (text.startsWith(_invisibleChar)) {
      if (textController.selection.start == 0) {
        selection = 1;
      }
      _onChangeCallback();
    } else if (text.trim().isEmpty) {
      _requestDelete(uuid);
    } else {
      _requestDelete(uuid, text);
      text = _getText(text);
      selection = 1;
    }
  }

  void _onFocus() {
    if (!focusNode.hasFocus) {
      text = text.trim();
    }
  }

  void requestFocus() => focusNode.requestFocus();

  void dispose() {
    textController.removeListener(_onChange);
    textController.dispose();
    focusNode.removeListener(_onFocus);
    focusNode.dispose();
  }

  @override
  List<Object?> get props => [uuid];
}
