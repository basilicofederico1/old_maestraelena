dynamic downloadedPosts = List.empty(growable: true);
dynamic downloadedSearchPosts = List.empty(growable: true);

int getIndexFromId(int idPost) {
  for (int i = 0; i < downloadedPosts.length; i++) {
    if (downloadedPosts[i].id == idPost) return i;
  }
  return -1;
}
