From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/7] ovl: add infrastructure for intercepting file ops
Date: Thu, 24 Nov 2016 15:12:57 +0200
Message-ID: <CAOQ4uxh9-s6+0Si+k+=wcz0TvQ5gAMHM_rwxFrnwWytj=hz+_A@mail.gmail.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
 <1479984944-1017-6-git-send-email-mszeredi@redhat.com> <CAOQ4uxhcT8ihDkz4fEHAUN85=o-sP--POe8Hpq84dGZ+9ar3dw@mail.gmail.com>
 <CAJfpegto3K+G3wZ-atebMW_3ZwZ5fiA3r2F14DwTXwuaSu7sww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38250 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935112AbcKXNM7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 08:12:59 -0500
In-Reply-To: <CAJfpegto3K+G3wZ-atebMW_3ZwZ5fiA3r2F14DwTXwuaSu7sww@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, Nov 24, 2016 at 2:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Nov 24, 2016 at 12:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Nov 24, 2016 at 12:55 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>
>>> +               /*
>>> +                * These should be intercepted, but they are very unlikely to be
>>> +                * a problem in practice.  Leave them alone for now.
>>
>> It could also be handled in vfs helpers.
>> Since these ops all start with establishing that src and dest are on
>> the same sb,
>> then the cost of copy up of src is the cost of clone_file_range from
>> lower to upper,
>> so it is probably worth to copy up src and leave those fops alone.
>>
>>> +                */
>>> +               ofop->fops.copy_file_range = orig->copy_file_range;
>>> +               ofop->fops.clone_file_range = orig->clone_file_range;
>>> +               ofop->fops.dedupe_file_range = orig->dedupe_file_range;
>
> Not sure I understand.  Why should we copy up src?  Copy up is the
> problem not the solution.
>

Maybe the idea is ill conceived, but the reasoning is:
To avoid the corner case of cloning from a stale lower src,
call d_real() in vfs helpers to always copy up src before cloning from it
and pass the correct file onwards.

It would have been crazy if we suggested the same for read_iter(),
so why it may make sense for clone?
because once you got that far into the vfs_clone_range() helper,
with src from lower and dst from upper, it means they are on the same sb
that supports clone, so it is likely that copy up is going to use clone and
be relatively cheap.

Pretty twisted. I agree... and not sure if this logic holds for copy_range as
well. Anyway, that's what I meant.

Amir.
