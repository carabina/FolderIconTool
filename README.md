# FolderIconTool

Swift framework and tool to generate engraved macOS folder icons.

![](https://github.com/pvieito/FolderIconTool/raw/master/Documentation/README.png)

## Usage

```bash
$ swift run FolderIconTool -i Image.png -t Target/Directory
```

```bash
$ swift run FolderIconTool -h
Usage: FolderIconTool [options]
-i, --input:
    Input image.
-p, --mask-opacity:
    Mask opacity.
-z, --mask-size-scale:
    Mask size scale.
-o, --output:
    Output path.
-t, --target:
    Target directory.
-x, --show:
    Show generated icon.
-v, --verbose:
    Verbose mode.
-h, --help:
    Prints a help message.
```

## Dependencies

- Swift 5.1+
- [ImageMagic](http://www.imagemagick.org/)

## Note

`FolderIconTool` is heavily inspired by the [`folderify` by Lucas Garron](https://github.com/lgarron/folderify).
