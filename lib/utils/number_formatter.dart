const _suffixes = [
  '',
  'K',
  'M',
  'B',
  'T',
  'Qa',
  'Qi',
  'Sx',
  'Sp',
  'Oc',
  'No',
  'Dc',
  'Ud',
  'Dd',
  'Td',
  'Qad',
  'Qid',
  'Sxd',
  'Spd',
  'Od',
  'Nd',
  'Vg',
];

String formatCompactNumber(Object? value) {
  final original = value?.toString() ?? '';
  final normalized = original.replaceAll(',', '').trim();
  final match = RegExp(r'^([+-]?)(\d+)(?:\.(\d+))?$').firstMatch(normalized);

  if (match == null) return original;

  final sign = match.group(1) == '-' ? '-' : '';
  final integerPart = match.group(2)!.replaceFirst(RegExp(r'^0+(?=\d)'), '');
  final fractionPart = match.group(3) ?? '';

  if (integerPart.length <= 3) {
    final number = double.tryParse(normalized);
    return number == null ? original : _removeTrailingZeros(number);
  }

  var suffixIndex = (integerPart.length - 1) ~/ 3;
  final leadingDigitCount = integerPart.length - (suffixIndex * 3);
  final wholePart = integerPart.substring(0, leadingDigitCount);
  final remainingDigits =
      '${integerPart.substring(leadingDigitCount)}$fractionPart';
  final precisionDigits = remainingDigits.substring(
    0,
    remainingDigits.length > 6 ? 6 : remainingDigits.length,
  );

  var scaled = double.parse(
    precisionDigits.isEmpty ? wholePart : '$wholePart.$precisionDigits',
  );
  var formatted = _removeTrailingZeros(scaled);

  if (double.parse(formatted) >= 1000) {
    suffixIndex++;
    scaled = double.parse(formatted) / 1000;
    formatted = _removeTrailingZeros(scaled);
  }

  if (suffixIndex < _suffixes.length) {
    return '$sign$formatted${_suffixes[suffixIndex]}';
  }

  final exponent = (integerPart.length - 1).toString();
  final scientificDigits = integerPart.length > 3
      ? '${integerPart[0]}.${integerPart.substring(1, 3)}'
      : integerPart;
  return '$sign${_trimDecimalText(scientificDigits)}e$exponent';
}

String _removeTrailingZeros(double value) {
  return _trimDecimalText(value.toStringAsFixed(2));
}

String _trimDecimalText(String value) {
  if (!value.contains('.')) return value;
  return value
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}
