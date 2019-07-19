class SearchModel {
  String keyword;
	final List<SearchItem> data;

  SearchModel({this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
  	var dataJson = json['data'] as List;
  	List<SearchItem> data = dataJson.map((i)=>SearchItem.fromJson(i)).toList();
  	return SearchModel(
			data: data
		);
	}
}

class SearchItem {
	String star;
	String districtname;
	String price;
	String type;
	String word;
	String zonename;
	String url;

	SearchItem({this.star, this.districtname, this.price, this.type, this.word, this.zonename, this.url});

	SearchItem.fromJson(Map<String, dynamic> json) {
		star = json['star'];
		districtname = json['districtname'];
		price = json['price'];
		type = json['type'];
		word = json['word'];
		zonename = json['zonename'];
		url = json['url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['star'] = this.star;
		data['districtname'] = this.districtname;
		data['price'] = this.price;
		data['type'] = this.type;
		data['word'] = this.word;
		data['zonename'] = this.zonename;
		data['url'] = this.url;
		return data;
	}
}
