Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36653 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbfC2C0w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Mar 2019 22:26:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id 85so443761pgc.3
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2019 19:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <CALsfCbd2UKVsC4k=da5x+joaBQk-phCizkyF0vXeMNOYDojWwQ@mail.gmail.com>
 <CAOQ4uxgEaMVF4kp4O8T=vY4zZSWfFYK2JmhwB4JSKhRVb-0KXw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgEaMVF4kp4O8T=vY4zZSWfFYK2JmhwB4JSKhRVb-0KXw@mail.gmail.com>
From: koishi komeiji <maykagura@gmail.com>
Date: Fri, 29 Mar 2019 10:26:39 +0800
Message-ID: <CALsfCbeFZu7WW3_-jGGtFA5EtM3H-yJ2wKpxhVbuXwK6uyOysg@mail.gmail.com>
Subject: Re: [Help]Cannot read symbolic link(Invalid argument) in overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

1.Which fs is this on?
the fs on diff/ is ext2/ext3, the fs on merged/ is  overlayfs.

root:/var/lib/docker/overlay2# stat -f  dd9.../diff/usr/lib/libscheduler.so
  File: "dd9.../diff/usr/lib/libscheduler.so"
    ID: c31f80297c8e8883 Namelen: 255     Type: ext2/ext3
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 21641822   Free: 14040944   Available: 12935844
Inodes: Total: 5505024    Free: 4977146

root:/var/lib/docker/overlay2# stat -f dd9.../merged/usr/lib/libscheduler.so
  File: "dd9.../merged/usr/lib/libscheduler.so"
    ID: c31f80297c8e8883 Namelen: 255     Type: overlayfs
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 21641822   Free: 14040942   Available: 12935842
Inodes: Total: 5505024    Free: 4977146


2.Do you know if the symlink was just recently created or if it existed before
container has been started?
the symlink is existed before container has been started,but it is
compressed in the image.After the container run, it is decompressed in
/usr/lib.
so the upperdir(diff/) has the symlink while the lowerdir doesnot have.

bash-4.2# mount  | grep overlay
overlay on / type overlay
(rw,noatime,lowerdir=/var/lib/docker/overlay2/l/PVL6K62ZQQT3UNPFRH3GW4XAAU:/var/lib/docker/overlay2/l/D7RVPB765GILGJYUU4XSKOXWFF,upperdir=/var/lib/docker/overlay2/dd9.../diff,workdir=/var/lib/docker/overlay2/dd9.../work)

root:/var/lib/docker/overlay2# find . -name "libscheduler.so"
./dd9.../diff/usr/lib/libscheduler.so
./dd9.../merged/usr/lib/libscheduler.so

3.I imagine that if you restart container or just drop caches problem
goes away, but if problem still persists,
I cannot restart the container,for it is not mine.It is using by other tester.

4.Can you try to 'cat' the file under 'diff' folder?
If I cat the file under 'diff' folder.It shows ok without error.It
would show the file that the symlink links to.

5.Please record strace from failures (e.g. of cat, stat, ls, readlink).
the strace record is too long. the important error info is as following:
open("dd9.../merged/usr/lib/libscheduler.so", O_RDONLY) = -1 ELOOP
(Too many levels of symbolic links)
readlink("dd9.../merged/usr/lib/libscheduler.so", 0x7ffff35d3690,
8191) = -1 EINVAL (Invalid argument)


 I will paste strace record in the next mail.Thanks for your addvice!

On Wed, Mar 27, 2019 at 8:09 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Mar 27, 2019 at 4:44 AM koishi komeiji <maykagura@gmail.com> wrote:
> >
> > Hello.I met a bug about overlayfs again. I run a container by docker .
> > In the container, a symbolic link has been broken.I switch to host,
> > and find the broken file in /var/lib/docker.   I find 2 file that one
> > is in /var/lib/docker/overlay2/e3.../merged and another one is in
> > /var/lib/docker/overlay2/e3.../diff.
> > The directory of /var/lib/docker/overlay2/e3.../merged is mounted on
> > overlay fs. The 2 file have same inode. I think this means they are
> > the same file. The file in /var/lib/docker/overlay2/e3.../diff is ok.
> > But the file in /var/lib/docker/overlay2/e3.../merged is broken.
> > I doubt this is a bug of overlayfs.
> >
> > root:/var/lib/docker# df -h
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/sda1        83G   29G   50G  38% /
> > overlay          83G   29G   50G  38% /var/lib/docker/overlay2/e3ed8.../merged
> > ...
> >
> >
> > root:/var/lib/docker# find . -name "libdrv_ip6proen.so"
> > ./overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
> > ./overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> >
> >
> > root:/var/lib/docker# cat overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> > cat: overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so: Too many
> > levels of symbolic links
> >
> > root:/var/lib/docker# ls -li overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> > ls: cannot read symbolic link
> > 'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so': Invalid
> > argument
> > 3038490 lrwxrwxrwx 1 root root 26 3 25 16:24
> > overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> >
> > root:/var/lib/docker# ls -li overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
> > 3038490 lrwxrwxrwx 1 root root 26 3 25 16:24
> > overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so ->
> > libdrv_ip6proen.so.0.0.0.4
> >
> >
> >
> >
> > root:/var/lib/docker# stat overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
> >   File: 'overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so' ->
> > 'libdrv_ip6proen.so.0.0.0.4'
> >   Size: 26              Blocks: 0          IO Block: 4096   symbolic link
> > Device: 801h/2049d      Inode: 3038490     Links: 1
> > Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2019-03-26 16:38:47.588388845 +0800
> > Modify: 2019-03-25 16:24:05.536041935 +0800
> > Change: 2019-03-25 16:24:05.536041935 +0800
> >  Birth: -
> >
> >
> > root:/var/lib/docker# stat overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> >   File: 'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so'stat:
> > cannot read symbolic link
> > 'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so': Invalid
> > argument
> >
> >   Size: 26              Blocks: 0          IO Block: 4096   symbolic link
> > Device: 801h/2049d      Inode: 3038490     Links: 1
> > Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2019-03-26 16:38:47.588388845 +0800
> > Modify: 2019-03-25 16:24:05.536041935 +0800
> > Change: 2019-03-25 16:24:05.536041935 +0800
> >  Birth: -
> >
> >
> >
> > root:/var/lib/docker# uname -a
> > Linux z15572-virtual-machine 4.9.29 #1 SMP Tue Oct 16 22:13:48 CST
> > 2018 x86_64 x86_64 x86_64 GNU/Linux
> >
> > root:/var/lib/docker# cat /etc/os-release
> > NAME="Ubuntu"
> > VERSION="16.04.5 LTS (Xenial Xerus)"
> > ID=ubuntu
> > ID_LIKE=debian
> > PRETTY_NAME="Ubuntu 16.04.5 LTS"
> > VERSION_ID="16.04"
> > HOME_URL="http://www.ubuntu.com/"
> > SUPPORT_URL="http://help.ubuntu.com/"
> > BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
> > VERSION_CODENAME=xenial
> > UBUNTU_CODENAME=xenial
>
> Which fs is this on?
> Please cat /proc/mountinfo from host.
>
> Do you know if the symlink was just recently created or if it existed before
> container has been started?
>
> I imagine that if you restart container or just drop caches problem
> goes away, but if problem still persists, please keep container up
> maybe Miklos will have more ideas for things to check.
>
> If seems that stat(2) works correctly, but readlink(2) return -EINVAL.
> Why does readlink(2) work for upper inode and no for overlay inode?
> The only reason I can think of is that somehow d_is_symlink(dentry)
> in vfs_get_link() is false, but not sure how that can come to be.
>
> Another clue is that open(2) (i.e. from cat) returns -ELOOP, which
> seem to also hint that maybe should_follow_link() sees false
> d_is_symlink(dentry) and open tries to open the symlink inode
> itself.
> Can you try to 'cat' the file under 'diff' folder?
> Please record strace from failures (e.g. of cat, stat, ls, readlink).
>
> Thanks,
> Amir.
