From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH v2 0/3] overlayfs: support freeze/thaw/syncfs
Date: Mon, 23 Jan 2017 21:52:22 +0200
Message-ID: <CAOQ4uxgWYX-AbUW53XW1vx6-2ZA3PKBxfk0bSBaAKoPfBdiF-w@mail.gmail.com>
References: <1485174742-15866-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33980 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbdAWTwX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Jan 2017 14:52:23 -0500
In-Reply-To: <1485174742-15866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 23, 2017 at 2:32 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> Take #2 for overlayfs freeze.
>
> Patch #2 I am quite confident is a bug fix and I have written an
> xfs specific test for it.
>
> Patch #1 is a POC of what I think overlay freezing should be like,
> although we may want to optimize it with some file flag?
>
> Patch #3 just enables overlayfs freezing with NOP freeze_fs()
> unfreeze_fs() operations, so I could test it.  It behaves as
> expected - overlay and underlying fs can be frozen independently
> and writes continue when both fs are thawed.
>
> I believe that mmap freeze protection is not covered, although I am
> not sure exactly how it works?
>
> Am I missing anything else?

Found a few missed spots ({copy,clone,dedup}_file_range() and
fallocate(). sent patch #4.

Anyway, I totally understand if the reaction to this patch set is
"what is the justification for overlayfs freeze", because outside
my use case I haven't found any yet.

I would still appreciate if you could tell me whether I am in the
general right direction, as I do need to carry these patches for
overlayfs snapshots.

As for patch #2, I am not sure how often apps use syncfs(2),
and whether or not any of the containers that use overlayfs relay
on it in some way, but it looks to me like something worth fixing.

Thanks,
Amir.
