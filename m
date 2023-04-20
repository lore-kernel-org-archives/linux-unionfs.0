Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB25FC77B72
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 12:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjDTMNN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 08:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbjDTMNJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 08:13:09 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8E359F7
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:12:39 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id v18so1988541uak.8
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681992753; x=1684584753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nguzq/f1Tjc/dp3Jnp8k4tZEg8n0swUGPV8jptc/xXY=;
        b=DHQ2lFx2MizWMQQrYU/Zu46mRFRdtM4lEuTKEsZ2tYoxgcQldR2JQ3bQG2T5mJxOhR
         b75zfmVi6WHumlV1KqvFEWyjGGVYORoOOzJPrPnkiI4CpPGnKMKfmiJ1Ff9xQI0zujLX
         4LYMoxP6wcwkhMzWAnZjrlTobrLtGROySoTCpSUIU+YuAwZ0m7x0NruhjcL6YQ+pes6s
         8rXwcP7fpckfnNNU0nNaDew9KHsoHdrDkSu5pbQUB4AWIuEWUJnxePaWNC5R0EJoHYx/
         IxKIea0Lg7bjgZNTEoc7z6Ir8vLhMM1MZdom9RxmnKYhM4+VBHC42WTpzqRHeLK65F8T
         a7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681992753; x=1684584753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nguzq/f1Tjc/dp3Jnp8k4tZEg8n0swUGPV8jptc/xXY=;
        b=c/na6kIAmZzaSAS7yA6YnFPwgjzC68uhJwp120GzI+gG8/oxrSJ+XAnL7Xrr9SCOD9
         asjbvm9ZgQvF5ZSXLWg5JigRmKmmYdRU7FCbZBnjB+6XC74EjwfqPyPUWX1QHQtsI8dG
         6QWqTpncfosD9H55cGj+AfJfEpPS81U0/Jpo17YC/CMfcfVoGU3bkCjXb6JRAuFjXWgi
         WEPNp28gLBk9ygdV4QP1mA+MiXb1P77CPmneFCWYi/4cOWWAkQVRaD04tDYkOoN1C3dJ
         rjQ8Za9FkaYqJBgf36ow37ckU3uSwSciRrSL15sX4hn7UToxC7yB97pwBCX7X0qmMgsn
         ihMw==
X-Gm-Message-State: AAQBX9fPLM/fd3NhVdTwkg9OwX/bHN+5BBGh3DPY5QkmkbIh/+c952O0
        VkSBrFuX2RHwee8Kol9qUFZn9b1aPHYkLFE7gTc=
X-Google-Smtp-Source: AKy350ZAWQBzAc920rmXqxFboV4WcJL/RkyzdyZVEAjmX5ykGw8ZKiZGhVdmaEOPbZo+XnBZYCpAiMN+G0rft3UT7lE=
X-Received: by 2002:a1f:a994:0:b0:446:c76f:a7e5 with SMTP id
 s142-20020a1fa994000000b00446c76fa7e5mr855147vke.0.1681992753049; Thu, 20 Apr
 2023 05:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <4c5c62c05a00a97dce0ce5fbee020e82ee76c202.1681917551.git.alexl@redhat.com>
In-Reply-To: <4c5c62c05a00a97dce0ce5fbee020e82ee76c202.1681917551.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 20 Apr 2023 15:12:21 +0300
Message-ID: <CAOQ4uxihGt_W=o69fdGn4DCKpY-kJYYvhhXf0qxqDLRmWAyL3w@mail.gmail.com>
Subject: Re: [PATCH 2/6] ovl: Break out ovl_entry_path_real() from ovl_i_path_real()
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 20, 2023 at 10:44=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> This allows us to get the real path from the ovl_entry in ovl_lookup()
> before having finished setting up the resulting inode.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/overlayfs.h |  2 ++
>  fs/overlayfs/util.c      | 25 ++++++++++++++++++-------
>  2 files changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 4e327665c316..477008186d18 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -395,6 +395,8 @@ void ovl_path_upper(struct dentry *dentry, struct pat=
h *path);
>  void ovl_path_lower(struct dentry *dentry, struct path *path);
>  void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
>  void ovl_i_path_real(struct inode *inode, struct path *path);
> +void ovl_entry_path_real(struct ovl_fs *ofs, struct ovl_entry *oe,
> +                        struct dentry *upperdentry, struct path *path);
>  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *pat=
h);
>  enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path =
*path);
>  struct dentry *ovl_dentry_upper(struct dentry *dentry);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 9a042768013e..77c954591daa 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -351,19 +351,30 @@ struct dentry *ovl_i_dentry_upper(struct inode *ino=
de)
>         return ovl_upperdentry_dereference(OVL_I(inode));
>  }
>
> -void ovl_i_path_real(struct inode *inode, struct path *path)
> -{
> -       struct ovl_path *lowerstack =3D ovl_lowerstack(OVL_I_E(inode));
> +void ovl_entry_path_real(struct ovl_fs *ofs,

Nit: I would use ovl_e_ prefix. Not critical.

Thanks,
Amir.
