From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 11:19:31 +0100
Message-ID: <CAJfpegtTUi51viUWE1tz3kvfGpwfj-kpivHQb=7vtr4tj5M+2g@mail.gmail.com>
References: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
 <CAJfpeguLEM-3OgvAzznsL_6Tj3aj0STEgs12WY9sZq++rwJcFA@mail.gmail.com> <CAOQ4uxg6HvakDexhwunMcMwoJUoZs2t9syjA+A_Bi8QxnhOuCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:40751 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbeAOKTc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 05:19:32 -0500
Received: by mail-qt0-f179.google.com with SMTP id u42so13521584qte.7
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 02:19:32 -0800 (PST)
In-Reply-To: <CAOQ4uxg6HvakDexhwunMcMwoJUoZs2t9syjA+A_Bi8QxnhOuCw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 15, 2018 at 11:10 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Jan 15, 2018 at 11:29 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Jan 15, 2018 at 8:33 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>> Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
>>> on upper_sb to synchronize whole dirty inodes in upper filesystem
>>> regardless of the overlay ownership of the inode. In the use case of
>>> container, when multiple containers using the same underlying upper
>>> filesystem, it has some shortcomings as below.
>>>
>>> (1) Performance
>>> Synchronization is probably heavy because it actually syncs unnecessary
>>> inodes for target overlayfs.
>>>
>>> (2) Interference
>>> Unplanned synchronization will probably impact IO performance of
>>> irrelative container processes on the other overlayfs.
>>>
>>> This patch iterates upper inode list in overlayfs to only sync target
>>> dirty inodes and wait for completion. By doing this, It is able to reduce
>>> cost of synchronization and will not seriously impact IO performance of
>>> irrelative processes. In special case, when having very few dirty inodes
>>> and a lot of clean upper inodes in overlayfs, then iteration may waste
>>> time so that synchronization is slower than before, but we think the
>>> potential for performance improvement far surpass the potential for
>>> performance regression in most cases.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>> ---
>>> Changes since v3:
>>> - Introduce upper_inode list to organize ovl indoe which has upper inode.
>>
>> Where is the inode removed from the list?  Should be done in
>> ovl_destroy_inode().
>>
>> Problem is: we can drop the overlay inode even when the underlying
>> inode is dirty, so we need to sync the upper inode before letting it
>> go in ovl_destroy_inode().
>>
>
> Isn't that a bit counter to the lazy inode writeback approach?

Not really.  The dcache still keeps inodes and cache in memory, until
there's memory pressure to get rid of the dentry itself.

So this is about syncing the upper inode when the overlay dentry is
flushed out of the dcache, which should not interfere with lazy
writeback in general.

> Won't this cause a change of behavior, e.g. by forcing data sync before
> returning from close of file after a large write?

No, file keeps a ref on dentry, which keeps a ref on inode +
underlying dentries.

Thanks,
Miklos
