# crack-the-windows
A script to automate process of clearing Windows password using chntpw tool.

This script first will try to find `NTFS` partitions and then mount them one-by-one and search for `SAM` file.
If finds any then it will try to clear its password using `chntpw` utility.

See [chntpw](https://github.com/Tody-Guo/chntpw)'s repo.

## Usage 
Find the `SAM` file and list all users available.

```sudo ./crack-the-windows.sh ```

Example output:
```
Trying: /dev/sda2
found SAM file in: /dev/sda2
----------------------------------------------------------------------
| RID -|---------- Username ------------| Admin? |- Lock? --|
| 01f4 | Administrator                  | ADMIN  | dis/lock |
| 03e9 | behnam                         | ADMIN  |          |
| 01f7 | DefaultAccount                 |        | dis/lock |
| 01f5 | Guest                          |        | dis/lock |
| 01f8 | WDAGUtilityAccount             |        | dis/lock |
----------------------------------------------------------------------
```

Clear a users password:

```sudo ./crack-the-windows.sh behnam```

This command will open `chntpw`s interactive editor, so you can clear the password and save the `SAM` file.([more info](https://github.com/Tody-Guo/chntpw))