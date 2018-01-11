From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3] ovl: Improving syncfs efficiency
Date: Thu, 11 Jan 2018 13:03:45 +0200
Message-ID: <CAOQ4uxj9AaDYm+8=KsPhtGhS5E-FhUCYRPasdC4mMz5z0X-ROg@mail.gmail.com>
References: <1515635335-8848-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxhM0Cp3eBU2OfsDY9x1vMnBjMLw9qV-eK1g+yDi2erwiw@mail.gmail.com> <20180111100742.exdlnmnrpejeqbds@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:45888 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbeAKLDr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jan 2018 06:03:47 -0500
Received: by mail-yw0-f196.google.com with SMTP id m19so831660ywh.12
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jan 2018 03:03:47 -0800 (PST)
In-Reply-To: <20180111100742.exdlnmnrpejeqbds@quack2.suse.cz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Chengguang Xu <cgxu519@icloud.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 11, 2018 at 12:07 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 11-01-18 05:30:33, Amir Goldstein wrote:
>> [CC: Jan Kara]
>>
>> On Thu, Jan 11, 2018 at 3:48 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>> > Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
>> > on upper_sb to synchronize whole dirty inodes in upper filesystem
>> > regardless of the overlay ownership of the inode. It has obvious
>> > shortcomings as below.
>> >
>> > (1) Performance
>> > Synchronization is probably heavy in most cases, especially when upper
>> > filesystem is not dedicated to target overlayfs.
>> >
>> > (2) Interference
>> > Unplanned synchronization will probably impact IO performance of the
>> > processes which use other overlayfs on same upper filesystem or directly
>> > use upper filesystem.
>> >
>> > This patch iterates overlay inodes to only sync target dirty inodes in
>> > upper filesystem. By doing this, It is able to reduce cost of synchronization
>> > and will not seriously impact IO performance of irrelative processes.
>> >
>> > Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>
>> Looks good.
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>
>> Jan,
>>
>> Would you mind taking a quick look at this?
>>
>> Overlayfs inodes have no dirty mapping, only the underlying upper inodes
>> do, so sync_inodes_sb() is not enough for overlay syncfs().
>>
>> This code creates the list of upper inodes to sync, syncs them and then
>> calls the underlying upper fs sync_fs().
>>
>> Does this look reasonable?
>
> If I understand the original changelog, this is a performance motivated
> change. As such it should have a some measurements accompanied with it to
> justify the change. I.e., how much does this help? What is the exact setup
> where this matters? Do users really care?
>

Hi Jan,

The performance improvement in the worst case is "infinite".
The relevant use case is multiple containers using the same underlying volume,
which is the more common case.

Each container uses an overlay mount, whose upper dir is on the same base
fs as all other container upper dirs.

Current implementation (since v4.15-rc4) for overlay syncfs() that is
issued from
within a container syncs all dirty inodes of all containers. The ratio
of "my" dirty
data vs. "others" dirty data can go to infinity. Even a single
container with lots of
dirty data can ruin it for everyone else.


> More technical comments inline.
>
>> > @@ -80,6 +83,8 @@ struct ovl_inode {
>> >
>> >         /* synchronize copy up and more */
>> >         struct mutex lock;
>> > +       /* ovl inode sync list */
>> > +       struct list_head sync_list;
>> >  };
>
> Additional overhead of 16-bytes per inode - not a huge deal since this is
> overlay specific but it's something to keep in mind. Could not we reuse
> i_io_list of the overlay inode instead?
>
>> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> > index 76440fe..947bb83 100644
>> > --- a/fs/overlayfs/super.c
>> > +++ b/fs/overlayfs/super.c
> ...
>> > +static void ovl_sync_inodes(struct super_block *sb)
>> > +{
>> > +       struct ovl_fs *ofs = sb->s_fs_info;
>> > +       struct inode *inode, *i_next;
>> > +       struct inode *upper_inode;
>> > +       struct blk_plug plug;
>> > +
>> > +       struct writeback_control wbc = {
>> > +               .sync_mode              = WB_SYNC_ALL,
>> > +               .for_sync               = 1,
>> > +               .range_start            = 0,
>> > +               .range_end              = LLONG_MAX,
>> > +               .nr_to_write            = LONG_MAX,
>> > +       };
>> > +
>> > +       blk_start_plug(&plug);
>> > +       spin_lock(&sb->s_inode_list_lock);
>> > +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, i_sb_list) {
>
> Why a _safe iteration variant here? If you hope it allows you to safely
> resume iteration after dropping sb->s_inode_list_lock, you are wrong
> because i_next inode can be removed from the list once you drop that lock
> as well.  You need to be more careful when iterating inodes. See how e.g.
> fs/notify/fsnotify.c:fsnotify_unmount_inodes() plays tricks with always
> keeping one inode reference to be able to resume iteration of the inode
> list.
>
> Another issue is that this will iterate all inodes on the overlayfs list.
> Both clean and dirty ones (well, those where underlying upper inode is
> dirty). When there are only a few underlying dirty inodes, this may be
> considerably slower than the original behavior. So this needs an
> explanation in the changelog why the use case you care about is more
> important than the use case this regresses. You might think that this will
> only add an iteration of an in memory list, but on large machines, this
> list may have millions of entries so it's iteration is not exactly fast.
>

Hmm. Right. So in case there are very few dirty inodes among all containers,
but each container had many non dirty inodes, this can be a problem.
We could maintain a list of upper inodes, that should be easy.
We could maintain a list of upper inodes that were opened for write, not sure
how much that will help.
For now, I think the potential for performance improvement far surpassed the
potential for performance regression (*).

Its not really a performance regression, because in <= v4.14, syncfs() in
overlayfs is broken and does not sync any dirty inodes...

Thanks a lot for your inputs!

Amir.
