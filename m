From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: two questiones about overlayfs
Date: Tue, 8 Aug 2017 07:01:30 +0200
Message-ID: <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:35106 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbdHHFBc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Aug 2017 01:01:32 -0400
Received: by mail-yw0-f171.google.com with SMTP id l82so14700801ywc.2
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Aug 2017 22:01:31 -0700 (PDT)
In-Reply-To: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com, Vivek Goyal <vgoyal@redhat.com>

On Mon, Aug 7, 2017 at 9:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi,all:
> I found two problemes about overlayfs, please let me know what you think:
>
> 1. Cannot update upper dir's access time.
> Reproduce:
> # mkdir lower upper worker merger
> # mkdir upper/dir
> # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
> # ls mrger/dir
> # stat mrger/dir
>   Access: 2017-08-07 11:03:56.364771584 -0400
>   Modify: 2017-08-07 11:01:52.319771584 -0400
>   Change: 2017-08-07 11:01:52.319771584 -0400
> # touch mrger/dir/aa
> # stat mrger/dir
>   Access: 2017-08-07 11:03:56.364771584 -0400
>   Modify: 2017-08-07 11:05:33.969771584 -0400
>   Change: 2017-08-07 11:05:33.969771584 -0400
> # ls mrger/dir
> # stat mrger/dir
>   Access: 2017-08-07 11:03:56.364771584 -0400
>   Modify: 2017-08-07 11:05:33.969771584 -0400
>   Change: 2017-08-07 11:05:33.969771584 -0400
>
> I find the reason of this problem is in update_ovl_inode_times():
> (598e3c8f7 "vfs: update ovl inode before relatime check")
>
> static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
>                                bool rcu)
> {
>         if (!rcu) {
>                 struct inode *realinode = d_real_inode(dentry);
>
>         *d_real_inode() cannot get dir's real inode, so i_mtime always equal to i_ctime*
>         *an not updated*
>

Technically, I think this could be changed to check
if unlikely(dentry->d_flags & DCACHE_OP_REAL) and call
vfs_getattr(&path, &stat, STATX_MTIME | STATX_CTIME, AT_STATX_SYNC_AS_STAT)
to get the really real inode times also for directory.

But I think that would be considered a hack and the proper way to solve this
would be to introduce a new dentry op ->d_real_inode().
Unlike d_real_inode() which returns the inode used for open,
->d_real_inode() would return the inode used for stat.

If the helper d_real_inode() would call the new op,
the only other user of d_real_inode() (check_conflicting_open) would have to
open code inode_is_open_for_write(d_real(dentry)->d_inode)

>                 if (unlikely(inode != realinode) &&
>                     (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
>                      !timespec_equal(&inode->i_ctime, &realinode->i_ctime))) {
>                         inode->i_mtime = realinode->i_mtime;
>                         inode->i_ctime = realinode->i_ctime;
>                 }
>         }
> }
>
> 2. Chattr will modify lower file's attributes directly.
> Reproduce:
> # mkdir lower upper worker merger
> # touch lower/aa
> # lsattr -p lower/aa
>     0 --------------e---- lower/aa
> # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
> # chattr -p 123 merger/aa             #set project id
> # lsattr -p lower/aa
>   123 --------------e---- lower/aa
>
> If we try to set "immutable" or any other attributes, the result are consistent.
> Because chattr open file in RDONLY mode, so it will not trigger copyup, and then,
> FS_IOC_SETFLAGS ioctl will get the lower inode and modify it.

Ouch! I guess it's a "known to some" issue.
Fixing this would be a pain (intercept ioctl and whitelisting readonly
fs specific ioctls).
Hopefully, at least sepolicy would prevent these unauthorized changes
to lower if
selinux is used??

Amir.
