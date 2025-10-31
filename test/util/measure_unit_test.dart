import 'package:aquapact/model/measure_unit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VolumeMeasureUnit.convertAmountTo()', () {
    final ml = VolumeMeasureUnit.ml;
    final l = VolumeMeasureUnit.l;

    expect(ml.convertAmountTo(1, ml), 1);
    expect(ml.convertAmountTo(1, l), 0.001);
    expect(l.convertAmountTo(1, ml), 1000);
    expect(l.convertAmountTo(1, l), 1);
  });
}
