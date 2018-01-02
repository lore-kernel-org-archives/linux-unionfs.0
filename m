From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 1/2] vfs: update overlay inode times on write
Date: Tue, 2 Jan 2018 21:45:50 +0200
Message-ID: <CAOQ4uxikmUgO1utOjMezv0bj-QmghqCYdcQir625pXD4iqJQhA@mail.gmail.com>
References: <1514896009-11468-1-git-send-email-amir73il@gmail.com>
 <1514896009-11468-2-git-send-email-amir73il@gmail.com> <1514918907.3462.17.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:42924 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeABTpw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 14:45:52 -0500
In-Reply-To: <1514918907.3462.17.camel@kernel.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jan 2, 2018 at 8:48 PM, Jeff Layton <jlayton@kernel.org> wrote:
> On Tue, 2018-01-02 at 14:26 +0200, Amir Goldstein wrote:
>> Currently with overlayfs, the real upper inode's i_mtime is updated on
>> write, but not overlay vfs inode. The vfs inode's i_mtime is used by nfsd
>> to check if nfs client cache is stale, so updating the overlay vfs inode
>> i_mtime on write is required for overlayfs NFS export support.
>>
>> The non uptodate mtime issue was found and verified with the
>> nfstest_posix test when run over NFS exported overlayfs:
>>
>>  $ nfstest_posix --runtest=write
>>  ...
>>  FAIL: write - file st_mtime should be updated
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/inode.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 03102d6ef044..a252256f4e51 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1567,8 +1567,7 @@ EXPORT_SYMBOL(bmap);
>>  /*
>>   * Update times in overlayed inode from underlying real inode
>>   */
>> -static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
>> -                            bool rcu)
>> +static void update_ovl_d_inode_times(struct dentry *dentry, bool rcu)
>>  {
>>       struct dentry *upperdentry;
>>
>> @@ -1585,6 +1584,7 @@ static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
>>        * stale mtime/ctime.
>>        */
>>       if (upperdentry) {
>> +             struct inode *inode = d_inode(dentry);
>>               struct inode *realinode = d_inode(upperdentry);
>>
>>               if ((!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
>> @@ -1607,7 +1607,8 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
>>       if (!(path->mnt->mnt_flags & MNT_RELATIME))
>>               return 1;
>>
>> -     update_ovl_inode_times(path->dentry, inode, rcu);
>> +     update_ovl_d_inode_times(path->dentry, rcu);
>> +
>>       /*
>>        * Is mtime younger than atime? If yes, update atime:
>>        */
>> @@ -1876,6 +1877,8 @@ int file_update_time(struct file *file)
>>       ret = update_time(inode, &now, sync_it);
>>       __mnt_drop_write_file(file);
>>
>> +     update_ovl_d_inode_times(file->f_path.dentry, false);
>> +
>>       return ret;
>>  }
>>  EXPORT_SYMBOL(file_update_time);
>
> This code all seems to be called from the relatime handling codepath,
> but the problem statement is all about the mtime.

See, currently update_ovl_inode_times() purpose is to update overlay
inode before the mtime reader relatime_need_update() access i_mtime.
Any other access to i_mtime (e.g. lease_get_mtime()) gets a non-update
version of i_mtime, because nobody bothers to call update_ovl_inode_times().

>
> Is there a reason for that, or would this be better done in (e.g.)
> ovl_update_time? Is this code trying to delay updating times until
> something is trying to access it?

There is no delaying requirement. The problem statement is that with
overlayfs there are 2 inodes in play, The overlay inode and the real underlying
inode. After an overlay regular file is open, file_inode(file) points
to the underlying real inode,
so write() only knowns about the real underlying inode and i_mtime is typically
only ever updated on real underlying inode. ovl_update_time() is thus
never called
on the write() path.

locks_inode(file) := file->f_path.dentry->d_inode is the overlay
inode, which is the
one used throughout locks.c, so the patch above calls  update_ovl_inode_times()
from file_update_time() with the overlay inode to copy i_mtime from
real to overlay
inode.

Patch 2/2, which seems like the better option to me, calls
update_ovl_inode_times()
from the i_mtime reader lease_get_mtime() before i_mtime access.

Is this making more sense to you?

Amir.
