import 'package:test/test.dart';
import 'bai1.dart';

void main() {
  group('Province', () {
    test('Create Province object from map', () {
      var province = Province.fromMap({
        'id': 1,
        'name': 'Hanoi',
        'level': 1,
      });

      expect(province.id, equals(1));
      expect(province.name, equals('Hanoi'));
      expect(province.level, equals(1));
    });
  });

  group('District', () {
    test('Create District object from map', () {
      var district = District.fromMap({
        'id': 1,
        'name': 'Ba Dinh',
        'level': 2,
        'provinceId': 1,
      });

      expect(district.id, equals(1));
      expect(district.name, equals('Ba Dinh'));
      expect(district.level, equals(2));
      expect(district.provinceId, equals(1));
    });
  });

  group('Ward', () {
    test('Create Ward object from map', () {
      var ward = Ward.fromMap({
        'id': 1,
        'name': 'Cua Dong',
        'level': 3,
        'districtId': 1,
      });

      expect(ward.id, equals(1));
      expect(ward.name, equals('Cua Dong'));
      expect(ward.level, equals(3));
      expect(ward.districtId, equals(1));
    });
  });
}
