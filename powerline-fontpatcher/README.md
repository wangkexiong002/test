## Docker Image: wangkexiong/powerline-fontpatcher

Patch arrow and symbol glyphs into fonts for usage with Powerline and other compatible plugins.

### Example:

* Patch the otf files from current directory

```bash
$ docker run --rm -v $PWD:/working wangkexiong/powerline-fontpatcher *.otf
```

* Patch the ttf files from current directory and DO NOT change font names

```bash
$ docker run --rm -v $PWD:/working wangkexiong/powerline-fontpatcher *.ttf -n
```

