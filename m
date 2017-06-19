From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 21/23] ovl: link up indexed lower hardlink on lookup
Date: Mon, 19 Jun 2017 13:22:34 +0300
Message-ID: <CAOQ4uxjLAW8iMvinMag=7VOPP_AvKehOJScnYL84fmLBh2mMFQ@mail.gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com> <1497425202-16270-22-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:32784 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753868AbdFSKWk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 06:22:40 -0400
Received: by mail-ot0-f194.google.com with SMTP id q16so7805186otb.0
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 03:22:40 -0700 (PDT)
In-Reply-To: <1497425202-16270-22-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jun 14, 2017 at 10:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> With inodes index feature, all lower and upper hardlinks point to
> the same overlay inode. However, when a lower hardlink is accessed
> for read operation, the real inode operated on is not the same inode
> as the real inode for read operation on an upper hardlink.
>
> When lookup finds a lower hardlink, which is already indexed by
> an earlier upper hardlink copy up, call ovl_copy_up() to link the
> indexed upper on top of the lower hardlink and then operate on the
> upper real inode to avoid this inconsistency.
>
> Invalidate a lower indexed dentry on dcache lookup, so ovl_lookup()
> is called to perform the index link up.
>
> The following test demonstrates the upper/lower hardlinks inconsistency:
>
> $ echo -n a > /lower/foo
> $ ln /lower/foo /lower/bar
> $ cd /mnt
> $ echo -n b >> foo
> $ tail foo bar # foo is indexed upper, bar is indexed lower
> ==> foo <==
> ab
> ==> bar <==
> a
>
> $ echo -n c >> bar
> $ tail foo bar # both aliases are indexed upper
> ==> foo <==
> abc
> ==> bar <==
> abc
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/namei.c | 11 ++++++++++-
>  fs/overlayfs/super.c | 32 +++++++++++++++++++++++++++-----
>  2 files changed, 37 insertions(+), 6 deletions(-)
>

> +
> +static const struct dentry_operations ovl_dentry_operations = {
> +       .d_release = ovl_dentry_release,
> +       .d_real = ovl_d_real,
> +       .d_revalidate = ovl_dentry_indexed_revalidate,
> +};
> +
>  static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
>  {

ovl_dentry_indexed_revalidate() should also be checked within this variant.
Will fix for next posting.
