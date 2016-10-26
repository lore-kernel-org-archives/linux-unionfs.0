From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Wed, 26 Oct 2016 14:51:40 +0200
Message-ID: <CAJfpegsMeiwgUjDN+-pNWMCyiFnQReZaS=mewRzPW-Ehg=BkNQ@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <CAOQ4uxhTOw9vHVSQURakYgamXMxXDTnZYFjUDZYx1Hnf=TA9dA@mail.gmail.com>
 <CAJfpegs+NDycOda67y5-8zDYHk90gxdQuQsRQ2pLq58UcUqa9A@mail.gmail.com> <CAOQ4uxjxSm6ncRBz66TWm_p0hv8RmmS9jKin-8q9LBF-CLaXkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33557 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942346AbcJZMvn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Oct 2016 08:51:43 -0400
Received: by mail-oi0-f65.google.com with SMTP id i127so10892762oia.0
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Oct 2016 05:51:42 -0700 (PDT)
In-Reply-To: <CAOQ4uxjxSm6ncRBz66TWm_p0hv8RmmS9jKin-8q9LBF-CLaXkg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, Oct 26, 2016 at 2:11 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Oct 26, 2016 at 2:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Oct 25, 2016 at 2:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>>> @@ -880,31 +913,34 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>>>>         if (WARN_ON(olddentry->d_inode == newdentry->d_inode))
>>>>                 goto out_dput;
>>>>
>>>> -       if (is_dir && !old_opaque && ovl_lower_positive(new)) {
>>>> -               err = ovl_set_opaque(olddentry);
>>>> -               if (err)
>>>> -                       goto out_dput;
>>>> -               ovl_dentry_set_opaque(old, true);
>>>> +       if (is_dir) {
>>>> +               if (ovl_type_merge_or_lower(old)) {
>>>> +                       err = ovl_set_redirect(old);
>>>
>>> There is a fair chance of getting ENOSPC/EDQUOT here and confuse user space.
>>> Would it be better to convert these non fatal errors with EXDEV, so
>>> user space will
>>> gracefully fallback to recursive rename/clone/copy?
>>
>> Recursive copy up will surely consume more space than an xattr?
>
> Surely. But that is not what I meant.
> In Ext4, for example, the total size of extended attributes for an
> inode is limited to a single block,
> so you can get ENOSPC with alot of free space in the file system.

Ah.

>
> You can also get ERANGE if the redirect path length > 256.

The 256 limit is for the name of the xattr, not the value.

Thanks,
Miklos
