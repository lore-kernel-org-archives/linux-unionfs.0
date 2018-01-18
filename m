From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5] ovl: Improving syncfs efficiency
Date: Thu, 18 Jan 2018 09:51:55 +0200
Message-ID: <CAOQ4uxjVNRjV96LokUvC+VkMRVKR5CeTUzOxDbB2_v-E5U6F2A@mail.gmail.com>
References: <1516258412-122012-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:38266 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753390AbeARHv4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 02:51:56 -0500
Received: by mail-yw0-f196.google.com with SMTP id m84so10519925ywd.5
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jan 2018 23:51:56 -0800 (PST)
In-Reply-To: <1516258412-122012-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 18, 2018 at 8:53 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
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
> This patch iterates upper inode list in overlayfs to only sync target
> dirty inodes and wait for completion. By doing this, It is able to reduce
> cost of synchronization and will not seriously impact IO performance of
> unrelated processes. In special case, when having very few dirty inodes
> and a lot of clean upper inodes in overlayfs, then iteration may waste
> time so that synchronization is slower than before, but we think the
> potential for performance improvement far surpass the potential for
> performance regression in most cases.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> Changes since v4:
> - Add syncing operation and deleting from upper_inodes list
> during ovl inode destruction.
> - Export symbol of inode_wait_for_writeback() for waiting
> writeback on ovl inode.
> - Reuse I_SYNC flag to avoid race conditions between syncfs
> and drop_inode.
>
> Changes since v3:
> - Introduce upper_inode list to organize ovl indoe which has upper inode.
> - Avoid iput operation inside spin lock.
> - Change list iteration method for safety.
> - Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
> - Modify commit log and add more comments to the code.
>
> Changes since v2:
> - Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
> overlayfs.
> - Factoring out sync operation to different helpers for easy understanding.
>
> Changes since v1:
> - If upper filesystem is readonly mode then skip synchronization.
> - Introduce global wait list to replace temporary wait list for
> concurrent synchronization.
>
>  fs/fs-writeback.c        |   1 +
>  fs/overlayfs/overlayfs.h |   1 +
>  fs/overlayfs/ovl_entry.h |   5 +
>  fs/overlayfs/super.c     | 270 ++++++++++++++++++++++++++++++++++++++++++++---

super.c is already large enough.
I think at this point, your patch should add sync.c for all the new sync magic.
And that concludes my contributions to this review.
The sync magic is beyond my review capabilities.

Thanks,
Amir.
