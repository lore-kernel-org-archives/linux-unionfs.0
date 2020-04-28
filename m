Return-Path: <SRS0=REe/=6M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FABC83000
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 13:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 859E6206A1
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 13:16:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mrKT7JIR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgD1NQE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgD1NQE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Apr 2020 09:16:04 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B1BC03C1A9
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 06:16:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s10so20152822iln.11
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 06:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5d3IzLwSFnExWd0gJjFP5lkM0osFLYh4TipRPRpn+oM=;
        b=mrKT7JIRWfNyXN7ULnbYEdH9sgndk8Xqqt51h7gDxUBoL6Rlfn139xm5hqnwFadYI4
         tZzmJ6Tpe8fgo/BqjgSp8GVJWwZKKN0KiwR61P9aMQM1eLXmdeXSQnUagpC4Y4XbWtqV
         LlJyzhjynSqemaOBMNt3rnwbRyqmj3Qhl+w8nJedSSLwk1WxoitoozirCaT3UveBEN49
         eFrHb01D6SHZOM5FKpLpoYgYv9pRqR9wb+yu9SnU45dLMiooD7uPnhmVSeAUjQ/Jm9oY
         XWAKKFLtByQX7694HLXKzcSkB7Iwxt+0VD1/vh24F90VBMwWwT4IldjOIP874ohZu97m
         1n0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5d3IzLwSFnExWd0gJjFP5lkM0osFLYh4TipRPRpn+oM=;
        b=D9riitr2uLApVNNevoSVKwF+edHrQzQFlczgnAk/Uuy8a2KW832eTG9ecS3PbQ1+8N
         4b/IjYXo9dpn5PuBjQ+qyYN0hazEc1EFPso0Z41lM6oJ48DBVDmEApluFSawba8zyz6i
         kU5UDF5G7RUE1cJGNXJBwULNaHXs66rqGeIfUOph5JOP6U9HaL6bsjez3+rwuFiB83vo
         QQ8BROD6HXFN63SX8zw/qoetwVvSSFn7q64UDpynbNjVsia8LjIlZpJAdie2PHleeS9w
         ozfuI9rKHq3togcx/GgtoUDn5VvPgK+umd9Lu3qWlLys0UDwSgJaqAh2wM0uzRBBHKF7
         yBUQ==
X-Gm-Message-State: AGi0PuYqWZEdwUp4wgynpfB2LpBP4s0UG1OirUzkk07zwGsK7M+Ey7nA
        UQnqguXREHqVkI3mE0YeO/dK15jNlsVfJp/s4Xuygv7N
X-Google-Smtp-Source: APiQypIpFNMC7lvebadIKhXYonE4EvHW8AgLbEu5yU3LMMd3tupAieNO1gzU44WoLuipnOLa0UrJC3RzY+QqmqNdLDA=
X-Received: by 2002:a92:b69b:: with SMTP id m27mr25825018ill.250.1588079763120;
 Tue, 28 Apr 2020 06:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200422102740.6670-1-cgxu519@mykernel.net> <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
 <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
 <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com>
 <171aadd9966.100e576ad1248.8616898883060201949@mykernel.net>
 <CAOQ4uxi_zp45KrjnR4FJx56gsDPsoim4U0H7hj1ta4+gXAwQtQ@mail.gmail.com> <20200428122104.GA13131@miu.piliscsaba.redhat.com>
In-Reply-To: <20200428122104.GA13131@miu.piliscsaba.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 28 Apr 2020 16:15:51 +0300
Message-ID: <CAOQ4uxh4ZVqOHtiytk4fHB5otNd8VRM-Z_8ZYpW1qMjzAsmkZw@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 28, 2020 at 3:21 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Apr 24, 2020 at 05:49:00PM +0300, Amir Goldstein wrote:
>
> > I didn't mean we need to check if link_max  is valid range for upper fs.
> > We anyway use minimum of user requested value and upper fs max.
> >
> > Frankly, I think there are only two sane options for system wide configuration:
> > 1. disable whiteout link
> > 2. enable whiteout link with ofs->workdir->d_sb->s_max_links
>
> And that one doesn't work, see for example ext4, which defines EXT4_LINK_MAX but
> doesn't set s_max_links.  This could be fixed, but using EMLINK to detect the
> max-link condition is simpler and more reliable.
>
> And I don't really see a reason to disable whiteout hard links.  What scenario
> would that be useful in?

I have a vague memory of e2fsck excessive memory consumption
in face of many hardlinks created by rsync backups.
Now I suppose it was a function of number of files with nlink > 1 and not
a function of nlink itself and could be a non issue for a long time, but I am
just being careful about introducing non-standard setups which may end up
exposing filesystem corner case bugs (near the edge of s_max_links).
Yeh that is very defensive, so I don't mind ignoring that concern and addressing
it in case somebody shouts.

>
> Updated patch below.  Changes from v5:
>
>  - fix a missing dput on shutdown
>  - don't poass workdir to ovl_cleanup_and_whiteout/ovl_whiteout
>  - flatten out retry loop in ovl_whiteout
>  - use EMLINK to distinguish max-links from misc failure
>
> Thanks,
> Miklos
>
> ---
> From: Chengguang Xu <cgxu519@mykernel.net>
> Subject: ovl: whiteout inode sharing
> Date: Fri, 24 Apr 2020 10:55:17 +0800
>
> Share inode with different whiteout files for saving inode and speeding up
> delete operation.
>
> If EMLINK is encountered when linking a shared whiteout, create a new one.
> In case of any other error, disable sharing for this super block.
>
> Note: ofs->whiteout is protected by inode lock on workdir.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/dir.c       |   49 +++++++++++++++++++++++++++++++++++------------
>  fs/overlayfs/overlayfs.h |    2 -
>  fs/overlayfs/ovl_entry.h |    3 ++
>  fs/overlayfs/readdir.c   |    2 -
>  fs/overlayfs/super.c     |    4 +++
>  fs/overlayfs/util.c      |    3 +-
>  6 files changed, 48 insertions(+), 15 deletions(-)
>
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -62,35 +62,59 @@ struct dentry *ovl_lookup_temp(struct de
>  }
>
>  /* caller holds i_mutex on workdir */
> -static struct dentry *ovl_whiteout(struct dentry *workdir)
> +static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>  {
>         int err;
>         struct dentry *whiteout;
> +       struct dentry *workdir = ofs->workdir;
>         struct inode *wdir = workdir->d_inode;
>
> -       whiteout = ovl_lookup_temp(workdir);
> -       if (IS_ERR(whiteout))
> -               return whiteout;
> +       if (!ofs->whiteout) {
> +               whiteout = ovl_lookup_temp(workdir);
> +               if (IS_ERR(whiteout))
> +                       return whiteout;
> +
> +               err = ovl_do_whiteout(wdir, whiteout);
> +               if (err) {
> +                       dput(whiteout);
> +                       return ERR_PTR(err);
> +               }
> +               ofs->whiteout = whiteout;
> +       }
>
> -       err = ovl_do_whiteout(wdir, whiteout);
> -       if (err) {
> +       if (ofs->share_whiteout) {
> +               whiteout = ovl_lookup_temp(workdir);
> +               if (IS_ERR(whiteout))
> +                       goto fallback;
> +
> +               err = ovl_do_link(ofs->whiteout, wdir, whiteout);
> +               if (!err)
> +                       goto success;
> +
> +               if (err != -EMLINK) {
> +                       pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%i)\n",
> +                               ofs->whiteout->d_inode->i_nlink, err);
> +                       ofs->share_whiteout = false;
> +               }
>                 dput(whiteout);
> -               whiteout = ERR_PTR(err);
>         }
> -
> +fallback:
> +       whiteout = ofs->whiteout;
> +       ofs->whiteout = NULL;
> +success:

This label is a bit strange, but fine.

>         return whiteout;
>  }
>

Thanks,
Amir.
