
extension ImagePath on String {
  String get pngImage => 'assets/images/$this.png';
  String get jpgImage => 'assets/images/$this.jpg';
  String get svgImage => 'assets/images/$this.svg';

  String get pngIcon => 'assets/icons/$this.png';
  String get jpgIcon => 'assets/icons/$this.jpg';
  String get svgIcon => 'assets/icons/$this.svg';

}


class Images {
  static String logo = 'logo'.pngIcon;
}






