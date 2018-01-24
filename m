From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v10 00/18] overlayfs: Delayed copy up of data
Date: Wed, 24 Jan 2018 10:05:05 +0100
Message-ID: <CAJfpegtdEJp7+QZj16uGY4wZ8eaTDO_0YH5T0qPnS=L5tMS8-A@mail.gmail.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:43046 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932685AbeAXJFH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jan 2018 04:05:07 -0500
Received: by mail-qt0-f169.google.com with SMTP id s3so8472326qtb.10
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Jan 2018 01:05:06 -0800 (PST)
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>

On Mon, Jan 22, 2018 at 7:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> Please find attached V10 of the metadata only copy up patches. I think
> I have taken care of review comments and I will start writing automated
> test cases now.
>
> One thing which concerns me about these patches is the fact that during
> file open d_real() will return lower inode which actually contains file
> data and that inode will be installed in f->f_inode. So while f->f_inode
> is perfectly fine for data operations, it is not fine for metadata
> operations. Because metadata has been copied up and is represented by
> a different inode.
>
> I am concerned that this is a subtle behavior change and especially
> security modules might be surprised by it. I will spend now more time
> looking at what security modules are doing with f->f_inode. Thoughts?

This is exactly the same situation where there is an r/o open and
copy-up later.  Except this makes it more widespread.  So I don't
think any new issues are introduced (doesn't mean there aren't any old
ones).

The only risk I see with this feature is exactly the fact that the
ro/rw inconsistency can happen more often, which might break more
cases.  I'd really like to work on getting rid of this issue.
Hopefully next cycle...

Thanks,
Miklos
>
