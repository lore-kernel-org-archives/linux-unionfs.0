From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Exporting a unique ino/dev pair to user space
Date: Fri, 8 Jun 2018 09:45:00 +0300
Message-ID: <CAOQ4uxjXA-todXfxXKh=iXpVuhH55A6xx_4WXahaHoyaS0QpRw@mail.gmail.com>
References: <20180606213807.GE9445@wotan.suse.de> <CAOQ4uxjT5U=cMvfDUBiHbmM-Wk0qp8Zo8DnzgYiKkkCUSo+nBA@mail.gmail.com>
 <20180607210642.GC28053@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180607210642.GC28053@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Jeff Mahoney <jeffm@suse.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 8, 2018 at 12:06 AM, Mark Fasheh <mfasheh@suse.de> wrote:
[...]

>> >  2c) I don't think we can really use a dedicated callback without
>> >      passing the vfsmount through since Overlayfs ->getattr might call
>> >      the lower fs ->getattr. At that point we might as well use getattr.
>> >
>>
>> Didn't get the Overlayfs lower fs getattr argument.
>> Overlayfs doesn't use the vfsmount passed into getattr
>> and it could very well pass a dentry to lower fs getattr.
>
> My main point in 2c) is that, from my understanding, Overlayfs may need to
> call down to one of the filesystem ->getattr() calls. Since those take a
> vfsmount we don't gain anything by having a unique callback from this - the
> plumbing work would be the same.
>

I guess I don't understand what you mean by "dedicated callback", but I
think we both in agreement that changing fs getattr() to take dentry is
preferred.

>
>> As a matter of fact, out of 35 getattr implementations in the kernel:
>> (git grep "\s\.getattr\s" fs| awk '{print $4}'| sort -u|grep -v
>> "nfs.*_proc_getattr"|wc -l)
>> there is only one using the vfsmount - nfs_getattr() for MNT_NOATIME
>> check and most of them only ever use d_inode(path->dentry).
>>
>> This API seems quite odd.
>> Maybe it should be fixed so more in kernel call sites could call getattr
>> without a vfsmount.
>> Not sure what would be the best way to handle nfs_getattr().
>
> Yeah I saw that nfs_getattr() is the only user of the vfsmount. I totally
> agree that this would be tons easier if we didn't have to pass the vfsmount
> (and like you said, there's only the ONE user).
>
> This is a bit hacky, but I wonder if we could blow the function signature
> back out to a dentry + vfsmount and make the vfsmount optional when getattr
> is called only for ino/dev. It's a bit ugly to have optional arguments like
> that but nfs would work with just a line or two change and the other fs
> would never even care.

OR.. change the signature of fs getattr() and vfs_getattr_nosec() to dentry
and set a kernel query_flag AT_STATX_NO_REMOTE_ATIME from
vfs_getattr(). No need to pass vfsmount to nfs.

Then users that access i_ino/s_dev can call vfs_getattr_nosec() with a
bonus of not having to go through security modules (which now they don't).

The only current user of vfs_getattr_nosec() expfs.c queries STATX_INO,
so change is safe.

Overlayfs doesn't need to get vfsmount in ovl_getattr() - it knows the
lower fs vfsmount for calling vfs_getattr() regardless and in other
places overlayfs just needs to query  STATX_INO, so it may also
use the light vfs_getattr_nosec() callback.

Thanks,
Amir.
