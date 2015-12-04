# dot-scripts
Scripts for common tasks sourced in .bashrc // .bash_profile

* Miscellaneous/drafts etc. in top level
* `exports` directory gets exported to PATH with this line in `.bashrc` [sourced to `.bash_profile`]:

   ```
export PATH=$PATH:/home/louis/.scripts/exports
```
   (thus they end up accessible from the command line without their source files cluttering the namespace)
* The `exportfiles.sh` script contains `cp` commands to refresh binaries in the `exports` folder
