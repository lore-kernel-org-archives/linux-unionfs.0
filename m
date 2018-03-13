Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgpMefj36c3PJUM=ejyDuDges3Yv3f5-FaHKNL1wvYJKw@mail.gmail.com>
References: <CALLuPvoJ_Eb4C9g4ouo97MUYAbYC0yJX0qVfJzihj2EGA5tbGQ@mail.gmail.com>
 <CAOQ4uxgpMefj36c3PJUM=ejyDuDges3Yv3f5-FaHKNL1wvYJKw@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Tue, 13 Mar 2018 09:39:21 +0800
Message-ID: <CALLuPvpm5mTaQS5CgE=5U4RPK9GyfvBQd5hL_9JDLNEE=3=q3w@mail.gmail.com>
Subject: Re: flock fails in overlay nfs-exported file
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,
Thanks your prompt response. After compare flock(1) and my flock(2)
test program, it seems open flag makes the result different. strace
result shows open with O_RDONLY flock fails (case A), open with
O_RDWR|O_CREAT|O_NOCTTY flock works (case B) and open local ext4 file
with O_RDONLY flock works too (case C)

case A:
strace myflock /mnt/n/foo
open("/mnt/n/foo", O_RDONLY)            = 3
flock(3, LOCK_EX|LOCK_NB)               = -1 EBADF (Bad file descriptor)

case B:
strace flock -x -n /mnt/n/foo echo locked
open("/mnt/n/foo", O_RDWR|O_CREAT|O_NOCTTY, 0666) = 3
flock(3, LOCK_EX|LOCK_NB)               = 0

case C:
strace myflock /tmp/t
open("/tmp/t", O_RDONLY)                = 3
flock(3, LOCK_EX|LOCK_NB)               = 0

Below is my test configuration of case A:
- underlying filesystem:
ext4
- /proc/mounts:
/dev/disk/by-uuid/a2d5005c-.... / ext4
rw,relatime,errors=remount-ro,data=ordered 0 0
none /share overlay
rw,relatime,lowerdir=/base/lower,upperdir=/base/upper,workdir=/base/work,index=on,nfs_export=on
0 0
localhost:/share /mnt/n nfs4
rw,relatime,vers=4.0,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=127.0.0.1,local_lock=none,addr=127.0.0.1
0 0
- /etc/exports
/share *(rw,sync,no_subtree_check,no_root_squash,fsid=41)


For dmesg, in case A, there's no any output from dmesg, however in my
applications running with overlay nfs exported files, there are  some
lock related messages. Which lock call triggers it, need more
investigation.
The message from nfs server side is like:
[  872.940080] Leaked POSIX lock on dev=0x0:0x42 ino=0xf5a1
fl_owner=0000000023265f44 fl_flags=0x1 fl_type=0x1 fl_pid=1
[ 1939.829655] Leaked locks on dev=0x0:0x42 ino=0xf5a1:
[ 1939.829659] POSIX: fl_owner=0000000023265f44 fl_flags=0x1
fl_type=0x1 fl_pid=1

thanks,
Eddie

2018-03-12 20:07 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
> On Mon, Mar 12, 2018 at 9:38 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
>> Hello Miklos,
>> I'd like to report a flock(2) problem to overlay nfs-exported files.
>> The error return from flock(2) is "Bad file descriptor".
>>
>> Environment:
>> OS: Ubuntu 14.04.2 LTS
>> Kernel: 4.16.0-041600rc4-generic (from
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16-rc4/)
>>
>> Reproduce step:
>> (nfs server side)
>> mount -t overlay
>> -orw,lowerdir=/mnt/ro,upperdir=/mnt/u,workdir=/mnt/w,nfs_export=on,index=on
>> none /mnt/m
>> touch /mnt/m/foo
>> (nfs client side)
>> mount server:/mnt/m /mnt/n
>>
>> flock /mnt/n/foo
>> failed to lock file '/mnt/n/foo': Bad file descriptor
>>
>
> Does not reproduce on my end. I am using v4.16-rc5, but I don't think
> any of the fixes there are relevant to this failure.
>
> This is what I have for underlying fs, overlay and nfs mount options
> (index and nfs_export are on by default in my kernel):
>
> /dev/mapper/storage-lower_layer on /base type xfs
> (rw,relatime,attr2,inode64,noquota)
> share on /share type overlay
> (rw,relatime,lowerdir=/base/lower,upperdir=/base/upper/0,workdir=/base/upper/work0)
> c800:/share on /mnt/t type nfs
> (rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.91.126,mountvers=3,mountport=49494,mountproto=udp,local_lock=none,addr=192.168.91.126)
>
> $ touch /mnt/t/foo
> $ flock -x -n /mnt/t/foo echo locked
> locked
>
> Please share more information about nfs mount options and underlying filesystem
>
> Please check if you see any relevant errors/warnings in dmesg.
>
> Thanks,
> Amir.
