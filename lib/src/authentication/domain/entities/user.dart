import 'package:equatable/equatable.dart';

/// Represents the field resource that will use the app
class LocalUser extends Equatable {
  /// Unique ID of the visitor assigned by Firebase
  final String? uid;

  /// Username of the visitor if set
  final String? name;

  /// Email of the visitor
  final String? email;

  /// Visitor phone
  final String? phone;

  /// URL of the profile picture of the user if set
  final String? profilePic;

  /// List of clients that the visitor is associated with
  final List<String>? clientIDs;

  final String? formID;

  final List<String>? talukas;

  final List<String>? districts;

  final String? village;

  final String? state;

  final String? createdOn;

  const LocalUser(
      {required this.uid,
      required this.name,
      required this.email,
      this.clientIDs,
      this.phone,
      this.profilePic,
      this.village,
      this.talukas,
      this.districts,
      this.state,
      this.formID,
      this.createdOn});

  /// Generates a default visitor primarily for tests
  LocalUser.empty()
      : this(
            email: 'empty.email',
            name: 'empty.name',
            uid: 'empty.uid',
            clientIDs: ['empty.cid']);

  @override
  List<Object?> get props => [uid];
}
