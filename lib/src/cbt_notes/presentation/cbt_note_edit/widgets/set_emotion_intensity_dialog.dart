import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/utils/emotions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

class SetEmotionIntensityDialog extends StatefulWidget {
  const SetEmotionIntensityDialog({
    super.key,
    required this.name,
    this.value = 1,
  });
  final String name;
  final int value;

  @override
  State<SetEmotionIntensityDialog> createState() => _SetEmotionIntensityDialogState();
}

class _SetEmotionIntensityDialogState extends State<SetEmotionIntensityDialog> {
  late final EmotionDesc _emotion;
  int _value = 0;

  @override
  void initState() {
    final emotions = getIt.get<Emotions>();
    _emotion = emotions.map[widget.name]!;
    _value = widget.value;
    super.initState();
  }

  void _onSubmit() {
    context.pop(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(_emotion.name),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverMainAxisGroup(slivers: [
              SliverToBoxAdapter(child: UISlider(
                label: _emotion.name,
                max: Emotion.maxIntensity,
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              )),
              SliverList.builder(
                itemCount: _emotion.help.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_emotion.help[index]),
                    contentPadding: const EdgeInsets.all(0),
                    onTap: (){
                      setState(() {
                        _value = index + 1;
                      });
                    },
                    leading: Radio<int>(
                      visualDensity: const VisualDensity(horizontal: -4),
                      value: index + 1,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value ?? 0;
                        });
                      },
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Btn(
                  onPressed: _onSubmit,
                  text: 'готово'
                ),
              ),
            ]),
          ),
        ]
      ),
    );
  }
}
