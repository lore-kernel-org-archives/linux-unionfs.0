From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Exporting a unique ino/dev pair to user space
Date: Thu, 7 Jun 2018 10:38:51 +0300
Message-ID: <CAOQ4uxjT5U=cMvfDUBiHbmM-Wk0qp8Zo8DnzgYiKkkCUSo+nBA@mail.gmail.com>
References: <20180606213807.GE9445@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180606213807.GE9445@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Jeff Mahoney <jeffm@suse.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jun 7, 2018 at 12:38 AM, Mark Fasheh <mfasheh@suse.de> wrote:
> Hi,
>
> We have an inconsistency in how the kernel is exporting inode number /
> device pairs for user space. There's of course stat(2) and statx(2),
> but aside from those we simply dump inode->i_ino and super->s_dev. In
> some cases, the dumped values differ from what is returned via stat(2)
> or statx(2). Some filesystems might even show duplicate (but
> internally different!) pairs when the raw i_ino/s_dev is used.
>
> Some examples where we dump raw ino/dev:
>
> - /proc/<pid>/maps. I've written about how this confuses lsof(8):
>   https://marc.info/?l=linux-btrfs&m=130074451403261&w=2
>
> - Unsurprisingly, many VFS tracepoints dump ino and/or dev. See
>   trace/events/lock.h or trace/events/writeback.h for examples.
>
> - eventpoll also dumps the raw ino/dev pair via ep_show_fdinfo()
>
> - Audit records the raw ino/dev and passes them around. We do seem to
>   have paths printed from audit as well, but if it's printed with the
>   wrong ino/dev pair I believe my point still stands.
>

knfsd also looks at i_ino. I converted one or two of these places
to getattr callbacks recently, but there are still some more.

Anyway, w.r.t. Overlayfs, I believe Miklos' work to make file_inode()
an overlay inode should resolve several of the issues listed above -
probably not all, but didn't check every tracepoint..

>
> This breaks software which expects these pairs to be unique, and can
> put the user in a situation where they might not be able to find an
> inode referenced from the kernel. What's even worse - depending on how
> ino is exported, they might even find the *wrong* inode.
>
> I also should point out that we're likely at this point because
> stat(2) has been using an unsigned long for ino. On a 32 bit system,
> it would have been impossible for the user to get the real inode
> number in the first place. So there probably wasn't much we could do.
>
> These days though, we have statx(2) which will do the right thing on
> all platforms so we no longer have that excuse. The user ought to be
> able to take an ino/dev pair and ultimately find the actual file on
> their system, partially with the help of statx(2).
>
>
> Some examples of how ino is manipulated by filesystems:
>
> - On 64 bit i_ino and kstat->ino tend to be filled in correctly (from
>   what I can tell). stat->dev is not always consistent with super->s_dev.
>
> - On 32 bits, many filesystems employ a transformation to squeeze a 64
>   bit identifier into 32 bits. The exact methods are fs specific,
>   what's important is that we're losing information, introducing the
>   possibility of duplicate inode numbers.
>
> - On all platforms, Btrfs and Overlayfs can have duplicate inode
>   numbers. Of course, device can be different across the fs as well
>   with the kernel reporting s_dev and these filesystems returning
>   a different device via stat() or statx().
>
>
> Getting the inode number portion of this pair fixed would immediately
> solve the situation for all filesystems except Btrfs and
> Overlayfs - they report a different device from stat.
>
> Regarding the device portion of the pair, I'm honestly not sure
> whether Overlayfs cares, and my attempts to fix the s_dev situation
> for Btrfs have all come to the same dead ends that I've hit briefly
> looking into this inode number issue - the problems are intrinsically
> linked.
>
> So my questions are:
>
> 1) Do we care about this? On one hand, we've had this inconsistency
>    for a long time, for various reasons. On the other hand, I can point
>    to bugzilla's where these inconsistencies have become a problem.
>
>    In the case that we don't care, any fs-internal solutions are
>    likely to be extremely disruptive to the end user.
>
>
> 2) If we do care, how do we fix this?
>
>  2a) Do we use 64 bit i_ino on 32 bit systems? This has some obvious
>      downsides from a memory usage standpoint. Also it doesn't fully
>      address the issue - we still have a device field that Btrfs and
>      Overlayfs override.
>
>      We could combine this with an intermediate structure between the
>      inode and super block so s_dev could be abstracted out. See my
>      fs_view patches for an example of how this could be done:
>      https://www.spinics.net/lists/linux-fsdevel/msg125492.html
>
>  2b) Do we call ->getattr for this information? Plumbing a vfsmount to
>      various regions of the kernel like audit, or some of the deeper
>      tracepoints looks ugly and prone to life-timing issues (which
>      vfsmount do we use?). On the upside, we could probably make it
>      really light by only sending down the STATX_INO flag and letting
>      the filesystem optimize accordingly.
>
>  2c) I don't think we can really use a dedicated callback without
>      passing the vfsmount through since Overlayfs ->getattr might call
>      the lower fs ->getattr. At that point we might as well use getattr.
>

Didn't get the Overlayfs lower fs getattr argument.
Overlayfs doesn't use the vfsmount passed into getattr
and it could very well pass a dentry to lower fs getattr.

As a matter of fact, out of 35 getattr implementations in the kernel:
(git grep "\s\.getattr\s" fs| awk '{print $4}'| sort -u|grep -v
"nfs.*_proc_getattr"|wc -l)
there is only one using the vfsmount - nfs_getattr() for MNT_NOATIME
check and most of them only ever use d_inode(path->dentry).

This API seems quite odd.
Maybe it should be fixed so more in kernel call sites could call getattr
without a vfsmount.
Not sure what would be the best way to handle nfs_getattr().

Thanks,
Amir.
