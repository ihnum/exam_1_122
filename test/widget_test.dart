import 'package:exam_1_122/model/app_user.dart';
import 'package:exam_1_122/utils/number_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RBAC permissions', () {
    test('Admin can create, read, update, and delete', () {
      const user = AppUser(
        uid: 'admin-uid',
        name: 'Admin',
        email: 'admin@test.com',
        role: 'Admin',
      );

      expect(user.canCreate, isTrue);
      expect(user.canRead, isTrue);
      expect(user.canUpdate, isTrue);
      expect(user.canDelete, isTrue);
    });

    test('Operator can only create and read', () {
      const user = AppUser(
        uid: 'operator-uid',
        name: 'Operator',
        email: 'operator@test.com',
        role: 'Operator',
      );

      expect(user.canCreate, isTrue);
      expect(user.canRead, isTrue);
      expect(user.canUpdate, isFalse);
      expect(user.canDelete, isFalse);
    });

    test('Unknown role has no access', () {
      const user = AppUser(
        uid: 'unknown-uid',
        name: 'Unknown',
        email: 'unknown@test.com',
        role: 'Guest',
      );

      expect(user.hasKnownRole, isFalse);
      expect(user.canCreate, isFalse);
      expect(user.canRead, isFalse);
      expect(user.canUpdate, isFalse);
      expect(user.canDelete, isFalse);
    });
  });

  group('Compact number formatter', () {
    test('formats thousands and millions', () {
      expect(formatCompactNumber('100000'), '100K');
      expect(formatCompactNumber('1000000'), '1M');
      expect(formatCompactNumber('1500000'), '1.5M');
      expect(formatCompactNumber('564656546547.99'), '564.66B');
      expect(formatCompactNumber('1000000000000'), '1T');
      expect(formatCompactNumber('1000000000000000'), '1Qa');
      expect(formatCompactNumber('1000000000000000000000000000000000'), '1Dc');
    });

    test('keeps small and non-numeric values readable', () {
      expect(formatCompactNumber('555'), '555');
      expect(formatCompactNumber('ไม่ระบุ'), 'ไม่ระบุ');
    });
  });
}
