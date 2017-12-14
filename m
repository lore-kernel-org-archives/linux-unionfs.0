From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Thu, 14 Dec 2017 15:13:50 +0100
Message-ID: <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com> <20171214064747.20999-2-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:44461 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdLNONv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 09:13:51 -0500
Received: by mail-qt0-f170.google.com with SMTP id m59so8028530qte.11
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Dec 2017 06:13:51 -0800 (PST)
In-Reply-To: <20171214064747.20999-2-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, miaoxie@huawei.com

On Thu, Dec 14, 2017 at 7:47 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> fsck.overlay
> ============
>
> fsck.overlay is used to check and optionally repair underlying
> directories of overlay-filesystem.

Thanks for working on this.


>
> Check the following points:
>
> Whiteouts
> ---------
>
> A whiteout is a character device with 0/0 device number. It is used to
> record the removed files or directories, When a whiteout is found in a
> directory, there should be at least one directory or file with the same
> name in any of the corresponding lower layers. If not exist, the whiteout
> will be treated as orphan whiteout and remove.

Okay.

>
> Opaque directories
> ------------------
>
> An opaque directory is a directory with "trusted.overlay.opaque" xattr
> valued "y". There are two legal situations of making opaque directory: 1)
> create directory over whiteout 2) creat directory in merged directory. If an
> opaque directory is found, corresponding matching name in lower layers might
> exist or parent directory might merged, If not, the opaque xattr will be
> treated as invalid and remove.

Current version of overlay fs doesn't bother with removing opaque
attribute.  So not sure fsck.overlay should care.  Or at least is
should be an optional thing and not worth warning about, since it's
perfectly normal.


>
> Redirect directories
> --------------------
>
> An redirect directory is a directory with "trusted.overlay.redirect"
> xattr valued to the path of the original location from the root of the
> overlay. It is only used when renaming a directory and "redirect dir"
> feature is enabled. If an redirect directory is found, the following
> must be met:
>
> 1) The directory store in redirect xattr should exist in one of lower
> layers.

Okay.

> 2) The origin directory should be redirected only once in one layer,
> which mean there is only one redirect xattr point to this origin directory in
> the specified layer.
> 3) A whiteout or an opaque directory with the same name to origin should
> exist in the same directory as the redirect directory.
>
> If not, 1) The redirect xattr is invalid and need to remove 2) One of
> the redirect xattr is redundant but not sure which one is, ask user 3)
> Create a whiteout device or set opaque xattr to an existing directory if the
> parent directory was meregd or remove xattr if not.

Hmm, in this case also should ask the user, as it's not clear that the
"new" copy resulting from removal of whiteout on upper is the wanted
one or the "old" renamed copy.


>
> Usage
> =====
>
> 1. Ensure overlay filesystem is not mounted based on directories which
> need to check.
>
> 2. Run fsck.overlay program:
>    Usage:
>    fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
>
>    Options:
>    -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
>                              multiple lower use ':' as separator.
>    -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
>    -w, --workdir=WORKDIR     specify work directory of overlayfs

Not sure what other fsck do, but I'd feel more logical to have the
same -olowerdir=..., etc. notation as for mount.

Thanks,
Miklos
