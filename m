Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5DBC47087
	for <linux-unionfs@archiver.kernel.org>; Fri, 28 May 2021 11:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 852406124B
	for <linux-unionfs@archiver.kernel.org>; Fri, 28 May 2021 11:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhE1Lka (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 28 May 2021 07:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhE1Lka (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 May 2021 07:40:30 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9750C061574
        for <linux-unionfs@vger.kernel.org>; Fri, 28 May 2021 04:38:55 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id c2so2985867ilo.11
        for <linux-unionfs@vger.kernel.org>; Fri, 28 May 2021 04:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73u+gEcQVWBNcnw3JP/jLhskDlHu0G/2GLwYShMgyk8=;
        b=dBAM29QHbpGd4al1M4FBA+D4VIlAmqUgNMoPEdVIFIhQAqxshRW/kE1xVaoFRoL2MA
         JbKatKVHt1WgBhQMu4FIc21QV9sW96n6LXCOMIbQ04NqapHBmlVb8kxsWAHRP3iSKkqR
         k6s+s8J3DkJ0xOtCFbD3pX2WKPFBcEaZBUB/bFRdmmgyMUkHMqj94FSU6PglEXEzn+Nd
         ouG6LIZz9zOOqygyFAb4JH4oEEht4cue5XX/u9PS54GZ+oDu6ydqn1upIMyelnivCM4W
         myX2UGuShJC7NjqgajrULD0wTIsdyiZXDVlQmPJXafKE0LYrEYqKH+r3/enqzpk4zGN2
         MWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73u+gEcQVWBNcnw3JP/jLhskDlHu0G/2GLwYShMgyk8=;
        b=OuQD2yfXSPXLU9Tu/5Ksq0e1pgswFO2AHOB7P3MKGENMeOqNiSywf9xL84ILT3tjUM
         +efwUBOG33tV3zV4N+hLMrHTjzv3QSAas6qn6KDU02k3WxNpxoN+cceuPEkGgZJzJpc6
         wR2AaeJGlKoV3cZQ0ltPCgNp/fnWZuvXiHJdL+lIX09AcgfVhMJ1Fjr362tib4tkSP7I
         2FXhfpKFD8M2yTiZ6GH64j39A1IjJg1JxlNpOOdi4pJ91p0LCzOBhtZFaA9C3o3YLfYK
         L50KUv5MT0lAJjXZBbv/kcaWP8kO8pUeE49/Fml5dd9CO20moOc+hYhFw2rFQviwGh4+
         fzeQ==
X-Gm-Message-State: AOAM5336tezM6JvZEfZ/50nR62cHMMJ5ZNaaXWMh2XpQZaoVJHDWfUZh
        j6xKFOvbEWtLGgacKs2UmTfgKZ8zT5YbbUC40tk=
X-Google-Smtp-Source: ABdhPJwwhaJydgl8v+syY8Kzs9K/V7cutetLUKd/3YqYOQ5/8hnP8OVk5js+8/C1rRshI+y82J9U9MDyAKNg3GFtk+g=
X-Received: by 2002:a92:cc43:: with SMTP id t3mr7157470ilq.250.1622201935094;
 Fri, 28 May 2021 04:38:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210527174547.109269-1-uvv.mail@gmail.com> <20210527174547.109269-3-uvv.mail@gmail.com>
In-Reply-To: <20210527174547.109269-3-uvv.mail@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 28 May 2021 14:38:44 +0300
Message-ID: <CAOQ4uxh7eSy6xAr9HdtZ=trcpUs8O5exXWJ8uqo2bacfMZXz3Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ovl: do not set overlay.opaque for new directories
To:     Vyacheslav Yurkov <uvv.mail@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 27, 2021 at 8:46 PM Vyacheslav Yurkov <uvv.mail@gmail.com> wrote:
>
> From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
>
> Enable optimizations only if user opted-in for any of extended features.
> If optimization is enabled, it breaks existing use case when a lower layer
> directory appears after directory was created on a merged layer. If
> overlay.opaque is applied, new files on lower layer are not visible.
>
> Consider the following scenario:
> - /lower and /upper are mounted to /merged
> - directory /merged/new-dir is created with a file test1
> - overlay is unmounted
> - directory /lower/new-dir is created with a file test2
> - overlay is mounted again
>
> If opaque is applied by default, file test2 is not going to be visible
> without explicitly clearing the overlay.opaque attribute
>
> Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
> ---

Vyacheslav,

The series looks good.
In case you post another version please add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

No need to repost just for that.

Did you happen to run xfstests on these patches?

If I am not mistaken, tests overlay/068 and overlay/069 provide
test coverage to the check in ovl_lower_uuid_ok() for the case
of lower null uuid (lower overlayfs) and user opt-in to new features
(nfs_export), so tests would have caught the bug you had in v2.

Please verify that I am not wrong (about test catching v2 bug) and
that v3 passes at least:
./check -overlay -g overlay/quick -g overlay/union

Please see README.overlay in xfstests for setting up to run
./check -overlay and the unionmount tests.

Thanks,
Amir.


>  fs/overlayfs/dir.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 93efe7048a77..03a22954fe61 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -320,6 +320,7 @@ static bool ovl_type_origin(struct dentry *dentry)
>  static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>                             struct ovl_cattr *attr)
>  {
> +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
>         struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
>         struct inode *udir = upperdir->d_inode;
>         struct dentry *newdentry;
> @@ -338,7 +339,8 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>         if (IS_ERR(newdentry))
>                 goto out_unlock;
>
> -       if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
> +       if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry) &&
> +           !ovl_allow_offline_changes(ofs)) {
>                 /* Setting opaque here is just an optimization, allow to fail */
>                 ovl_set_opaque(dentry, newdentry);
>         }
> --
> 2.25.1
>
