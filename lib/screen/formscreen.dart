import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/app_user.dart';
import '../model/carbon.dart';

class Formscreen extends StatefulWidget {
  const Formscreen({
    super.key,
    required this.user,
    this.documentId,
    this.carbon,
  });

  final AppUser user;
  final String? documentId;
  final Carbon? carbon;

  @override
  State<Formscreen> createState() => _FormscreenState();
}

class _FormscreenState extends State<Formscreen> {
  final formKey = GlobalKey<FormState>();
  late Carbon myCarbon;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  void _showKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    });
  }

  @override
  void initState() {
    super.initState();
    myCarbon =
        widget.carbon ??
        Carbon(id: '', emission: '', tCO2e: '', email: '', budget: '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final CollectionReference carbonCollection = FirebaseFirestore
              .instance
              .collection('carbon');
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 49, 224, 157),
              title: Text(
                widget.documentId == null
                    ? 'บันทึกการปล่อยคาร์บอน'
                    : 'แก้ไขการปล่อยคาร์บอน',
              ),
              actions: [
                IconButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'รหัสศูนย์ต้นทุน / แผนก ',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        initialValue: widget.carbon?.id ?? '',
                        onTap: _showKeyboard,
                        decoration: const InputDecoration(
                          hintText: 'เช่น CC-ENG-04',
                        ),
                        validator: RequiredValidator(
                          errorText: 'กรุณาป้อนรหัสศูนย์ต้นทุน / แผนก',
                        ).call,
                        onSaved: (id) {
                          myCarbon.id = id!;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'แหล่งกำเนิดการปล่อย ',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        initialValue: widget.carbon?.emission ?? '',
                        onTap: _showKeyboard,
                        decoration: const InputDecoration(
                          hintText: 'เช่น การใช้ไฟฟ้า, ยานพาหนะ, ขนส่ง',
                        ),
                        validator: RequiredValidator(
                          errorText: 'กรุณาป้อนแหล่งกำเนิดการปล่อย',
                        ).call,
                        onSaved: (emission) {
                          myCarbon.emission = emission!;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'อีเมลเจ้าหน้าที่',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        initialValue: widget.carbon?.email ?? '',
                        onTap: _showKeyboard,
                        decoration: const InputDecoration(
                          hintText: 'เช่น auditor@company.com',
                        ),
                        validator: MultiValidator([
                          EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                          RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                        ]).call,
                        onSaved: (email) {
                          myCarbon.email = email!;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'ปริมาณการปล่อย (tCO2e)',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        initialValue: widget.carbon?.tCO2e ?? '',
                        onTap: _showKeyboard,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณาป้อนปริมาณการปล่อย';
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return 'กรุณาป้อนปริมาณการปล่อยเป็นตัวเลข';
                          }
                          return null;
                        },
                        onSaved: (tCO2e) {
                          myCarbon.tCO2e = tCO2e!;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'งบประมาณชดเชยที่จัดสรร',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        initialValue: widget.carbon?.budget ?? '',
                        onTap: _showKeyboard,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณาป้อนงบประมาณชดเชย';
                          }
                          if (num.tryParse(value.trim()) == null) {
                            return 'กรุณาป้อนงบประมาณชดเชยเป็นตัวเลข';
                          }
                          return null;
                        },
                        onSaved: (budget) {
                          myCarbon.budget = budget!;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255,49,224,157,),),
                          onPressed: () async {
                            if (widget.documentId != null &&
                                !widget.user.canUpdate) {
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (widget.documentId == null) {
                                await carbonCollection.add({
                                  'id': myCarbon.id,
                                  'emission': myCarbon.emission,
                                  'tCO2e': myCarbon.tCO2e,
                                  'email': myCarbon.email,
                                  'budget': myCarbon.budget,
                                });
                                formKey.currentState!.reset();
                              } else {
                                await carbonCollection
                                    .doc(widget.documentId)
                                    .update({
                                      'id': myCarbon.id,
                                      'emission': myCarbon.emission,
                                      'tCO2e': myCarbon.tCO2e,
                                      'email': myCarbon.email,
                                      'budget': myCarbon.budget,
                                    });
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text(
                            widget.documentId == null
                                ? 'บันทึก'
                                : 'บันทึกการแก้ไข',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
