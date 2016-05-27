# Info

Dot files from my Mac OS X.

# How to install it

```bash
  mkdir github
  cd github
  git clone git://github.com/t0d0r/dotmatrix.git
  cd dotmatrix && ./bin/mklinks
```

# Janus: `~/.vim` is replaced by janus plugin

```bash
  curl -Lo- https://bit.ly/janus-bootstrap | bash
```

After installing janus, don't forget to execute:
```bash
  git submodule init
  git submodule update
```

It is possible git submodule commands to fail, try [this to solve it](http://stackoverflow.com/questions/14768509/unable-to-checkout-git-submodule-path)

# Notes
  * .netrc - part of goobook mutt helper
