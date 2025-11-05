
[Video Reference](https://www.youtube.com/watch?v=LnKoncbQBsM)

Every files and directory have 3 permission groups
- Owner
- Groups
- Others

To see, go to any directory and run the `ls -l` command.

![[Pasted image 20251101120939.png]]

**1st section** 

> drwxrwxr-x

"d" means directory
"-" means file

→ there are other letters but these 2 are the most common

"rwx" means read, write, execute permissions
"-" means no permission

**2nd section**

> 7/5/1

Ignore, hard link count? (still not sure exactly)

**3rd and 4th section**

> afrieirham afrieirham

user group
### Most common commands

1. `chown` - change owner
example → `chown user:group filename`

2. `chmod` - change mode
example
- `chmod 755 filename` 
- `chmod +x filename`

linux scoring system
- read 4
- write 2
- execute 1

775 means rwxrwxr -x

+x means add x to all

![[Pasted image 20251101164702.png]]

