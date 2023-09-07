Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D83EC8743
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 16:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbjIGQuM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243590AbjIGQuL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 12:50:11 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C110810F9
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 09:49:45 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6bdacc5ed66so599005a34.1
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 09:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694105294; x=1694710094; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUMPEE1gnL75R6g0gmm7d44jjBhPXr6umtGKB+iiWEI=;
        b=IEzYPyrg2MNdoi0JN9hKc7Jur3COb/P3x9e8FL7vdTnswDXmrkys+s04ldFa0IFdnc
         RGyfBirMZOThnULk4Zcp2NOm+va1TfQXAqLlvY34SHJeFzMFoDLptbvGWfgjaj8ud0iQ
         KyS0aIZiTmKNs/BvOQLZgc24DYLvbHLI9WjQbmdtkB+CTdRzYERZCIBGW+iszfdGr+fV
         zegSw/ZTPUPOYM1RHsJWS9PkYBWC/UP697+tkuQh94Tw3luuSBYlkmfWdbthznUJBMWe
         yAPacc7ZiK4baObW8wHFGcv73vpu98IRb+HGuXvRsqweu03zGvNN+MnxO8zuAFvSFu96
         i2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694105294; x=1694710094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lUMPEE1gnL75R6g0gmm7d44jjBhPXr6umtGKB+iiWEI=;
        b=lLfb+skuOYHdewPqjCupKxllwK7SUaFRTHdZS7WvnG5LNc/MAlguNQBsDJ1duHJ4c8
         Cgct9LhA2bosd0WrySBrqnNNjfx7wET/V5oM+4ro2IQvnNKnnmjknrBiypoez6cGoL99
         7YudoXdpqVTEXKJgY5vrmRoxk43Lv9qdbtfA/KP3MvjxgYzqo1igDr98cvxzg6/KLPpt
         1P6xyzgoYAI0vXTgS+xX1IWe3SggEY0oxrq/RdDAWa+w/Lry6PlBhdhNrO0UscZQw2lf
         26eAvqP1639RLqlDCIMnOIKi1Y1hDc/CArYJqB9YY+W4bsYNQBZkdhOOLRIdexKWg0eX
         8KRA==
X-Gm-Message-State: AOJu0YzdYPrJyqfTRMNgC5peLbzN9/6NS91l3VgTMpj5A+GpmVCvhd4N
        iTeOaCb3Rou5+MxWtp8Yqs/6mspC8srn7+mgrPLft9L0HVc=
X-Google-Smtp-Source: AGHT+IFUW08QaqKJIxl+jOrsSOjdgJbU+qKIxt0T+YifjeSei2o/yiLnaiO3ngCZVQMcxzmjzOPEZ8woM6YaGpQ9nD0=
X-Received: by 2002:a05:6102:32d5:b0:44e:e45f:3543 with SMTP id
 o21-20020a05610232d500b0044ee45f3543mr1715083vss.7.1694089676301; Thu, 07 Sep
 2023 05:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com> <acb6243943171a353091fa92cf1ffbf92bcb26ba.1694075674.git.alexl@redhat.com>
In-Reply-To: <acb6243943171a353091fa92cf1ffbf92bcb26ba.1694075674.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 7 Sep 2023 15:27:45 +0300
Message-ID: <CAOQ4uxjn8dF6K03jmyy64HURV2GXsY0DDBNOqfKNpk5k9E0AEg@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] ovl: Handle escaped xwhiteouts across layers
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 7, 2023 at 11:44=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> We use the "overlay.whiteouts" to mark any directory in a lower dir that =
may
> contain "overlay.whiteout" files (xwhiteouts). This works even if other l=
ayers
> overlap that directory in a mount.
>
> For example, take these files in three layers:
>
>  layer2/dir/ - overlay.whiteouts
>  layer2/dir/file - overlay.whiteout
>  layer1/dir/
>  layer1/dir/file
>
> An overlayfs mount with -o lowerdir=3Dlayer2:layer1 would have a whiteout=
 in
> layer2.
>
> However, suppose you wanted to put this inside an overlayfs layer (say
> "layerA"). I.e. you want to escape the whiteouts above so that when the n=
ew
> layer is mounted using overlayfs the mount shows the above content. The n=
atural
> approach is to just take each layer and escape it:
>
>  layerA/layer2/dir/ - overlay.overlay.whiteouts
>  layerA/layer2/dir/file - overlay.overlay.whiteout
>  layerA/layer1/dir/
>  layerA/layer1/dir/file
>
> This initially seems to work, however if there is another lowerdir (say
> "layerB") that overlaps the xwhiteouts dir, then this runs into problem:
>
>  layerB/layer2/dir/ - **NO overlay.overlay.whiteouts **
>  layerA/layer2/dir/ - overlay.overlay.whiteouts
>  layerA/layer2/dir/file - overlay.overlay.whiteout
>  layerA/layer1/dir/
>  layerA/layer1/dir/file
>
> If you mount this with -o lowerdir=3DlayerB:layerA, then in the final mou=
nt,
> there will be no overlay.whiteouts xattrs on the "layer2/dir" merged
> directory, because the topmost lower dir xattrs win.
>
> We would like this to work as is, to avoid having layer escaping depend o=
n other
> layers. So, to fix this up we special case the reading of escaped
> "overlay.whiteouts" xattrs by looking in all layers for the first hit.
>

I have a few issues with this special casing:
1. Miklos did not speak his opinion yet
2. I don't like special casing by suffix nor special casing a single xattr
3. I can think of example like this:

  layerB/layer2/dir/file3
  layerB/layer2/dir/ - **NO overlay.overlay.opaque **
  layerA/layer2/dir/ - overlay.overlay.opaque
  layerA/layer2/dir/file2
  layerA/layer1/dir/
  layerA/layer1/dir/file1

LayerB doesn't have layer1 so it does not know that
opaque is needed, therefore opaque needs to be merged
as well in this case.

Can we employ the logic of ovl_xattr_get_first() for any
escaped xattr prefix on a merge dir?

Thanks,
Amir.

> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/xattrs.c | 46 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> index 27b31f812eb1..9e5f50ba333d 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -92,6 +92,25 @@ static int ovl_xattr_get(struct dentry *dentry, struct=
 inode *inode, const char
>         return res;
>  }
>
> +static int ovl_xattr_get_first(struct dentry *dentry, struct inode *inod=
e, const char *name,
> +                              void *value, size_t size)
> +{
> +       const struct cred *old_cred;
> +       struct path realpath;
> +       int idx, next;
> +       int res =3D -ENODATA;
> +
> +       old_cred =3D ovl_override_creds(dentry->d_sb);
> +       for (idx =3D 0; idx !=3D -1; idx =3D next) {
> +               next =3D ovl_path_next(idx, dentry, &realpath);
> +               res =3D vfs_getxattr(mnt_idmap(realpath.mnt), realpath.de=
ntry, name, value, size);
> +               if (res !=3D -ENODATA && res !=3D -EOPNOTSUPP)
> +                       break;
> +       }
> +       revert_creds(old_cred);
> +       return res;
> +}
> +
>  static bool ovl_can_list(struct super_block *sb, const char *s)
>  {
>         /* Never list non-escaped private (.overlay) */
> @@ -176,6 +195,18 @@ static char *ovl_xattr_escape_name(const char *prefi=
x, const char *name)
>         return escaped;
>  }
>
> +
> +static int str_ends_with(const char *s, const char *sub)
> +{
> +       int slen =3D strlen(s);
> +       int sublen =3D strlen(sub);
> +
> +       if (sublen > slen)
> +               return 0;
> +
> +       return !memcmp(s + slen - sublen, sub, sublen);
> +}
> +
>  static int ovl_own_xattr_get(const struct xattr_handler *handler,
>                              struct dentry *dentry, struct inode *inode,
>                              const char *name, void *buffer, size_t size)
> @@ -187,7 +218,20 @@ static int ovl_own_xattr_get(const struct xattr_hand=
ler *handler,
>         if (IS_ERR(escaped))
>                 return PTR_ERR(escaped);
>
> -       r =3D ovl_xattr_get(dentry, inode, escaped, buffer, size);
> +       /*
> +        * Escaped "overlay.whiteouts" directories need to be combined ac=
ross layers.
> +        * For example, if a lower layer contains an escaped "overlay.whi=
teout"
> +        * its parent directory will be marked with an escaped "overlay.w=
hiteouts".
> +        * The merged directory will contain a (now non-escaped) whiteout=
, and its
> +        * parent should therefore be marked too. However, if a layer abo=
ve the marked
> +        * one has covers the same directory but without whiteouts the co=
vering directory
> +        * would not be marged, and thus the merged directory would not b=
e marked.
> +        */
> +       if (d_is_dir(dentry) &&
> +           str_ends_with(escaped, "overlay.whiteouts"))
> +               r =3D ovl_xattr_get_first(dentry, inode, escaped, buffer,=
 size);
> +       else
> +               r =3D ovl_xattr_get(dentry, inode, escaped, buffer, size)=
;
>
>         kfree(escaped);
>
> --
> 2.41.0
>
