From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/4] assorted overlayfs fixes for v4.14-rc3
Date: Mon, 25 Sep 2017 17:06:20 +0300
Message-ID: <CAOQ4uxgS-61nCPo+qVU+MnesKamw_AFArrieEiyGLjjBBFNjXg@mail.gmail.com>
References: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34817 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932698AbdIYOG0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:06:26 -0400
Received: by mail-yw0-f195.google.com with SMTP id u134so3508265ywu.2
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2017 07:06:25 -0700 (PDT)
In-Reply-To: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Sep 25, 2017 at 12:36 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> Following are 1 fix for a commit in v4.14-rc1
> and 3 fixes for index error paths in v4.13.

Make that 4 fixes to v4.13..
Available at https://github.com/amir73il/linux/commits/ovl-fixes

>
> Amir.
>
> Amir Goldstein (5):
>   ovl: fix may_write_real() for overlayfs directories
>   ovl: fix error value printed in ovl_lookup_index()
>   ovl: fix dput() of ERR_PTR in ovl_cleanup_index()
>   ovl: fix dentry leak in ovl_indexdir_cleanup()

+   ovl: fix missing unlock_rename() in ovl_do_copy_up()

>
>  fs/namespace.c         | 4 +++-
>  fs/overlayfs/namei.c   | 1 +
>  fs/overlayfs/readdir.c | 6 ++++--
>  fs/overlayfs/util.c    | 9 ++++++---
>  4 files changed, 14 insertions(+), 6 deletions(-)
>
> --
> 2.7.4
>
