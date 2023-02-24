class ProductImage {
    int? id;
    String? imagepath;

    ProductImage({this.id, this.imagepath});

    factory ProductImage.fromJson(Map<String, dynamic> json) {
        return ProductImage(
            id: json['id'], 
            imagepath: json['imagepath'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['imagepath'] = this.imagepath;
        return data;
    }
}