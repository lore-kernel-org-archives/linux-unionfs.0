From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 00/13][V5] overlayfs: Delayed copy up of data
Date: Sat, 28 Oct 2017 17:50:19 +0300
Message-ID: <CAOQ4uxhOLm+Jx3LoEeeXKMEK+i3yiok1+Ad93W2fRfThgJ=nDA@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxhDkDHAFxhs6mu6HQ+Z1+y8ykvcw5vbXO3H79kGJ6zAaA@mail.gmail.com> <20171027164032.GB5442@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:48298 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdJ1OuU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 28 Oct 2017 10:50:20 -0400
Received: by mail-yw0-f194.google.com with SMTP id q1so8062404ywh.5
        for <linux-unionfs@vger.kernel.org>; Sat, 28 Oct 2017 07:50:20 -0700 (PDT)
In-Reply-To: <20171027164032.GB5442@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 27, 2017 at 7:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 26, 2017 at 10:18:19AM +0300, Amir Goldstein wrote:
>> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Hi,
>> >
>> > Here is the V5 of patches. Following are changes from V4.
>>
>> Please use git format-patch -v6 next time you post.
>> It tags all the patch subjects so it is easier to find the former
>> revision of specific patch.
>
> Will do.
>
>>
>> >
>> > - Flipped the meaning of bit. Now OVL_METACOPY is called OVL_UPPERDATA and
>> >   dropped a barrier patch which implemented ordering requirements between
>> >   oi->flags and oi->__upperdentry.
>> >
>> > - Now ovl_d_real() does return upper dentry if upper dentry is metacopy only
>> >   dentry.
>>
>> doesn't return upper dentry
>>
>> But I am still not convinced that metacopy upper inode is not accessed in places
>> it shouldn't be accessed by vfs, via other APIs.
>>
>> For example, ovl_permission(), ovl_getattr(), ovl_setattr(), ovl_listxattr(),
>> ovl_get_acl() will all access metacopy inode and that outcome will be desired.
>> But you did not provide a complete list of vfs APIs and verify for each
>> that accessing the metacopy upper via various variants of ovl_dentry_real()
>> is either not possible (because access requires a rw fd) or is the
>> desired outcome.
>
> Thanks for asking this. I have been looking at code and trying to figure
> out if there is anything which is broken. But this also requires the
> eyeballs from all the experienced filesystem folks. I have tried
> going through all overlayfs interfaces and listing my thoughts below.
> AFAICS, nothing seems to be broken.

That's a very good start.
Now I wonder if the metacopy feature can break userspace apps that relied on
metadata operations doing copy up to avoid the RDONLY/RDWR fd inconsistency,
even if they escaped the inconsistency by accident so far.
I guess there is only one one to know...

>
> - I am assuming that ovl_dir_operations{} are not impacted by this at
>   all. Metadata copy up affects only regular files and does not touch any
>   of directory operations.
>
> Operations internal to overlayfs
> ================================
> 1. ovl_setattr()
>
>    Will do metadata copy up and work on upper inode.
>
> 2. inode_permission()
>
>    Will do permission checks on upper metacopy inode. Which seems to be
>    right thing.
>
> 3. ovl_getattr()
>
>    Will do getattr on metacopy inode and will query lower for number of
>    blocks. Seems ok.

Hmm it seems ok for stat(2), not sure about statx().
If upper metacopy is not encrypted (it has no data) and lower
is encrypted, not sure what should be the result of querying
the STATX_ATTR_ENCRYPTED attribute.
But that is just an example showing how fragile this can, when
'metadata' is not a well defined term.

Not saying that this is a show stopper, but something to consider.

>
> 4. vfs_listxattr()
>
>    Will retrieve xattr list from upper metacopy inode. Seems right.
>
> 5. ovl_get_acl()
>
>    Will retrieve acl from upper metacopy inode. Seems right.
>

You missed ovl_posix_acl_xattr_set/get().
They are hiding well ;-)
But they seem right anyway.

> 6. ovl_update_time()
>
>    Will update atime on upper metacopy inode. Seems right.
>
> 7. ovl_get_link()
>
>    Should work on upper inode. For symlinks upper will never be metadata inode
>    as this is not a regular file. So this should be fine
>
> 8. ovl_lookup()
>
>    Will set the upperdentry to metacopy inode. Seems right.
>
> 9. ovl_mkdir()
>
>    Shouldn't be affected as directories can't be metacopy only.
>
> 10. ovl_symlink()
>
>    Shouldn't be affected as symlinks can't be metacopy only.
>
> 11. ovl_unlink()
>
>    This should remove upper metacopy dentry/inode and replace with whiteout.
>
> 12. ovl_rmdir()
>
>    Should not be impacted. There are no metadata copy up for dir inodes.
>
> 13. ovl_rename()
>
>    Will copy up files metadata only (as needed) and then do rename. Data
>    will be copied up later when files are opened for WRITE. Can't think
>    of anything which will be broken due to metadata only inode.
>
> 14. ovl_link()
>
>    Will copy up old file metadata only and then create link. Or create
>    link if metadata inode already exists on upper. Feels it should not
>    be impacted either.
>
> 15. ovl_create()
>
>    Will create a new object. No metadata only inode involved.
>
> 16. ovl_mknod()
>
>    Will create a new object. No metadata only inode involved.
>
>
> d_real() and friends
> ===================
> 1. vfs_truncate() (fs/open.c)
> {
>   upperdentry = d_real(path->dentry, NULL, O_WRONLY, 0);
> }
>
> This will enforce full copy up. So no behavior change.
>
> 2. vfs_open() (fs/open.c)
> {
>   dentry *dentry = d_real(path->dentry, NULL, file->f_flags, 0)
> }
>
> This will get dentry based on flags. If file is opened for READ, then
> one will get lower dentry for metacopy inode case. This should be
> fine. Can't see anything wrong yet.
>
> 3. update_ovl_inode_times() (fs/inode.c)
> {
>         upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
> }
>
> This will return NULL for metacopy inode (for regular files). And that should
> not impact atime updates for following reason.
>
> - mtime does not change for metacopy inode. So overlay inode and upper inode
>   should have same mtime.
>
> - ctime is kept in sync with overlay inode for all metadata related operations
>   which happen on metadata inode (through overlay).
>
> - Whenever mtime or ctime because file has been written to, that time full
>   copy up will take place and this will return upperdentry (and not NULL).
>
>
> 4. may_write_real() (fs/namespace.c)
> {
>         upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
> }
>
> This can get a NULL for metadata only inode and that means return -EPERM. IOW,
> may_write_real() will always return -EPERM on metadata only inode and these
> will be treated as if these are files on lower/.
>
> Now question is does it break something. This will not allow write access to
> a file which is metadata only and it makes sense to me. One can not write
> to lower file. One could argue that metadata update should be allowed but
> current API does not distinguish between the two. So it will be denied.
>
> There are many users of it and I will spend some time and try to understand
> each and every use case.
>
> 5. file_dentry() (include/linux/fs.h)
> {
>         return d_real(file->f_path.dentry, file_inode(file), 0, 0);
> }
>
> This is trying to find dentry matching with file->f_inode. For metadata inodes
> ->f_inode will return lower inode which is expected.
>
> 6. d_real_inode() (include/linux/dcache.h)
> {
>         d_backing_inode(d_real((struct dentry *) dentry, NULL, 0, 0));
>
> }
>  only inode, this should return lower dentry and lower inode.
> Question is, does it break anything.
>
> Only place d_real_inode() seems to be being used is in fs/locks.c
>
> check_conflicting_open() {
>         if ((arg == F_RDLCK) &&
>            (atomic_read(&d_real_inode(dentry)->i_writecount) > 0))
>                 return -EAGAIN;
> }
>
> i_writecount will be updated only on upper file. So if there is metadata
> only inode, then i_writecount should be zero both on upper and lower. So
> this case is similar to lower inode, IIUC and should not be a problem.
>
>
