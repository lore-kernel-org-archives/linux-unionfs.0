Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A915C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 06:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFABE20771
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 06:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="EY2eHb12"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407771AbgDPGJy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:09:54 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25307 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407264AbgDPGJt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 02:09:49 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587017340; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=cpURVa+NrBpST772IIgbm6QDZ40r5QEt/PkJ95OQemvi5cBcgW33Y5+MT49FzW6r2RJRwKuRwFYcTacQ6jpZZhJhOjWd5QQJf6UgHmj1FzafTcsK4CaaGItSo+gAKX/dnOlEMBIDgDvboXesx8EkLaq1RpDiXoKMYG2nS1eFyN0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587017340; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=uhgG8WHDMgjxPnbTzn1IHRdHUtrkC2zbdBPCt6YTDbY=; 
        b=KQWyywAQRlZ/ibWxpnwdfa1BMUG//m8FoQ/Y3zoEZ7o8aqsLSfCEx+BhPJ2zaeLMR2gZHudUiTu6dEoiKsRPDiU5eB9kjA1ETZYRodlhbgvsDf0KmFRn6p1qPmpmHADfdmS6l3Ls677uCalwN5JsR8k9lZEUiRqx53/B5jFRp0I=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587017340;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=uhgG8WHDMgjxPnbTzn1IHRdHUtrkC2zbdBPCt6YTDbY=;
        b=EY2eHb12wCOzAEF443FnKeqEASVKERh4TBTZGyJrRTqXeFlZfU0ObJTFGQLp9t5P
        WA1JWqXvrZi21zKGE3RTPsnAnZA1W1BRr2LK5BY8kqxJyMGYJUjBww4Dtdq7y9be7M5
        mpXh3xPUXu3Wvx1lhfrcrblfIgU4CpFQdXAY8w+4=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1587017339185905.7437831409711; Thu, 16 Apr 2020 14:08:59 +0800 (CST)
Date:   Thu, 16 Apr 2020 14:08:59 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "Amir Goldstein" <amir73il@gmail.com>, "Jan Kara" <jack@suse.cz>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net>
In-Reply-To: <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
References: <20200210031009.61086-1-cgxu519@mykernel.net> <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
Subject: Re: [PATCH v11] ovl: Improving syncfs efficiency
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 03:19:50 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
 > > on upper_sb to synchronize whole dirty inodes in upper filesystem
 > > regardless of the overlay ownership of the inode. In the use case of
 > > container, when multiple containers using the same underlying upper
 > > filesystem, it has some shortcomings as below.
 > >
 > > (1) Performance
 > > Synchronization is probably heavy because it actually syncs unnecessar=
y
 > > inodes for target overlayfs.
 > >
 > > (2) Interference
 > > Unplanned synchronization will probably impact IO performance of
 > > unrelated container processes on the other overlayfs.
 > >
 > > This patch iterates upper inode list in overlayfs to only sync target
 > > dirty inodes and wait for completion. By doing this, It is able to
 > > reduce cost of synchronization and will not seriously impact IO perfor=
mance
 > > of unrelated processes. In special case, when having very few dirty in=
odes
 > > and a lot of clean upper inodes in overlayfs, then iteration may waste
 > > time so that synchronization is slower than before, but we think the
 > > potential for performance improvement far surpass the potential for
 > > performance regression in most cases.
 >=20
 > A possible optimization would be to only add inodes to the list that
 > may have been modified (e.g. opened for write, truncated, etc..).
 > This might not be a big win due to the fact that upper inodes are
 > likely those that have been recently copied up.  But as I see it, it
 > does not not have any drawbacks compared to adding the inode to the
 > list on lookup.
 >=20

Yes, I agree with you, I'll fix it in next version.

 >=20
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > > Changes since v10:
 > > - Add special handling in ovl_evict_inode() for inode eviction trigere=
d
 > > by kswapd memory reclamation(with PF_MEMALLOC flag).
 > > - Rebase on current latest overlayfs-next tree.
 > > - Slightly modify license information.
 > >
 > > Changes since v9:
 > > - Rebase on current latest overlayfs-next tree.
 > > - Calling clear_inode() regardless of having upper inode.
 > >
 > > Changes since v8:
 > > - Remove unnecessary blk_start_plug() call in ovl_sync_inodes().
 > >
 > > Changes since v7:
 > > - Check OVL_EVICT_PENDING flag instead of I_FREEING to recognize
 > > inode which is in eviction process.
 > > - Do not move ovl_inode back to ofs->upper_inodes when inode is in
 > > eviction process.
 > > - Delete unnecessary memory barrier in ovl_evict_inode().
 > >
 > > Changes since v6:
 > > - Take/release sb->s_sync_lock bofore/after sync_fs to serialize
 > > concurrent syncfs.
 > > - Change list iterating method to improve code readability.
 > > - Fix typo in commit log and comments.
 > > - Add header comment to sync.c.
 > >
 > > Changes since v5:
 > > - Move sync related functions to new file sync.c.
 > > - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
 > > - If ovl inode flag is I_WILL_FREE or I_FREEING then syncfs
 > > will wait until OVL_EVICT_PENDING to be cleared.
 > > - Move inode sync operation into evict_inode from drop_inode.
 > > - Call upper_sb->sync_fs with no-wait after sync dirty upper
 > > inodes.
 > > - Hold s_inode_wblist_lock until deleting item from list.
 > > - Remove write_inode fuction because no more used.
 > >
 > > Changes since v4:
 > > - Add syncing operation and deleting from upper_inodes list
 > > during ovl inode destruction.
 > > - Export symbol of inode_wait_for_writeback() for waiting
 > > writeback on ovl inode.
 > > - Reuse I_SYNC flag to avoid race conditions between syncfs
 > > and drop_inode.
 > >
 > > Changes since v3:
 > > - Introduce upper_inode list to organize ovl inode which has upper
 > >   inode.
 > > - Avoid iput operation inside spin lock.
 > > - Change list iteration method for safety.
 > > - Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
 > > - Modify commit log and add more comments to the code.
 > >
 > > Changes since v2:
 > > - Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
 > > overlayfs.
 > > - Factoring out sync operation to different helpers for easy
 > >   understanding.
 > >
 > > Changes since v1:
 > > - If upper filesystem is readonly mode then skip synchronization.
 > > - Introduce global wait list to replace temporary wait list for
 > > concurrent synchronization.
 > >
 > >  fs/overlayfs/Makefile    |   2 +-
 > >  fs/overlayfs/overlayfs.h |   9 ++
 > >  fs/overlayfs/ovl_entry.h |   5 +
 > >  fs/overlayfs/super.c     |  44 ++----
 > >  fs/overlayfs/sync.c      | 331 ++++++++++++++++++++++++++++++++++++++=
+
 > >  fs/overlayfs/util.c      |  23 ++-
 > >  6 files changed, 381 insertions(+), 33 deletions(-)
 > >  create mode 100644 fs/overlayfs/sync.c
 > >
 > > diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
 > > index 9164c585eb2f..0c4e53fcf4ef 100644
 > > --- a/fs/overlayfs/Makefile
 > > +++ b/fs/overlayfs/Makefile
 > > @@ -6,4 +6,4 @@
 > >  obj-$(CONFIG_OVERLAY_FS) +=3D overlay.o
 > >
 > >  overlay-objs :=3D super.o namei.o util.o inode.o file.o dir.o readdir=
.o \
 > > -               copy_up.o export.o
 > > +               copy_up.o export.o sync.o
 > > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
 > > index 3623d28aa4fa..3cdb06e206a3 100644
 > > --- a/fs/overlayfs/overlayfs.h
 > > +++ b/fs/overlayfs/overlayfs.h
 > > @@ -40,6 +40,10 @@ enum ovl_inode_flag {
 > >         OVL_UPPERDATA,
 > >         /* Inode number will remain constant over copy up. */
 > >         OVL_CONST_INO,
 > > +       /* Set when ovl inode is about to be freed */
 > > +       OVL_EVICT_PENDING,
 > > +       /* Set when sync upper inode in workqueue work */
 > > +       OVL_WRITE_INODE_PENDING,
 > >  };
 > >
 > >  enum ovl_entry_flag {
 > > @@ -295,6 +299,7 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)=
;
 > >  char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
 > >  ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
 > >                      size_t padding);
 > > +void ovl_detach_upper_inodes_list(struct inode *inode);
 > >
 > >  static inline bool ovl_is_impuredir(struct dentry *dentry)
 > >  {
 > > @@ -466,3 +471,7 @@ int ovl_set_origin(struct dentry *dentry, struct d=
entry *lower,
 > >
 > >  /* export.c */
 > >  extern const struct export_operations ovl_export_operations;
 > > +
 > > +/* sync.c */
 > > +void ovl_evict_inode(struct inode *inode);
 > > +int ovl_sync_fs(struct super_block *sb, int wait);
 > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
 > > index 89015ea822e7..42e092e8cd61 100644
 > > --- a/fs/overlayfs/ovl_entry.h
 > > +++ b/fs/overlayfs/ovl_entry.h
 > > @@ -75,6 +75,9 @@ struct ovl_fs {
 > >         struct inode *indexdir_trap;
 > >         /* -1: disabled, 0: same fs, 1..32: number of unused ino bits =
*/
 > >         int xino_mode;
 > > +       /* Upper inode list and lock */
 > > +       spinlock_t upper_inodes_lock;
 > > +       struct list_head upper_inodes;
 > >  };
 > >
 > >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 > > @@ -115,6 +118,8 @@ struct ovl_inode {
 > >
 > >         /* synchronize copy up and more */
 > >         struct mutex lock;
 > > +       /* Upper inodes list */
 > > +       struct list_head upper_inodes_list;
 > >  };
 > >
 > >  static inline struct ovl_inode *OVL_I(struct inode *inode)
 > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
 > > index 319fe0d355b0..3e6871e1a7ba 100644
 > > --- a/fs/overlayfs/super.c
 > > +++ b/fs/overlayfs/super.c
 > > @@ -183,6 +183,7 @@ static struct inode *ovl_alloc_inode(struct super_=
block *sb)
 > >         oi->lower =3D NULL;
 > >         oi->lowerdata =3D NULL;
 > >         mutex_init(&oi->lock);
 > > +       INIT_LIST_HEAD(&oi->upper_inodes_list);
 > >
 > >         return &oi->vfs_inode;
 > >  }
 > > @@ -249,36 +250,6 @@ static void ovl_put_super(struct super_block *sb)
 > >         ovl_free_fs(ofs);
 > >  }
 > >
 > > -/* Sync real dirty inodes in upper filesystem (if it exists) */
 > > -static int ovl_sync_fs(struct super_block *sb, int wait)
 > > -{
 > > -       struct ovl_fs *ofs =3D sb->s_fs_info;
 > > -       struct super_block *upper_sb;
 > > -       int ret;
 > > -
 > > -       if (!ofs->upper_mnt)
 > > -               return 0;
 > > -
 > > -       /*
 > > -        * If this is a sync(2) call or an emergency sync, all the sup=
er blocks
 > > -        * will be iterated, including upper_sb, so no need to do anyt=
hing.
 > > -        *
 > > -        * If this is a syncfs(2) call, then we do need to call
 > > -        * sync_filesystem() on upper_sb, but enough if we do it when =
being
 > > -        * called with wait =3D=3D 1.
 > > -        */
 > > -       if (!wait)
 > > -               return 0;
 > > -
 > > -       upper_sb =3D ofs->upper_mnt->mnt_sb;
 > > -
 > > -       down_read(&upper_sb->s_umount);
 > > -       ret =3D sync_filesystem(upper_sb);
 > > -       up_read(&upper_sb->s_umount);
 > > -
 > > -       return ret;
 > > -}
 > > -
 > >  /**
 > >   * ovl_statfs
 > >   * @sb: The overlayfs super block
 > > @@ -376,11 +347,19 @@ static int ovl_remount(struct super_block *sb, i=
nt *flags, char *data)
 > >         return 0;
 > >  }
 > >
 > > +static int ovl_drop_inode(struct inode *inode)
 > > +{
 > > +       if (ovl_inode_upper(inode))
 > > +               ovl_set_flag(OVL_EVICT_PENDING, inode);
 > > +       return 1;
 > > +}
 > > +
 > >  static const struct super_operations ovl_super_operations =3D {
 > >         .alloc_inode    =3D ovl_alloc_inode,
 > >         .free_inode     =3D ovl_free_inode,
 > >         .destroy_inode  =3D ovl_destroy_inode,
 > > -       .drop_inode     =3D generic_delete_inode,
 > > +       .drop_inode     =3D ovl_drop_inode,
 > > +       .evict_inode    =3D ovl_evict_inode,
 > >         .put_super      =3D ovl_put_super,
 > >         .sync_fs        =3D ovl_sync_fs,
 > >         .statfs         =3D ovl_statfs,
 > > @@ -1601,6 +1580,9 @@ static int ovl_fill_super(struct super_block *sb=
, void *data, int silent)
 > >         if (!ofs)
 > >                 goto out;
 > >
 > > +       spin_lock_init(&ofs->upper_inodes_lock);
 > > +       INIT_LIST_HEAD(&ofs->upper_inodes);
 > > +
 > >         ofs->creator_cred =3D cred =3D prepare_creds();
 > >         if (!cred)
 > >                 goto out_err;
 > > diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
 > > new file mode 100644
 > > index 000000000000..aecd312ec851
 > > --- /dev/null
 > > +++ b/fs/overlayfs/sync.c
 > > @@ -0,0 +1,331 @@
 > > +// SPDX-License-Identifier: GPL-2.0-only
 > > +/*
 > > + * Copyright (C) 2020 All Rights Reserved.
 > > + * Author Chengguang Xu <cgxu519@mykernel.net>
 > > + */
 > > +
 > > +#include <linux/fs.h>
 > > +#include <linux/xattr.h>
 > > +#include <linux/mount.h>
 > > +#include <linux/writeback.h>
 > > +#include <linux/blkdev.h>
 > > +#include "overlayfs.h"
 > > +
 > > +/**
 > > + * upper_inodes list is used for organizing potential target of syncf=
s,
 > > + * ovl inode which has upper inode will be added to this list while
 > > + * initializing or updating and will be deleted from this list while
 > > + * evicting.
 > > + *
 > > + * Introduce ovl_inode flag "OVL_EVICT_PENDING" to indicate the ovl i=
node
 > > + * is in eviction process, syncfs(actually ovl_sync_inodes()) will wa=
it on
 > > + * evicting inode until the IO to be completed in evict_inode().
 > > + *
 > > + * inode state/ovl_inode flags cycle in syncfs context will be as bel=
ow.
 > > + * OVL_EVICT_PENDING (ovl_inode->flags) is only marked when inode hav=
ing
 > > + * upper inode.
 > > + *
 > > + * (allocation)
 > > + *   |
 > > + * I_NEW (inode->i_state)
 > > + *   |
 > > + * NONE  (inode->i_state)
 > > + *   |
 > > + * OVL_EVICT_PENDING (ovl_inode->flags)
 > > + *   |
 > > + * I_FREEING (inode->i_state) | OVL_EVICT_PENDING (ovl_inode->flags)
 > > + *   |
 > > + * I_FREEING (inode->i_state) | I_CLEAR (inode->i_state)
 > > + *   |
 > > + * (destruction)
 > > + *
 > > + *
 > > + * There are five locks in in syncfs contexts:
 > > + *
 > > + * upper_sb->s_umount(semaphore)    : avoiding r/o to r/w or vice ver=
sa
 > > + * sb->s_sync_lock(mutex)           : avoiding concorrent syncfs runn=
ing
 > > + * ofs->upper_inodes_lock(spinlock) : protecting upper_inodes list
 > > + * sb->s_inode_wblist_lock(spinlock): protecting s_inodes_wb(sync wai=
ting) list
 > > + * inode->i_lock(spinlock)          : protecting inode fields
 > > + *
 > > + * Lock dependencies in syncfs contexts:
 > > + *
 > > + * upper_sb->s_umount
 > > + *     sb->s_sync_lock
 > > + *             ofs->upper_inodes_lock
 > > + *                     inode->i_lock
 > > + *
 > > + * upper_sb->s_umount
 > > + *     sb->s_sync_lock
 > > + *             sb->s_inode_wblist_lock
 > > + *
 > > + */
 > > +
 > > +struct ovl_write_inode_work {
 > > +       struct work_struct work;
 > > +       struct inode *inode;
 > > +};
 > > +
 > > +static void ovl_write_inode_work_fn(struct work_struct *work)
 > > +{
 > > +       struct ovl_write_inode_work *ovl_wiw;
 > > +       struct inode *inode;
 > > +
 > > +       ovl_wiw =3D container_of(work, struct ovl_write_inode_work, wo=
rk);
 > > +       inode =3D ovl_wiw->inode;
 > > +       write_inode_now(ovl_inode_upper(inode), 1);
 > > +
 > > +       spin_lock(&inode->i_lock);
 > > +       ovl_clear_flag(OVL_WRITE_INODE_PENDING, inode);
 > > +       wake_up_bit(&OVL_I(inode)->flags, OVL_WRITE_INODE_PENDING);
 > > +       spin_unlock(&inode->i_lock);
 > > +}
 > > +
 > > +void ovl_evict_inode(struct inode *inode)
 > > +{
 > > +       struct ovl_inode *oi =3D OVL_I(inode);
 > > +       struct ovl_write_inode_work ovl_wiw;
 > > +       DEFINE_WAIT_BIT(wait, &oi->flags, OVL_WRITE_INODE_PENDING);
 > > +       wait_queue_head_t *wqh;
 > > +
 > > +       if (ovl_inode_upper(inode)) {
 > > +               if (current->flags & PF_MEMALLOC) {
 > > +                       spin_lock(&inode->i_lock);
 > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING, inode);
 > > +                       wqh =3D bit_waitqueue(&oi->flags,
 > > +                                       OVL_WRITE_INODE_PENDING);
 > > +                       prepare_to_wait(wqh, &wait.wq_entry,
 > > +                                       TASK_UNINTERRUPTIBLE);
 > > +                       spin_unlock(&inode->i_lock);
 > > +
 > > +                       ovl_wiw.inode =3D inode;
 > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_inode_work_=
fn);
 > > +                       schedule_work(&ovl_wiw.work);
 > > +
 > > +                       schedule();
 > > +                       finish_wait(wqh, &wait.wq_entry);
 >=20
 > What is the reason to do this in another thread if this is a PF_MEMALLOC=
 task?

Some underlying filesystems(for example ext4) check the flag in ->write_ino=
de()
and treate it as an abnormal case.(warn and return)

ext4_write_inode():
        if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
                sb_rdonly(inode->i_sb))
                        return 0;

overlayfs inodes are always keeping clean even after wring/modifying  upper=
file ,=20
so they are right target of kswapd  but in the point of lower layer, ext4 j=
ust thinks
kswapd is choosing a wrong dirty inode to reclam memory.

 >=20
 > > +               } else {
 > > +                       write_inode_now(ovl_inode_upper(inode), 1);
 > > +               }
 > > +               ovl_detach_upper_inodes_list(inode);
 > > +
 > > +               /*
 > > +                * ovl_sync_inodes() may wait until
 > > +                * flag OVL_EVICT_PENDING to be cleared.
 > > +                */
 > > +               spin_lock(&inode->i_lock);
 > > +               ovl_clear_flag(OVL_EVICT_PENDING, inode);
 > > +               wake_up_bit(&OVL_I(inode)->flags, OVL_EVICT_PENDING);
 > > +               spin_unlock(&inode->i_lock);
 > > +       }
 > > +       clear_inode(inode);
 > > +}
 > > +
 > > +void ovl_wait_evict_pending(struct inode *inode)
 > > +{
 > > +       struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
 > > +       struct ovl_inode *oi =3D OVL_I(inode);
 > > +       DEFINE_WAIT_BIT(wait, &oi->flags, OVL_EVICT_PENDING);
 > > +       wait_queue_head_t *wqh;
 > > +
 > > +       wqh =3D bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
 > > +       prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 > > +       spin_unlock(&inode->i_lock);
 > > +       spin_unlock(&ofs->upper_inodes_lock);
 > > +       schedule();
 > > +       finish_wait(wqh, &wait.wq_entry);
 > > +}
 > > +
 > > +/**
 > > + * ovl_sync_inodes
 > > + * @sb: The overlayfs super block
 > > + *
 > > + * upper_inodes list is used for organizing ovl inode which has upper=
 inode,
 > > + * by iterating the list to looking for and syncing dirty upper inode=
.
 > > + *
 > > + * When starting syncing inode, we add the inode to wait list explici=
tly,
 > > + * in order to save memory we reuse inode->i_wb_list and sb->s_inodes=
_wb,
 > > + * so those fields have slightly differnt meanings in overlayfs.
 > > + */
 > > +static void ovl_sync_inodes(struct super_block *sb)
 > > +{
 > > +       struct ovl_fs *ofs =3D sb->s_fs_info;
 > > +       struct ovl_inode *oi;
 > > +       struct inode *inode;
 > > +       struct inode *upper_inode;
 > > +       struct blk_plug plug;
 > > +       LIST_HEAD(sync_tmp_list);
 > > +
 > > +       struct writeback_control wbc_for_sync =3D {
 > > +               .sync_mode              =3D WB_SYNC_ALL,
 > > +               .for_sync               =3D 1,
 > > +               .range_start            =3D 0,
 > > +               .range_end              =3D LLONG_MAX,
 > > +               .nr_to_write            =3D LONG_MAX,
 > > +       };
 > > +
 > > +       blk_start_plug(&plug);
 > > +       spin_lock(&ofs->upper_inodes_lock);
 > > +       list_splice_init(&ofs->upper_inodes, &sync_tmp_list);
 > > +
 > > +       while (!list_empty(&sync_tmp_list)) {
 > > +               oi =3D list_first_entry(&sync_tmp_list, struct ovl_ino=
de,
 > > +                                               upper_inodes_list);
 > > +               inode =3D &oi->vfs_inode;
 > > +               spin_lock(&inode->i_lock);
 > > +
 > > +               if (inode->i_state & I_NEW) {
 > > +                       list_move_tail(&oi->upper_inodes_list,
 > > +                                       &ofs->upper_inodes);
 > > +                       spin_unlock(&inode->i_lock);
 > > +                       continue;
 > > +               }
 > > +
 > > +               /*
 > > +                * If ovl_inode flags is OVL_EVICT_PENDING,
 > > +                * left sync operation to the ovl_evict_inode(),
 > > +                * so wait here until OVL_EVICT_PENDING flag to be cle=
ared.
 > > +                */
 > > +               if (ovl_test_flag(OVL_EVICT_PENDING, inode)) {
 > > +                       ovl_wait_evict_pending(inode);
 > > +                       goto next;
 >=20
 > Does this skip re-adding to upper_inodes_list?

No,  the inode will be destroyed after evicting operation.


Thanks,
cgxu

