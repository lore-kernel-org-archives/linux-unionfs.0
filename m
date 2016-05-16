From: Krisztian Litkey <kli@iki.fi>
Subject: Re: [PATCH v2 1/1] ovl: setxattr: avoid deadlock when setting IMA xattr.
Date: Mon, 16 May 2016 23:22:09 +0300
Message-ID: <CAH4bDXi+WoTS3bKWct6y2Y0A23TP+hNvDCM9JJ=iPJ+=s1J7bw@mail.gmail.com>
References: <1463338367.14611.40.camel@linux.vnet.ibm.com>
	<1463342855-27091-1-git-send-email-kli@iki.fi>
	<201605161420.u4GEKLHk009316@d03av05.boulder.ibm.com>
	<CAH4bDXi+Cb9XsU9eF5pLOLG9EGZ2W9C6BGWQKQTMwuXd_YuyDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35640 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbcEPUWK (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 16 May 2016 16:22:10 -0400
Received: by mail-wm0-f66.google.com with SMTP id e201so20595083wme.2
        for <linux-unionfs@vger.kernel.org>; Mon, 16 May 2016 13:22:10 -0700 (PDT)
In-Reply-To: <CAH4bDXi+Cb9XsU9eF5pLOLG9EGZ2W9C6BGWQKQTMwuXd_YuyDA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Mimi Zohar <zohar@us.ibm.com>
Cc: linux-unionfs@vger.kernel.org, zohar@linux.vnet.ibm.com

On Mon, May 16, 2016 at 6:13 PM, Krisztian Litkey <kli@iki.fi> wrote:
> On Mon, May 16, 2016 at 5:20 PM, Mimi Zohar <zohar@us.ibm.com> wrote:
>> Krisztian Litkey wrote on 05/15/2016 04:07:35 PM:
>>
>>> If we're writing the extended attribute used by IMA, don't
>>> try to lock sb_writers (mnt_want_write) or i_mutex. We're
>>> being called from ima_file_free and the necessary locks
>>> are already being held. Trying to lock them again will
>>> deadlock.
>>
>> Thinking about this some more, security.ima can be written here in
>> ima_file_free, but it also can be written by userspace.  The former updates
>> the file hash, while the latter is used to write the file signature.
>>
>>> In practice we test if the real inode has the S_IMA flag
>>> set and if the xattr being set is the IMA attribute. If
>>> both are true, we call __vfs_setxattr_noperm instead of
>>> the usual vfs_setxattr we call for all other cases.
>>>
>>> Signed-off-by: Krisztian Litkey <kli@iki.fi>
>>
>> Writing the file signature from userspace should call the normal
>> vfs_setxattr().
>
> Yes. If there was a reliable way to detect that we're being called
> as an end result of ima_fix_attr we should check for that and branch
> accordingly. Based on your original suggestion I was under the
> impression that testing S_IMA would have been the right check.
> Now based on your recent comment, and checking the code, I see
> that it will be set for all inodes that are associated with an iint cache
> entry...
>
> Unless we add a dedicated *vfs_setxattr* flag just for this and pass it
> from ima_fix_xattr (so that it'd propagate back to ovl_setxattr where
> we test and branch accordingly), I see no easy way to check for the
> necessary precondition. And adding a dedicated flag would probably
> be considered a horrible kludge... so I think I need to dig deeper and
> see if I can come up with another way of fixing this.
>
> I have taken a small peek at other architecturally not quite unlike FS
> implementations. Encryptfs seems to be one of the closest ones. I
> will test if their approach works together with IMA and if it does I'll try
> to roll a similar implementation for overlayfs. Does that sound
> reasonable to you ?

Hmm... after having taken a closer look at ecryptfs, I think its setxattr
is not comparable to overlayfs. The former is much simpler because
it simply passes the call on to the underlying filesystem implementation
calling vfs_setxattr, much like overlayfs was trying to do. But ecryptfs
does not need to do anything else besides setting the attribute so it can
call vfs_setxattr without taking any locks or mutexes itself.

However, there is a crucial difference in overlayfs: it might need to
copy the dentry (and all directories leading up to it) on demand in
setxattr. This happens if setxattr is being called for a file system entry
which has never been modified in/through the overlay. I think this copy
operation is what really should be protected by mnt_{want,drop}_write.

So the right thing to do would be to protect the copy and do the rest by
unconditionally calling __vfs_setxattr_noperm. But wouldn't that just bring
us back to the original problem: if i_mutex is already held, can't really
mnt_want_write without triggering the lockdep problem, right ?

>
>>
>> Mimi
>>

  Cheers,
    Krisztian

>
>   Cheers,
>     Krisztian
>
>>
>>
>>> ---
>>>  fs/overlayfs/inode.c | 24 ++++++++++++++++++------
>>>  1 file changed, 18 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>>> index b29036a..15f4af3 100644
>>> --- a/fs/overlayfs/inode.c
>>> +++ b/fs/overlayfs/inode.c
>>> @@ -222,12 +222,18 @@ static bool ovl_is_private_xattr(const char *name)
>>>  int ovl_setxattr(struct dentry *dentry, const char *name,
>>>         const void *value, size_t size, int flags)
>>>  {
>>> -   int err;
>>> +   int err, ima;
>>>     struct dentry *upperdentry;
>>> +   struct inode *inode;
>>>
>>> -   err = ovl_want_write(dentry);
>>> -   if (err)
>>> -      goto out;
>>> +   inode = ovl_dentry_real(dentry)->d_inode;
>>> +   ima = IS_IMA(inode) && !strcmp(name, XATTR_NAME_IMA);
>>> +
>>> +   if (!ima) {
>>> +      err = ovl_want_write(dentry);
>>> +      if (err)
>>> +         goto out;
>>> +   }
>>>
>>>     err = -EPERM;
>>>     if (ovl_is_private_xattr(name))
>>> @@ -238,10 +244,16 @@ int ovl_setxattr(struct dentry *dentry, const
>>> char *name,
>>>        goto out_drop_write;
>>>
>>>     upperdentry = ovl_dentry_upper(dentry);
>>> -   err = vfs_setxattr(upperdentry, name, value, size, flags);
>>> +
>>> +   if (!ima)
>>> +      err = vfs_setxattr(upperdentry, name, value, size, flags);
>>> +   else
>>> +      err = __vfs_setxattr_noperm(upperdentry, name, value, size,
>>> +                   flags);
>>>
>>>  out_drop_write:
>>> -   ovl_drop_write(dentry);
>>> +   if (!ima)
>>> +      ovl_drop_write(dentry);
>>>  out:
>>>     return err;
>>>  }
>>> --
>>> 2.5.5
>>>
>>
