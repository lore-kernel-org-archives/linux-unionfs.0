From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix EIO from lookup of non-indexed upper
Date: Tue, 24 Oct 2017 11:59:18 +0200
Message-ID: <CAJfpegsLbJN84S=-KoBOpV-b_8p9AyoEWbc66nSSX_SRzeuiLQ@mail.gmail.com>
References: <1507824184-6244-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51184 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932445AbdJXJ7U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 05:59:20 -0400
Received: by mail-wm0-f67.google.com with SMTP id u138so14544742wmu.5
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 02:59:19 -0700 (PDT)
In-Reply-To: <1507824184-6244-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "# v4 . 13" <stable@vger.kernel.org>

On Thu, Oct 12, 2017 at 6:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Commit fbaf94ee3cd5 ("ovl: don't set origin on broken lower hardlink")
> attempt to avoid the condition of non-indexed upper inode with lower
> hardlink as origin. If this condition is found, lookup returns EIO.
>
> The protection of commit mentioned above does not cover the case of lower
> that is not a hardlink when it is copied up (with either index=off/on)
> and then lower is hardlinked while overlay is offline.
>
> Changes to lower layer while overlayfs is offline should not result in
> unexpected behavior, so a permanent EIO error after creating a link in
> lower layer should not be considered as correct behavior.
>
> This fix replaces EIO error with a warning in cases where upper has
> origin but no index is found, or index is found that does not match upper
> inode. In those cases, lookup will not fail and the returned overlay
> inode will be hashed by upper inode instead of by lower origin inode.
>
> Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
> Cc: <stable@vger.kernel.org> # v4.13
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> Following a discussion with Vivek about metacopy feature and the option
> of setting ORIGIN for non-indexed lower hardlinks on copy up, I came to
> a conclusion that the current EIO behavior is not quite tollerant to lower
> changes as one would hope and that it should be fixed in stable kernels.

Okay, but I started wondering if we really should be writing warnings
to the kernel log if this situation is considered normal.

Is it worth warning about these?

Thanks,
Miklos
