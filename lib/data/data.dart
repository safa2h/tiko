class Data {
  final String id;
  final String title;
  final String play;
  final String playHd;
  final String music;

  Data(this.id, this.title, this.play, this.playHd, this.music);

  Data.fromJosn(Map<String, dynamic> jsons)
      : id = jsons['id'],
        title = jsons['title'],
        play = jsons['play'],
        playHd = jsons['wmplay'],
        music = jsons['music'];
}
