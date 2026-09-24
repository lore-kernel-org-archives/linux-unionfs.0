Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F01A476043
	for <linux-unionfs@vger.kernel.org>; Thu, 24 Sep 2026 11:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248381; cv=pass; b=f4dFlMYwHCnOcor4fvfZ8MULfErjBcF0wC9AL93r123Of9EUDHH9xh02pbQqLywHSjdoLE4F1dllFtRi2+P27W5FcQKZ63mcv/gQid2lLuxW5lksXUZDCoxO5vbWGQtY55oECQAmnvM1arSdjVuPNnWotBkZMOPzsH4JXclwAiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248381; c=relaxed/simple;
	bh=eJYqN4wEoL/OX9Q03eUTbGvGTyg+Jo8gjHizQ3XF3AE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3b4x5gNouxSRUAiVU9Vp3SHjWcHm8vxHQC9TyBSEa1hnJ+o7wWZK0EZ8YBRWbYj4f7YzxWgBGC9it2uUtaPzX/nWk/0gUFdizA1HXX5dzBs0ZoNRvobTX+DfjRA5zgvQE99MQwfhx2IirnmeYG4S9bqFy3MAgY8bet4CZjruDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UO5XdKUV; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UO5XdKUV"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a64c7cdb46so3161612a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Sep 2026 04:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790248376; cv=none;
        d=google.com; s=arc-20260327;
        b=Vq4JtP3DLlgRG/GCXhKekMxAlwrGwYaa92QuDTd33hDD1XbEo4PGpHxaChtmf+/h11
         jAxcXVTmuRTMIACI0QTiv/FSKx6Gid0M5LI16e8WA+cZiETIEe/w5fV1M6GU65g2IFot
         pZN/AjJaC7AWPrsw+T9dmoTnj2tJmYXAo6xVw+yC+kELRCit/vwhKExmubZB1XWPBi57
         zzBdy9Qckaj2mfAgZtKgF86vkhscTGTihUO1PAnYCdZZBgNshMRgwX+pNJWgsL0O48cJ
         QNkE25LiyyP+kH2SeAOrVDj7a9dlfRQWoW6+lWrVoRQ2gmq6qor/WOIO0sgSkgFdOKvI
         1gzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BIF+DNqqKyKNEhEgpncpLAUjcdtzT9Ko8rcMz3NbVVk=;
        fh=3cJsvkylugvT8OE0+ma9BsnO3u71PW8Lo8ttxylxFHg=;
        b=EriMCgImyL/z/KhtI7kvKL6WNKnPAUNJzaaAbdG1ByUoV08AXrxn0VOhQneobcdflb
         tPrTXuY0uIlCWiMSuQSv1lkmD8IiSfniVI+4y7rF4l+OD3axtL1eHP6k+TaRW56A0lG9
         XAm00Br3HboCoPzn02kz0TjfgqVhbbSy3BaffdN7Q25GTQUGuOdeki0gzFAQ1L3CyCeA
         1Vnoiq5MAw695xEM9sEry4Fc5iwOlr1JvNEf1m6jVMWCTRR8B6FMjWIaX5dlpesocU3U
         aRD5ISyCje2IGokCdQjEm3XvTgBOhKaXLJnMpIExa1bCgt37+J9AaIbHNojKTqWNuF48
         HUMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790248376; x=1790853176; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BIF+DNqqKyKNEhEgpncpLAUjcdtzT9Ko8rcMz3NbVVk=;
        b=UO5XdKUVr0Tnk1hLWi6U3CPXLr93cZu/hKzPqXOfEb9XlRA0iR/adpDePOfLdoKpvd
         5FjwlmLvQrvCHJHg4or9JvxUYzyPNL/Sb8ina3N19bebDtjEHcwJ9zjGwVAo7aKkRYeg
         5LjvvdEApWh+gyHuf9RPlsIA0p9I4kErydeF8UZief7e6N/lRrhKU05VI8G/DZxVQLjO
         7dMo/uOT+lVUArZxkGK+U+g2aqzCdtgO+FJravKU2rX05b5uYT6H0/8dxVEGWexA3sYf
         giEgTf65NfSGtsvwzw3VsVMbuPP3Enl/KJAZea0xDbpy6OQbqaD+47wmAUhOpUZCqNZR
         EP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790248376; x=1790853176;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIF+DNqqKyKNEhEgpncpLAUjcdtzT9Ko8rcMz3NbVVk=;
        b=l/RzXoyk+nkx0M00NBqOxey3B/z1eyxj3SFBJDf9QZEJLdWimAT5XLyMwwhjWui6a2
         kjmly7EpskRbNJFpKEJhgIKj8G8JHtWu8uKYHES18yV825o9LMRo0kDlTdg5DMN5gnAt
         i9S/ctwyNmm/BU+J4qnT+ci/tnathsv7bt9K/87ENdwWw5l59kmyIwyFK5gJKR8zKAn2
         xZryqbKQXqHkdMLdeIrWo8yvhQ4dKc0btfOFGlIQrBk5+NQt+v9TRdPFgofa9Cb0Nhpc
         vc2vvrFFxENE22KAM3o+m2RsIefJvywrirCHR3OdIp0Dpm2XisGINm3d/YDujUqikkDE
         DnFA==
X-Forwarded-Encrypted: i=1; AKwUvBwou2hwDTLjnWKRCdbAWIq8mFkNB9HS0WZPKHz4fiOqwd0am4ppPbnguzTnQzfv/Ie5slklx3huWbExdORt@vger.kernel.org
X-Gm-Message-State: AFuF++mDEaURy9xrsO1RaM0da+2Z8DgfulvPE6or15NhKwQXXCMB/KIZ
	tcWgnOzH3KZIn+c6KpZ3fgyNc8ZOFHdLuH5f+e52RILdrFTWoGf3gmC6bJLUaavOxu5SVL2XjQY
	go6ke5ieu/NDqL0kzKUbagq9tEmkAnNw=
X-Gm-Gg: AYBFou04NX6jng05zRC58NU07als8dxB0GvszO7/tf1bnJlDrlRXTbvw7lJOEbvsT30
	95VhlL+2YrPFHF+xgPv4nH7PYLfAtAnRl8B5rDfdBqfnam4p6Amm4WW84cPf4AyZYFtc6XVt48o
	1iBldvA+eQtwqBE51G0f9diWBCEbbXvkqTJG+EZ97eNF55ERTVilTGYG0H2bR9jTRRlCAM+BevF
	Rw99EpMdLUBoL9xeVKxaKIb7+NIBZNIUHHDIAEC0cUpJq+WqahUURZFAdHZtbLvyma1fQXwjBva
	DYdoP0TqkgfWHNJRb4zvUdTL0nHB+JZk5tBq4CAEM9tFIvqNspvdOPj2
X-Received: by 2002:a05:6402:278f:b0:6aa:665:830 with SMTP id
 4fb4d7f45d1cf-6aac8f4be3bmr1951363a12.15.1790248376170; Thu, 24 Sep 2026
 04:12:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924104831.1081137-1-caixinchen1@huawei.com> <20260924104831.1081137-4-caixinchen1@huawei.com>
In-Reply-To: <20260924104831.1081137-4-caixinchen1@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 24 Sep 2026 13:12:44 +0200
X-Gm-Features: AclHuK814JZB8XXMibt7ISdY9GmULY6F59LGn_JEl7Ybs7QawxIOFdTv7Ii5ZE4
Message-ID: <CAOQ4uxhMhcxq5+crz84f8xj+Wi1bHhNqa_TecP-RvipheBR+ug@mail.gmail.com>
Subject: Re: [PATCH RFC -next 03/12] fs: pass struct path to xattr helpers
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: mic@digikod.net, gnoack@google.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, 
	dakr@kernel.org, dlemoal@kernel.org, hch@lst.de, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	dhowells@redhat.com, code@tyhicks.com, linkinjeon@kernel.org, 
	sj1557.seo@samsung.com, yuezhang.mo@sony.com, hirofumi@mail.parknet.co.jp, 
	cel@kernel.org, jlayton@kernel.org, neil@brown.name, okorniev@redhat.com, 
	Dai.Ngo@oracle.com, tom@talpey.com, miklos@szeredi.hu, 
	senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com, zohar@linux.ibm.com, 
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, 
	stephen.smalley.work@gmail.com, omosnacek@gmail.com, casey@schaufler-ca.com, 
	nanx95726@gmail.com, djwong@kernel.org, daniel@iogearbox.net, 
	linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netfs@lists.linux.dev, ecryptfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	xiujianfeng@huawei.com, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 12:22=E2=80=AFPM Cai Xinchen <caixinchen1@huawei.co=
m> wrote:
>
> vfs_setxattr(), vfs_getxattr(), vfs_listxattr() and vfs_removexattr()
> along with their __vfs_setxattr_locked()/__vfs_removexattr_locked()
> counterparts and the do_setxattr()/do_getxattr()/listxattr()/
> removexattr() syscall helpers take a struct mnt_idmap and a struct
> dentry even though callers either already hold a struct path (or a
> struct file) or have to pass &nop_mnt_idmap because no idmapped
> mount is involved.  Switch them all to take a struct path instead
> and derive the idmap and dentry from it where needed.
>
> __vfs_setxattr_noperm(), __vfs_getxattr(), __vfs_setxattr(),
> __vfs_removexattr() and vfs_getxattr_alloc() keep taking the idmap
> and dentry as they are only called from contexts that operate on
> bare dentries such as LSM internals.  The SELinux and Smack
> inode_setsecctx implementations now pass the path they got from the
> previous patch straight through.
>
> The security_inode_*xattr() hooks invoked from fs/xattr.c keep
> taking the idmap and dentry for now; they will be converted together
> with the LSM hooks themselves in separate patches.
>
> evm_calc_hmac_or_hash() contains a redundant xattr size sanity check
> which calls vfs_getxattr() only to emit a debug message when the
> kernel-side and user-space-side xattr sizes differ, without ever
> influencing the result.  Because that function only has a dentry, the
> call cannot be migrated to the new path-based signature; drop the
> check and the now unused user_space_size variable instead.
>
> Assisted-by: opencode: glm-5.3
> Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
> ---
>  drivers/block/zloop.c               |   4 +-
>  fs/cachefiles/xattr.c               |  32 ++++----
>  fs/ecryptfs/inode.c                 |   8 +-
>  fs/nfsd/nfs4ctl.h                   |   4 +-
>  fs/nfsd/vfs.c                       |  57 +++++++-------
>  fs/overlayfs/copy_up.c              |   4 +-
>  fs/overlayfs/overlayfs.h            |  18 +++--
>  fs/overlayfs/xattrs.c               |  13 +++-
>  fs/smb/server/smb2pdu.c             |  75 +++++++------------
>  fs/smb/server/smb_common.c          |   2 -
>  fs/smb/server/smbacl.c              |  19 +++--
>  fs/smb/server/tests/smbacl_kunit.c  |   6 +-
>  fs/smb/server/vfs.c                 | 112 ++++++++++++----------------
>  fs/smb/server/vfs.h                 |  39 ++++------
>  fs/smb/server/vfs_cache.c           |   3 +-
>  fs/xattr.c                          |  92 ++++++++++++-----------
>  include/linux/xattr.h               |  22 +++---
>  security/integrity/evm/evm_crypto.c |   8 +-
>  security/selinux/hooks.c            |   4 +-
>  security/smack/smack_lsm.c          |   4 +-
>  20 files changed, 243 insertions(+), 283 deletions(-)
>

[...]

> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index e963701b4c87..6dc241f195a6 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -83,7 +83,7 @@ int ovl_copy_xattr(struct super_block *sb, const struct=
 path *oldpath, struct de
>         if (!old->d_inode->i_op->listxattr || !new->d_inode->i_op->listxa=
ttr)
>                 return 0;
>
> -       list_size =3D vfs_listxattr(old, NULL, 0);
> +       list_size =3D vfs_listxattr(oldpath, NULL, 0);
>         if (list_size <=3D 0) {
>                 if (list_size =3D=3D -EOPNOTSUPP)
>                         return 0;
> @@ -94,7 +94,7 @@ int ovl_copy_xattr(struct super_block *sb, const struct=
 path *oldpath, struct de
>         if (!buf)
>                 return -ENOMEM;
>
> -       list_size =3D vfs_listxattr(old, buf, list_size);
> +       list_size =3D vfs_listxattr(oldpath, buf, list_size);
>         if (list_size <=3D 0) {
>                 error =3D list_size;
>                 goto out;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index d915b87c0b06..c13f6b2c915c 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -291,8 +291,7 @@ static inline ssize_t ovl_do_getxattr(const struct pa=
th *path, const char *name,
>
>         WARN_ON(path->dentry->d_sb !=3D path->mnt->mnt_sb);
>
> -       err =3D vfs_getxattr(mnt_idmap(path->mnt), path->dentry,
> -                              name, value, size);
> +       err =3D vfs_getxattr(path, name, value, size);
>         len =3D (value && err > 0) ? err : 0;
>
>         pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) =3D %i\n",
> @@ -325,9 +324,13 @@ static inline int ovl_do_setxattr(struct ovl_fs *ofs=
, struct dentry *dentry,
>                                   const char *name, const void *value,
>                                   size_t size, int flags)
>  {
> +       struct path path =3D {
> +               .mnt =3D ovl_upper_mnt(ofs),
> +               .dentry =3D dentry,
> +       };
> +
>         /* Use vfs_setxattr(), not __vfs_setxattr(): it idmaps the securi=
ty.capability rootid. */
> -       int err =3D vfs_setxattr(ovl_upper_mnt_idmap(ofs), dentry, name,
> -                              value, size, flags);
> +       int err =3D vfs_setxattr(&path, name, value, size, flags);
>
>         pr_debug("setxattr(%pd2, \"%s\", \"%*pE\", %zu, %d) =3D %i\n",
>                  dentry, name, min((int)size, 48), value, size, flags, er=
r);
> @@ -344,7 +347,12 @@ static inline int ovl_setxattr(struct ovl_fs *ofs, s=
truct dentry *dentry,
>  static inline int ovl_do_removexattr(struct ovl_fs *ofs, struct dentry *=
dentry,
>                                      const char *name)
>  {
> -       int err =3D vfs_removexattr(ovl_upper_mnt_idmap(ofs), dentry, nam=
e);
> +       struct path path =3D {
> +               .mnt =3D ovl_upper_mnt(ofs),
> +               .dentry =3D dentry,
> +       };
> +
> +       int err =3D vfs_removexattr(&path, name);
>         pr_debug("removexattr(%pd2, \"%s\") =3D %i\n", dentry, name, err)=
;
>         return err;
>  }
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> index 5ae44b9c8790..b4658324b9f3 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -45,7 +45,7 @@ static int ovl_xattr_set(struct dentry *dentry, struct =
inode *inode, const char
>         if (!value && !upperdentry) {
>                 ovl_path_lower(dentry, &realpath);
>                 with_ovl_creds(dentry->d_sb)
> -                       err =3D vfs_getxattr(mnt_idmap(realpath.mnt), rea=
ldentry, name, NULL, 0);
> +                       err =3D vfs_getxattr(&realpath, name, NULL, 0);
>                 if (err < 0)
>                         goto out;
>         }
> @@ -86,7 +86,7 @@ static int ovl_xattr_get(struct dentry *dentry, struct =
inode *inode, const char
>         ovl_i_path_real(inode, &realpath);
>         /* Use vfs_getxattr(), not __vfs_getxattr(): it idmaps the securi=
ty.capability rootid. */
>         with_ovl_creds(dentry->d_sb)
> -               return vfs_getxattr(mnt_idmap(realpath.mnt), realpath.den=
try, name, value, size);
> +               return vfs_getxattr(&realpath, name, value, size);
>  }
>
>  static bool ovl_can_list(struct super_block *sb, const char *s)
> @@ -105,15 +105,20 @@ static bool ovl_can_list(struct super_block *sb, co=
nst char *s)
>
>  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>  {
> -       struct dentry *realdentry =3D ovl_dentry_real(dentry);
> +       struct path realpath;
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         ssize_t res;
>         size_t len;
>         char *s;
>         size_t prefix_len, name_len;
>
> +       if (ovl_dentry_upper(dentry))
> +               ovl_path_upper(dentry, &realpath);
> +       else
> +               ovl_path_lower(dentry, &realpath);
> +

that's ovl_path_real()

I have no technical issue with the ovl patch bits in this series.
Anyway, I guess landlock is not going to enforce anything on the
private mnt with ovl_creds anyway?

Thanks,
Amir.
