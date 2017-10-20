From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Fri, 20 Oct 2017 07:09:52 +0300
Message-ID: <CAOQ4uxj1kTREkCpkO6FjaJPTG9u_m30DDGcSFzzL++bL5zwALA@mail.gmail.com>
References: <1508274358-17456-12-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxg6Y7LU_JffejeteT11PT5rqGhUASNgk-hTdngGOqmAjg@mail.gmail.com>
 <20171019130030.GA2090@redhat.com> <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
 <20171019145824.GB2090@redhat.com> <CAOQ4uxgzcO=jJ5putycLD7xPwPbk4Tr+axfFxvR_wwtAnhHBiQ@mail.gmail.com>
 <20171019152221.GC2090@redhat.com> <CAOQ4uxjfkTfwEi7iwca7sHfsQvWK_foinBYjP1OjVTjDeEKq+A@mail.gmail.com>
 <20171019155932.GA24029@redhat.com> <CAOQ4uxhLM=DYLRJMhCRvce3u=fhMtL=mE-CCu+QBazFdoKH5Yg@mail.gmail.com>
 <20171019203344.GB24029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:48393 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdJTEJx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2017 00:09:53 -0400
Received: by mail-yw0-f193.google.com with SMTP id q1so5387899ywh.5
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Oct 2017 21:09:53 -0700 (PDT)
In-Reply-To: <20171019203344.GB24029@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 19, 2017 at 11:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 19, 2017 at 07:33:37PM +0300, Amir Goldstein wrote:
...
>>
>> If that was true then you should have tested OVL_UPPER_DATA outside
>> the if condition. The reason it is not needed if inode is not NULL and equals
>> to the upper inode then we have already made it visible to someone, then
>> we can make it visible to evevryone.
>
> That's a good point. I think there is more to it. More below.
>>
>> This is very not clear from this code, so worth some fat comments.
>> Also at top of ovl_d_real(),  D_REAL_UPPER just returns upper dentry
>> without testing flag :-/
>
> When you say "flag" you mean testing for OVL_UPPER_DATA?

That's right.

>
>> and this is not good for may_write_real()
>> not sure about update_ovl_inode_times()...
>
> Hmm..., thinking aloud about the whole issue. I think I have not
> thought through the issue of d_real() returning a metadata only
> dentry and what does that mean for rest of the system.

It's not only d_real(), there are more entry points from vfs.
For example, ovl_permission,ovl_xattr_set/get will get to upper inode
from overlay inode (which is good for metadata copy case).

>
> I think atleast current code is not broken w.r.t d_real(D_REAL_UPPER).
> There are two users of D_REAL_UPPER currently. may_write_real() and
> update_ovl_inode_times().
>
> If we have a upper dentry which has only metadata, then may_write_real()
> should return -EPERM because "file_inode(file) != d_inode(dentry)". IIUC,
> these will be equal only if file had been opened with WRITE and in that
> case returned dentry will not be metadata only.

Right.

>
> And update_ovl_inode_times() just seems to retrieve metadata information
> from upper inode and which should be just fine for metacopy inode.

I guess it ok, but if that information leads to atime update and atime update
is done on wrong inode that its not good. didn't check.

>
> But D_REAL_UPPER is only one path. There are other ways one can get
> pointer to upper metadata only dentry.
>
> d_real(inode=X), can return upper dentry with metacopy only.
>
> d_real(inode=NULL), will *not* return upper dentry with metacopy only. If
> upper is metacopy only, it return lower dentry instead. I think this is
> primarily the case of open(O_RDONLY).
>
> So in terms of semantics of d_real() I am thinking of this now.
>
> - d_real(inode=NULL, flags=0), will never return METACOPY dentry. Either
>   it will copy up lower (if open_flags & WRITE) or will return lower.
>
> If caller forces d_real() to return a specific dentry (either by
> specifying D_REAL_UPPER or by specifying an inode, then one can
> get back a METACOPY dentry. And one should not do any of data
> operations on that dentry/inode.
>
> So d_real(D_REAL_UPPER) and d_real(inode=X) can return METACOPY only
> dentry.
>
> Does that sound reasonable, or it is too fragile and broken?

Fragile - yes! broken - probably ;)

>
> I will try to audit the callers of d_real() now and see if something
> else can be broken due to METACOPY only dentry being returned.
>
>>
>> You should run another pass on all ovl_dentry_upper()
>> ovl_dentry_real(), ovl_path_real() and ovl_path_upper()
>> ovl_inode_upper() ovl_i_dentry_upper()
>> I have a feeling there other issues lurking...
>
> Will do.

Hmm maybe we need to take yet a different approach.
Store __metaupperdentry when upper is metacopy
and store __upperdentry only after upper is blessed with data.

So only code that is aware of metacopy like setattr/getattr/permission
will even know there is a metacopy to read/write information from
rest of vfs cannot be exposed.
And it's even simpler than metacopy flag w.r.t memory barriers.

I've actually already implemented this scheme, but since then
abandoned this method. You may be able to use some code from:
https://github.com/amir73il/linux/commits/ovl-rocopyup-v1

Mainly ovl_dentry_ro_upper() and the code changes in util.c
and ovl_entry.h.

>
> I am also wondering what happens to various timestamps when data is
> copied up later on a metadata only inode. I am guessing that I will
> have to atleast copy mtime from lower and apply on upper.
>

Hmm this could be tricky. I think you need to "merge" mtime with ctime/atime
of metacopy inode. There are some relations to maintain among them,
which may not be trivial.
The simplest rule I think is mtime := ctime on data copy up,
ignoring the case of lower being modified after metadata was copied.
In most cases, mtime is about to be updated by write shortly after anyway.

Amir.
