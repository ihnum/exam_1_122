# ระบบบันทึกคาร์บอน

แอป Flutter สำหรับบันทึกข้อมูลการปล่อยคาร์บอน ใช้ Firebase Authentication,
Cloud Firestore และ RBAC แยกสิทธิ์ `Admin` กับ `Operator`

## สิทธิ์ผู้ใช้

| การทำงาน | Admin | Operator |
| --- | --- | --- |
| เข้าสู่ระบบและออกจากระบบ | ✅ | ✅ |
| ดูข้อมูล | ✅ | ✅ |
| เพิ่มข้อมูล | ✅ | ✅ |
| แก้ไขข้อมูล | ✅ | ❌ |
| ลบข้อมูล | ✅ | ❌ |

## ตั้งค่า Firebase ก่อนใช้งาน

1. เปิด Email/Password ใน Firebase Authentication
2. สร้างบัญชี Admin และ Operator ใน Authentication
3. คัดลอก UID ของแต่ละบัญชี แล้วสร้างเอกสารใน collection `users`
   โดยใช้ UID เป็น Document ID
4. กำหนดฟิลด์ `name`, `email` และ `role` โดย `role` ต้องเป็น `Admin`
   หรือ `Operator` เท่านั้น
5. นำเนื้อหาใน `firestore.rules` ไป Publish ที่ Firestore Database > Rules

ตัวอย่างเอกสารผู้ใช้:

```text
users/{uid}
  name: "Admin"
  email: "admin@test.com"
  role: "Admin"
```

## ตรวจสอบโปรเจกต์

```text
flutter pub get
flutter analyze
flutter test
flutter run
```
