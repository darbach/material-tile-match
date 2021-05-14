import 'package:sprintf/sprintf.dart';

const _hmsFormat = '%d:%02d:%02d';

String ticksToHms(int ticks) {
  var work = (ticks / 1000).round();
  final seconds = work % 60;
  work ~/= 60;
  final minutes = work % 60;
  final hours = work ~/ 60;
  return sprintf(_hmsFormat, [hours, minutes, seconds]);
}