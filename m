Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8EDC2B9F8
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 May 2021 08:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEACC61401
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 May 2021 08:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhEYIdV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 25 May 2021 04:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhEYIdU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 May 2021 04:33:20 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D083C061574
        for <linux-unionfs@vger.kernel.org>; Tue, 25 May 2021 01:31:50 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id o21so30662954iow.13
        for <linux-unionfs@vger.kernel.org>; Tue, 25 May 2021 01:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+0haGgG0V5YdkmN7qkWsC+lwCid6DrFtGyepTh9r2RY=;
        b=k+gkSYUoy167fRGDTOpQzyGUNsoo5NRd89SqrELvi/9cHN/tq2tWz3klPQ+BCd5eoY
         oVdwkUjZxqXcIIG+DzZkWkTws4ZX/IVVrhnupcuYhx+z89qpvGCW8vmkv0wd48xvok4p
         ES64unNyn4bwI44iSvfO40VLNmGdyChrUPJdjssz2ZvSFcA9IbymsyYpp40gljYNpK06
         A9wJM2JOBbCotjQtf+mw49W84qco8brmEdtZtcbLcodh/CAqXmQ7oz1GNSPIEFUg7i/N
         H4zbmBYBKJ9k9PHhp79a5iR2Hs7ieRygq+4V+XNrAXZEZDCIBtsndeY0y/+vYmEo/d8h
         +LUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+0haGgG0V5YdkmN7qkWsC+lwCid6DrFtGyepTh9r2RY=;
        b=MR2J4UBz89KDP3iqLmhwtv+TXatl6SHGh3cULB/cx2buVKyHvLcyd0ygL152tLaKQb
         6pitGYNmQ8qQJ6chD8idnFgWNJ6G4WVIUcl0OH0GbjV8WRxBp9ynEyZFTYQ5kt5RKwt+
         83Fo0XrkbItckuJ+FH/SkOxO91JzFzFZZIbvlMNvdRyuUqva/eB+UCg9AVB/wxLDG/PO
         zwDRqmCcaNSpKkYxTe6/4apA5oJvBqhMQohIBLS8SfGtmGumCApX4wZgYE5w98YXhlmE
         ojwK+k6/SGVvmRmYCRrtw56Rshqasr/+pCnar8dWi/VPO1kl86NvzK9sjiAxq56gHUA1
         kH1g==
X-Gm-Message-State: AOAM533Zpau5NhCJbCKAPD/cSHvWhft9wVeOEBxigEyGMrhemyLBatiW
        5413YIOYpSldwDFB8lr+Sy1yRJdG/Hgj3UWkP2ugWH80dGo=
X-Google-Smtp-Source: ABdhPJz2mZnm/41187qdN/h3LZGome5bjBedtGDuQn5piA2y2NDddrjtauOTvKh+dZ0MJ/Nwqcgpl3krT/+/qgwqinw=
X-Received: by 2002:a02:6d6c:: with SMTP id e44mr29175086jaf.81.1621931509478;
 Tue, 25 May 2021 01:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210503184258.96714-1-Vyacheslav.Yurkov@bruker.com>
In-Reply-To: <20210503184258.96714-1-Vyacheslav.Yurkov@bruker.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 May 2021 11:31:38 +0300
Message-ID: <CAOQ4uximN3=VQ=CYryGrrkdXn0GpXe=skrrRma07MMRvz_gByw@mail.gmail.com>
Subject: Re: [PATCH] ovl: do not set overlay.opaque for new directories
To:     Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, May 3, 2021 at 9:43 PM Vyacheslav Yurkov
<Vyacheslav.Yurkov@bruker.com> wrote:
>
> This optimization breaks existing use case when a lower layer directory
> appears after directory was created on a merged layer. If overlay.opaque
> is applied, new files on lower layer are not visible.
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

Hi Vyacheslav,

Sorry for the late reply.
Is the described regression really happening in real deployments?
I would like to avoid removing the optimization if possible.

In any case, if we have to support existing deployments that use this practice,
the optimization should be removed only for the case where the user did not
opt-in to any of the new features, quoting overlayfs.rst:
'
  Offline changes to the lower tree are only allowed if the
  "metadata only copy up", "inode index", "xino" and "redirect_dir" features
  have not been used. If the lower tree is modified and any of these
  features has been used, the behavior of the overlay is undefined,
  though it will not result in a crash or deadlock.
'

This means putting this check from ovl_lower_uuid_ok() into a helper:

static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
{
        /*
         * To avoid regressions in existing setups with overlay lower offline
         * changes, we allow lower changes only if none of the new features
         * are used.
         */
        return (!ofs->config.index && !ofs->config.metacopy &&
                    !ofs>config.redirect_dir && ofs->config.xino !=
OVL_XINO_ON);
}

Note that ovl_lower_uuid_ok() does not currently check the redirect_dir
feature, but it would be better to use the same helper in that case as well.

Thanks,
Amir.

> ---
>  fs/overlayfs/dir.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 93efe7048a77..f66f96dd9f0c 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -338,11 +338,6 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>         if (IS_ERR(newdentry))
>                 goto out_unlock;
>
> -       if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
> -               /* Setting opaque here is just an optimization, allow to fail */
> -               ovl_set_opaque(dentry, newdentry);
> -       }
> -
>         err = ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
>         if (err)
>                 goto out_cleanup;
> --
> 2.25.1
>
