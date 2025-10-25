import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user.dart';

/// The model of the visitor class. This model extends the entity and adds
/// additional features to it. This is the model that will be used throughout
/// the data layer.
class LocalUserModel extends LocalUser {
  const LocalUserModel(
      {required super.uid,
      required super.name,
      required super.email,
      super.phone,
      super.profilePic,
      super.clientIDs,
      super.village,
      super.talukas,
      super.districts,
      super.state,
      super.formID,
      super.createdOn});

  /// Generates a default Visitor Model. This is also primary used for testing.
  LocalUserModel.empty()
      : this(
            uid: 'empty.uid',
            name: 'empty.name',
            email: 'empty.email',
            clientIDs: ['empty.cid']);

  /// Generates a [LocalUser] model from the [UserCredential] object received from
  /// Firebase.
  LocalUserModel.fromFirebase(User? user)
      : this(
            email: user?.email,
            uid: user?.uid,
            name: user?.displayName,
            profilePic: user?.photoURL,
            phone: user?.phoneNumber,
            clientIDs: []);

  /// Adds the new properties to the existing [LocalUser] object. This method is
  /// called after the visitor has signed in to Firebase and has retrieved its
  /// additional data after calling our backend APIs
  LocalUserModel copyWith({required DataMap visitorData}) {
    return LocalUserModel(
        uid: uid,
        name: name,
        email: email,
        village: visitorData['village'],
        talukas: List<String>.from(visitorData['Taluka']),
        districts: List<String>.from(visitorData['district']),
        state: visitorData['state'],
        formID: visitorData['form'],
        createdOn: visitorData['created_On']
        // clientIDs: visitorData['cid']

        );
  }
}
