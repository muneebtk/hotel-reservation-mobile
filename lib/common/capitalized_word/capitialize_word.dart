String capitalizeFirstLetter(String word) {
  return word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
}

String capitalizeWords(String sentence) {
  List<String> words = sentence.split(" ");
  for (int i = 0; i < words.length; i++) {
    words[i] = capitalizeFirstLetter(words[i]);
  }
  return words.join(" ");
}
