Return-Path: <SRS0=mld1=7M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0524EC433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 11:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C36EA2073B
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 11:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0mV1Abx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgE3LBm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 30 May 2020 07:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3LBk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 May 2020 07:01:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB63C03E969
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 04:01:40 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 18so4956715iln.9
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 04:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mOb2ILxo0kNUO1wdLbFroPyy/0wn4wnDw/Jn6RtH+6s=;
        b=Y0mV1AbxveHifMq1aKxYEjz8SraBQa7RGFCgKUc0+VqpsL341t5x77dEHy1/LPR8Tp
         vZVTGFLEodRqUPL+fCtonHJXnOQjqL0e146UYrzcikdyH+uxx8r4oqEOIc45RtkyMTbl
         FGuMt1pkkdA82uB7v6cq3FydhtEqBi0ivENHk45PavD2sOtVfih8OVVdD2V6C3a4wwQ9
         ZEi5Qmj8f4evreV7PSpnVcukq79MZRKlLUlqQKHvkEVMX9V4kpG7oHuIEIb+5GsXTXMx
         vy18vDB1yHHqmUkq72z/XvGEKO3BU3WwK8s5IKsq8pQVexIRpy0ITcjidPfV/clefy/r
         JCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mOb2ILxo0kNUO1wdLbFroPyy/0wn4wnDw/Jn6RtH+6s=;
        b=L9C1SliLrCilZ2WP3+8WkQ4DkS25tdCHmKy9PywqMFH8oQ+QKqww1WuF5W9xkDuFU+
         Vyd9fwuibKvaXLGrmCcd1wUHB5Ge6+n4AdP9kA1V9I1Lq1naAV+k8tF5cc/zRBHddYFt
         gkRg9qox2mE0nbxq1//6u0nkVQ/+kJtkPTrHfkAjQsqe+uti+bNghlAMRbfChjYBxCQU
         3zC8TV5vJ6e8uUqV7TGgagPf+WPoSg7F9NGfWdN6NpndV3Qeyj4NtZ3ibN/904kCZwxa
         /1hlS+S744/wRYFbWmXhWn9DlcQ52T14/PDIBxrkSge9nHBwU1WQigenLAwsrFSaBKTl
         BKzA==
X-Gm-Message-State: AOAM533kLyrQMxCDhuZsYq0ec43dKHSU5ByrT4Jf6gEk9MhkKennRTLx
        uKh6g+pJlTvAmhmh/ItIOuVVq/2wJwfm/s3X/s1j98VT
X-Google-Smtp-Source: ABdhPJzkXwNs+jV9qUaTKzb74x9+y4pnPXrhvQHj+hjEMJVe7goIdwrDNM2tKHZOwwjuPLDsqF/jeovmPdUctx5sSXw=
X-Received: by 2002:a92:c9ce:: with SMTP id k14mr5274134ilq.250.1590836500013;
 Sat, 30 May 2020 04:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200529212952.214175-1-vgoyal@redhat.com> <20200529212952.214175-3-vgoyal@redhat.com>
In-Reply-To: <20200529212952.214175-3-vgoyal@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 30 May 2020 14:01:28 +0300
Message-ID: <CAOQ4uxi08jyGa_aPBLxWoF1649+6CzZ6iJtiz76cKUvWRnpVvA@mail.gmail.com>
Subject: Re: [PATCH 2/3] overlayfs: ovl_lookup(): Use only uppermetacopy state
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 30, 2020 at 12:30 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Currently we use a variable "metacopy" which signifies that dentry
> could be either uppermetacopy or lowermetacopy. Amir suggested that
> we can move code around and use d.metacopy in such a way that we
> don't need lowermetacopy and just can do away with uppermetacopy.
>
> So this patch replaces "metacopy" with "uppermetacopy".
>
> It also moves some code little higher to keep reading little simpler.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 57 ++++++++++++++++++++++----------------------
>  1 file changed, 28 insertions(+), 29 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 5d80d8cc0063..a1889a160708 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -823,7 +823,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct dentry *this;
>         unsigned int i;
>         int err;
> -       bool metacopy = false;
> +       bool uppermetacopy = false;
>         struct ovl_lookup_data d = {
>                 .sb = dentry->d_sb,
>                 .name = dentry->d_name,
> @@ -869,7 +869,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                                 goto out_put_upper;
>
>                         if (d.metacopy)
> -                               metacopy = true;
> +                               uppermetacopy = true;
>                 }
>
>                 if (d.redirect) {
> @@ -906,6 +906,22 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 if (!this)
>                         continue;
>
> +               if ((uppermetacopy || d.metacopy) && !ofs->config.metacopy) {
> +                       err = -EPERM;
> +                       pr_warn_ratelimited("refusing to follow metacopy origin"
> +                                           " for (%pd2)\n", dentry);
> +                       goto out_put;
> +               }
> +
> +               /*
> +                * Do not store intermediate metacopy dentries in chain,
> +                * except top most lower metacopy dentry
> +                */
> +               if (d.metacopy && ctr) {
> +                       dput(this);
> +                       continue;
> +               }
> +
>                 /*
>                  * If no origin fh is stored in upper of a merge dir, store fh
>                  * of lower dir and set upper parent "impure".
> @@ -940,17 +956,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         origin = this;
>                 }
>
> -               if (d.metacopy)
> -                       metacopy = true;
> -               /*
> -                * Do not store intermediate metacopy dentries in chain,
> -                * except top most lower metacopy dentry
> -                */
> -               if (d.metacopy && ctr) {
> -                       dput(this);
> -                       continue;
> -               }
> -
>                 stack[ctr].dentry = this;
>                 stack[ctr].layer = lower.layer;
>                 ctr++;
> @@ -982,23 +987,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 }
>         }
>
> -       if (metacopy) {
> -               /*
> -                * Found a metacopy dentry but did not find corresponding
> -                * data dentry
> -                */
> -               if (d.metacopy) {
> -                       err = -EIO;
> -                       goto out_put;
> -               }
> +       /* Found a metacopy dentry but did not find corresponding data dentry */
> +       if (d.metacopy) {

I suggested this change and I think it is correct, but it is correct for a bit
of a subtle reason.
It is correct because ovl_lookup_layer() (currently) cannot return NULL
and set d.metacopy to false.
So I suggest to be a bit more defensive and write this condition as:

       if (d.metacopy || (uppermetacopy && !ctr)) {

> +               err = -EIO;
> +               goto out_put;
> +       }
>
> -               err = -EPERM;
> -               if (!ofs->config.metacopy) {
> -                       pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",
> -                                           dentry);
> -                       goto out_put;
> -               }
> -       } else if (!d.is_dir && upperdentry && !ctr && origin_path) {
> +       /* For regular non-metacopy upper dentries, there is no lower
> +        * path based lookup, hence ctr will be zero. dentry found using
> +        * ORIGIN xattr on upper, install it in stack.
> +        */
> +       if (!d.is_dir && upperdentry && !ctr && origin_path) {

I don't like this comment style for multi line comment and I don't
like that you detached this if statement from else if.
I think it made more sense with the else because this is (as you write)
the non-metacopy case.

Thanks,
Amir.
