export class Reader {
    id?: string;
    email?: string;
    name?: string;
    phoneNumber?: string;
    phoneNumberAlt?: string;
  
    constructor(
      id?: string,
      email?: string,
      name?: string,
      phoneNumber?: string,
      phoneNumberAlt?: string
    ) {
      this.id = id;
      this.email = email;
      this.name = name;
      this.phoneNumber = phoneNumber;
      this.phoneNumberAlt = phoneNumberAlt;
    }
  
    static fromJson(json: any): Reader {
      return new Reader(
        json['id'],
        json['email'],
        json['name'],
        json['phoneNumber'],
        json['phoneNumberAlt']
      );
    }
  
    toJson(): object {
      return {
        id: this.id ?? null,
        email: this.email ?? null,
        name: this.name ?? null,
        phoneNumber: this.phoneNumber ?? null,
        phoneNumberAlt: this.phoneNumberAlt ?? null
      };
    }
  
    static fromFirestore(data: FirebaseFirestore.DocumentData): Reader {
      return new Reader(
        data['id'],
        data['email'],
        data['name'],
        data['phoneNumber'],
        data['phoneNumberAlt']
      );
    }
  }
  