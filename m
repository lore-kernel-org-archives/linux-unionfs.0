From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 07/10] ovl: mount overlay read-only on failure to verify
 index dir
Date: Fri, 14 Jul 2017 09:51:22 +0300
Message-ID: <CAOQ4uxiQ7ONfkbx=buUTaS6bCpDurHk7qB5vj6c9wOesJbS4FQ@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-8-git-send-email-amir73il@gmail.com> <CAJfpegvR5qZWb6dJRMSL4N-qpbJT1rqN_1KkVZhO4G2AgJWd3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:33824 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdGNGv2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jul 2017 02:51:28 -0400
Received: by mail-yb0-f193.google.com with SMTP id n205so4538978yba.1
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 23:51:23 -0700 (PDT)
In-Reply-To: <CAJfpegvR5qZWb6dJRMSL4N-qpbJT1rqN_1KkVZhO4G2AgJWd3g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jul 13, 2017 at 11:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Jul 11, 2017 at 2:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Just like on failure to create work dir or index dir, when
>> index dir verification or cleanup fails, mount the overlay
>> read-only with a warning instead of failing the mount.
>
> Why?

First of all, why not? to me, it makes more sense to treat
"cannot create indexdir" and "cannot use existing indexdir" the same way
and provide slightly better user experience.
But I agree that this patch doesn't fix any bug or correctness issue.

>
> The failure to create case was done to ensure we can mount the overlay
> read-only with the same options if the underlying layers are read-only
> as well.
>
> This, however, does not have such a use case.  Or does it?
>

I can think of two corner use cases:
1. We have a bug that causes ovl_indexdir_cleanup() failure.
2. Trying to reuse workdir from previous mount with a new upperdir.

The second use case happened to me both with unionmount-testsuite
and with xfstests.
I pushed a fix to unionmount-testsuite:
d283eab - Use separate workdir per upper dir
and posted a fix for xfstests.

Of course I am not concerned about out of date testsuite failing tests,
but it goes to show that if utilities *can* reuse workdir with new
upperdir they may very well do so, just on account on being used
to overlayfs cleaning workdir for them on mount.

If such a utility exists, say to create a new overlay of /home/guest/ dir
on every login and it happens to reuse the same workdir for every login,
then upgrading to new kernel with CONFIG_OVERLAYFS_INDEX=y will
result in failure to mount /home/guest on login.

I claim, that we would be better off falling back to ro mount, which could,
maybe slightly, alter the pitch of the voice of the shouting we get from
admins.

But maybe I am miss-reading the shouting chain. I have no experience
interacting with downstream projects.

Thanks,
Amir.
