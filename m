From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 0/2] ovl: fix IS_APPEND() checks
Date: Thu, 20 Apr 2017 15:19:13 +0300
Message-ID: <CAOQ4uxhe2Ec9fB2x4ovx5CCxXQKw+CV7a+zdjk6JBo4Vj1aWOw@mail.gmail.com>
References: <1491652147-19794-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35914 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942842AbdDTMTO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 08:19:14 -0400
Received: by mail-oi0-f68.google.com with SMTP id a3so3667151oii.3
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2017 05:19:14 -0700 (PDT)
In-Reply-To: <1491652147-19794-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On Sat, Apr 8, 2017 at 2:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This series fixes the append-only violations found by the new
> xfstest overlay/030.
>
> I addressed your comments on v2 and removed the patch to vfs_truncate()
> because d_real() already takes cares of IS_APPEND().
>

Miklos,

I know I bombed you with patches to review and
you are probably still catching up on your emails.

Since 4.11 release is around the corner, wanted to
ping you on these fix patches from 2 weeks ago,
so they have some time to soak in -next.

V3 turned out to be quite simple and not controversial IMO.

Thanks,
Amir.

> Amir.
>
> v3:
> - address comments by Miklos
> - discard unneeded patch to vfs_truncate()
>
> v2:
> - move open check to ovl_d_real()
> - discard wrong patch to file_start_write() in ftruncate()
>
> v1:
> - fix checks in [f]truncate and vfs_open()
>
> Amir Goldstein (2):
>   vfs: ftruncate check IS_APPEND() on real upper inode
>   ovl: check IS_APPEND() on real upper inode
>
>  fs/open.c            |  3 ++-
>  fs/overlayfs/super.c | 28 +++++++++++++++++++++++++---
>  2 files changed, 27 insertions(+), 4 deletions(-)
>
> --
> 2.7.4
>
