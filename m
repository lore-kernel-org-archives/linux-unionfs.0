From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH] ovl: count subdirs to get the correct link count
Date: Mon, 12 Oct 2015 16:35:56 +0200
Message-ID: <CAJfpegsbLD+hKBRVmPVBRvMyJ-RR8nDqsd+sPrknGDc_t=DfOw@mail.gmail.com>
References: <1444636874-16886-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34274 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbbJLOf5 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 10:35:57 -0400
Received: by obbda8 with SMTP id da8so108080011obb.1
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2015 07:35:57 -0700 (PDT)
In-Reply-To: <1444636874-16886-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, v9fs-developer@lists.sourceforge.net, Zheng Liu <wenqing.lz@taobao.com>

On Mon, Oct 12, 2015 at 10:01 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> This patch makes overlayfs count subdirs to get the correct link count
> because 9pfs needs this.  Otherwise, we will get a warning message from
> inc_nlink() because inode->i_nlink == 0 and inode->i_state w/o
> I_LINKABLE flag in a virtualization environment.  The warning message
> looks like as below.
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 27343 at ../fs/inode.c:330 inc_nlink+0x32/0x50()
> Modules linked in:
> CPU: 0 PID: 27343 Comm: mkdir Tainted: G        W       4.1.6+ #1
>  ffffffff81540a0e ffff88046b103da8 ffffffff8120d849 ffff88046b103db8
>  ffffffff8120d897 ffff88046b103df8 ffffffff81044bbd ffff88046b2a0403
>  ffff88046b936d68 0000000000000000 ffff88046b936d68 ffff88046b2a9300
> Call Trace:
>  [<ffffffff8120d849>] __dump_stack+0x19/0x20
>  [<ffffffff8120d897>] dump_stack+0x47/0x60
>  [<ffffffff81044bbd>] warn_slowpath_common+0xad/0xe0
>  [<ffffffff81044c0a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8117caa2>] inc_nlink+0x32/0x50
>  [<ffffffff811d3c89>] v9fs_vfs_mkdir_dotl+0x269/0x2b0
>  [<ffffffff8116f9a9>] vfs_mkdir+0x89/0xd0
>  [<ffffffff81173912>] SyS_mkdirat+0x82/0xd0
>  [<ffffffff8116dae9>] SyS_mkdir+0x19/0x20
>  [<ffffffff813b29d7>] system_call_fastpath+0x12/0x6a
> ---[ end trace dd0930847ec4e6d2 ]---
>
> The root cause is that overlayfs doesn't count subdirs and it reports
> a wrong link count.  From the output of stat(1) we can seen that the
> 'Links' of a directory is 1, but at least it should be 2.  When creating
> a directory in 9pfs, the parent directory's inode->i_nlink is 0 and a
> WARN_ON will be triggered.

I don't see how the above two statements have anything to do with each
other. And the "fix" is obviously wrong (and not tested), since it
still won't count the subdirectories.

> This warning can be reproduced by the following steps.
>
> [In host os]
> 1. build a ROOTFS for booting up a vm using 9pfs
> 2. mount -t overlay -olowerdir=${lower},upperdir=${upper},workdir={work} none ${ROOTFS}/mnt
> 3. run a vm using 9pfs
>    e.g. http://www.linux-kvm.org/page/9p_virtio
> [In guest os]
> 4. cd /mnt
> 5. mkdir 1
> 6. rm -rf 1; mkdir 1

In the stack trace above I don'[t see overlayfs calls.  So apparently
the mkdir goes directly to the 9p filesystem.  So where's overlayfs in
all this?

Thanks,
Miklos


>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/overlayfs/dir.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 692ceda..fbeb841 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -147,14 +147,6 @@ static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
>         stat->dev = dentry->d_sb->s_dev;
>         stat->ino = dentry->d_inode->i_ino;
>
> -       /*
> -        * It's probably not worth it to count subdirs to get the
> -        * correct link count.  nlink=1 seems to pacify 'find' and
> -        * other utilities.
> -        */
> -       if (OVL_TYPE_MERGE(type))
> -               stat->nlink = 1;
> -
>         return 0;
>  }
>
> --
> 2.4.0.rc3.3.g6eb1401
>
