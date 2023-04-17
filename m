Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D54BC77B76
	for <linux-unionfs@archiver.kernel.org>; Mon, 17 Apr 2023 14:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDQOVK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 17 Apr 2023 10:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjDQOVJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Apr 2023 10:21:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF89173A
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 07:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681741220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P6nOdX40m7EcDkWmMzMYS+1SYVji7Eiopc2cYOWmrcE=;
        b=igF84CaoNe/+fSkyAM22W11BT+qBehQCh1vu6xJ717bpShIdpXz4RonTlVxCxVPJyZWvji
        S3CqUXulKFwArBLRrGSg9D2M0AkjGhRKn+bmP8IqBYobNN9h/bUhamOxHok2yP9tW9CjzX
        gtBK1wbNRohdDU9MCMGzFSJxY+NTiac=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-coBMAevyM26UuzLRr1XfbQ-1; Mon, 17 Apr 2023 10:20:19 -0400
X-MC-Unique: coBMAevyM26UuzLRr1XfbQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4edb884cdc3so497228e87.1
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 07:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681741217; x=1684333217;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P6nOdX40m7EcDkWmMzMYS+1SYVji7Eiopc2cYOWmrcE=;
        b=lmDCfmO4L0wYo9aISQAIezGtb/dOAAx7hjH4L/0vtjbVF8LpCQwJfo4THLbjQL5RF/
         VARc05OB1xoSe1Ut/uCAj5B5cxIZMERF/zEmj8YKKN7pOJ4MK0vDx/qAZicUjzqA+70V
         4OT8HYrflx2rkGcOZuwFyxN+uIYYmK0SSwdUU4cI6Wfnzuak5RJwUWsK0fip7asO4Wbv
         TwN5rQhr0+gYORPy2WVwh12ALwuyIBcw2JkHLdA+6EfVmEGepoI9ySZcKgpUzBzAwJrC
         fU+lzVCdPPQZCyz4h8Om5CwRCeiCadrjyrNi/oHuoklLNYykXAN7PWJr3XwMDEh08Xjn
         rKfg==
X-Gm-Message-State: AAQBX9eGAORyxMgaRwZEpImIk8O8PiyXPfWVReff3H913nyfL89KUg0g
        TCQXP+ZfwK1Na8JJLFNXm1Q2ICixkTyBshcsQELtJidtDsil+NCMF5nmBQu7SHXN3yeOxW8Civi
        LR4jTQ5LIvJwKRBcKwMoplbjicVGYu6UwFQ==
X-Received: by 2002:ac2:4558:0:b0:4eb:c19e:c61c with SMTP id j24-20020ac24558000000b004ebc19ec61cmr1810868lfm.38.1681741217306;
        Mon, 17 Apr 2023 07:20:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350bkalk6ZmLKKHdtNCyD7jA3g3BxyTrLuSZZwCgHmEbL65Gxsn7KXQK7/KN1i8Pv78szOVfX+g==
X-Received: by 2002:ac2:4558:0:b0:4eb:c19e:c61c with SMTP id j24-20020ac24558000000b004ebc19ec61cmr1810864lfm.38.1681741216922;
        Mon, 17 Apr 2023 07:20:16 -0700 (PDT)
Received: from greebo.mooo.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id v16-20020ac25610000000b004cb0dd2367fsm2041390lfd.308.2023.04.17.07.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 07:20:16 -0700 (PDT)
Message-ID: <4893401820bb3339194dc6cd89a43ebc5c505ce5.camel@redhat.com>
Subject: Re: [PATCH 2/7] ovl: use OVL_E() and OVL_E_FLAGS() accessors
From:   Alexander Larsson <alexl@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Date:   Mon, 17 Apr 2023 16:20:15 +0200
In-Reply-To: <20230408164302.1392694-3-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
         <20230408164302.1392694-3-amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 2023-04-08 at 19:42 +0300, Amir Goldstein wrote:
> Instead of open coded instances, because we are about to split
> the two apart.
>=20
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Alexander Larsson <alexl@redhat.com>

> ---
> =C2=A0fs/overlayfs/export.c=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/overlayfs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 8 ++++----
> =C2=A0fs/overlayfs/ovl_entry.h |=C2=A0 5 +++++
> =C2=A0fs/overlayfs/super.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/overlayfs/util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 20 ++++++++++--=
--------
> =C2=A05 files changed, 21 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 5c36fb3a7bab..2cfdfcca5659 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -341,7 +341,7 @@ static struct dentry *ovl_obtain_alias(struct
> super_block *sb,
> =C2=A0/* Get the upper or lower dentry in stack whose on layer @idx */
> =C2=A0static struct dentry *ovl_dentry_real_at(struct dentry *dentry, int
> idx)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!idx)
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 100a492d2b2a..e66352f19755 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -790,7 +790,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs
> *ofs, struct dentry *upper,
> =C2=A0 */
> =C2=A0int ovl_path_next(int idx, struct dentry *dentry, struct path *path=
)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUG_ON(idx < 0);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (idx =3D=3D 0) {
> @@ -833,8 +833,8 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct cred *old_cr=
ed;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_fs *ofs =3D de=
ntry->d_sb->s_fs_info;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *poe =3D dent=
ry->d_parent->d_fsdata;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *roe =3D dent=
ry->d_sb->s_root->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *poe =3D OVL_=
E(dentry->d_parent);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *roe =3D OVL_=
E(dentry->d_sb->s_root);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_path *stack =
=3D NULL, *origin_path =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct dentry *upperdir, =
*upperdentry =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct dentry *origin =3D=
 NULL;
> @@ -1157,7 +1157,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> struct dentry *dentry,
> =C2=A0
> =C2=A0bool ovl_lower_positive(struct dentry *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *poe =3D dent=
ry->d_parent->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *poe =3D OVL_=
E(dentry->d_parent);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct qstr *name =
=3D &dentry->d_name;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct cred *old_cr=
ed;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int i;
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index fd11fe6d6d45..4c7312126b3b 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -124,6 +124,11 @@ static inline struct ovl_entry *OVL_E(struct
> dentry *dentry)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return (struct ovl_entry =
*) dentry->d_fsdata;
> =C2=A0}
> =C2=A0
> +static inline unsigned long *OVL_E_FLAGS(struct dentry *dentry)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return &OVL_E(dentry)->flags;
> +}
> +
> =C2=A0struct ovl_inode {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0union {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_dir_cache *cache;=C2=A0=C2=A0=C2=A0=C2=
=A0/* directory */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 49b6956468f9..108824b359e6 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -138,7 +138,7 @@ static int ovl_revalidate_real(struct dentry *d,
> unsigned int flags, bool weak)
> =C2=A0static int ovl_dentry_revalidate_common(struct dentry *dentry,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0unsigned int flags, bool
> weak)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct inode *inode =3D d=
_inode_rcu(dentry);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct dentry *upper;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int i;
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 6a0652bd51f2..01e6b4ec3074 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -143,7 +143,7 @@ bool ovl_dentry_weird(struct dentry *dentry)
> =C2=A0
> =C2=A0enum ovl_path_type ovl_path_type(struct dentry *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enum ovl_path_type type =
=3D 0;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ovl_dentry_upper(dent=
ry)) {
> @@ -176,7 +176,7 @@ void ovl_path_upper(struct dentry *dentry, struct
> path *path)
> =C2=A0
> =C2=A0void ovl_path_lower(struct dentry *dentry, struct path *path)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (oe->numlower) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0path->mnt =3D oe->lowerstack[0].layer->mnt;
> @@ -188,7 +188,7 @@ void ovl_path_lower(struct dentry *dentry, struct
> path *path)
> =C2=A0
> =C2=A0void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (oe->numlower) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0path->mnt =3D oe->lowerstack[oe->numlower - 1].laye=
r-
> >mnt;
> @@ -231,14 +231,14 @@ struct dentry *ovl_dentry_upper(struct dentry
> *dentry)
> =C2=A0
> =C2=A0struct dentry *ovl_dentry_lower(struct dentry *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return oe->numlower ? oe-=
>lowerstack[0].dentry : NULL;
> =C2=A0}
> =C2=A0
> =C2=A0const struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return oe->numlower ? oe-=
>lowerstack[0].layer : NULL;
> =C2=A0}
> @@ -251,7 +251,7 @@ const struct ovl_layer *ovl_layer_lower(struct
> dentry *dentry)
> =C2=A0 */
> =C2=A0struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return oe->numlower ? oe-=
>lowerstack[oe->numlower - 1].dentry
> : NULL;
> =C2=A0}
> @@ -329,17 +329,17 @@ void ovl_set_dir_cache(struct inode *inode,
> struct ovl_dir_cache *cache)
> =C2=A0
> =C2=A0void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0set_bit(flag, &OVL_E(dentry)->=
flags);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0set_bit(flag, OVL_E_FLAGS(dent=
ry));
> =C2=A0}
> =C2=A0
> =C2=A0void ovl_dentry_clear_flag(unsigned long flag, struct dentry
> *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0clear_bit(flag, &OVL_E(dentry)=
->flags);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0clear_bit(flag, OVL_E_FLAGS(de=
ntry));
> =C2=A0}
> =C2=A0
> =C2=A0bool ovl_dentry_test_flag(unsigned long flag, struct dentry *dentry=
)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return test_bit(flag, &OVL_E(d=
entry)->flags);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return test_bit(flag, OVL_E_FL=
AGS(dentry));
> =C2=A0}
> =C2=A0
> =C2=A0bool ovl_dentry_is_opaque(struct dentry *dentry)
> @@ -1015,7 +1015,7 @@ int ovl_check_metacopy_xattr(struct ovl_fs
> *ofs, const struct path *path)
> =C2=A0
> =C2=A0bool ovl_is_metacopy_dentry(struct dentry *dentry)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D dentr=
y->d_fsdata;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ovl_entry *oe =3D OVL_E=
(dentry);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!d_is_reg(dentry))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return false;

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a one-legged devious stage actor for the 21st century. She's a=20
mistrustful blonde research scientist prone to fits of savage,=20
blood-crazed rage. They fight crime!=20

