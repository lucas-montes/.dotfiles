{
  mainUser,
  ...
}: {
  gtk = {
    enable = true;
    gtk3 = {
      bookmarks = [
        "file:///home/${mainUser}/Documents"
        "file:///home/${mainUser}/Downloads"
        "file:///home/${mainUser}/Pictures"
        "file:///home/${mainUser}/Downloads/music"
        "file:///home/${mainUser}/Projects"
        "file:///home/${mainUser}/Notes"
        "file:///data"
      ];
    };
  };
}
