import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  CollectionReference product = FirebaseFirestore.instance.collection('items');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot) async{
    nameController.text = documentSnapshot['name'];
    priceController.text = documentSnapshot['price'];

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context){
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async{
                    final String name = nameController.text;
                    final String price = priceController.text;
                    product.doc(documentSnapshot.id).update({
                      "name" : name, "price" : price
                    });
                    nameController.text = "";
                    priceController.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Text('update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _create() async{

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context){
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async{
                    final String name = nameController.text;
                    final String price = priceController.text;
                    await product.add({"name" : name, "price" : price});
                    nameController.text = "";
                    priceController.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Text('create'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(String productId) async{
    await product.doc(productId).delete();
  }

  Future<void> showAlert(BuildContext context, String productId) async{
    return showDialog(
      context: context,
      builder: (context){
        return Dialog(
          child: SizedBox(
            height: 150,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start ,
                    children: [
                      Icon(Icons.add_alert,
                      size: 25,),
                      Text('Confirm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ],
                  ),
                ),
                Text('Do you really want to delete item?',
                style: TextStyle(
                  fontSize: 15,
                ),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red
                      ),
                      onPressed: () async{
                        await _delete(productId);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You have successfully deleted a product')
                          ));
                      },
                      child: Text('Yes',
                      style: TextStyle(
                        color: Colors.white
                      ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      appBar: AppBar(
        title: Text('Cloud Firestore'),
      ),
      body: StreamBuilder(
        stream: product.snapshots(),
        builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                  return Card(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['price']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async{
                                await _update(documentSnapshot);
                              },
                              icon: Icon(Icons.edit),),
                            IconButton(
                              onPressed: () async{
                                await showAlert(context, documentSnapshot.id);
                              },
                              icon: Icon(Icons.delete),),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            }
            return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          _create();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
