// models/User.ts

export class User {
  userId?: string;
  email?: string;
  name?: string;
  role?: string;
  login?: string;
  phoneNumber?: string;
  phoneNumberAlt?: string;
  photoUrl?: string;



  constructor(
    userId: string,
    email?: string,
    name?: string,
    role?: string,
    login?: string,
    phoneNumber?: string,
    phoneNumberAlt?: string,
    photoUrl?: string,
  ) {
    this.userId = userId;
    this.email = email;
    this.name = name;
    this.role = role;
    this.login = login;
    this.phoneNumber = phoneNumber;
    this.phoneNumberAlt = phoneNumberAlt;
    this.photoUrl = photoUrl;

  }

  static fromJson(json: any): User {
    return new User(
      json['userId'],
      json['email'],
      json['name'],
      json['role'],
      json['login'],
      json['phoneNumber'],
      json['phoneNumberAlt'],
      json['photoUrl']
    );
  }

  toJson(): object {
    return {
      uid: this.userId ?? null,
      email: this.email ?? null,
      name: this.name ?? null,
      role: this.role ?? null,
      login: this.login ?? null,
      phoneNumber: this.phoneNumber ?? null,
      phoneNumberAlt: this.phoneNumberAlt ?? null,
      photoUrl: this.photoUrl ?? null
    };
  }


  static fromFirestore(data: FirebaseFirestore.DocumentData): User {
    return new User(
      data['userId'],
      data['email'],
      data['name'],
      data['role'],
      data['login'],
      data['phoneNumber'],
      data['phoneNumberAlt'],
      data['photoUrl']
    );
  }

}
