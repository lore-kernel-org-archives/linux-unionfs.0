Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1520945500.4474.26.camel@kernel.org>
References: <CALLuPvoJ_Eb4C9g4ouo97MUYAbYC0yJX0qVfJzihj2EGA5tbGQ@mail.gmail.com>
 <CAOQ4uxgpMefj36c3PJUM=ejyDuDges3Yv3f5-FaHKNL1wvYJKw@mail.gmail.com>
 <CALLuPvpm5mTaQS5CgE=5U4RPK9GyfvBQd5hL_9JDLNEE=3=q3w@mail.gmail.com>
 <CAOQ4uxhTqKkU_md1t8QSs9xGnBk+qr_3tv4FH3D5Nqg8jUpbQQ@mail.gmail.com> <1520945500.4474.26.camel@kernel.org>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Wed, 14 Mar 2018 10:11:36 +0800
Message-ID: <CALLuPvoFOHjP2HPJ4=dASctMhBTXY86cFWApg2S-LOdRG4wCDw@mail.gmail.com>
Subject: Re: flock fails in overlay nfs-exported file
Content-Type: text/plain; charset="UTF-8"
To: Jeff Layton <jlayton@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Trond Myklebust <trondmy@primarydata.com>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Jeff and Amir,
Thanks your clarifying, flock issue has nothing to do with overlay,
the application should change open flag to adapt for NFSv4.
For POSIX dmesg, I will try to find how it is triggered.

thanks,
Eddie

2018-03-13 20:51 GMT+08:00 Jeff Layton <jlayton@kernel.org>:
> On Tue, 2018-03-13 at 08:24 +0200, Amir Goldstein wrote:
>> [CC some NFS/lock folks (see history below top post)]
>>
>> On Tue, Mar 13, 2018 at 3:39 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
>> > Hi Amir,
>> > Thanks your prompt response. After compare flock(1) and my flock(2)
>> > test program, it seems open flag makes the result different. strace
>> > result shows open with O_RDONLY flock fails (case A), open with
>> > O_RDWR|O_CREAT|O_NOCTTY flock works (case B) and open local ext4 file
>> > with O_RDONLY flock works too (case C)
>> >
>> > case A:
>> > strace myflock /mnt/n/foo
>> > open("/mnt/n/foo", O_RDONLY)            = 3
>> > flock(3, LOCK_EX|LOCK_NB)               = -1 EBADF (Bad file descriptor)
>> >
>>
>> It looks like flock(1) has special code to handle this case for NFSv4
>> and fall back to open O_RDRW:
>> https://github.com/karelzak/util-linux/blob/master/sys-utils/flock.c#L295
>>
>> Although I tested with NFSv3 and open flags used by flock(1)
>> where O_RDONLY|O_CREAT|O_NOCTTY
>>
>> Why do you need to get an exclusive lock on a file that is open for read?
>> Can you open the file for write and resolve the issue like flock(1) does?
>>
>> You should know that even if you manage to lock a O_RDONLY fd,
>> if this file is then open for write by another process, that process will
>> get a file descriptor pointing to a *different* inode.
>> This is a long standing issue with overlayfs (inconsistent ro/rw fd),
>> which is being worked around by some user applications -
>> i.e. touch the file before first access to avoid applications
>> getting open file descriptor to lower inode.
>>
>> Let me know if this answer suffice or if you get this error only
>> with NFSv4 over overalyfs.
>>
>> > case B:
>> > strace flock -x -n /mnt/n/foo echo locked
>> > open("/mnt/n/foo", O_RDWR|O_CREAT|O_NOCTTY, 0666) = 3
>> > flock(3, LOCK_EX|LOCK_NB)               = 0
>> >
>> > case C:
>> > strace myflock /tmp/t
>> > open("/tmp/t", O_RDONLY)                = 3
>> > flock(3, LOCK_EX|LOCK_NB)               = 0
>> >
>>
>> So that presumably works because the test is not over NFS and not
>> because test is not over NFS+overlayfs, because of no NFSv4 flock
>> emulation.
>>
>
> Agreed. The real issue here is that NFSv4 emulates flock locks using
> LOCK/LOCKT byte-range locks. The NFSv4 spec does not allow you to set a
> write lock on a file open read-only, so that just plain doesn't work on
> NFSv4.
>
>>
>> > Below is my test configuration of case A:
>> > - underlying filesystem:
>> > ext4
>> > - /proc/mounts:
>> > /dev/disk/by-uuid/a2d5005c-.... / ext4
>> > rw,relatime,errors=remount-ro,data=ordered 0 0
>> > none /share overlay
>> > rw,relatime,lowerdir=/base/lower,upperdir=/base/upper,workdir=/base/work,index=on,nfs_export=on
>> > 0 0
>> > localhost:/share /mnt/n nfs4
>> > rw,relatime,vers=4.0,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=127.0.0.1,local_lock=none,addr=127.0.0.1
>> > 0 0
>> > - /etc/exports
>> > /share *(rw,sync,no_subtree_check,no_root_squash,fsid=41)
>> >
>> >
>> > For dmesg, in case A, there's no any output from dmesg, however in my
>> > applications running with overlay nfs exported files, there are  some
>> > lock related messages. Which lock call triggers it, need more
>> > investigation.
>> > The message from nfs server side is like:
>> > [  872.940080] Leaked POSIX lock on dev=0x0:0x42 ino=0xf5a1
>> > fl_owner=0000000023265f44 fl_flags=0x1 fl_type=0x1 fl_pid=1
>> > [ 1939.829655] Leaked locks on dev=0x0:0x42 ino=0xf5a1:
>> > [ 1939.829659] POSIX: fl_owner=0000000023265f44 fl_flags=0x1
>> > fl_type=0x1 fl_pid=1
>> >
>>
>> I'm not sure what those mean. Maybe NFS folks can shed some light.
>>
>
> That means that there was a file_lock associated with this struct file
> that was left on the POSIX lock list after filp_close. Either it didn't
> get released properly or a lock raced onto the list after
> locks_remove_posix ran. That should never happen, so this is likely a
> bug.
>
>> Thanks,
>> Amir.
>>
>> >
>> > 2018-03-12 20:07 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
>> > > On Mon, Mar 12, 2018 at 9:38 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
>> > > > Hello Miklos,
>> > > > I'd like to report a flock(2) problem to overlay nfs-exported files.
>> > > > The error return from flock(2) is "Bad file descriptor".
>> > > >
>> > > > Environment:
>> > > > OS: Ubuntu 14.04.2 LTS
>> > > > Kernel: 4.16.0-041600rc4-generic (from
>> > > > http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16-rc4/)
>> > > >
>> > > > Reproduce step:
>> > > > (nfs server side)
>> > > > mount -t overlay
>> > > > -orw,lowerdir=/mnt/ro,upperdir=/mnt/u,workdir=/mnt/w,nfs_export=on,index=on
>> > > > none /mnt/m
>> > > > touch /mnt/m/foo
>> > > > (nfs client side)
>> > > > mount server:/mnt/m /mnt/n
>> > > >
>> > > > flock /mnt/n/foo
>> > > > failed to lock file '/mnt/n/foo': Bad file descriptor
>> > > >
>> > >
>> > > Does not reproduce on my end. I am using v4.16-rc5, but I don't think
>> > > any of the fixes there are relevant to this failure.
>> > >
>> > > This is what I have for underlying fs, overlay and nfs mount options
>> > > (index and nfs_export are on by default in my kernel):
>> > >
>> > > /dev/mapper/storage-lower_layer on /base type xfs
>> > > (rw,relatime,attr2,inode64,noquota)
>> > > share on /share type overlay
>> > > (rw,relatime,lowerdir=/base/lower,upperdir=/base/upper/0,workdir=/base/upper/work0)
>> > > c800:/share on /mnt/t type nfs
>> > > (rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.91.126,mountvers=3,mountport=49494,mountproto=udp,local_lock=none,addr=192.168.91.126)
>> > >
>> > > $ touch /mnt/t/foo
>> > > $ flock -x -n /mnt/t/foo echo locked
>> > > locked
>> > >
>> > > Please share more information about nfs mount options and underlying filesystem
>> > >
>> > > Please check if you see any relevant errors/warnings in dmesg.
>> > >
>> > > Thanks,
>> > > Amir.
>
> --
> Jeff Layton <jlayton@kernel.org>
