Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8314C001DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 15:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbjHOPNH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 11:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237831AbjHOPMo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 11:12:44 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999E11985
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 08:12:42 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99bc9e3cbf1so1146371966b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 08:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692112361; x=1692717161;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f7++LAfeKI4bpVPsp/4xuH4vUxvSt0QA270gljFQjHA=;
        b=PDzjDDJVGWOvnCQZ7Y8PLh4Of7SWWzaD72ud+0nd8MLZDw/mZWWxAxuobW/NgmFHp3
         g3U8HySAW+vQ1JHFbTrw5SpED8JpEZZOvoq+Lxh4q8/DqSk7wVqwF3WdKEIktNwJJJWZ
         uxPhOn0BaSPrMvVCXQFMTUH1zRlhH3oMaLpVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692112361; x=1692717161;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7++LAfeKI4bpVPsp/4xuH4vUxvSt0QA270gljFQjHA=;
        b=NyQw9IttpxRjzcv2rCjqwCLMhya8ztzV5C9h2VKsVzOGQKK49/QK8AZJtqk/7J4hif
         U9bXsYhS08xR2TV3n1Y3+L6oOQkwiiNy4RXB3UGrfx0zWl+wUXFjsaqH70yGX4FKAha0
         xnq+mkeqUXt1m42FlneytiYhk0auxoLa4u+5NRVLsCypLZ87XDyuo4FxSU7cLK9ZOODd
         U3pqBsEZmk5k609MJmttpTGiBrww5MahFMUKDIBdcH77xFEpC2NXERmzDRUs8psiLyPZ
         4mbviaDXmRRMKLU0irKfK9DY8hl/8WRLKIlhvCRtrKaqVvgCYrmfb5KtznjbT3V/0p3V
         7d7g==
X-Gm-Message-State: AOJu0YwiyurtmXNy9txIzBn6xZL9Gl3HEh0v2OdP4G3N7vtKHZGb+Nc5
        nCMPWpi+1fKkf7Yf0qRF+snlcwRnm7u5lxvoXS44+WEsJzLsrsac+BbuCg==
X-Google-Smtp-Source: AGHT+IGOnQusA5EIS1gt12OG2NXBSqzvzGu88aGwODJocEv6UeGU5fBVic3jGjbCdL0amNiqJxbKE7RuNaEgclyr8kU=
X-Received: by 2002:a17:906:3043:b0:989:450:e565 with SMTP id
 d3-20020a170906304300b009890450e565mr2158752ejd.23.1692112360855; Tue, 15 Aug
 2023 08:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-3-amir73il@gmail.com>
In-Reply-To: <20230814140518.763674-3-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 15 Aug 2023 17:12:29 +0200
Message-ID: <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: do not open/llseek lower file with upper
 sb_writers held
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 14 Aug 2023 at 16:05, Amir Goldstein <amir73il@gmail.com> wrote:
>
> overlayfs file open (ovl_maybe_lookup_lowerdata) and overlay file llseek
> take the ovl_inode_lock, without holding upper sb_writers.
>
> In case of nested lower overlay that uses same upper fs as this overlay,
> lockdep will warn about (possibly false positive) circular lock
> dependency when doing open/llseek of lower ovl file during copy up with
> our upper sb_writers held, because the locking ordering seems reverse to
> the locking order in ovl_copy_up_start():
>
> - lower ovl_inode_lock
> - upper sb_writers
>
> Take upper sb_writers only when we actually need it, so we won't hold it
> during lower file open and lower file llseek to avoid the lockdep warning.
>
> Minimizing the scope of ovl_want_write() during copy up is also needed
> for fixing other possible deadlocks by following patches.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 117 +++++++++++++++++++++++++++++++----------
>  1 file changed, 88 insertions(+), 29 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index c998dab440f8..f2a31ff790fb 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -251,8 +251,13 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
>         if (IS_ERR(old_file))
>                 return PTR_ERR(old_file);
>
> +       error = ovl_want_write(dentry);
> +       if (error)
> +               goto out_fput;

What occurs to me is why are we bothering with getting write access on
the internal upper mnt each time.  Seems to me it's a historical thing
without a good reason.  Upper mnt is never changed from R/W to R/O.

So the only thing we need to do is grab the upper mount write access
on superblock creation and do the sb_start_write/end_write() thing
which can't fail.  If upper mnt is read-only, we effectively have a
read-only filesystem, and can handle it that way (sb->s_flags |=
SB_RDONLY).

There's still the possibility that we do some changes to upper even
for non-modify operations.  But with careful review we can remove a
most (possibly all) error handling cases from ovl_want_write()
callsites when we do know that we have write access on upper.  And
WARN_ON(__mnt_is_readonly(ovl_upper_mnt(ofs))) should ensure that we
catch any mistakes.

Hmm?

Thanks,
Miklos
