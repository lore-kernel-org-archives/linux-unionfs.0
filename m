Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE903C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 11:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245752AbiC3LEu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 07:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245754AbiC3LEs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 07:04:48 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781A626A970
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 04:03:03 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id d142so16300284qkc.4
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 04:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TsgNuFo2eIWDrWBc9oEi/VhcSMA4cvpTVu4LDN0w6Ps=;
        b=WS1GInsphZXGmX6gmjo9BfYMpwN7XSJHqOkg6zSR4tfj/QoZ/QFnzB2t12QS4+t1V/
         qmOX4XLO8EaY8OL7fJ8eE/TFU18BFbu8nArLS7qXo/TLCacU/iflZyb/ey+OcxAA1DA9
         HtqlHj6SVteknO7wS+DL6l/wnm4zEEM/RbCL6TJ1GH+sfFHgEQj7mXOq7TTOjz8J4PeD
         YCyztsg+9KtaRYEUu27LvujDD0bI0ZIULTGazF3kG8UztPAO0tbdSJY/pyayHP3vP9iP
         EzF9eA062OZEIzjZ2OeDh4xsrpf95Ym3ea0Oc4WH0gdPpD6peRLDY6Za0Pz1gruzLef1
         Fkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TsgNuFo2eIWDrWBc9oEi/VhcSMA4cvpTVu4LDN0w6Ps=;
        b=5nq5U6QOct0Moe83/BAwBeP524zOJYcLgqtiR90/2R0m2qK9xs3384Oo1mYNwZ2Hoe
         QmHhENI1X8SAXJOcavMTjlUlWR3NGFb6k+IWwtWg0yxUWb6fsN+h51+YyEQ79YfcjckE
         P+TzgYco23Htxx7gAEdk/oLYn0LxIdJxAJq+s++Ai0f31xS8m33SxqH589fgXJ2CZSth
         NEE7+H/kBWhybNVGvsUXWuPyO6OuIe0H2TnVDRQzRjDM8M/63W5DaLPdee9fL2+6Mg+H
         XqEr5b0g8dT7uIUt+qLEtABUCUMyU8Drl+2Fb4vuQjoiBxL1CQeJuCRiunnLp1TidTlX
         yf6Q==
X-Gm-Message-State: AOAM531slkhkVs/b5dOSNoexRQC1B9OZ4mLys1J+qLXykUBxJHHxpUK9
        nUpUeSc0szi9gAFXwN95fzFbHF9M5QllgxZY7lU=
X-Google-Smtp-Source: ABdhPJyM1mbCIB/AG1N1869fLc+Z3Bf2fTbD9w4nLVxuw3soq9G8CzIZPx7NVuGJelWwUT/0mfWlHhE2NKELMJASGLU=
X-Received: by 2002:a05:620a:170c:b0:680:48e4:1b1b with SMTP id
 az12-20020a05620a170c00b0068048e41b1bmr23308591qkb.258.1648638182561; Wed, 30
 Mar 2022 04:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220330102409.1290850-1-brauner@kernel.org> <20220330102409.1290850-20-brauner@kernel.org>
In-Reply-To: <20220330102409.1290850-20-brauner@kernel.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 30 Mar 2022 14:02:51 +0300
Message-ID: <CAOQ4uxj1dhNhFC6oBGj623kJ-89vU0rXPSh-wr32u4rh2_W-=g@mail.gmail.com>
Subject: Re: [PATCH v2 19/19] ovl: support idmapped layers
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Mar 30, 2022 at 1:26 PM Christian Brauner <brauner@kernel.org> wrote:
>
> Now that overlay is able to take a layers idmapping into account allow
> overlay mounts to be created on top of idmapped mounts.
>
> Cc: <linux-unionfs@vger.kernel.org>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
> /* v2 */
> unchanged

ovl_upper_idmap() changed but let's not be petty about this ;)

> ---
>  fs/overlayfs/ovl_entry.h | 2 +-
>  fs/overlayfs/super.c     | 4 ----
>  2 files changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 79b612cfbe52..898b002a5c6f 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -92,7 +92,7 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
>
>  static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)
>  {
> -       return &init_user_ns;
> +       return mnt_user_ns(ovl_upper_mnt(ofs));
>  }
>
>  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 9a656a24f7b1..d4cc07f7a2ef 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -874,10 +874,6 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
>                 pr_err("filesystem on '%s' not supported\n", name);
>                 goto out_put;
>         }
> -       if (is_idmapped_mnt(path->mnt)) {
> -               pr_err("idmapped layers are currently not supported\n");
> -               goto out_put;
> -       }
>         if (!d_is_dir(path->dentry)) {
>                 pr_err("'%s' not a directory\n", name);
>                 goto out_put;
> --
> 2.32.0
>
