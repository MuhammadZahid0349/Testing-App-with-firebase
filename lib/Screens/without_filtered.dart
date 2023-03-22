// StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection("users")
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.active) {
//                       if (snapshot.hasData && snapshot.data != null) {
//                         return Container(
//                           height: 300.h,
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               scrollDirection: Axis.vertical,
//                               itemCount: snapshot.data!.docs.length,
//                               itemBuilder: (context, index) {
//                                 Map userMap =
//                                     snapshot.data!.docs[index].data() as Map;
//                                 return ListTile(
//                                   title: Text(userMap["name"]),
//                                   subtitle: Text(userMap["email"]),
//                                   trailing: GestureDetector(
//                                       onTap: () async {
//                                         await FirebaseFirestore.instance
//                                             .collection("users")
//                                             .doc(snapshot.data!.docs[index].id)
//                                             .delete();
//                                         log("Deletd");
//                                         Get.snackbar("Delete", "User Deleted");
//                                       },
//                                       child: Icon(Icons.delete)),
//                                 );
//                               }),
//                         );
//                       } else {
//                         return Text("No data");
//                       }
//                     } else {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   },
// );