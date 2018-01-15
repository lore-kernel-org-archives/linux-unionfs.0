From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 12:10:36 +0200
Message-ID: <CAOQ4uxg6HvakDexhwunMcMwoJUoZs2t9syjA+A_Bi8QxnhOuCw@mail.gmail.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com> <CAJfpeguLEM-3OgvAzznsL_6Tj3aj0STEgs12WY9sZq++rwJcFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36501 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbeAOKKi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 05:10:38 -0500
Received: by mail-yb0-f194.google.com with SMTP id j7so5533008ybl.3
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 02:10:38 -0800 (PST)
In-Reply-To: <CAJfpeguLEM-3OgvAzznsL_6Tj3aj0STEgs12WY9sZq++rwJcFA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chengguang Xu <cgxu519@icloud.com>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 15, 2018 at 11:29 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jan 15, 2018 at 8:33 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>> Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>> regardless of the overlay ownership of the inode. In the use case of
>> container, when multiple containers using the same underlying upper
>> filesystem, it has some shortcomings as below.
>>
>> (1) Performance
>> Synchronization is probably heavy because it actually syncs unnecessary
>> inodes for target overlayfs.
>>
>> (2) Interference
>> Unplanned synchronization will probably impact IO performance of
>> irrelative container processes on the other overlayfs.
>>
>> This patch iterates upper inode list in overlayfs to only sync target
>> dirty inodes and wait for completion. By doing this, It is able to reduce
>> cost of synchronization and will not seriously impact IO performance of
>> irrelative processes. In special case, when having very few dirty inodes
>> and a lot of clean upper inodes in overlayfs, then iteration may waste
>> time so that synchronization is slower than before, but we think the
>> potential for performance improvement far surpass the potential for
>> performance regression in most cases.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>> Changes since v3:
>> - Introduce upper_inode list to organize ovl indoe which has upper inode.
>
> Where is the inode removed from the list?  Should be done in
> ovl_destroy_inode().
>
> Problem is: we can drop the overlay inode even when the underlying
> inode is dirty, so we need to sync the upper inode before letting it
> go in ovl_destroy_inode().
>

Isn't that a bit counter to the lazy inode writeback approach?
Won't this cause a change of behavior, e.g. by forcing data sync before
returning from close of file after a large write?

Perhaps it would be better if the inode refcount was elevated when adding
inode to upper_inodes list and in ovl_sync/wait_inodes(), if refcount is 1
after inode is synced, remove it from list and drop last refcount.

This all sounds very subtle...

Thanks,
Amir.
