Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED36CDB47E
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Oct 2023 06:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjJMG6F (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 02:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjJMG6F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Oct 2023 02:58:05 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E1ABC
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 23:58:03 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-7741c5bac51so114300385a.1
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 23:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697180282; x=1697785082; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ceWbieRZgtXFrWUTn9pSgIbVw/Tr+MmwFcAhWcIiZw8=;
        b=ABPQpjH1XiSFCGO70AgS185S07E4+htcXvaegkczKXnSekuxdAnAp099F1UegIluh7
         ogNsUOQk+7qD2FUJtgemgB2q7vrNCl3j5wFTDv8Noj+eHaMc4dWnd1Oomy8k0RSqTFQc
         WU8/qxvk6O0yuXIiyE2dpcbDK4CF39Q0OxP8+XOQwL94tKTktwshr91ThgU5HfXSxdUE
         WgE7SkScB6FQHtTo/J9SZkASI9HBtF6cfa4VS8iJpcn5KJDAL5eG6O2zN2+xvKLRZSDl
         tP564fjGNQ6xrBBJIERufv4Os26npez2LLp2WqOOtIurNAbGvV4DG9e44D9FUXw5cOmk
         jAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697180282; x=1697785082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ceWbieRZgtXFrWUTn9pSgIbVw/Tr+MmwFcAhWcIiZw8=;
        b=hOSNnTxz9978jOOewRIHfdAJw6ZSVox8oomPNocfHVvzNECcrjrqcs81Cv9Ow4uvhq
         wA0Ho9hNXfCADelE4G8i6BKSvkqEyyQDatZBHOv1nqBGpqb0sAuUtAnRVxepKBVckU0F
         BEdGcfHVoN0rYdih1ucME8h+YQ3BCQefTMdmQS1wjDUw2NvWBq3eMrVLWs1kTZ5YNnBs
         /ZRyDDxJO0EW/40UBHmoY0xTsqIlyKmtNNdJL3L4zIBAlDPsibeo4dZ8qT6upeaMOMPB
         LctPy626tXJ9IlD34MpWluV11nJ1F3Yv3RdSmQHv3lLMLzvS2tRVtV50VcP0nnJFotjK
         Zi8Q==
X-Gm-Message-State: AOJu0YzrsLe3jqKlgL4ZVkHGe1kInjjF85yJIqwhuT8HRUJtd+wWm8WS
        yaKMui7udgXyKu4UKwtDahhvRvqSF1rRWRSKFkZPhZdbm3k=
X-Google-Smtp-Source: AGHT+IF8PNf1bMqJzxmyZlOOt1Be3G5muO3Pw/Mm+47VkzNDmwFBYT3KkrlZbcCtmDIlcj/MI+uCGPGub6l7G9+TS+E=
X-Received: by 2002:a0c:f38e:0:b0:66c:fb15:c16b with SMTP id
 i14-20020a0cf38e000000b0066cfb15c16bmr9019617qvk.61.1697180282084; Thu, 12
 Oct 2023 23:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20231012-einband-uferpromenade-80541a047a1f@brauner>
In-Reply-To: <20231012-einband-uferpromenade-80541a047a1f@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 13 Oct 2023 09:57:50 +0300
Message-ID: <CAOQ4uxgEyBaCgmG5q85+kfaVyGDNUkzf_W-Oy7PbCmqe+gNtUQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: rely on SB_I_NOUMASK
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Max Kellermann <max.kellermann@ionos.com>,
        linux-unionfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 12, 2023 at 6:37=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> In commit f61b9bb3f838 ("fs: add a new SB_I_NOUMASK flag") we added a
> new SB_I_NOUMASK flag that is used by filesystems like NFS to indicate
> that umask stripping is never supposed to be done in the vfs independent
> of whether or not POSIX ACLs are supported.
>
> Overlayfs falls into the same category as it raises SB_POSIXACL
> unconditionally to defer umask application to the upper filesystem.
>
> Now that we have SB_I_NOUMASK use that and make SB_POSIXACL properly
> conditional on whether or not the kernel does have support for it. This
> will enable use to turn IS_POSIXACL() into nop on kernels that don't
> have POSIX ACL support avoding bugs from missed umask stripping.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
> Hey Amir & Miklos,
>
> This depends on the aforementioned patch in vfs.misc. So if you're fine
> with this change I'd take this through vfs.misc.

Generally, I'm fine with a version of this going through the vfs tree.

>
> Christian
> ---
>  fs/overlayfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 9f43f0d303ad..361189b676b0 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1489,8 +1489,16 @@ int ovl_fill_super(struct super_block *sb, struct =
fs_context *fc)
>         sb->s_xattr =3D ofs->config.userxattr ? ovl_user_xattr_handlers :
>                 ovl_trusted_xattr_handlers;
>         sb->s_fs_info =3D ofs;
> +#ifdef CONFIG_FS_POSIX_ACL
>         sb->s_flags |=3D SB_POSIXACL;
> +#endif

IDGI, if IS_POSIXACL() is going to turn into noop
why do we need this ifdef?

To me the flag SB_POSIXACL means that any given inode
MAY have a custom posix acl.

>         sb->s_iflags |=3D SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGNATUR=
E;
> +       /*
> +        * Ensure that umask handling is done by the filesystems used
> +        * for the the upper layer instead of overlayfs as that would
> +        * lead to unexpected results.
> +        */
> +       sb->s_iflags |=3D SB_I_NOUMASK;
>

Looks like FUSE has a similar pattern, although the testing and then
setting of SB_POSIXACL is perplexing to me:

        /* Handle umasking inside the fuse code */
        if (sb->s_flags & SB_POSIXACL)
                fc->dont_mask =3D 1;
        sb->s_flags |=3D SB_POSIXACL;

And for NFS, why was SB_I_NOUMASK set for v4 and not for v3
when v3 clearly states:

        case 3:
                /*
                 * The VFS shouldn't apply the umask to mode bits.
                 * We will do so ourselves when necessary.
                 */
                sb->s_flags |=3D SB_POSIXACL;

Feels like I am missing parts of the big picture?

Thanks,
Amir.
