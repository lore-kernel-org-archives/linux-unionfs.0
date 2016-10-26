From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Wed, 26 Oct 2016 22:56:07 +0300
Message-ID: <CAOQ4uxidCNkXNVBZFM9q9261DGZ_mmBNjWkDTsZii7Z12dyRKg@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <CAOQ4uxhTOw9vHVSQURakYgamXMxXDTnZYFjUDZYx1Hnf=TA9dA@mail.gmail.com>
 <CAJfpegs+NDycOda67y5-8zDYHk90gxdQuQsRQ2pLq58UcUqa9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34805 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbcJZT4J (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Oct 2016 15:56:09 -0400
In-Reply-To: <CAJfpegs+NDycOda67y5-8zDYHk90gxdQuQsRQ2pLq58UcUqa9A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, Oct 26, 2016 at 2:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Oct 25, 2016 at 2:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>>> @@ -880,31 +913,34 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>>>         if (WARN_ON(olddentry->d_inode == newdentry->d_inode))
>>>                 goto out_dput;
>>>
>>> -       if (is_dir && !old_opaque && ovl_lower_positive(new)) {
>>> -               err = ovl_set_opaque(olddentry);
>>> -               if (err)
>>> -                       goto out_dput;
>>> -               ovl_dentry_set_opaque(old, true);
>>> +       if (is_dir) {
>>> +               if (ovl_type_merge_or_lower(old)) {
>>> +                       err = ovl_set_redirect(old);
>>
>> There is a fair chance of getting ENOSPC/EDQUOT here and confuse user space.
>> Would it be better to convert these non fatal errors with EXDEV, so
>> user space will
>> gracefully fallback to recursive rename/clone/copy?
>
> Recursive copy up will surely consume more space than an xattr?
>
>>> @@ -162,6 +223,23 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>>                 stack[ctr].dentry = this;
>>>                 stack[ctr].mnt = lowerpath.mnt;
>>>                 ctr++;
>>> +
>>> +               if (!stop && i != poe->numlower - 1 &&
>>> +                   d_is_dir(this) && ovl_redirect_dir(dentry->d_sb)) {
>>> +                       err = ovl_check_redirect(this, &redirect);
>>> +                       if (err)
>>> +                               goto out_put;
>>> +
>>> +                       if (redirect && poe != dentry->d_sb->s_root->d_fsdata) {
>>> +                               poe = dentry->d_sb->s_root->d_fsdata;
>>> +
>>
>> Now you are about to continue looping until new value of poe->numlower,
>> which is >= then olf value of poe->numlower, but 'stack' was allocated
>> according to old value of poe->numlower, so aren't you in danger of
>> overflowing it?
>>
>> Please add a comment to explain the purpose of this loop rewind.
>
> We are jumping to a stack possibly wider than the current one and need
> to find the layer where to continue the downward traversal.  I'll add
> the comment.
>

OK. my point was that you need to allocate an sb max depth stack in advance,
in case you need to jump to a wider stack.

> BTW I don't remember having tested this, so it might possibly be
> buggy.  Automatic multi-layer testing would really be good.  What we
> basically need is:
>
>  - create normal (two layer) overlay (with interesting constructs,
> whiteout, opaque dir, redirect)
>  - umount
>  - create three layer overlay where the two lower layers come from the
> previous upper/lower layers
>  - do more interesting things
>
> There's one such test in xfstests but it would be good to have more.
>

I just sent 2 patches to fix 2 overlayfs xfstests failures.
With these 2 changes, the entire quick test group passes on my setup
(short of one test that also fails on ext4 and xfs).

Now I will start to think about instrumenting generic xfstests with lower/upper
files and then with rotating upper (i.e. layer stack).

Amir.
