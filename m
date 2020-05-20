Return-Path: <SRS0=Uqc0=7C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A9EC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 01:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0966207D8
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 01:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="LD3T50Ij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgETBCb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:02:31 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17114 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgETBCa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 May 2020 21:02:30 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589936512; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=QM66RFfJJiwZztI2WvwwAf9i4SKhK069NwLDmZCDVcyRIIt3ExeFCflr1Pj6KqNwzHc1vtgyKLR5KRQfbIMc9IFAWVg9bGVU5HgQFj3YxM/XwyvJHnxdBsJXsVxBOI/O9j5vESmYo3/fLu2VyaB80+5HY5De7zNLMR6Dae/R4ks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589936512; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=amPki4tUvxXbGdnWpJgaiqiQ4Zjtd+BMWip4NkgBJzo=; 
        b=P1VVvl9LbDDnjYsolX3NSY0WijJABFXPu3cNJ1lbuHvJ7lEELjNQAfGzgcwAlTvEt44lPJvREnq+NzUCk3lRMH0iKCx1LHOSHp4CRGoRJEaaeditBSPV5geN8CttIFfn606jcOG5Am+B4QKN+jdG3ptOKVoWBcqK/ZgW7y5PomI=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589936512;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=amPki4tUvxXbGdnWpJgaiqiQ4Zjtd+BMWip4NkgBJzo=;
        b=LD3T50IjtbfJRuvHny4o97dmHVitORdBsHu4GsGWYxKBWTGqMWDBGvw5lmiILgm9
        zlXnJ+f/CmgXdj4KSNY+Id+alZYiLwWyF0psV34FoBi+X1ITaBXSbr6qXBPhV7JZSrp
        4pqZtQsSSXVJh9uJNONPFUqwhoVCNoQba6LYFepc=
Received: from [192.168.166.138] (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1589936510121127.07896002697817; Wed, 20 May 2020 09:01:50 +0800 (CST)
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
To:     jack@suse.cz, miklos@szeredi.hu, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org
References: <20200506095307.23742-1-cgxu519@mykernel.net>
From:   cgxu <cgxu519@mykernel.net>
Message-ID: <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
Date:   Wed, 20 May 2020 09:01:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200506095307.23742-1-cgxu519@mykernel.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ZohoCNMailClient: External
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 5/6/20 5:53 PM, Chengguang Xu wrote:
> Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
> on upper_sb to synchronize whole dirty inodes in upper filesystem
> regardless of the overlay ownership of the inode. In the use case of
> container, when multiple containers using the same underlying upper
> filesystem, it has some shortcomings as below.
>
> (1) Performance
> Synchronization is probably heavy because it actually syncs unnecessary
> inodes for target overlayfs.
>
> (2) Interference
> Unplanned synchronization will probably impact IO performance of
> unrelated container processes on the other overlayfs.
>
> This patch tries to only sync target dirty upper inodes which are belong
> to specific overlayfs instance and wait for completion. By doing this,
> it is able to reduce cost of synchronization and will not seriously impac=
t
> IO performance of unrelated processes.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Except explicit sycnfs is triggered by user process, there is also implicit
syncfs during umount process of overlayfs instance. Every syncfs will
deliver to upper fs and whole dirty data of upper fs syncs to persistent
device at same time.

In high density container environment, especially for temporary jobs,
this is quite unwilling=C2=A0 behavior. Should we provide an option to
mitigate this effect for containers which don't care about dirty data?


Thanks,
cgxu

> ---
> Changes since v11:
> - Introduce new structure sync_entry to organize target dirty upper
>    inode list.
> - Rebase on overlayfs-next tree.
>
> Changes since v10:
> - Add special handling in ovl_evict_inode() for inode eviction trigered
> by kswapd memory reclamation(with PF_MEMALLOC flag).
> - Rebase on current latest overlayfs-next tree.
> - Slightly modify license information.
>
> Changes since v9:
> - Rebase on current latest overlayfs-next tree.
> - Calling clear_inode() regardless of having upper inode.
>
> Changes since v8:
> - Remove unnecessary blk_start_plug() call in ovl_sync_inodes().
>
> Changes since v7:
> - Check OVL_EVICT_PENDING flag instead of I_FREEING to recognize
> inode which is in eviction process.
> - Do not move ovl_inode back to ofs->upper_inodes when inode is in
> eviction process.
> - Delete unnecessary memory barrier in ovl_evict_inode().
>
> Changes since v6:
> - Take/release sb->s_sync_lock bofore/after sync_fs to serialize
> concurrent syncfs.
> - Change list iterating method to improve code readability.
> - Fix typo in commit log and comments.
> - Add header comment to sync.c.
>
> Changes since v5:
> - Move sync related functions to new file sync.c.
> - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
> - If ovl inode flag is I_WILL_FREE or I_FREEING then syncfs
> will wait until OVL_EVICT_PENDING to be cleared.
> - Move inode sync operation into evict_inode from drop_inode.
> - Call upper_sb->sync_fs with no-wait after sync dirty upper
> inodes.
> - Hold s_inode_wblist_lock until deleting item from list.
> - Remove write_inode fuction because no more used.
>
> Changes since v4:
> - Add syncing operation and deleting from upper_inodes list
> during ovl inode destruction.
> - Export symbol of inode_wait_for_writeback() for waiting
> writeback on ovl inode.
> - Reuse I_SYNC flag to avoid race conditions between syncfs
> and drop_inode.
>
> Changes since v3:
> - Introduce upper_inode list to organize ovl inode which has upper
>    inode.
> - Avoid iput operation inside spin lock.
> - Change list iteration method for safety.
> - Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
> - Modify commit log and add more comments to the code.
>
> Changes since v2:
> - Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
> overlayfs.
> - Factoring out sync operation to different helpers for easy
>    understanding.
>
> Changes since v1:
> - If upper filesystem is readonly mode then skip synchronization.
> - Introduce global wait list to replace temporary wait list for
> concurrent synchronization.
>
>   fs/overlayfs/Makefile    |   2 +-
>   fs/overlayfs/copy_up.c   |  20 +++
>   fs/overlayfs/overlayfs.h |  19 +++
>   fs/overlayfs/ovl_entry.h |  21 +++
>   fs/overlayfs/super.c     |  63 +++-----
>   fs/overlayfs/sync.c      | 338 +++++++++++++++++++++++++++++++++++++++
>   fs/overlayfs/util.c      |  15 ++
>   7 files changed, 440 insertions(+), 38 deletions(-)
>   create mode 100644 fs/overlayfs/sync.c
>
> diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
> index 9164c585eb2f..0c4e53fcf4ef 100644
> --- a/fs/overlayfs/Makefile
> +++ b/fs/overlayfs/Makefile
> @@ -6,4 +6,4 @@
>   obj-$(CONFIG_OVERLAY_FS) +=3D overlay.o
>  =20
>   overlay-objs :=3D super.o namei.o util.o inode.o file.o dir.o readdir.o=
 \
> -=09=09copy_up.o export.o
> +=09=09copy_up.o export.o sync.o
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 66004534bd40..f760bd4f9bae 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -956,6 +956,10 @@ static bool ovl_open_need_copy_up(struct dentry *den=
try, int flags)
>   int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>   {
>   =09int err =3D 0;
> +=09struct ovl_inode *oi =3D OVL_I(d_inode(dentry));
> +=09struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> +=09struct ovl_sync_info *si =3D ofs->si;
> +=09struct ovl_sync_entry *entry;
>  =20
>   =09if (ovl_open_need_copy_up(dentry, flags)) {
>   =09=09err =3D ovl_want_write(dentry);
> @@ -965,6 +969,22 @@ int ovl_maybe_copy_up(struct dentry *dentry, int fla=
gs)
>   =09=09}
>   =09}
>  =20
> +=09if (!err && ovl_open_flags_need_copy_up(flags) && !oi->sync_entry) {
> +=09=09entry =3D kmem_cache_zalloc(ovl_sync_entry_cachep, GFP_KERNEL);
> +=09=09if (IS_ERR(entry))
> +=09=09=09return PTR_ERR(entry);
> +
> +=09=09spin_lock_init(&entry->lock);
> +=09=09INIT_LIST_HEAD(&entry->list);
> +=09=09entry->upper =3D ovl_inode_upper(d_inode(dentry));
> +=09=09ihold(entry->upper);
> +=09=09oi->sync_entry =3D entry;
> +
> +=09=09spin_lock(&si->list_lock);
> +=09=09list_add_tail(&entry->list, &si->pending_list);
> +=09=09spin_unlock(&si->list_lock);
> +=09}
> +
>   =09return err;
>   }
>  =20
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 76747f5b0517..d9cd2405c3a2 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -42,6 +42,11 @@ enum ovl_inode_flag {
>   =09OVL_CONST_INO,
>   };
>  =20
> +enum ovl_sync_entry_flag {
> +=09/* Indicate the sync_entry should be reclaimed after syncing */
> +=09OVL_SYNC_RECLAIM_PENDING,
> +};
> +
>   enum ovl_entry_flag {
>   =09OVL_E_UPPER_ALIAS,
>   =09OVL_E_OPAQUE,
> @@ -289,6 +294,9 @@ int ovl_set_impure(struct dentry *dentry, struct dent=
ry *upperdentry);
>   void ovl_set_flag(unsigned long flag, struct inode *inode);
>   void ovl_clear_flag(unsigned long flag, struct inode *inode);
>   bool ovl_test_flag(unsigned long flag, struct inode *inode);
> +void ovl_sync_set_flag(unsigned long flag, struct ovl_sync_entry *entry)=
;
> +void ovl_sync_clear_flag(unsigned long flag, struct ovl_sync_entry *entr=
y);
> +bool ovl_sync_test_flag(unsigned long flag, struct ovl_sync_entry *entry=
);
>   bool ovl_inuse_trylock(struct dentry *dentry);
>   void ovl_inuse_unlock(struct dentry *dentry);
>   bool ovl_is_inuse(struct dentry *dentry);
> @@ -490,3 +498,14 @@ int ovl_set_origin(struct dentry *dentry, struct den=
try *lower,
>  =20
>   /* export.c */
>   extern const struct export_operations ovl_export_operations;
> +
> +/* sync.c */
> +extern struct kmem_cache *ovl_sync_entry_cachep;
> +
> +void ovl_evict_inode(struct inode *inode);
> +int ovl_sync_fs(struct super_block *sb, int wait);
> +int ovl_sync_entry_create(struct ovl_fs *ofs, int bucket_bits);
> +int ovl_sync_info_init(struct ovl_fs *ofs);
> +void ovl_sync_info_destroy(struct ovl_fs *ofs);
> +int ovl_sync_entry_cache_init(void);
> +void ovl_sync_entry_cache_destroy(void);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index a8f82fb7ffb4..22367b1ea83c 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -44,6 +44,23 @@ struct ovl_path {
>   =09struct dentry *dentry;
>   };
>  =20
> +struct ovl_sync_entry {
> +=09spinlock_t lock;
> +=09unsigned long flags;
> +=09struct list_head list;
> +=09struct inode *upper;
> +};
> +
> +struct ovl_sync_info {
> +=09/* odd means in syncfs process */
> +=09atomic_t in_syncing;
> +=09atomic_t reclaim_count;
> +=09spinlock_t list_lock;
> +=09struct list_head pending_list;
> +=09struct list_head reclaim_list;
> +=09struct list_head waiting_list;
> +};
> +
>   /* private information held for overlayfs's superblock */
>   struct ovl_fs {
>   =09struct vfsmount *upper_mnt;
> @@ -80,6 +97,8 @@ struct ovl_fs {
>   =09atomic_long_t last_ino;
>   =09/* Whiteout dentry cache */
>   =09struct dentry *whiteout;
> +=09/* For organizing ovl_sync_entries which are used in syncfs */
> +=09struct ovl_sync_info *si;
>   };
>  =20
>   static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> @@ -120,6 +139,8 @@ struct ovl_inode {
>  =20
>   =09/* synchronize copy up and more */
>   =09struct mutex lock;
> +=09/* pointing to relevant sync_entry */
> +=09struct ovl_sync_entry *sync_entry;
>   };
>  =20
>   static inline struct ovl_inode *OVL_I(struct inode *inode)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index a88a7badf444..e1f010d0ebda 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -184,6 +184,7 @@ static struct inode *ovl_alloc_inode(struct super_blo=
ck *sb)
>   =09oi->lower =3D NULL;
>   =09oi->lowerdata =3D NULL;
>   =09mutex_init(&oi->lock);
> +=09oi->sync_entry =3D NULL;
>  =20
>   =09return &oi->vfs_inode;
>   }
> @@ -241,6 +242,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>   =09kfree(ofs->config.redirect_mode);
>   =09if (ofs->creator_cred)
>   =09=09put_cred(ofs->creator_cred);
> +=09ovl_sync_info_destroy(ofs);
>   =09kfree(ofs);
>   }
>  =20
> @@ -251,36 +253,6 @@ static void ovl_put_super(struct super_block *sb)
>   =09ovl_free_fs(ofs);
>   }
>  =20
> -/* Sync real dirty inodes in upper filesystem (if it exists) */
> -static int ovl_sync_fs(struct super_block *sb, int wait)
> -{
> -=09struct ovl_fs *ofs =3D sb->s_fs_info;
> -=09struct super_block *upper_sb;
> -=09int ret;
> -
> -=09if (!ofs->upper_mnt)
> -=09=09return 0;
> -
> -=09/*
> -=09 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
> -=09 * All the super blocks will be iterated, including upper_sb.
> -=09 *
> -=09 * If this is a syncfs(2) call, then we do need to call
> -=09 * sync_filesystem() on upper_sb, but enough if we do it when being
> -=09 * called with wait =3D=3D 1.
> -=09 */
> -=09if (!wait)
> -=09=09return 0;
> -
> -=09upper_sb =3D ofs->upper_mnt->mnt_sb;
> -
> -=09down_read(&upper_sb->s_umount);
> -=09ret =3D sync_filesystem(upper_sb);
> -=09up_read(&upper_sb->s_umount);
> -
> -=09return ret;
> -}
> -
>   /**
>    * ovl_statfs
>    * @sb: The overlayfs super block
> @@ -377,6 +349,7 @@ static const struct super_operations ovl_super_operat=
ions =3D {
>   =09.free_inode=09=3D ovl_free_inode,
>   =09.destroy_inode=09=3D ovl_destroy_inode,
>   =09.drop_inode=09=3D generic_delete_inode,
> +=09.evict_inode=09=3D ovl_evict_inode,
>   =09.put_super=09=3D ovl_put_super,
>   =09.sync_fs=09=3D ovl_sync_fs,
>   =09.statfs=09=09=3D ovl_statfs,
> @@ -1773,6 +1746,11 @@ static int ovl_fill_super(struct super_block *sb, =
void *data, int silent)
>   =09if (!ofs)
>   =09=09goto out;
>  =20
> +=09err =3D ovl_sync_info_init(ofs);
> +=09if (err)
> +=09=09goto out_err;
> +
> +=09err =3D -ENOMEM;
>   =09ofs->creator_cred =3D cred =3D prepare_creds();
>   =09if (!cred)
>   =09=09goto out_err;
> @@ -1943,15 +1921,25 @@ static int __init ovl_init(void)
>   =09=09return -ENOMEM;
>  =20
>   =09err =3D ovl_aio_request_cache_init();
> -=09if (!err) {
> -=09=09err =3D register_filesystem(&ovl_fs_type);
> -=09=09if (!err)
> -=09=09=09return 0;
> +=09if (err)
> +=09=09goto out_aio_req_cache;
>  =20
> -=09=09ovl_aio_request_cache_destroy();
> -=09}
> -=09kmem_cache_destroy(ovl_inode_cachep);
> +=09err =3D ovl_sync_entry_cache_init();
> +=09if (err)
> +=09=09goto out_sync_entry_cache;
> +
> +=09err =3D register_filesystem(&ovl_fs_type);
> +=09if (err)
> +=09=09goto out_register_fs;
>  =20
> +=09return 0;
> +
> +out_register_fs:
> +=09ovl_sync_entry_cache_destroy();
> +out_sync_entry_cache:
> +=09ovl_aio_request_cache_destroy();
> +out_aio_req_cache:
> +=09kmem_cache_destroy(ovl_inode_cachep);
>   =09return err;
>   }
>  =20
> @@ -1966,6 +1954,7 @@ static void __exit ovl_exit(void)
>   =09rcu_barrier();
>   =09kmem_cache_destroy(ovl_inode_cachep);
>   =09ovl_aio_request_cache_destroy();
> +=09ovl_sync_entry_cache_destroy();
>   }
>  =20
>   module_init(ovl_init);
> diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
> new file mode 100644
> index 000000000000..36d9e0b543d7
> --- /dev/null
> +++ b/fs/overlayfs/sync.c
> @@ -0,0 +1,338 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 All Rights Reserved.
> + * Author Chengguang Xu <cgxu519@mykernel.net>
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/xattr.h>
> +#include <linux/mount.h>
> +#include <linux/writeback.h>
> +#include <linux/blkdev.h>
> +#include "overlayfs.h"
> +
> +/**
> + * ovl_sync_entry is used for making connection between ovl_inode and
> + * upper_inode, when opening a file with writable flags, a new ovl_sync_=
entry
> + * will be created and link to global pending list, when evicting ovl_in=
ode,
> + * the relevant ovl_sync_entry will be moved to global reclaim list.
> + * In syncfs we iterate pending/reclaim list to sync every potential tar=
get
> + * to ensure all dirty data of overlayfs get synced.
> + *
> + * We reclaim ovl_sync_entry which is in OVL_SYNC_RECLAIM_PEDING state d=
uring
> + * ->syncfs() and ->evict() in case too much of resource comsumption.
> + *
> + * There are four kind of locks in in syncfs contexts:
> + *
> + * upper_sb->s_umount(semaphore)  : avoiding r/o to r/w or vice versa
> + * sb->s_sync_lock(mutex)         : avoiding concorrent syncfs running
> + * ofs->si->list_lock(spinlock)   : protecting pending/reclaim/waiting l=
ists
> + * sync_entry->lock(spinlock)     : protecting sync_entry fields
> + *
> + * Lock dependencies in syncfs contexts:
> + *
> + * upper_sb->s_umount
> + * sb->s_sync_lock
> + *  ofs->si->list_lock
> + *   sync_entry->lock
> + */
> +
> +struct kmem_cache *ovl_sync_entry_cachep;
> +
> +int ovl_sync_entry_cache_init(void)
> +{
> +=09ovl_sync_entry_cachep =3D kmem_cache_create("ovl_sync_entry",
> +=09=09=09=09=09sizeof(struct ovl_sync_entry),
> +=09=09=09=09=090, SLAB_HWCACHE_ALIGN, NULL);
> +=09if (!ovl_sync_entry_cachep)
> +=09=09return -ENOMEM;
> +
> +=09return 0;
> +}
> +
> +void ovl_sync_entry_cache_destroy(void)
> +{
> +=09kmem_cache_destroy(ovl_sync_entry_cachep);
> +}
> +
> +int ovl_sync_info_init(struct ovl_fs *ofs)
> +{
> +=09struct ovl_sync_info *si;
> +
> +=09si =3D kmalloc(sizeof(struct ovl_sync_info), GFP_KERNEL);
> +=09if (!si)
> +=09=09return -ENOMEM;
> +
> +=09atomic_set(&si->in_syncing, 0);
> +=09atomic_set(&si->reclaim_count, 0);
> +=09spin_lock_init(&si->list_lock);
> +=09INIT_LIST_HEAD(&si->pending_list);
> +=09INIT_LIST_HEAD(&si->reclaim_list);
> +=09INIT_LIST_HEAD(&si->waiting_list);
> +=09ofs->si =3D si;
> +=09return 0;
> +}
> +
> +void ovl_sync_info_destroy(struct ovl_fs *ofs)
> +{
> +=09struct ovl_sync_info *si =3D ofs->si;
> +=09struct ovl_sync_entry *entry;
> +=09LIST_HEAD(tmp_list);
> +
> +=09if (!si)
> +=09=09return;
> +
> +=09spin_lock(&si->list_lock);
> +=09list_splice_init(&si->pending_list, &tmp_list);
> +=09list_splice_init(&si->reclaim_list, &tmp_list);
> +=09list_splice_init(&si->waiting_list, &tmp_list);
> +=09spin_unlock(&si->list_lock);
> +
> +=09while (!list_empty(&tmp_list)) {
> +=09=09entry =3D list_first_entry(&tmp_list,
> +=09=09=09=09struct ovl_sync_entry, list);
> +=09=09list_del(&entry->list);
> +=09=09iput(entry->upper);
> +=09=09kmem_cache_free(ovl_sync_entry_cachep, entry);
> +=09}
> +
> +=09kfree(si);
> +=09ofs->si =3D NULL;
> +}
> +
> +#define OVL_SYNC_BATCH_RECLAIM 10
> +void ovl_evict_inode(struct inode *inode)
> +{
> +=09struct ovl_fs *ofs =3D OVL_FS(inode->i_sb);
> +=09struct ovl_inode *oi =3D OVL_I(inode);
> +=09struct ovl_sync_entry *entry =3D oi->sync_entry;
> +=09struct ovl_sync_info *si;
> +=09struct inode *upper_inode;
> +=09unsigned long scan_count =3D OVL_SYNC_BATCH_RECLAIM;
> +
> +=09if (!ofs)
> +=09=09goto out;
> +
> +=09si =3D ofs->si;
> +=09spin_lock(&si->list_lock);
> +=09if (entry) {
> +=09=09oi->sync_entry =3D NULL;
> +=09=09atomic_inc(&si->reclaim_count);
> +=09=09spin_lock(&entry->lock);
> +=09=09ovl_sync_set_flag(OVL_SYNC_RECLAIM_PENDING, entry);
> +=09=09spin_unlock(&entry->lock);
> +
> +=09=09/* syncfs is running, avoid manipulating list */
> +=09=09if (atomic_read(&si->in_syncing) % 2)
> +=09=09=09goto out2;
> +
> +=09=09list_move_tail(&entry->list, &si->reclaim_list);
> +=09=09while (scan_count) {
> +=09=09=09if (list_empty(&si->reclaim_list))
> +=09=09=09=09break;
> +
> +=09=09=09entry =3D list_first_entry(&si->reclaim_list,
> +=09=09=09=09=09=09 struct ovl_sync_entry, list);
> +=09=09=09upper_inode =3D entry->upper;
> +=09=09=09scan_count--;
> +=09=09=09if (upper_inode->i_state & I_DIRTY_ALL ||
> +=09=09=09=09=09mapping_tagged(upper_inode->i_mapping,
> +=09=09=09=09=09PAGECACHE_TAG_WRITEBACK)) {
> +=09=09=09=09list_move_tail(&entry->list, &si->reclaim_list);
> +=09=09=09} else {
> +=09=09=09=09list_del_init(&entry->list);
> +=09=09=09=09spin_unlock(&si->list_lock);
> +=09=09=09=09atomic_dec(&si->reclaim_count);
> +=09=09=09=09iput(upper_inode);
> +=09=09=09=09kmem_cache_free(ovl_sync_entry_cachep, entry);
> +=09=09=09=09spin_lock(&si->list_lock);
> +=09=09=09=09if (atomic_read(&si->in_syncing) % 2)
> +=09=09=09=09=09goto out2;
> +=09=09=09}
> +=09=09}
> +
> +=09=09while (scan_count) {
> +=09=09=09if (list_empty(&si->pending_list))
> +=09=09=09=09break;
> +
> +=09=09=09entry =3D list_first_entry(&si->pending_list,
> +=09=09=09=09=09=09 struct ovl_sync_entry, list);
> +=09=09=09scan_count--;
> +=09=09=09spin_lock(&entry->lock);
> +=09=09=09if (ovl_sync_test_flag(OVL_SYNC_RECLAIM_PENDING, entry))
> +=09=09=09=09list_move_tail(&entry->list, &si->reclaim_list);
> +=09=09=09spin_unlock(&entry->lock);
> +=09=09}
> +=09}
> +out2:
> +=09spin_unlock(&si->list_lock);
> +out:
> +=09clear_inode(inode);
> +}
> +
> +/**
> + * ovl_sync_info_inodes
> + * @sb: The overlayfs super block
> + *
> + * Looking for dirty upper inode by iterating pending/reclaim list.
> + */
> +static void ovl_sync_info_inodes(struct super_block *sb)
> +{
> +=09struct ovl_fs *ofs =3D sb->s_fs_info;
> +=09struct ovl_sync_info *si =3D ofs->si;
> +=09struct ovl_sync_entry *entry;
> +=09struct blk_plug plug;
> +=09LIST_HEAD(sync_pending_list);
> +=09LIST_HEAD(sync_waiting_list);
> +
> +=09struct writeback_control wbc_for_sync =3D {
> +=09=09.sync_mode  =3D WB_SYNC_ALL,
> +=09=09.for_sync  =3D 1,
> +=09=09.range_start  =3D 0,
> +=09=09.range_end  =3D LLONG_MAX,
> +=09=09.nr_to_write  =3D LONG_MAX,
> +=09};
> +
> +=09blk_start_plug(&plug);
> +=09spin_lock(&si->list_lock);
> +=09atomic_inc(&si->in_syncing);
> +=09list_splice_init(&si->pending_list, &sync_pending_list);
> +=09list_splice_init(&si->reclaim_list, &sync_pending_list);
> +=09spin_unlock(&si->list_lock);
> +
> +=09while (!list_empty(&sync_pending_list)) {
> +=09=09entry =3D list_first_entry(&sync_pending_list,
> +=09=09=09=09=09 struct ovl_sync_entry, list);
> +=09=09sync_inode(entry->upper, &wbc_for_sync);
> +=09=09list_move_tail(&entry->list, &sync_waiting_list);
> +=09=09cond_resched();
> +=09}
> +
> +=09blk_finish_plug(&plug);
> +=09spin_lock(&si->list_lock);
> +=09list_splice_init(&sync_waiting_list, &si->waiting_list);
> +=09spin_unlock(&si->list_lock);
> +}
> +
> +/**
> + * ovl_wait_inodes
> + * @sb: The overlayfs super block
> + *
> + * Waiting writeback inodes which are in waiting list,
> + * all the IO that has been issued up to the time this
> + * function is enter is guaranteed to be completed.
> + */
> +static void ovl_wait_inodes(struct super_block *sb)
> +{
> +=09struct ovl_fs *ofs =3D sb->s_fs_info;
> +=09struct ovl_sync_info *si =3D ofs->si;
> +=09struct ovl_sync_entry *entry;
> +=09struct inode *upper_inode;
> +=09bool should_free =3D false;
> +=09LIST_HEAD(sync_pending_list);
> +=09LIST_HEAD(sync_waiting_list);
> +
> +=09/*
> +=09 * Splice the global waiting list onto a temporary list to avoid
> +=09 * waiting on inodes that have started writeback after this point.
> +=09 */
> +=09spin_lock(&si->list_lock);
> +=09list_splice_init(&si->waiting_list, &sync_waiting_list);
> +=09spin_unlock(&si->list_lock);
> +
> +=09while (!list_empty(&sync_waiting_list)) {
> +=09=09entry =3D list_first_entry(&sync_waiting_list,
> +=09=09=09=09=09 struct ovl_sync_entry, list);
> +=09=09upper_inode =3D entry->upper;
> +=09=09if (mapping_tagged(upper_inode->i_mapping,
> +=09=09=09=09=09PAGECACHE_TAG_WRITEBACK)) {
> +=09=09=09filemap_fdatawait_keep_errors(upper_inode->i_mapping);
> +=09=09=09cond_resched();
> +=09=09}
> +
> +=09=09spin_lock(&entry->lock);
> +=09=09if (ovl_sync_test_flag(OVL_SYNC_RECLAIM_PENDING, entry))
> +=09=09=09should_free =3D true;
> +=09=09spin_unlock(&entry->lock);
> +
> +=09=09if (should_free) {
> +=09=09=09list_del(&entry->list);
> +=09=09=09atomic_dec(&si->reclaim_count);
> +=09=09=09iput(entry->upper);
> +=09=09=09kmem_cache_free(ovl_sync_entry_cachep, entry);
> +=09=09} else {
> +=09=09=09list_move_tail(&entry->list, &sync_pending_list);
> +=09=09}
> +=09}
> +
> +=09spin_lock(&si->list_lock);
> +=09list_splice_init(&sync_pending_list, &si->pending_list);
> +=09atomic_inc(&si->in_syncing);
> +=09spin_unlock(&si->list_lock);
> +}
> +
> +/**
> + * ovl_sync_info_filesystem
> + * @sb: The overlayfs super block
> + *
> + * Sync underlying dirty inodes in upper filesystem and
> + * wait for completion.
> + */
> +static int ovl_sync_filesystem(struct super_block *sb)
> +{
> +=09struct ovl_fs *ofs =3D sb->s_fs_info;
> +=09struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
> +=09int ret =3D 0;
> +
> +=09 down_read(&upper_sb->s_umount);
> +=09if (!sb_rdonly(upper_sb)) {
> +=09=09/*
> +=09=09 * s_sync_lock is used for serializing concurrent
> +=09=09 * syncfs operations.
> +=09=09 */
> +=09=09mutex_lock(&sb->s_sync_lock);
> +=09=09ovl_sync_info_inodes(sb);
> +=09=09/* Calling sync_fs with no-wait for better performance. */
> +=09=09if (upper_sb->s_op->sync_fs)
> +=09=09=09upper_sb->s_op->sync_fs(upper_sb, 0);
> +
> +=09=09ovl_wait_inodes(sb);
> +=09=09if (upper_sb->s_op->sync_fs)
> +=09=09=09upper_sb->s_op->sync_fs(upper_sb, 1);
> +
> +=09=09ret =3D sync_blockdev(upper_sb->s_bdev);
> +=09=09mutex_unlock(&sb->s_sync_lock);
> +=09}
> +=09up_read(&upper_sb->s_umount);
> +=09return ret;
> +}
> +
> +/**
> + * ovl_sync_fs
> + * @sb: The overlayfs super block
> + * @wait: Wait for I/O to complete
> + *
> + * Sync real dirty inodes in upper filesystem (if it exists)
> + */
> +int ovl_sync_fs(struct super_block *sb, int wait)
> +{
> +=09struct ovl_fs *ofs =3D sb->s_fs_info;
> +=09int ret;
> +
> +=09if (!ofs->upper_mnt)
> +=09=09return 0;
> +
> +=09/*
> +=09 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
> +=09 * All the super blocks will be iterated, including upper_sb.
> +=09 *
> +=09 * If this is a syncfs(2) call, then we do need to call
> +=09 * sync_filesystem() on upper_sb, but enough if we do it when being
> +=09 * called with wait =3D=3D 1.
> +=09 */
> +=09if (!wait)
> +=09=09return 0;
> +
> +=09ret =3D ovl_sync_filesystem(sb);
> +=09return ret;
> +}
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 01755bc186c9..e99634fab602 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -602,6 +602,21 @@ bool ovl_test_flag(unsigned long flag, struct inode =
*inode)
>   =09return test_bit(flag, &OVL_I(inode)->flags);
>   }
>  =20
> +void ovl_sync_set_flag(unsigned long flag, struct ovl_sync_entry *entry)
> +{
> +=09set_bit(flag, &entry->flags);
> +}
> +
> +void ovl_sync_clear_flag(unsigned long flag, struct ovl_sync_entry *entr=
y)
> +{
> +=09clear_bit(flag, &entry->flags);
> +}
> +
> +bool ovl_sync_test_flag(unsigned long flag, struct ovl_sync_entry *entry=
)
> +{
> +=09return test_bit(flag, &entry->flags);
> +}
> +
>   /**
>    * Caller must hold a reference to inode to prevent it from being freed=
 while
>    * it is marked inuse.


