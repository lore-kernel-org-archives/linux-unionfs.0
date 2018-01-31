From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [ANNOUNCE] fsck.overlayfs: update master branch
Date: Wed, 31 Jan 2018 22:23:06 +0200
Message-ID: <CAOQ4uxjk8F-a4s7JdcFJXWeU9+VD-b3dddagQjVWEg0F=+5ftg@mail.gmail.com>
References: <19ac0eea-d57f-169b-503b-ad734b30a495@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35866 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbeAaUXH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 15:23:07 -0500
Received: by mail-yw0-f196.google.com with SMTP id q6so8586639ywg.3
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 12:23:07 -0800 (PST)
In-Reply-To: <19ac0eea-d57f-169b-503b-ad734b30a495@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>

On Wed, Jan 31, 2018 at 12:23 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi All,
>
> The master branch on my overlayfs-progs [1] has been updated.
>
> No feature add, just handle comments form Amir in last iterations and
> fix some bugs:
> - Improve header comments for many functions, these becomes more readable.

Looking very good!
FYI the "header comment" which I requested, are the comment on the top of
the file. But hey I'm not complaining ;-)

> - Fix some path manipulation bugs in path.c.

Sigh. Too bad you couldn't find a path manipulation library for joinpath()
and basename2(). Things like that should really never be re-implemented.
If you really have to implement them or really want to, then you should
write simple unit tests that run on 'make test' to verify that your helpers
do what you claim they do for all the listed inputs, because right now,
I doubt that you have good test coverage for complex path composing
just from running fsck.overlay itself.

> - Improve impurities check.
> - Split out functions and constants from kernel into overlayfs.c/.h.
> - Update README, split out and detail TODO list.
>

Looks good!

Amir.
