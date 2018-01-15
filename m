From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 10:29:48 +0100
Message-ID: <CAJfpeguLEM-3OgvAzznsL_6Tj3aj0STEgs12WY9sZq++rwJcFA@mail.gmail.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34793 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755096AbeAOJ3u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 04:29:50 -0500
Received: by mail-qk0-f195.google.com with SMTP id b76so16084433qkc.1
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 01:29:49 -0800 (PST)
In-Reply-To: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 15, 2018 at 8:33 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
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
> irrelative container processes on the other overlayfs.
>
> This patch iterates upper inode list in overlayfs to only sync target
> dirty inodes and wait for completion. By doing this, It is able to reduce
> cost of synchronization and will not seriously impact IO performance of
> irrelative processes. In special case, when having very few dirty inodes
> and a lot of clean upper inodes in overlayfs, then iteration may waste
> time so that synchronization is slower than before, but we think the
> potential for performance improvement far surpass the potential for
> performance regression in most cases.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> Changes since v3:
> - Introduce upper_inode list to organize ovl indoe which has upper inode.

Where is the inode removed from the list?  Should be done in
ovl_destroy_inode().

Problem is: we can drop the overlay inode even when the underlying
inode is dirty, so we need to sync the upper inode before letting it
go in ovl_destroy_inode().

Thanks,
Miklos
