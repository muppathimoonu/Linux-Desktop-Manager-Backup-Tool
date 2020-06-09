# Desktop-Manager-Backup-Tool
Complete desktop backup tool for Linux.
Backup and restore linux desktop settings easily.
* Themes
* Icons
* WM Settings [ all apps ]
* Wallpaper
* Panels
* Applets
* Desklets
* Extensions
* Launchers


## NOTE

System Default themes and icons are not included in the backup to reduce backup time and size.

Excluded themes and icons are listed in respective DM files.

* X-Cinnamon.icons
* X-Cinnamon.themes


## TODO

- Currently supports cinnamon desktop only.

- Yet to support other desktop managers.


## Installation

```bash
git clone https://github.com/muppathimoonu/Desktop-Manager-Backup-Tool.git
```

## Usage

```bash
chmod +x utility.sh
./utility.sh backup < path >
./utility.sh restore xxxxxx.gz
`````
## Contributing
Pull requests are welcome. Please open an issue to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)
