# dot-scripts
Scripts for common tasks sourced in .bashrc // .bash_profile

* Miscellaneous/drafts etc. in top level
* `exports` directory gets exported to PATH with this line in `.bashrc` [sourced to `.bash_profile`]:

   ```
export PATH=$PATH:/home/louis/.scripts/exports
```
   (thus symlinks to binaries and scripts end up accessible from the command line without their source files cluttering the namespace)
* It's also possible to keep 'nicer names' (e.g. leave off file extensions, shorten for the idiosyncrasies of shell tab completion ease-of-use etc...) for sym links under exports while maintaining understandable source folders
