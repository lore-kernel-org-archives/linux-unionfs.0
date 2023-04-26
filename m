Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DFBC7618E
	for <linux-unionfs@archiver.kernel.org>; Wed, 26 Apr 2023 14:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbjDZO5I (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjDZO5H (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2023 10:57:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC93D8
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 07:57:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-94f32588c13so1065091066b.2
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 07:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1682521024; x=1685113024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=haQMILol60uW5xewbEuWvSfguNqJ9w2s4P5feZO7RKc=;
        b=Nd0p8H8SIjBXz+q5lL8xVSUPIiGCKg0DuQ0NX/upLHrswjtS9jBUJ8xp4bMb6zLMYX
         uisBejeYblnEk+KQZhklRNLUTlE2S63IjJRj5YdEtvM3UYrQ/aM/r15XNxxkzNXLb/wI
         qqkd7wiZpOFOaerdtpmcdv5EWhzOHJPBw3OI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682521024; x=1685113024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=haQMILol60uW5xewbEuWvSfguNqJ9w2s4P5feZO7RKc=;
        b=QIxGsVbyQmaO7uby83HAgDP4BpKV5Qj0pzw1ABsh3yQoAPVPY/zv/wsPqy0fJx/9Ku
         VyTFtFexDOQOhYJDemAqsQl7BhhXQETU30nFOHy5tbG28ASZSznoqIoM1UDU4BVlcYcn
         ilVSD4mUcJv7xtk6y7KzIAYXNydgnVazwJVIEwXdANSEeNQyn2VD6TtZwXn4AxPR74fR
         /MGyhm6Yypd5dp2sAVHag/0/E6IwZJjKWQp3dohK2otJRjcNd+plXX4jjCfhPalMqT47
         5xRF6gGswgNLh0XUGMO00WmlrlHybL26XAlSTScxTNzRK/wmHh8aPUX1wwO4mfkI4utF
         Udvg==
X-Gm-Message-State: AAQBX9cmyCHD7OBQ3GNmLdq2qturtEKcTaIP3McqlWjOPqmNyCB3rkP7
        o5D1JAiXdYBuEGG84cdS4bp6egVmrpZ78gwYOvE+3rpyEOeJ3KaBUAA=
X-Google-Smtp-Source: AKy350YTmhe3yWRwG9CLUZgCoX9D889WqZri97n7twDREFVAZvLvJkylb9CZhF1S5s8szcN9vDouu+DiVWIVJC4ZezY=
X-Received: by 2002:a17:907:98f6:b0:94f:6ca2:e34 with SMTP id
 ke22-20020a17090798f600b0094f6ca20e34mr17865463ejc.66.1682521024237; Wed, 26
 Apr 2023 07:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-5-amir73il@gmail.com>
In-Reply-To: <20230412135412.1684197-5-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 26 Apr 2023 16:56:52 +0200
Message-ID: <CAJfpegtx2DixU+TNRa5LA8Dv=mvi_w=Oh5k3USLmip3LmGtX2g@mail.gmail.com>
Subject: Re: [PATCH 4/5] ovl: prepare for lazy lookup of lowerdata inode
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 12 Apr 2023 at 15:54, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Make the code handle the case of numlower > 1 and missing lowerdata
> dentry gracefully.
>
> Missing lowerdata dentry is an indication for lazy lookup of lowerdata
> and in that case the lowerdata_redirect path is stored in ovl_inode.
>
> Following commits will defer lookup and perform the lazy lookup on
> acccess.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/export.c |  2 +-
>  fs/overlayfs/file.c   |  7 +++++++
>  fs/overlayfs/inode.c  | 18 ++++++++++++++----
>  fs/overlayfs/super.c  |  3 +++
>  fs/overlayfs/util.c   |  2 +-
>  5 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 9951c504fb8d..2498fa8311e3 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -343,7 +343,7 @@ static struct dentry *ovl_dentry_real_at(struct dentry *dentry, int idx)
>         if (!idx)
>                 return ovl_dentry_upper(dentry);
>
> -       for (i = 0; i < ovl_numlower(oe); i++) {
> +       for (i = 0; i < ovl_numlower(oe) && lowerstack[i].layer; i++) {

Metacopy and NFS export are mutually exclusive, so this doesn't make sense.


> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 3484f39a8f27..ef78abc21998 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c

ovl_d_real() calls ovl_dentry_lowerdata().  If triggered from
file_dentry() it should be okay, since that is done on an open file
(lazy lookup already perfromed).   But it can also be called from
d_real_inode(), the only caller of which is trace_uprobe.  Is this
going to be okay?

In any case a comment is needed at least.

Thanks,
Miklos
