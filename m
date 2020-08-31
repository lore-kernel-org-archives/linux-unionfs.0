Return-Path: <SRS0=nzN1=CJ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BB7C433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 14:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE5920866
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 14:23:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="PDyMXlkk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgHaOXF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 10:23:05 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25367 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726489AbgHaOXB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Aug 2020 10:23:01 -0400
X-Greylist: delayed 2083 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2020 10:22:53 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1598883747; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=JCX8IGTpMgoTANyIx+/KufD2mVfSA2lL34vejHlz77ye9FOXtyUzjg6mTVzjwUNsBk84pPI2Vy5yKhpx7Poke1KR2RIHzSQPdUhYrTp1HJF2bXIYhiva015hWrlNaNFWbZxb7ctK4wyvG3eRTJvbvlD6HdYhtfyiPAAF0OThBGc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1598883747; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=blMEvNT5UEzc76zU6fuyfXe0/dp4/gUQwK7pCY/5cVI=; 
        b=qN4Is6LrSeUCVsDzRSovOe3KgyWLp+eTp7ChTd9UWD2+4+k0Z6YPyXNW38chJGVgpJGC7IySyrYAIjSzd7q94KlLZz58U7dCOBqtRgi+NDsnc3s9lp4ye4QtQHXMeFuuqpGY2yj4FPv+LjHVo7ifz1nXP6zyn4ZGXM6ws2OStBM=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1598883747;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=blMEvNT5UEzc76zU6fuyfXe0/dp4/gUQwK7pCY/5cVI=;
        b=PDyMXlkkPh6RHWYqqRBdpMv69ojGlg2pmgqkXZtR3eMTm9P496PYMMsKrSHCxgR2
        0BaPAWwcLmGfkJznYHokecHjnWrwPFYvFCZZBx4JGoid6gw4sGu9u/NxFvDPB0pohDW
        O9VdtXTgyw3ysj5LJE3QWYK8WGDVl9Ie04Y6FEnA=
Received: from [10.0.0.2] (113.88.135.106 [113.88.135.106]) by mx.zoho.com.cn
        with SMTPS id 1598883746689637.7527997993253; Mon, 31 Aug 2020 22:22:26 +0800 (CST)
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
To:     jack@suse.cz, miklos@szeredi.hu, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org
References: <20200506095307.23742-1-cgxu519@mykernel.net>
From:   cgxu <cgxu519@mykernel.net>
Message-ID: <9165be8f-f125-bd1f-498e-46004f5a845e@mykernel.net>
Date:   Mon, 31 Aug 2020 22:22:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200506095307.23742-1-cgxu519@mykernel.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

Hi Miklos, Jack, Amir and folks

Recently I got another idea to mitigate the syncfs interferes between 
instances, I would like to talk with you guys first before I post
full patch series and hope to get some comments about it.

The basic design as below:

1) Introduce a RB-Tree to orgnize upper inode number bitmap entry,
the entry struct is like below

/* Upper inode number bitmap entry */
struct ovl_uib_entry {
    struct rb_node node;  //link to rb-tree
    struct list_head list;//list for destruction iterating
    unsigned long start;  //start inode number of bitmap
    unsigned long bitmap; //bitmap for ino range (start ~ start+64 -1)
};

2) Record upper inode number to bitmap.

3) Iterating upper-sb's inode list during ->syncfs and only sync dirty 
inode which number is in the bitmap.

Cons/Pros compare to previous approach

Cons:
This approach
1) May need to interate more inodes in upper sb list and need to search 
the ino in rb-tree for dirty inode.

2) Cost some memory for saving inode number bitmap.

Pros:
This approach
1) Does not need to hold upper inode, so upper inode can be reclaim if
needed.

2) The logic looks simpler(at least for me).


Thanks,

cgxu


> 
> This patch tries to only sync target dirty upper inodes which are belong
> to specific overlayfs instance and wait for completion. By doing this,
> it is able to reduce cost of synchronization and will not seriously impact
> IO performance of unrelated processes.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
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
>   obj-$(CONFIG_OVERLAY_FS) += overlay.o
>   
>   overlay-objs := super.o namei.o util.o inode.o file.o dir.o readdir.o \
> -		copy_up.o export.o
> +		copy_up.o export.o sync.o
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 66004534bd40..f760bd4f9bae 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -956,6 +956,10 @@ static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
>   int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>   {
>   	int err = 0;
> +	struct ovl_inode *oi = OVL_I(d_inode(dentry));
> +	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
> +	struct ovl_sync_info *si = ofs->si;
> +	struct ovl_sync_entry *entry;
>   
>   	if (ovl_open_need_copy_up(dentry, flags)) {
>   		err = ovl_want_write(dentry);
> @@ -965,6 +969,22 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>   		}
>   	}
>   
> +	if (!err && ovl_open_flags_need_copy_up(flags) && !oi->sync_entry) {
> +		entry = kmem_cache_zalloc(ovl_sync_entry_cachep, GFP_KERNEL);
> +		if (IS_ERR(entry))
> +			return PTR_ERR(entry);
> +
> +		spin_lock_init(&entry->lock);
> +		INIT_LIST_HEAD(&entry->list);
> +		entry->upper = ovl_inode_upper(d_inode(dentry));
> +		ihold(entry->upper);
> +		oi->sync_entry = entry;
> +
> +		spin_lock(&si->list_lock);
> +		list_add_tail(&entry->list, &si->pending_list);
> +		spin_unlock(&si->list_lock);
> +	}
> +
>   	return err;
>   }
>   
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 76747f5b0517..d9cd2405c3a2 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -42,6 +42,11 @@ enum ovl_inode_flag {
>   	OVL_CONST_INO,
>   };
>   
> +enum ovl_sync_entry_flag {
> +	/* Indicate the sync_entry should be reclaimed after syncing */
> +	OVL_SYNC_RECLAIM_PENDING,
> +};
> +
>   enum ovl_entry_flag {
>   	OVL_E_UPPER_ALIAS,
>   	OVL_E_OPAQUE,
> @@ -289,6 +294,9 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
>   void ovl_set_flag(unsigned long flag, struct inode *inode);
>   void ovl_clear_flag(unsigned long flag, struct inode *inode);
>   bool ovl_test_flag(unsigned long flag, struct inode *inode);
> +void ovl_sync_set_flag(unsigned long flag, struct ovl_sync_entry *entry);
> +void ovl_sync_clear_flag(unsigned long flag, struct ovl_sync_entry *entry);
> +bool ovl_sync_test_flag(unsigned long flag, struct ovl_sync_entry *entry);
>   bool ovl_inuse_trylock(struct dentry *dentry);
>   void ovl_inuse_unlock(struct dentry *dentry);
>   bool ovl_is_inuse(struct dentry *dentry);
> @@ -490,3 +498,14 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
>   
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
>   	struct dentry *dentry;
>   };
>   
> +struct ovl_sync_entry {
> +	spinlock_t lock;
> +	unsigned long flags;
> +	struct list_head list;
> +	struct inode *upper;
> +};
> +
> +struct ovl_sync_info {
> +	/* odd means in syncfs process */
> +	atomic_t in_syncing;
> +	atomic_t reclaim_count;
> +	spinlock_t list_lock;
> +	struct list_head pending_list;
> +	struct list_head reclaim_list;
> +	struct list_head waiting_list;
> +};
> +
>   /* private information held for overlayfs's superblock */
>   struct ovl_fs {
>   	struct vfsmount *upper_mnt;
> @@ -80,6 +97,8 @@ struct ovl_fs {
>   	atomic_long_t last_ino;
>   	/* Whiteout dentry cache */
>   	struct dentry *whiteout;
> +	/* For organizing ovl_sync_entries which are used in syncfs */
> +	struct ovl_sync_info *si;
>   };
>   
>   static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> @@ -120,6 +139,8 @@ struct ovl_inode {
>   
>   	/* synchronize copy up and more */
>   	struct mutex lock;
> +	/* pointing to relevant sync_entry */
> +	struct ovl_sync_entry *sync_entry;
>   };
>   
>   static inline struct ovl_inode *OVL_I(struct inode *inode)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index a88a7badf444..e1f010d0ebda 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -184,6 +184,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
>   	oi->lower = NULL;
>   	oi->lowerdata = NULL;
>   	mutex_init(&oi->lock);
> +	oi->sync_entry = NULL;
>   
>   	return &oi->vfs_inode;
>   }
> @@ -241,6 +242,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>   	kfree(ofs->config.redirect_mode);
>   	if (ofs->creator_cred)
>   		put_cred(ofs->creator_cred);
> +	ovl_sync_info_destroy(ofs);
>   	kfree(ofs);
>   }
>   
> @@ -251,36 +253,6 @@ static void ovl_put_super(struct super_block *sb)
>   	ovl_free_fs(ofs);
>   }
>   
> -/* Sync real dirty inodes in upper filesystem (if it exists) */
> -static int ovl_sync_fs(struct super_block *sb, int wait)
> -{
> -	struct ovl_fs *ofs = sb->s_fs_info;
> -	struct super_block *upper_sb;
> -	int ret;
> -
> -	if (!ofs->upper_mnt)
> -		return 0;
> -
> -	/*
> -	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
> -	 * All the super blocks will be iterated, including upper_sb.
> -	 *
> -	 * If this is a syncfs(2) call, then we do need to call
> -	 * sync_filesystem() on upper_sb, but enough if we do it when being
> -	 * called with wait == 1.
> -	 */
> -	if (!wait)
> -		return 0;
> -
> -	upper_sb = ofs->upper_mnt->mnt_sb;
> -
> -	down_read(&upper_sb->s_umount);
> -	ret = sync_filesystem(upper_sb);
> -	up_read(&upper_sb->s_umount);
> -
> -	return ret;
> -}
> -
>   /**
>    * ovl_statfs
>    * @sb: The overlayfs super block
> @@ -377,6 +349,7 @@ static const struct super_operations ovl_super_operations = {
>   	.free_inode	= ovl_free_inode,
>   	.destroy_inode	= ovl_destroy_inode,
>   	.drop_inode	= generic_delete_inode,
> +	.evict_inode	= ovl_evict_inode,
>   	.put_super	= ovl_put_super,
>   	.sync_fs	= ovl_sync_fs,
>   	.statfs		= ovl_statfs,
> @@ -1773,6 +1746,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>   	if (!ofs)
>   		goto out;
>   
> +	err = ovl_sync_info_init(ofs);
> +	if (err)
> +		goto out_err;
> +
> +	err = -ENOMEM;
>   	ofs->creator_cred = cred = prepare_creds();
>   	if (!cred)
>   		goto out_err;
> @@ -1943,15 +1921,25 @@ static int __init ovl_init(void)
>   		return -ENOMEM;
>   
>   	err = ovl_aio_request_cache_init();
> -	if (!err) {
> -		err = register_filesystem(&ovl_fs_type);
> -		if (!err)
> -			return 0;
> +	if (err)
> +		goto out_aio_req_cache;
>   
> -		ovl_aio_request_cache_destroy();
> -	}
> -	kmem_cache_destroy(ovl_inode_cachep);
> +	err = ovl_sync_entry_cache_init();
> +	if (err)
> +		goto out_sync_entry_cache;
> +
> +	err = register_filesystem(&ovl_fs_type);
> +	if (err)
> +		goto out_register_fs;
>   
> +	return 0;
> +
> +out_register_fs:
> +	ovl_sync_entry_cache_destroy();
> +out_sync_entry_cache:
> +	ovl_aio_request_cache_destroy();
> +out_aio_req_cache:
> +	kmem_cache_destroy(ovl_inode_cachep);
>   	return err;
>   }
>   
> @@ -1966,6 +1954,7 @@ static void __exit ovl_exit(void)
>   	rcu_barrier();
>   	kmem_cache_destroy(ovl_inode_cachep);
>   	ovl_aio_request_cache_destroy();
> +	ovl_sync_entry_cache_destroy();
>   }
>   
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
> + * upper_inode, when opening a file with writable flags, a new ovl_sync_entry
> + * will be created and link to global pending list, when evicting ovl_inode,
> + * the relevant ovl_sync_entry will be moved to global reclaim list.
> + * In syncfs we iterate pending/reclaim list to sync every potential target
> + * to ensure all dirty data of overlayfs get synced.
> + *
> + * We reclaim ovl_sync_entry which is in OVL_SYNC_RECLAIM_PEDING state during
> + * ->syncfs() and ->evict() in case too much of resource comsumption.
> + *
> + * There are four kind of locks in in syncfs contexts:
> + *
> + * upper_sb->s_umount(semaphore)  : avoiding r/o to r/w or vice versa
> + * sb->s_sync_lock(mutex)         : avoiding concorrent syncfs running
> + * ofs->si->list_lock(spinlock)   : protecting pending/reclaim/waiting lists
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
> +	ovl_sync_entry_cachep = kmem_cache_create("ovl_sync_entry",
> +					sizeof(struct ovl_sync_entry),
> +					0, SLAB_HWCACHE_ALIGN, NULL);
> +	if (!ovl_sync_entry_cachep)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +void ovl_sync_entry_cache_destroy(void)
> +{
> +	kmem_cache_destroy(ovl_sync_entry_cachep);
> +}
> +
> +int ovl_sync_info_init(struct ovl_fs *ofs)
> +{
> +	struct ovl_sync_info *si;
> +
> +	si = kmalloc(sizeof(struct ovl_sync_info), GFP_KERNEL);
> +	if (!si)
> +		return -ENOMEM;
> +
> +	atomic_set(&si->in_syncing, 0);
> +	atomic_set(&si->reclaim_count, 0);
> +	spin_lock_init(&si->list_lock);
> +	INIT_LIST_HEAD(&si->pending_list);
> +	INIT_LIST_HEAD(&si->reclaim_list);
> +	INIT_LIST_HEAD(&si->waiting_list);
> +	ofs->si = si;
> +	return 0;
> +}
> +
> +void ovl_sync_info_destroy(struct ovl_fs *ofs)
> +{
> +	struct ovl_sync_info *si = ofs->si;
> +	struct ovl_sync_entry *entry;
> +	LIST_HEAD(tmp_list);
> +
> +	if (!si)
> +		return;
> +
> +	spin_lock(&si->list_lock);
> +	list_splice_init(&si->pending_list, &tmp_list);
> +	list_splice_init(&si->reclaim_list, &tmp_list);
> +	list_splice_init(&si->waiting_list, &tmp_list);
> +	spin_unlock(&si->list_lock);
> +
> +	while (!list_empty(&tmp_list)) {
> +		entry = list_first_entry(&tmp_list,
> +				struct ovl_sync_entry, list);
> +		list_del(&entry->list);
> +		iput(entry->upper);
> +		kmem_cache_free(ovl_sync_entry_cachep, entry);
> +	}
> +
> +	kfree(si);
> +	ofs->si = NULL;
> +}
> +
> +#define OVL_SYNC_BATCH_RECLAIM 10
> +void ovl_evict_inode(struct inode *inode)
> +{
> +	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
> +	struct ovl_inode *oi = OVL_I(inode);
> +	struct ovl_sync_entry *entry = oi->sync_entry;
> +	struct ovl_sync_info *si;
> +	struct inode *upper_inode;
> +	unsigned long scan_count = OVL_SYNC_BATCH_RECLAIM;
> +
> +	if (!ofs)
> +		goto out;
> +
> +	si = ofs->si;
> +	spin_lock(&si->list_lock);
> +	if (entry) {
> +		oi->sync_entry = NULL;
> +		atomic_inc(&si->reclaim_count);
> +		spin_lock(&entry->lock);
> +		ovl_sync_set_flag(OVL_SYNC_RECLAIM_PENDING, entry);
> +		spin_unlock(&entry->lock);
> +
> +		/* syncfs is running, avoid manipulating list */
> +		if (atomic_read(&si->in_syncing) % 2)
> +			goto out2;
> +
> +		list_move_tail(&entry->list, &si->reclaim_list);
> +		while (scan_count) {
> +			if (list_empty(&si->reclaim_list))
> +				break;
> +
> +			entry = list_first_entry(&si->reclaim_list,
> +						 struct ovl_sync_entry, list);
> +			upper_inode = entry->upper;
> +			scan_count--;
> +			if (upper_inode->i_state & I_DIRTY_ALL ||
> +					mapping_tagged(upper_inode->i_mapping,
> +					PAGECACHE_TAG_WRITEBACK)) {
> +				list_move_tail(&entry->list, &si->reclaim_list);
> +			} else {
> +				list_del_init(&entry->list);
> +				spin_unlock(&si->list_lock);
> +				atomic_dec(&si->reclaim_count);
> +				iput(upper_inode);
> +				kmem_cache_free(ovl_sync_entry_cachep, entry);
> +				spin_lock(&si->list_lock);
> +				if (atomic_read(&si->in_syncing) % 2)
> +					goto out2;
> +			}
> +		}
> +
> +		while (scan_count) {
> +			if (list_empty(&si->pending_list))
> +				break;
> +
> +			entry = list_first_entry(&si->pending_list,
> +						 struct ovl_sync_entry, list);
> +			scan_count--;
> +			spin_lock(&entry->lock);
> +			if (ovl_sync_test_flag(OVL_SYNC_RECLAIM_PENDING, entry))
> +				list_move_tail(&entry->list, &si->reclaim_list);
> +			spin_unlock(&entry->lock);
> +		}
> +	}
> +out2:
> +	spin_unlock(&si->list_lock);
> +out:
> +	clear_inode(inode);
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
> +	struct ovl_fs *ofs = sb->s_fs_info;
> +	struct ovl_sync_info *si = ofs->si;
> +	struct ovl_sync_entry *entry;
> +	struct blk_plug plug;
> +	LIST_HEAD(sync_pending_list);
> +	LIST_HEAD(sync_waiting_list);
> +
> +	struct writeback_control wbc_for_sync = {
> +		.sync_mode  = WB_SYNC_ALL,
> +		.for_sync  = 1,
> +		.range_start  = 0,
> +		.range_end  = LLONG_MAX,
> +		.nr_to_write  = LONG_MAX,
> +	};
> +
> +	blk_start_plug(&plug);
> +	spin_lock(&si->list_lock);
> +	atomic_inc(&si->in_syncing);
> +	list_splice_init(&si->pending_list, &sync_pending_list);
> +	list_splice_init(&si->reclaim_list, &sync_pending_list);
> +	spin_unlock(&si->list_lock);
> +
> +	while (!list_empty(&sync_pending_list)) {
> +		entry = list_first_entry(&sync_pending_list,
> +					 struct ovl_sync_entry, list);
> +		sync_inode(entry->upper, &wbc_for_sync);
> +		list_move_tail(&entry->list, &sync_waiting_list);
> +		cond_resched();
> +	}
> +
> +	blk_finish_plug(&plug);
> +	spin_lock(&si->list_lock);
> +	list_splice_init(&sync_waiting_list, &si->waiting_list);
> +	spin_unlock(&si->list_lock);
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
> +	struct ovl_fs *ofs = sb->s_fs_info;
> +	struct ovl_sync_info *si = ofs->si;
> +	struct ovl_sync_entry *entry;
> +	struct inode *upper_inode;
> +	bool should_free = false;
> +	LIST_HEAD(sync_pending_list);
> +	LIST_HEAD(sync_waiting_list);
> +
> +	/*
> +	 * Splice the global waiting list onto a temporary list to avoid
> +	 * waiting on inodes that have started writeback after this point.
> +	 */
> +	spin_lock(&si->list_lock);
> +	list_splice_init(&si->waiting_list, &sync_waiting_list);
> +	spin_unlock(&si->list_lock);
> +
> +	while (!list_empty(&sync_waiting_list)) {
> +		entry = list_first_entry(&sync_waiting_list,
> +					 struct ovl_sync_entry, list);
> +		upper_inode = entry->upper;
> +		if (mapping_tagged(upper_inode->i_mapping,
> +					PAGECACHE_TAG_WRITEBACK)) {
> +			filemap_fdatawait_keep_errors(upper_inode->i_mapping);
> +			cond_resched();
> +		}
> +
> +		spin_lock(&entry->lock);
> +		if (ovl_sync_test_flag(OVL_SYNC_RECLAIM_PENDING, entry))
> +			should_free = true;
> +		spin_unlock(&entry->lock);
> +
> +		if (should_free) {
> +			list_del(&entry->list);
> +			atomic_dec(&si->reclaim_count);
> +			iput(entry->upper);
> +			kmem_cache_free(ovl_sync_entry_cachep, entry);
> +		} else {
> +			list_move_tail(&entry->list, &sync_pending_list);
> +		}
> +	}
> +
> +	spin_lock(&si->list_lock);
> +	list_splice_init(&sync_pending_list, &si->pending_list);
> +	atomic_inc(&si->in_syncing);
> +	spin_unlock(&si->list_lock);
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
> +	struct ovl_fs *ofs = sb->s_fs_info;
> +	struct super_block *upper_sb = ofs->upper_mnt->mnt_sb;
> +	int ret = 0;
> +
> +	 down_read(&upper_sb->s_umount);
> +	if (!sb_rdonly(upper_sb)) {
> +		/*
> +		 * s_sync_lock is used for serializing concurrent
> +		 * syncfs operations.
> +		 */
> +		mutex_lock(&sb->s_sync_lock);
> +		ovl_sync_info_inodes(sb);
> +		/* Calling sync_fs with no-wait for better performance. */
> +		if (upper_sb->s_op->sync_fs)
> +			upper_sb->s_op->sync_fs(upper_sb, 0);
> +
> +		ovl_wait_inodes(sb);
> +		if (upper_sb->s_op->sync_fs)
> +			upper_sb->s_op->sync_fs(upper_sb, 1);
> +
> +		ret = sync_blockdev(upper_sb->s_bdev);
> +		mutex_unlock(&sb->s_sync_lock);
> +	}
> +	up_read(&upper_sb->s_umount);
> +	return ret;
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
> +	struct ovl_fs *ofs = sb->s_fs_info;
> +	int ret;
> +
> +	if (!ofs->upper_mnt)
> +		return 0;
> +
> +	/*
> +	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
> +	 * All the super blocks will be iterated, including upper_sb.
> +	 *
> +	 * If this is a syncfs(2) call, then we do need to call
> +	 * sync_filesystem() on upper_sb, but enough if we do it when being
> +	 * called with wait == 1.
> +	 */
> +	if (!wait)
> +		return 0;
> +
> +	ret = ovl_sync_filesystem(sb);
> +	return ret;
> +}
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 01755bc186c9..e99634fab602 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -602,6 +602,21 @@ bool ovl_test_flag(unsigned long flag, struct inode *inode)
>   	return test_bit(flag, &OVL_I(inode)->flags);
>   }
>   
> +void ovl_sync_set_flag(unsigned long flag, struct ovl_sync_entry *entry)
> +{
> +	set_bit(flag, &entry->flags);
> +}
> +
> +void ovl_sync_clear_flag(unsigned long flag, struct ovl_sync_entry *entry)
> +{
> +	clear_bit(flag, &entry->flags);
> +}
> +
> +bool ovl_sync_test_flag(unsigned long flag, struct ovl_sync_entry *entry)
> +{
> +	return test_bit(flag, &entry->flags);
> +}
> +
>   /**
>    * Caller must hold a reference to inode to prevent it from being freed while
>    * it is marked inuse.
> 
