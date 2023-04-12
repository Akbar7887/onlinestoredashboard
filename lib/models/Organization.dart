
class Organization {
    String? adress;
    String? email;
    String? facebook;
    int? id;
    String? instagram;
    String? name;
    String? region;
    String? telegram;
    String? telephon;

    Organization({ this.adress,
         this.email,
        this.facebook,
        this.id,
        this.instagram,
        this.name,
        this.region,
        this.telegram,
        this.telephon});

    factory Organization.fromJson(Map<String, dynamic> json) {
        return Organization(
            adress: json['adress'], 
            email: json['email'], 
            facebook: json['facebook'], 
            id: json['id'], 
            instagram: json['instagram'], 
            name: json['name'], 
            region: json['region'], 
            telegram: json['telegram'], 
            telephon: json['telephon'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['adress'] = this.adress;
        data['email'] = this.email;
        data['facebook'] = this.facebook;
        data['id'] = this.id;
        data['instagram'] = this.instagram;
        data['name'] = this.name;
        data['region'] = this.region;
        data['telegram'] = this.telegram;
        data['telephon'] = this.telephon;
        return data;
    }
}