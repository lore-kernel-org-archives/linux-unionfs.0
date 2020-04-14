Return-Path: <SRS0=sqyI=56=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1B1C2BA19
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 13:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 228D820578
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 13:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NN4I8b+E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgDNNpB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 09:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388081AbgDNNow (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Apr 2020 09:44:52 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE10CC061A0C
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Apr 2020 06:44:51 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f2so672280ilq.7
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Apr 2020 06:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PgVmcWwtrT/96D86+ZTOvH+AWfuOPwEQe4UafBRJ2u0=;
        b=NN4I8b+EispxH1r2RSVgY0zOE79o+GZfsPb2Q8bBfPDuaTNmPwsgAdh/HVWYDjI3T5
         lsA2NXS+sG+9ib7nP3AGxD/7HyJ/FUhc0AEQ+TWylgSAZxtfVfLqZs5QypZr7l4dvWXW
         yrzYv1BKtkaX0OjamagdoI32k5PV5RPYv+HeCoyrGvRht3cGb41w2Yi3MikKNqKhNwPH
         JG0yMFVqjoyrbDfbXgt6S4hy/pOXtLRctZoktoAzgywYPAiPb77BLmnaju6ob5f4wb92
         BWjJ+PIrm+sLxsS7SoGqbwxVxmXjMqxeLj2AYdFUYR5yW1vfwWq+OZ++oNMgBQOwijbK
         yWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PgVmcWwtrT/96D86+ZTOvH+AWfuOPwEQe4UafBRJ2u0=;
        b=PmIe4QFy64vChMgt9mNw3ND67BatZZF6L0YOD/1XoMjotNnJeURws/GR1D5VhPrZ/u
         286l3AZEpDIweg5wL+80izH6mpfh8V6kRglgospBwL3jbkYmJP4joqiSMVjIkfLMiLlR
         eWR3PwRNxpSYiGgqjsaPtxhIXxbzFtm/WMzm7tul4PdRP/QPcStRA0XYHPBG3rxJ5sp2
         4nki4KONr6IAK4uR9RlyHEoEH1g4RL+RqoM/4VysTin5pEA3Fvtb/qUNTcp/sanV1A3G
         3AKnbjp36Yg+v1jYGS4/XmZaO+otEfhbsN+fwtJiWjTZNPs14T1fa41QIHyAJA9PQsu/
         ga3Q==
X-Gm-Message-State: AGi0PuZa+LDOndgVog+3rSUo4vrZs5yJ6sGji8FpRkz1r2sLKKB9j94N
        wzUYG9Yi08+q4X1no+hka5MVUvw4rfsQX59otYj8l9z0
X-Google-Smtp-Source: APiQypLM2x1y19W7iqIbvWB+OyNIUHgN54OpyMrGuZmtl8cOI/oij2Bcv8wadOqIrG+gLMX6TXIGi8M4GA54YpiGlt8=
X-Received: by 2002:a92:cc02:: with SMTP id s2mr280780ilp.9.1586871891258;
 Tue, 14 Apr 2020 06:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200414095310.31491-1-cgxu519@mykernel.net>
In-Reply-To: <20200414095310.31491-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Apr 2020 16:44:39 +0300
Message-ID: <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Sharing inode with different whiteout files for saving
> inode and speeding up deleting operation.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> v1->v2:
> - Address Amir's comments in v1
>
> v2->v3:
> - Address Amir's comments in v2
> - Rebase on Amir's "Overlayfs use index dir as work dir" patch set
> - Keep at most one whiteout tmpfile in work dir
>
>  fs/overlayfs/dir.c       | 35 ++++++++++++++++++++++++++++-------
>  fs/overlayfs/overlayfs.h |  9 +++++++--
>  fs/overlayfs/ovl_entry.h |  4 ++++
>  fs/overlayfs/readdir.c   |  3 ++-
>  fs/overlayfs/super.c     |  9 +++++++++
>  fs/overlayfs/util.c      |  3 ++-
>  6 files changed, 52 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 279009dee366..dbe5e54dcb16 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
>  }
>
>  /* caller holds i_mutex on workdir */
> -static struct dentry *ovl_whiteout(struct dentry *workdir)
> +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *workdir)
>  {
>         int err;
> +       bool retried = false;
> +       bool should_link = (ofs->whiteout_link_max > 1);
>         struct dentry *whiteout;
>         struct inode *wdir = workdir->d_inode;
>
> +retry:
>         whiteout = ovl_lookup_temp(workdir);
>         if (IS_ERR(whiteout))
>                 return whiteout;
>
> +       if (should_link && ofs->whiteout) {

What happens with ofs->whiteout_link_max == 2 is that half of the
times, whiteout gets linked and then unlinked.
That is not needed.
I think code would look better like this:

          if (ovl_whiteout_linkable(ofs)) {
                  err = ovl_do_link(ofs->whiteout, wdir, whiteout);
...
          } else if (ofs->whiteout) {
                  ovl_cleanup(wdir, ofs->whiteout);
....

With:

static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
{
       return ofs->whiteout &&
                 ofs->whiteout->d_inode->i_nlink < ofs->whiteout_link_max;
}

> +               err = ovl_do_link(ofs->whiteout, wdir, whiteout);
> +               if (err || !ovl_whiteout_linkable(ofs)) {
> +                       ovl_cleanup(wdir, ofs->whiteout);
> +                       dput(ofs->whiteout);
> +                       ofs->whiteout = NULL;
> +               }
> +
> +               if (!err)
> +                       return whiteout;
> +       }
> +
...
> @@ -1762,6 +1767,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>                 if (!ofs->workdir)
>                         sb->s_flags |= SB_RDONLY;
> +               else
> +                       ofs->whiteout_link_max = min_not_zero(
> +                                       ofs->workdir->d_sb->s_max_links,
> +                                       ovl_whiteout_link_max_def ?: 1);
>

Please leave that code inside ovl_get_workdir() or ovl_make_workdir().

Thanks,
Amir.
