Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E79C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 11:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiC2L6E (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 07:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiC2L6D (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 07:58:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73A2241B66
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 04:56:19 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p15so34596099ejc.7
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 04:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=skUd+Pj6OgOPtV/hxcxYCIwiEwhr8Wo70G0+0OCqQ3c=;
        b=YCLZmijRreia5FhR4RsaZEmdQCGFiDlNcaStTTM9gRhi43y25n+wrFcxBJG2pFrYpf
         IU7ysGFM59DRtTKyLpYMg6ADHCAl1f1lpMgsDVZGADCNVXOsvaiiwfz4yR1DRWGG2Q8W
         /2NlZwaT+S4Er8d5t1k8QlnQmGxMNxGspBZF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=skUd+Pj6OgOPtV/hxcxYCIwiEwhr8Wo70G0+0OCqQ3c=;
        b=tRgT+fGqJ0plSGukiv73WxzvMdim9U1ta7heKF8n4tYtwGKOFENrOsnTtZl/Pv0RJy
         NG7E38pTp4qvD7xw9u/O9Ojgco3PCBIv+PE0RKkmnQVLAVpp+sTrZ80UU5lxKtmh+dWm
         4sZizAXyRtbda8vLzJde4gUlrDGjNlXDMPyqxAkgmIB20dpVS2DzEeTT+DVeGKOqFZ8i
         fdnVDNqnw72e1IzDpUhIB8EsDdjA++YXOSDPl8kDWqxsXfjGo+ONYwCirHqfuvyXavVf
         o1ToVwdTAM7S1PF5qbPibpO3zyStdPpd7p0p/9VTyX2Mtyig4JhFzFQphjJtqRX3m7Ns
         WWqg==
X-Gm-Message-State: AOAM531QD8fnM0SwTDjApYAHsc9HlWIvmFMWVZZ3UWTJxykPdU89PV65
        b7fPwd8Z5kF53DIk1Kh6smEnQU+fX80xfGmssDp1dg==
X-Google-Smtp-Source: ABdhPJz3eyGIYal3w2UkTdNvr4Ru4SWXnkHQRcv6dd9iRYWB0eFeR1K29YR1u6vZmpiG/5cpJw73ROI1vn3HicpqFCM=
X-Received: by 2002:a17:906:c211:b0:6ce:e221:4c21 with SMTP id
 d17-20020a170906c21100b006cee2214c21mr33402732ejz.691.1648554978138; Tue, 29
 Mar 2022 04:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220329103526.1207086-1-brauner@kernel.org> <20220329103526.1207086-9-brauner@kernel.org>
In-Reply-To: <20220329103526.1207086-9-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 13:56:06 +0200
Message-ID: <CAJfpegu9z+EVSTjq2-hXLPRJsTpvQpGu=LQrKCgWjs3Wux=e8Q@mail.gmail.com>
Subject: Re: [PATCH 08/18] ovl: use ovl_do_notify_change() wrapper
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 29 Mar 2022 at 12:37, Christian Brauner <brauner@kernel.org> wrote:
>
> Introduce ovl_do_notify_change() as a simple wrapper around
> notify_change() to support idmapped layers. The helper mirrors other
> ovl_do_*() helpers that operate on the upper layers.
>
> When changing ownership of an upper object the intended ownership needs
> to be mapped according to the upper layer's idmapping. This mapping is
> the inverse to the mapping applied when copying inode information from
> an upper layer to the corresponding overlay inode. So e.g., when an
> upper mount maps files that are stored on-disk as owned by id 1001 to
> 1000 this means that calling stat on this object from an idmapped mount
> will report the file as being owned by id 1000. Consequently in order to
> change ownership of an object in this filesystem so it appears as being
> owned by id 1000 in the upper idmapped layer it needs to store id 1001
> on disk. The mnt mapping helpers take care of this.
>
> All idmapping helpers are nops when no idmapped base layers are used.
>
> Cc: <linux-unionfs@vger.kernel.org>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
>  fs/overlayfs/copy_up.c   |  8 ++++----
>  fs/overlayfs/dir.c       |  2 +-
>  fs/overlayfs/inode.c     |  3 ++-
>  fs/overlayfs/overlayfs.h | 25 +++++++++++++++++++++++++
>  fs/overlayfs/ovl_entry.h |  5 +++++
>  fs/overlayfs/super.c     |  2 +-
>  6 files changed, 38 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 2c336acb2ba0..a5d68302693f 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -301,7 +301,7 @@ static int ovl_set_size(struct ovl_fs *ofs,
>                 .ia_size = stat->size,
>         };
>
> -       return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +       return ovl_do_notify_change(ofs, upperdentry, &attr);
>  }
>
>  static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
> @@ -314,7 +314,7 @@ static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
>                 .ia_mtime = stat->mtime,
>         };
>
> -       return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +       return ovl_do_notify_change(ofs, upperdentry, &attr);
>  }
>
>  int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> @@ -327,7 +327,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
>                         .ia_valid = ATTR_MODE,
>                         .ia_mode = stat->mode,
>                 };
> -               err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +               err = ovl_do_notify_change(ofs, upperdentry, &attr);
>         }
>         if (!err) {
>                 struct iattr attr = {
> @@ -335,7 +335,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
>                         .ia_uid = stat->uid,
>                         .ia_gid = stat->gid,
>                 };
> -               err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> +               err = ovl_do_notify_change(ofs, upperdentry, &attr);
>         }
>         if (!err)
>                 ovl_set_timestamps(ofs, upperdentry, stat);
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 27a40b6754f4..9ae0352ff52a 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -516,7 +516,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
>                         .ia_mode = cattr->mode,
>                 };
>                 inode_lock(newdentry->d_inode);
> -               err = notify_change(&init_user_ns, newdentry, &attr, NULL);
> +               err = ovl_do_notify_change(ofs, newdentry, &attr);
>                 inode_unlock(newdentry->d_inode);
>                 if (err)
>                         goto out_cleanup;
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index c51a9dd36cc7..9a8e6b94d9e8 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -21,6 +21,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>                 struct iattr *attr)
>  {
>         int err;
> +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
>         bool full_copy_up = false;
>         struct dentry *upperdentry;
>         const struct cred *old_cred;
> @@ -77,7 +78,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>
>                 inode_lock(upperdentry->d_inode);
>                 old_cred = ovl_override_creds(dentry->d_sb);
> -               err = notify_change(&init_user_ns, upperdentry, attr, NULL);
> +               err = ovl_do_notify_change(ofs, upperdentry, attr);
>                 revert_creds(old_cred);
>                 if (!err)
>                         ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 816a69b46b67..eff8a1edb693 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -122,6 +122,31 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
>         return ovl_xattr_table[ox][ofs->config.userxattr];
>  }
>
> +/*
> + * When changing ownership of an upper object map the intended ownership
> + * according to the upper layer's idmapping. When an upper mount idmaps files
> + * that are stored on-disk as owned by id 1001 to id 1000 this means stat on
> + * this object will report it as being owned by id 1000 when calling via the
> + * upper mount. So in order to change ownership of an object so it reports id
> + * 1000 when calling stat on it through the upper mount the value written to
> + * disk must be 1001. The mount mapping helper will take of this. The mnt
> + * idmapping helpers are nops if the upper layer isn't idmapped.
> + */
> +static inline int ovl_do_notify_change(struct ovl_fs *ofs,
> +                                      struct dentry *upperdentry,
> +                                      struct iattr *attr)
> +{
> +       struct user_namespace *upper_idmap = ovl_upper_idmap(ofs);
> +       struct user_namespace *fs_idmap = i_user_ns(d_inode(upperdentry));
> +
> +       if (attr->ia_valid & ATTR_UID)
> +               attr->ia_uid = mapped_kuid_user(upper_idmap, fs_idmap, attr->ia_uid);
> +       if (attr->ia_valid & ATTR_GID)
> +               attr->ia_gid = mapped_kgid_user(upper_idmap, fs_idmap, attr->ia_gid);

I see a similar transformation in chown_common() but I can't say I
fully understand how this works...

> +
> +       return notify_change(ovl_upper_idmap(ofs), upperdentry, attr, NULL);

First argument can use upper_idmap, right?

Thanks,
Miklos

> +}
> +
>  static inline int ovl_do_rmdir(struct ovl_fs *ofs,
>                                struct inode *dir, struct dentry *dentry)
>  {
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 63efee554f69..cf6aebcf893c 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -90,6 +90,11 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
>         return ofs->layers[0].mnt;
>  }
>
> +static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)
> +{
> +       return mnt_user_ns(ovl_upper_mnt(ofs));
> +}

Ah, here it is.

Can this function be introduced early in the series, but return &init_userns?

Then when everything in place the mnt userns support can be switched on.

Thanks,
Miklos
