Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40664 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731383AbfDADZp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 Mar 2019 23:25:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id u9so3996742pgo.7
        for <linux-unionfs@vger.kernel.org>; Sun, 31 Mar 2019 20:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <CALsfCbd2UKVsC4k=da5x+joaBQk-phCizkyF0vXeMNOYDojWwQ@mail.gmail.com>
 <CAOQ4uxgEaMVF4kp4O8T=vY4zZSWfFYK2JmhwB4JSKhRVb-0KXw@mail.gmail.com>
 <CALsfCbeFZu7WW3_-jGGtFA5EtM3H-yJ2wKpxhVbuXwK6uyOysg@mail.gmail.com>
 <CAOQ4uxhd9OdACFu5nedo-zeGZutu2a=RQdSQtUb7TZwwpgkCjw@mail.gmail.com>
 <CALsfCbfdJJycdVeyO=O1Jh7jz9XL7sDqj3xFn2cC+fgzcnrVtA@mail.gmail.com>
 <CAOQ4uxgXpMLGFfCVw9oP7o5APDgtkjqAOde6fuJMao4-0=Y0Zw@mail.gmail.com> <CALsfCbdS5Vu8TLT477A4pvMip=NaNNABOkRy1x=U_V9W0=L6Dg@mail.gmail.com>
In-Reply-To: <CALsfCbdS5Vu8TLT477A4pvMip=NaNNABOkRy1x=U_V9W0=L6Dg@mail.gmail.com>
From: koishi komeiji <maykagura@gmail.com>
Date: Mon, 1 Apr 2019 11:25:32 +0800
Message-ID: <CALsfCbedRf-Nt=oCgyVi9qJCa6WrkTu-GAvkMVhYd56M-0c6JA@mail.gmail.com>
Subject: Re: [Help]Cannot read symbolic link(Invalid argument) in overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

>This problem should not exist in stable kernel >= v4.14
But My host's kernel version is 4.9.29.

Sorry, I got it wrong.I just see  v4.14 as 4.1.4.I will ask my
classmate to update the kernel version.Thanks!!

On Mon, Apr 1, 2019 at 10:52 AM koishi komeiji <maykagura@gmail.com> wrote:
>
> Sorry for replying late.
> >This problem should not exist in stable kernel >= v4.14
> But My host's kernel version is 4.9.29.
>
> Kernel info:
> #uname -a
> Linux z15572-virtual-machine 4.9.29 #1 SMP Tue Oct 16 22:13:48 CST
> 2018 x86_64 x86_64 x86_64 GNU/Linux
>
> #cat /proc/version
> Linux version 4.9.29 (root) (gcc version 5.4.0 20160609 (Ubuntu
> 5.4.0-6ubuntu1~16.04.11) ) #1 SMP Tue Oct 16 22:13:48 CST 2018
>
> >The problem described in the patch was solved in upstream kernel by
> >commits:
> >09d8b586731b ovl: move __upperdentry to ovl_inode
> >31747eda41ef ovl: hash directory inodes for fsnotify
>
> Have these two commits been submitted to the kernel 4.9.29?
>
> I will try to use your patch. Thanks U very much !
>
> On Fri, Mar 29, 2019 at 7:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Fri, Mar 29, 2019 at 10:02 AM koishi komeiji <maykagura@gmail.com> wrote:
> >
> > >> I imagine that if you restart container or just drop caches problem
> > >> goes away?
> > >
> > > I try to drop caches, the problem goes away immediately.
> > > So I think the problem is about dentry and inode cache.
> > >
> > > # ls -l | grep invalid
> > > ls: cannot read symbolic link librmifm.so: Invalid argument
> > > ls: cannot read symbolic link libdrv_vlan.so: Invalid argument
> > > #
> > > # echo 2 > /proc/sys/vm/drop_caches
> > > #
> > > # ls -l | grep invalid
> > > #
> > >
> > >
> > >
> > >> Do you know if the symlink was just recently created or if it existed before
> > >> container has been started?
> > >
> > > The symlink in the image is ok. when the container start, the  symlink
> > > is decompressed from a cpio file.In this time ,it is still  ok. Just
> > > after some time, it break suddenly.
> > >
> > >
> >
> > Koishi,
> >
> > I have a theory, but it is not so easy to test.
> > I am not sure if you are able to compile and install a new overlayfs module.
> > Attached is un-tested patch to solve the speculated problem.
> >
> > This problem should not exist in stable kernel >= v4.14, so if you
> > can update the host kernel that would be the best option for you.
> >
> > The problem described in the patch was solved in upstream kernel by
> > commits:
> > 09d8b586731b ovl: move __upperdentry to ovl_inode
> > 31747eda41ef ovl: hash directory inodes for fsnotify
> >
> > But those depend on many other changes, so cannot be easily
> > backported to kernel v4.9.
> >
> > What I speculate that happens is:
> > 1. Some ovl dentry holds a reference on upper dentry
> > 2. upper dentry hold a ref on upper NON-symlink inode
> > 3. overlay inode->i_private point to upper inode, but does not
> >     hold a refcount to upper inode
> > 4. overlay inode is hashed by value of upper inode pointer
> > 5. At some point, overlay dentry, upper dentry and upper inode
> >    are dropped, but overlay inode remains with elevated refcount
> >    (maybe by inotify) and hashed
> > 6. A new lookup of the symlink allocates a new upper inode
> >     struct and reuses the address of NON-symlink free upper inode
> > 7. ovl lookup finds the old ovl inode in cache by upper inode
> >     address, but the found overlay inode is not a symlink
> > 8. The new ovl dentry is !d_is_symlink, although stat(2) will show
> >     i_mode from real inode that is a symlink
> > 9. readlink(2) of ovl dentry will also fail with -EINVAL
> > 10. open(2) on ovl dentry will not try to follow symlink and will
> >     eventually fail to open the symlink itself with -ELOOP
> >
> > Thanks,
> > Amir.
