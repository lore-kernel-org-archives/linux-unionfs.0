From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 4/7] ovl: add infrastructure for intercepting file ops
Date: Thu, 24 Nov 2016 14:51:21 +0100
Message-ID: <CAJfpegvihASTC+uSjXruokVT-sfqegh_h1-w_dB9bLGZCMUvnQ@mail.gmail.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
 <1479984944-1017-6-git-send-email-mszeredi@redhat.com> <CAOQ4uxhcT8ihDkz4fEHAUN85=o-sP--POe8Hpq84dGZ+9ar3dw@mail.gmail.com>
 <CAJfpegto3K+G3wZ-atebMW_3ZwZ5fiA3r2F14DwTXwuaSu7sww@mail.gmail.com> <CAOQ4uxh9-s6+0Si+k+=wcz0TvQ5gAMHM_rwxFrnwWytj=hz+_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34363 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965011AbcKXNvX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 08:51:23 -0500
Received: by mail-oi0-f65.google.com with SMTP id m75so3033207oig.1
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2016 05:51:23 -0800 (PST)
In-Reply-To: <CAOQ4uxh9-s6+0Si+k+=wcz0TvQ5gAMHM_rwxFrnwWytj=hz+_A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, Nov 24, 2016 at 2:12 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Nov 24, 2016 at 2:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Nov 24, 2016 at 12:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Thu, Nov 24, 2016 at 12:55 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>>
>>>> +               /*
>>>> +                * These should be intercepted, but they are very unlikely to be
>>>> +                * a problem in practice.  Leave them alone for now.
>>>
>>> It could also be handled in vfs helpers.
>>> Since these ops all start with establishing that src and dest are on
>>> the same sb,
>>> then the cost of copy up of src is the cost of clone_file_range from
>>> lower to upper,
>>> so it is probably worth to copy up src and leave those fops alone.
>>>
>>>> +                */
>>>> +               ofop->fops.copy_file_range = orig->copy_file_range;
>>>> +               ofop->fops.clone_file_range = orig->clone_file_range;
>>>> +               ofop->fops.dedupe_file_range = orig->dedupe_file_range;
>>
>> Not sure I understand.  Why should we copy up src?  Copy up is the
>> problem not the solution.
>>
>
> Maybe the idea is ill conceived, but the reasoning is:
> To avoid the corner case of cloning from a stale lower src,
> call d_real() in vfs helpers to always copy up src before cloning from it
> and pass the correct file onwards.

Which correct file?  src is still the wrong one after calling d_real.
We need to clone-open src, just like we do in ovl_read_iter to get the
correct file.  But then what's the use of copying it up beforehand?

We could move the whole logic into the vfs, but I don't really see the point.

I left these ops alone because there is some confusion in there about
getting the f_op from the source or the destination file.  And while
it doesn't matter normally (all regular files have the same f_op,
regardless of open flags)  it does matter for overlayfs intercept,
because overriding fops in the the dest file would mean additional
complexity and  resources).  That could easily be fixed in the vfs:
calling src->f_ops->foo works equally well, but I simply didn't want
to bother with this.  We can return to it later.

Thanks,
Miklos
