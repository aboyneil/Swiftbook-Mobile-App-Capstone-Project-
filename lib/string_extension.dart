extension StringExtension on String {
  String get titleCase => this
      .split(' ')
      .map((word) => word.length > 0 ? word[0].toUpperCase() + word.substring(1) : '')
      .join(' ');

  /*String capitalize(){
    return "${
        this.split(' ')
            .map((word) => word.length > 0 ? word[0].toUpperCase() + word.substring(1)
                                          : '')
            .join(' ')}";
  }*/
}