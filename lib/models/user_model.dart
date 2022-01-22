// Model that will help to send and pass data to the manage registration 

class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String role = 'Patient';

  UserModel({
    this.uid, 
    this.firstName, 
    this.lastName, 
    this.username, 
    this.email, 
    role,
  });

  // Send Data to the Server
  Map <String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'role': role,
    };
  }
  
  //Retrieve the Data from the Server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      username: map['username'],
      email: map['email'],
      role: map['role'],
    );
  }
}