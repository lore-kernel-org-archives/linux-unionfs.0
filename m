From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 4/7] ovl: add infrastructure for intercepting file ops
Date: Thu, 24 Nov 2016 13:03:40 +0100
Message-ID: <CAJfpegto3K+G3wZ-atebMW_3ZwZ5fiA3r2F14DwTXwuaSu7sww@mail.gmail.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
 <1479984944-1017-6-git-send-email-mszeredi@redhat.com> <CAOQ4uxhcT8ihDkz4fEHAUN85=o-sP--POe8Hpq84dGZ+9ar3dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35539 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936501AbcKXMDl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 07:03:41 -0500
Received: by mail-oi0-f46.google.com with SMTP id b126so48683404oia.2
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2016 04:03:41 -0800 (PST)
In-Reply-To: <CAOQ4uxhcT8ihDkz4fEHAUN85=o-sP--POe8Hpq84dGZ+9ar3dw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, Nov 24, 2016 at 12:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Nov 24, 2016 at 12:55 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:

>> +               /*
>> +                * These should be intercepted, but they are very unlikely to be
>> +                * a problem in practice.  Leave them alone for now.
>
> It could also be handled in vfs helpers.
> Since these ops all start with establishing that src and dest are on
> the same sb,
> then the cost of copy up of src is the cost of clone_file_range from
> lower to upper,
> so it is probably worth to copy up src and leave those fops alone.
>
>> +                */
>> +               ofop->fops.copy_file_range = orig->copy_file_range;
>> +               ofop->fops.clone_file_range = orig->clone_file_range;
>> +               ofop->fops.dedupe_file_range = orig->dedupe_file_range;

Not sure I understand.  Why should we copy up src?  Copy up is the
problem not the solution.

Thanks,
Miklos
