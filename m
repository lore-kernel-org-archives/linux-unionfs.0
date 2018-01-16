From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 10/17] ovl: decode lower file handles of unlinked but
 open files
Date: Tue, 16 Jan 2018 10:16:24 +0100
Message-ID: <CAJfpegvbACMv5p3Qb2RhT7dqEucxQmZrJPMiPwp3cbGWKt4h1A@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com> <1515086449-26563-11-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33259 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbeAPJQZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Jan 2018 04:16:25 -0500
Received: by mail-qt0-f194.google.com with SMTP id e2so17387566qti.0
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Jan 2018 01:16:25 -0800 (PST)
In-Reply-To: <1515086449-26563-11-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Lookup overlay inode in cache by origin inode, so we can decode a file
> handle of an open file even if the index has a whiteout index entry to
> mark this overlay inode was unlinked.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/export.c    | 22 ++++++++++++++++++++--
>  fs/overlayfs/inode.c     | 16 ++++++++++++++++
>  fs/overlayfs/overlayfs.h |  1 +
>  3 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 602bada474ba..6ecb54d4b52c 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -385,13 +385,21 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>         struct ovl_path *stack = &origin;
>         struct dentry *dentry = NULL;
>         struct dentry *index = NULL;
> +       struct inode *inode = NULL;
> +       bool is_deleted = false;
>         int err;
>
>         /* First lookup indexed upper by fh */

Why not first look up origin, then look up ovl inode by origin?  It
seems a faster path than going through the index first.  Obviously if
icache lookup fails then we need to look up index, but the common case
will the cached one, so that should be the fast one, no?

Thanks,
Miklos
