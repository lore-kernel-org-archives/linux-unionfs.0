Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAMp4zn9NsrdByVzWbThBd7Y0DsufJnqp=LdbDscbtyZx82E0Ug@mail.gmail.com>
In-Reply-To: <CAMp4zn9NsrdByVzWbThBd7Y0DsufJnqp=LdbDscbtyZx82E0Ug@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Oct 2018 21:20:44 +0300
Message-ID: <CAOQ4uxjfW0_hgrmYW97tirRqisgEyWALCCtVfBhTvwFjaset2A@mail.gmail.com>
Subject: Re: ovl: Ephemeral Mounts
Content-Type: text/plain; charset="UTF-8"
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ghartmann@netflix.com, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 6:28 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> We recently upgraded our kernel from 4.9 to 4.18 and were surprised to
> find a behaviour change in overlayfs. Overlayfs now calls sync on the
> upper dir's superblock on shutdown. This causes all of our containers
> to stall out for a little bit.
>
> We run lots of ephemeral "containers" with overlayfs (Docker) on XFS.
> A given XFS filesystem could be host to 50+ containers. We block our
> users from calling syncfs on their overlayfs mount. Unfortunately, on
> filesystem shutdown, syncfs gets called on the overlayfs, which calls
> syncfs on the upperdir, causing a ton of I/O on the block device. This
> is useless, because all of the data they wrote to the upperdir is
> subsequently removed.
>
> We believe that we're not going to be the only ones surprised by this behaviour.

Yeh, like all the users unhappy with EBUSY mounts because
of leaked old mounts... Sigh!
We should have named this filesystem unionsfs, because the unions won't
let us change anything in the contract ;-)

Without escaping responsibility for legacy behavior, which is very simple
to do technically, I will try to suggest "proper" solutions to fit your needs
until other users come along with other needs.

>
> Since we don't control shutdown of the mount namespace, and therefore
> control shutdown of the mount, it's not easy to add an ioctl to
> shutdown the filesystem cleanly, instead we need something at mount
> time we can use to indicate that syncfs shouldn't happen.
>
> I propose that we add a mount option "ephemeral" to the overlayfs
> mount which tells overlayfs to not syncfs at shutdown time.
>
> It might also be nice to extend this mount option to tell overlayfs to
> drop all syncfs calls, or return EIO.
>

umount(2) and syncfs(2) end up calling the same fs sync_fs method
so it wont be pleasant to have different behavior in the two cases.

> Does anyone else have any other suggestions?

I tried to find a similar semantics through the storage stack (e.g noflush)
but couldn't find anything like that in the kernel. The only thing that closely
resembles is the SHUTDOWN ioctl (xfs, ext4, f2fs), but you say that this
is not an option for your application.

Can you explain what prevents you from holding a reference (e.g via
master/slave mount propagation) on the overlay mount (that your
application created?) and when you need to tear down the container,
use that bind mount to issue the SHUTDOWN command before final
umount?

Implementing the "write-side" of the SHUTDOWN is quite simple
because the check for ofs->shutdown could go into ovl_want_write()
and that should actually be enough to provide the semantics you need.

Problems with SHUTDOWN ioctl solution are:
- Maybe you really cannot implement a shutdown hook?
- Other users may come complaining about a regression without
  the ability or intention to change their application
- Implementing just the "write-side" of the SHUTDOWN is not
  conforming to existing convention, but not sure if anybody has
  a need for the "full shutdown" (read and write return EIO).

Another "conventional" solution would be to fix ovl_sync_fs()
to only sync the upper inodes that belong to upper layer and not the
entire upper fs. There are already patches for this solution:
https://lkml.org/lkml/2018/6/10/4

The problem with this solution is that it is taking an opposite
direction of the plan to move upper inodes page cache to overlay
inodes, so it's unlikely that is going to happen and you will have to
wait for the overlay inode page cache.

Will that sort of solution be adequate for your application?
meaning each container tear-down only flushed its own upper inodes
but not the rest of the upper filesystem dirty inodes?

Thanks,
Amir.
