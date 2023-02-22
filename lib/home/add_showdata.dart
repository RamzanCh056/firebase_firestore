import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/custom_text_field.dart';
import '../model/data_model.dart';

class AddShowData extends StatefulWidget {
  const AddShowData({Key? key}) : super(key: key);

  @override
  State<AddShowData> createState() => _AddShowDataState();
}

class _AddShowDataState extends State<AddShowData> {
  List<DataModel> data = [];
  TextEditingController name = TextEditingController();
  TextEditingController textTitle = TextEditingController();
  TextEditingController topicTalk = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

// function for upload data in firestore
  uploadData() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    DataModel dataModel = DataModel(
      name: name.text,
      textTitle: textTitle.text,
      topicTalk: topicTalk.text,
      doc: id.toString(),
    );
    try {
      await FirebaseFirestore.instance.collection("data").doc('$id').set(dataModel.toJson());
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Data add successfully');
    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Some error occurred');
    }
  }

// function for get data in firestore
  getData() {
    try {
      data.clear();
      setState(() {});
      FirebaseFirestore.instance.collection("data").snapshots().listen((event) {
        data.clear();
        setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          DataModel dataModel = DataModel.fromJson(event.docs[i].data());
          data.add(dataModel);
        }
        setState(() {});
      });
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    print("init call");
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Show Data"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CommonTextFieldWithTitle('Name', 'Enter name', name, (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 15,
                ),
                CommonTextFieldWithTitle('Topic', 'Enter Topic ', topicTalk, (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 15,
                ),
                CommonTextFieldWithTitle('Title', 'Enter Title', textTitle, (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 20,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            uploadData();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor,
                            ),
                            height: 50,
                            width: double.infinity,
                            child: const Center(
                              child: Text(
                                "Upload Data",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Data show and Delete",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        //color: Colors.blueAccent,
                        elevation: 4,
                        child: ListTile(
                          title: Text(data[index].topicTalk.toString()),
                          leading: Text(data[index].name.toString()),
                          trailing: GestureDetector(
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('data')
                                  .doc(data[index].doc.toString())
                                  .delete()
                                  .then(
                                    (doc) => print("Document deleted"),
                                    onError: (e) => print("Error updating document $e"),
                                  );
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          subtitle: Text(data[index].textTitle.toString()),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
