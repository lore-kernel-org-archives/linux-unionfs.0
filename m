From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] vfs: introduce inode 'inuse' lock
Date: Wed, 31 May 2017 18:16:41 +0300
Message-ID: <CAOQ4uxgigP4hTfsYvCtsrKCSu5_nAsMSjMvD3pg4BY1Cd_t9mQ@mail.gmail.com>
References: <1495533033-22367-1-git-send-email-amir73il@gmail.com>
 <1495533033-22367-2-git-send-email-amir73il@gmail.com> <CAJfpegugzuJUszWV4CEDC92pCcU1tv1t=kZX0O0Uk_Uhjyoi1A@mail.gmail.com>
 <CAOQ4uxi=0w2JmBJqoRGZ9iqete2rhCQv0i+qYyk9=rXvEX+s3Q@mail.gmail.com> <CAJfpegsSM9jP06kC4DzF1a-xumtW7p5=tUnvCPXm4OsL+t0jLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35109 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdEaPQn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 11:16:43 -0400
In-Reply-To: <CAJfpegsSM9jP06kC4DzF1a-xumtW7p5=tUnvCPXm4OsL+t0jLw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 31, 2017 at 5:30 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, May 31, 2017 at 3:54 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, May 31, 2017 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Tue, May 23, 2017 at 11:50 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Added an i_state flag I_INUSE and helpers to set/clear/test the bit.
>>>>
>>>> The 'inuse' lock is an 'advisory' inode lock, which also provides
>>>> may_delete() protection, so can be used to extend exclusive create
>>>> protection beyond parent->i_mutex lock among cooperating users.
>>>>
>>>> This is going to be used by overlayfs to get exclusive ownership
>>>> on upper and work dirs among overlayfs mounts.
>>>
>>> Not sure I like the delete protection.  Any modification of workdir or
>>> layers while mounted might cause inconsistencies or errors in the
>>> overlay.  So why single out deletion of base directories?
>>>
>>
>> There are a few reasons why 'inuse' inode should not be deleted,
>> regardless of whether delete protection is needed by overlayfs or not
>> (I think we don't need it).
>>
>> 1. setting INUSE on a  FREEING|WILL_FREE inode is not allowed
>> so preventing delete on INUSE makes the possible states fewer and
>> easier to manage.
>
> Overlayfs keeps a ref on upperdir, so the inode cannot be deleted only
> unhashed.  No ref is kept on workdir, because we don't currently use
> it for anything other than creating the empty work directory inside,
> but if we mark it inuse, we should keep a ref on it as well.
>
> Maybe the interface should be:
>
> struct dentry *d_try_to_use(struct dentry *dentry)
> {
>     struct inode *inode = d_inode(dentry);
>
>     spin_lock(&inode->i_lock);
>     if (inode->i_state & I_INUSE) {
>         spin_unlock(&inode->i_lock);
>         return NULL;
>     }
>     inode->i_state |= I_INUSE;
>     spin_unlock(&inode->i_lock);
>
>     return dget(dentry)
> }
>
> void d_unuse(struct dentry *dentry)
> {
>     struct inode *inode = d_inode(dentry);
>
>     WARN_ON(!(inode->i_state & I_INUSE));
>
>     spin_lock(&inode->i_lock);
>     inode->i_state &= ~I_INUSE;
>     spin_unlock(&inode->i_lock);
>
>     dput(dentry);
> }
>
>
>>
>> 2. With latest patchset I also implemented wait_on_inode_inuse()
>> https://github.com/amir73il/linux/blob/ovl-dir-lock/fs/inode.c#L2175
>> which is later used by to copy up code for index hardlink.
>
> Need to see these patches to see what's going on here.
>

Sure. I'll post the patch bomb tomorrow.

>> By preventing delete, I can isolate I_INUSE waiters from I_NEW waiters
>> and don't need to deal with INUSE waiters and inode delete.
>>
>> 3. Backwards justification: the man page for unlink(2) and rmdir(2)
>> already explain EBUSY in a generic way:
>> "pathname cannot be unlinked because it is being used by the system ..."
>> "pathname is currently in use by the system or ..."
>
> That's fine.  I'm not objecting to the error value.
>
> I'm objecting to special casing the root upperdentry wrt.
> delete/modification protection.
>
> Make I_INUSE recursive?  I think it would be an overkill.  Just let it
> do the minimal thing that needs to be done to prevent unobvious
> configuration errors.  Removing upperdir or workdir is pretty
> obviously going to break the overlay, so I don't think we need to
> worry about that.
>

Again, I don't think we need inuse to provide delete protection
For overlayfs dirs. I think implementing the inuse API is simpler
Without having to deal with inode lifetime consideration.

I'll see if getting rid of delete protection can be done without
To much complications.

Amir.
