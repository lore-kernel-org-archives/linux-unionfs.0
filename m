From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 1/2] ovl: store path type in dentry
Date: Tue, 28 Mar 2017 12:59:45 -0400
Message-ID: <CAOQ4uxjGP2R2dY+Js2ycR10WeC1ehKJ_Q6qSDbK_ocbh+ps_wQ@mail.gmail.com>
References: <1490113005-28787-1-git-send-email-amir73il@gmail.com>
 <1490113005-28787-2-git-send-email-amir73il@gmail.com> <CAJfpegvzd_o+pY7vT_5LL+y1UUyF0Biv5b7G6f1YLHtuUJhtTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:32791 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdC1RAK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Mar 2017 13:00:10 -0400
Received: by mail-ot0-f174.google.com with SMTP id 102so46095509otv.0
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Mar 2017 10:00:04 -0700 (PDT)
In-Reply-To: <CAJfpegvzd_o+pY7vT_5LL+y1UUyF0Biv5b7G6f1YLHtuUJhtTw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Mar 28, 2017 at 10:03 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Mar 21, 2017 at 5:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> ovl_path_type() is called quite often (e.g.: on every file open)
>> to calculate the path type flags of overlay dentry.  Those flags
>> are rarely changed after dentry instantiation  and when changed,
>> flags can only be added. (e.g.: on copyup, rename and create).
>>
>> Store the type value in ovl_entry and update the flags when
>> needed, so ovl_path_type() just returns the stored value.
>
> Since accessing __upperdentry is lockless we need to be careful with
> memory ordering issues.
>
> For example in the new version of ovl_dentry_update() we first store
> oe->__upperdentry then oe->type.  In a concurrent ovl_path_real() we
> first read oe->type and then based on the OVL_TYPE_UPPER flag read
> oe->__upperdentry.  Without any barriers the above could very easily
> result in NULL upperdentry being read.  The compiler or the CPU  could
> reorder the stores in ovl_dentry_update(), etc...
>

Right.. thanks for pointing that out. I'll take better care.

FYI, I am just in the midst of adding oe->__tempdentry and
OVL_TYPE_RO_UPPER for copy up on O_RDONLY.
I started by trying to "upgrade" oe->__upperdentry from tmpfile
to linked file, but that was real messy.

> For the gory details see Documentation/memory-barriers.txt
>

I know about them, but still easy for me to get them wrong...
Hopefully will have something for you to review by tomorrow.

Thanks,
Amir.
