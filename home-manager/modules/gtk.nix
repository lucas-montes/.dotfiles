{user, ...}: {
  gtk = {
    enable = true;
    gtk3 = {
      bookmarks = [
        "file:///home/${user}/Documents"
        "file:///home/${user}/Downloads"
        "file:///home/${user}/Pictures"
        "file:///home/${user}/Downloads/music"
        "file:///home/${user}/Projects"
        "file:///home/${user}/Notes"
        "file:///data"
        #"sftp://lucas@homelab/home/lucas"
      ];
    };
  };
}
