From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: take lower dir inode mutex outside upper sb_writers lock
Date: Wed, 22 Nov 2017 07:46:54 +0200
Message-ID: <CAOQ4uxh-=vEQaW96_ZR1GcnOpbjy==k_zVsGy_Bt9kcdrdD-1w@mail.gmail.com>
References: <1510312687-9680-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f181.google.com ([209.85.213.181]:43880 "EHLO
        mail-yb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdKVFqz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Nov 2017 00:46:55 -0500
Received: by mail-yb0-f181.google.com with SMTP id q84so2289602ybc.10
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Nov 2017 21:46:55 -0800 (PST)
In-Reply-To: <1510312687-9680-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Nov 10, 2017 at 1:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> The functions ovl_lower_positive() and ovl_check_empty_dir() both take
> inode mutex on the real lower dir under ovl_want_write() which takes
> the upper_mnt sb_writers lock.
>
> While this is not a clear locking order or layering violation, it creates
> an undesired lock dependency between two unrelated layers for no good
> reason.
>
> This lock dependency materializes to a false(?) positive lockdep warning
> when calling rmdir() on a nested overlayfs, where both nested and
> underlying overlayfs both use the same fs type as upper layer.
>
> rmdir() on the nested overlayfs creates the lock chain:
>   sb_writers of upper_mnt (e.g. tmpfs) in ovl_do_remove()
>   ovl_i_mutex_dir_key[] of lower overlay dir in ovl_lower_positive()
>
> rmdir() on the underlying overlayfs creates the lock chain in
> reverse order:
>   ovl_i_mutex_dir_key[] of lower overlay dir in vfs_rmdir()
>   sb_writers of nested upper_mnt (e.g. tmpfs) in ovl_do_remove()
>
> To rid of the unneeded locking dependency, move both ovl_lower_positive()
> and ovl_check_empty_dir() to before ovl_want_write() in rmdir() and
> rename() implementation.
>
> This change spreads the pieces of ovl_check_empty_and_clear() directly
> inside the rmdir()/rename() implementations so the helper is no longer
> needed and removed.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> Please consider this patch for v4.15.
>
> I bumped into the lockdep warning while testing file handles on nested
> overlay and had to work around it by using different type of fs for the
> lower-upper(xfs) and the upper-upper(tmpfs).
>
> The workaround doesn't suffice if there is another test mounting an overlay
> with the same fs type used for upper-upper (e.g. unionmount-testsuite)
> at the same machine boot, which happens on my automated testing.
>
> So fixing this removes a false positive from my automated testing.
>

Miklos,

Any objections to this change?

Thanks,
Amir.
