export class Book {
    id?: string;
    title?: string;
    author?: string;
    genre?: string;
    publisher?: string;
    description?: string;
    imageUrl?: string;
    barcode?: string;
    isAvailable?: boolean;
    createdAt?: FirebaseFirestore.Timestamp;
    updatedAt?: FirebaseFirestore.Timestamp;
    averageRating?: number;
    reviewsCount?: number;
  
    constructor(
      id: string,
      title?: string,
      author?: string,
      genre?: string,
      publisher?: string,
      description?: string,
      imageUrl?: string,
      barcode?: string,
      isAvailable?: boolean,
      createdAt?: FirebaseFirestore.Timestamp,
      updatedAt?: FirebaseFirestore.Timestamp,
      averageRating?: number,
      reviewsCount?: number,
    ) {
      this.id = id;
      this.title = title;
      this.author = author;
      this.genre = genre;
      this.publisher = publisher;
      this.description = description;
      this.imageUrl = imageUrl;
      this.barcode = barcode;
      this.isAvailable = isAvailable ?? true;
      this.createdAt = createdAt ?? FirebaseFirestore.Timestamp.now();
      this.updatedAt = updatedAt ?? FirebaseFirestore.Timestamp.now();
      this.averageRating = averageRating;
      this.reviewsCount = reviewsCount;
    }
  
    static fromJson(json: any): Book {
      return new Book(
        json['id'],
        json['title'],
        json['author'],
        json['genre'],
        json['publisher'],
        json['description'],
        json['imageUrl'],
        json['barcode'],
        json['isAvailable'],
        json['createdAt'],
        json['updatedAt'],
        json['averageRating'],
        json['reviewsCount']
      );
    }
  
    toJson(): object {
      return {
        id: this.id ?? null,
        title: this.title ?? null,
        author: this.author ?? null,
        genre: this.genre ?? null,
        publisher: this.publisher ?? null,
        description: this.description ?? null,
        imageUrl: this.imageUrl ?? null,
        barcode: this.barcode ?? null,
        isAvailable: this.isAvailable ?? true,
        createdAt: this.createdAt ?? FirebaseFirestore.Timestamp.now(),
        updatedAt: this.updatedAt ?? FirebaseFirestore.Timestamp.now(),
        averageRating: this.averageRating ?? 0,
        reviewsCount: this.reviewsCount ?? 0
      };
    }
  
    static fromFirestore(data: FirebaseFirestore.DocumentData): Book {
      return new Book(
        data['id'],
        data['title'],
        data['author'],
        data['genre'],
        data['publisher'],
        data['description'],
        data['imageUrl'],
        data['barcode'],
        data['isAvailable'],
        data['createdAt'],
        data['updatedAt'],
        data['averageRating'],
        data['reviewsCount']
      );
    }
  }
  