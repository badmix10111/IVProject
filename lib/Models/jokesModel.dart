class Joke {
  final String setup;
  final String delivery;

  Joke({required this.setup, required this.delivery});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'] ?? '',
      delivery: json['delivery'] ?? '',
    );
  }
}
