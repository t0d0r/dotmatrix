# Info

Dot files from my Mac OS X.

# How to install it

```bash
  mkdir github
  cd github
  git clone git://github.com/t0d0r/dotmatrix.git
  cd dotmatrix && ./bin/dotmatrix-install
```


If you prefer zsh, here is how to install it:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

It is possible git submodule commands to fail, try [this to solve it](http://stackoverflow.com/questions/14768509/unable-to-checkout-git-submodule-path)

# Notes
  * .netrc - part of goobook mutt helper

# Convert .gitmodule files to commands:
	
```
cat .gitmodules | grep -v submodule \
	| paste -s -d' \n' - | tr -s '\t' -t \
	| awk '{ print "git submodule add " $6 " " $3}'

git submodule update --remote --merge
```
