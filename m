Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585C2C47247
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 02:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B468206D7
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 02:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JiIxCZ2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEEC6s (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 May 2020 22:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726516AbgEEC6s (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 May 2020 22:58:48 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4030DC061A0F
        for <linux-unionfs@vger.kernel.org>; Mon,  4 May 2020 19:58:48 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i16so881141ils.12
        for <linux-unionfs@vger.kernel.org>; Mon, 04 May 2020 19:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y8+aV/kfwwGcdB+vO5gE40hyiDeqpcdC6GMWcZlU8G0=;
        b=JiIxCZ2glfMFepy/70Z8uBSjlRo4klsdxn/1VTzxxWOJJKSbSQtZ1++CdHPZ99j0pO
         jG4vG9nq3G3dECXSZC2Z6DyzsHoKQoDFp/p/dv86AKRz8F2N4u+iUa8KOIrvQI8LbIYQ
         FrZ/B2Vo0RJWnTsBIthu5tmqd++9XpQqeNaFhdyhj/45CgrDkQ2UUaCsCbsUN32lxdoD
         9keY8uyKcQL4hyZ7AIdRIL5GHpUal/I0bwzqmnQW3DU5s07C9d8OXOxEYeIWj9RuhjOy
         du2CV+QvrPxU7qexLNriN/pyPHz+Ky0Cx9rtbUXxWwnmvTnduMJAC5QSAHt/hL43NK9e
         zVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y8+aV/kfwwGcdB+vO5gE40hyiDeqpcdC6GMWcZlU8G0=;
        b=V0xMt1cuYRTee5gsEppIEE4CbP0aYfSQrJsoR1+5ZJbPLjtEVjZP7i2nY7XEusV9eD
         XFqqfBLQGAf2eGFdMzU6ohIW2LqR+wQ9uGV9P6ynFrdt1fQUfL8807M5cmOowPjjd6lL
         zedO/yzW4X4ucTYd8cQpLo5zmSqwzF4HcAj27o6gvDnmMbeCUsjtsh2sukNubMUNJryY
         C0JyQFOl/mrAYPILZ+Z8Yi8p9aW+rz7E73GpVaR1oI0Bl/ABZ+pFV8SjpmksSFgbwYVy
         pZJHP51u4qMbF9OzWzKSj2BwbXF2P8mClqyvxH1PEhFvrGXWjLHZhpmfNHwHYADB/rqw
         /DZw==
X-Gm-Message-State: AGi0PubyGjApoq7P3Sfzb4fVQAk4a1suggLDetGbAlDNqDOi+1uMyvEJ
        jIUnuV1mhzDdUrZBJUL1nRjWtNkV6H+ctuQeoveZcpL6
X-Google-Smtp-Source: APiQypI+bEsjBFO/enfIo07cxO+ZvhalPtfkdrIeFGGPyuK9uSFZp4Hd2ONfieiSApnhE12bsbaJJ4Xae5nZMX/9jHY=
X-Received: by 2002:a92:9e11:: with SMTP id q17mr1581371ili.137.1588647527487;
 Mon, 04 May 2020 19:58:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200504193508.10519-1-lubos@dolezel.info>
In-Reply-To: <20200504193508.10519-1-lubos@dolezel.info>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 5 May 2020 05:58:35 +0300
Message-ID: <CAOQ4uxhEu+vLrvpnqdCdT+vaLAnaNXBBiQ9fPmN39zC4_UzLSg@mail.gmail.com>
Subject: Re: [PATCH] overlay: return required buffer size for file handles
To:     Lubos Dolezel <lubos@dolezel.info>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, May 4, 2020 at 10:50 PM Lubos Dolezel <lubos@dolezel.info> wrote:
>
> Hello,
>
> overlayfs doesn't work well with the fanotify mechanism.
>
> Fanotify first probes for the required buffer size for the file handle,
> but overlayfs currently bails out without passing the size back.
>
> That results in errors in the kernel log, such as:
>
> [527944.485384] overlayfs: failed to encode file handle (/, err=-75, buflen=0, len=29, type=1)
> [527944.485386] fanotify: failed to encode fid (fsid=ae521e68.a434d95f, type=255, bytes=0, err=-2)
>
> Lubos

Hi Lubos,

Thank you for the fix.
Please leave greeting (Hello) and this line outside of the commit message.
You may add extra notes for email after --- line

>
> Signed-off-by: Lubos Dolezel <lubos@dolezel.info>

After fixing below you may add for v2:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/export.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 475c61f53..0068bf3a0 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -231,12 +231,9 @@ static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
>         if (IS_ERR(fh))
>                 return PTR_ERR(fh);
>
> -       err = -EOVERFLOW;
>         len = OVL_FH_LEN(fh);
> -       if (len > buflen)
> -               goto fail;

in pr_warn_ratelimited() under fail label, all printed values after 'err' are
now irrelevant for the warning. please remove them.

> -
> -       memcpy(fid, fh, len);
> +       if (buflen >= len)
> +               memcpy(fid, fh, len);
>         err = len;
>
>  out:
> @@ -255,6 +252,7 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
>  {
>         struct dentry *dentry;
>         int bytes = *max_len << 2;
> +       int bytes_used;

Please use these variable names instead to make code clearer:

         int bytes, buflen = *max_len << 2;

BTW, do you plan to backport this patch to stable kernel 5.4?
Because this patch will not apply cleanly, but we should fix this in stable.

Thanks,
Amir.
