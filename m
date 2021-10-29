Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F33C433F5
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 13:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C35861100
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 13:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhJ2NuE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:50:04 -0400
Received: from mout.gmx.net ([212.227.15.15]:59669 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhJ2NuD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Oct 2021 09:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635515252;
        bh=5ZnHW8lBzPyDAmOmhzX0urKSo+BYPEIE248fjalnG3U=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=D1/Bg92O0ZQJfR14pb8uoX9wT9ICe5Jiez++y6bq/dhwoB/u+9CjPMLaJQI7L9mKS
         JM/RthZPlz9GJEmGVN1WxucHWHuW3H6G1TyYyCNjcXZqRA5jACrAlhaHWboDM0Xj70
         vwBu6DGXHHie/GNmZ626lcEoEj38GTi1V70hSmEw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.54.0.166] ([87.167.93.4]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N2E1M-1mnMC546zm-013b7w; Fri, 29
 Oct 2021 15:47:32 +0200
Message-ID: <9ebbe5cc-becf-c491-1bf2-4d627fde15c8@gmx.net>
Date:   Fri, 29 Oct 2021 15:47:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: overlayfs: supporting O_TMPFILE
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
References: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net>
 <CAOQ4uxh_P0fiV9gQOs9CLvB+xJpJT4hWfAFyKBx0A-TyxAma8Q@mail.gmail.com>
 <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
From:   =?UTF-8?Q?Georg_M=c3=bcller?= <georgmueller@gmx.net>
In-Reply-To: <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OoxUWqyQFexGj0zvH+MiuesX3yQfDFI0pxH2epxfIT8LMpr+ybI
 YljL5ABR1AyTF4/sC6Ofm9+lN7ZMqNxzN6ioji4qjxrhnV8y2bHjSL01qeL/ci8hbYsOBlF
 LKlnfC2V5tBnU4gSf1dtZjdnbgEOYYPqc7RXOmeoHKwNqWyfSI1J1fM/FKptaDHoW0r2UPr
 XGaQXmjU0UQ6+pQ3t3Bkw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OHKd5DLm58o=:ySXfs/9g0M9hze3QGtMfgy
 diXLCcIH8Wq6hevEHB1tZPjfupaIjkQu2djCv7IyujlPNbz8z/zLDxrWs7pR6Ov1zhLFr69y1
 kt9aI1LQWO6bxrH5F6LN3S7ZBtVoK+uNTx8x2RclP1cSoGsU8RT1nq5ggVvRnOKQSw+eBksUT
 BuGMu2PRwbjVOPM2GCrm1jwt/h6jm2dmtyRIYdgfgPRDI7S3fPqk0HQV0PA/zxFMyHvmTcJBr
 H367+hZAU5+HlSPvIzd6P90lofofxaVykNt97u5dg7YdCLAKY58PhHkIGFhcTCFV+Ev/3tCkv
 QiJQE5NXbMNrjWISb/lYipLGYTRhHJgJgWFnrWzx/+V7awhzk3d/MKrm0QNZXSCE5WKP1HQNP
 7g7EuPxn7FZSwpFAGx+9Guo5orwli/OwL3r7l8Rph0jydsG1LFRcFCElaTuK0DMfUDtwCHzTc
 SYbWAawNeUfuoERrXJ5VwiAjV6yHfFIBoLBpY2FWySaX6Lw+lADMaHzwHOvPKhmQyUPr0RQ6s
 u2CecD7uisNVm2HkdAmg4JGY9b4sqpLM75E5iGGW9oskblfc5YexsQ8TJy6N1gRzuS6MulbGm
 kfsZAF057xN0ACmkTgFtwOORveyx4Oe2mE8q8vSOLGEjq8QXtUgvCgqRNhp/fZxeoWQnaPGB7
 o7S9J83GUE7wAf3jPNIWPYzdy5huhWcW8LCvYj+1aZpqHtAdJjaT5MJMFas3NL8eIe+YxbJOU
 3TbvLyKjjd9X72mLZ8qh63FdZGbHHtyBQm7HLS9gR5Eob7kGydzZ5WRTsl7nTVw+Zh0K1v5u/
 dJEJhtenCeAen1O7bbdAjqFrMwMh9mBt0z9cLKhUNhTYZb3jBvXTWKoykEfaLKSfNnSDv3Jex
 EAFYBOFJBD2T5PmsMgWrXuEVLlKXVjXiJtCkltcCse2c8B84b7vu3awc+BX/9ish5zDov0rFw
 xcdWLKNWdgvwpsV7JhPapfzWI/ELX5B6jSGOlG3h816nJejkGbRsDFmYgf80KHYPBNwev0ddl
 /hXnQYA0WT2Z5iRhRJsVomyHXvpUBgN1f8D25uBhJbDRiS7bIfO8bcag3A9bKA5/Og9a0Sesl
 J3VeypJGt0Spgo=
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Am 29.10.21 um 14:54 schrieb Miklos Szeredi:
> On Fri, Oct 29, 2021 at 01:37:49AM +0300, Amir Goldstein wrote:
>> On Thu, Oct 28, 2021 at 11:41 PM Georg M=C3=BCller<georgmueller@gmx.net=
>  wrote:
>>> Hi,
>>>
>>> I was trying to implement .tmpfile for overlayfs inode_operations to s=
upport O_TMPFILE.
>>>
>>> Docker with aufs supports it, but this is deprecated and removed from =
current docker. I now have a work-around in my code (create tmpfile+unlink=
), but
>>> I thought it might be a good idea to have tmpfile support in overlayfs=
.
>>>
>>> I was trying to do it on my own, but I have some headaches to what is =
necessary to achieve the goal.
>>>
>>>   From my understanding, I have to find the dentry for the upper dir (=
or workdir) and call vfs_tmpdir() for this, but I am running from oops to =
oops.
>>>
>>> Is there some hint what I have to do to achieve the goal?
>>>
>> You'd want to use ovl_create_object() and probably pass a tmpfile argum=
ent
>> then pass it on struct ovl_cattr to ovl_create_or_link() after that
>> it becomes more complicated. You'd need ovl_create_tempfile() like
>> ovl_create_upper().
>> You can follow xfs_generic_create() for some clues.
>> You need parts of ovl_instantiate() but not all of it - it's a mess.
> Here's something I prepared earlier;)
>
> Don't know why it got stuck, quite possibly I realized some fatal flaw t=
hat I
> can't remember anymore...
>
> Seems to work though, so getting this out for review and testing.


Thank you for the patch. I will give it a try in my local setup here and w=
ill come back with the results.

Best regards,
Georg
