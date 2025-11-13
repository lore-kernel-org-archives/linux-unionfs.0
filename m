Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A77B2D7813
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763045744; cv=none; b=oYskcy0ynzEfmF3UlKvpN+yY1/atwS+mPP5LjEFSt9qVRdNIZOO1sz0DLu68zyJAxsLMzmzsAyr8kLrS2mW6l3zTD81jxX6pVDUBFu9V1cSUsGl3BrAUQyu4Sm5m7h4jJHO61Hu52rfdTP+X9G2Za2OKtqFtDEzfAh3JD94WZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763045744; c=relaxed/simple;
	bh=sh+s/qXUZ2rh64xsJiskmiVsNjJbWKe3f8tpt1C1q9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FeGR1Ncda7ymlY7QU1ghg5vV6i+LQntZZk9OGenK9HG9/H///AYwgiqZ3wrU1dM0cGncoEGxhG3XHEL97Wsok8G6GWA3Txnta5EUCXdQ+nj0uTqcGecJZMV2Yyo25eceH54mdji5BXJ9mC9JnHgPa7R2KMdXQv/ld5rMlhsbUxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d8OIQC95; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d8OIQC95"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so1333955a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 06:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763045741; x=1763650541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=brBUztMoH4YFBA+OILZ8WA/THukvBoRZDn7Cjylhh5c=;
        b=d8OIQC95LqPcIN1VDThalDj0fnw4Cg2VH7Sf1ZGg199xJfq64KYv469dyJdwkbYjy4
         rK/PaHTx8BC5cvLefS6UDavX7d9Hl3KxmI942H0+FQg2XPWG9ctM9CPR0jQQAI7og7De
         Fg/TmnH74bPTfREG7Qi/uuc0K/0wBy+PGMkXKOOCqUUyus+Gt4as7blpP1drJoD4RUo9
         feuTT3jF5CrY4TUSrjU5+Nvg1hYkZsQtnO90gXd0mtlB0AjEmDphvtLB35Vd+YWYB709
         D4SROUz3Uwvi/iJn3xu0HffYgoQg/UlIC4KOhCOzV3MzawI2bnEQvpY5vvDU6z6S3VUa
         leGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763045741; x=1763650541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=brBUztMoH4YFBA+OILZ8WA/THukvBoRZDn7Cjylhh5c=;
        b=KfS616qieQS2YqAtYMpPi5YTWd59AgAwb6Ma/nEpV8zorBVesXwMe5456MSQX5MNdK
         7Lt1mT3QAlprZGt4iAr8UYFE2CuYdvYmiIhMbQPZGxz2BLCOwhYrOEP5kzOy8zVeAo2X
         h+CSjJIUGAxy86BPasKGEToW28LDtUc6RmL7T47yP0T/UwRC8vBS1B66RSmrjZAdqmGC
         sMJtCMrrPwEcd0TGqZQzMaj6qml1YnWuDzW2JG7E0fK2YldDYjClUssCHOYu8PYQ68eL
         ONc8//mcPPp7HnhAVMnnohbzNlkD2Sh8ZAIXNDTcDBC/LSlCYkQgDbMoBRW3sN93hPjA
         JBHg==
X-Forwarded-Encrypted: i=1; AJvYcCVcwYmoDgz/tJwXa3mPD7y027BpYxr6mmj14O81YloyNKXShSDyHwBXvtTHEwNCw7JX8TjtZcI5u4rFR3FL@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8sYdSS08qAd4Ip8yS0e3gkD/OvD7kTcnOxKrXTAl/TGeJuuIR
	9XfqAEeEmCNIKSptGaonXs+1yZx5Z/mhdo0SOjxJ+98gMBdYZuO4oEl0xC+f+C2wP8ZHkqKqAA5
	TcH2oMZjUZbPq0mjfy9Gk20E9pNZNdNrjsc+f3Xi6fA==
X-Gm-Gg: ASbGnctiw01Xl2ATlr+8q7LRWs6kF4+Ps4Evhu+uLRHlHdfZd5QPx+ZHkfwLpqQDy2B
	XdCfUML8vFzYOGcpv8MiH8zOI1yFB1ahL9IGDDUyn04Be1PSFk0t50vJjpgNWD7FyFhL2xTL4k+
	u8f0PZilugu9n2DRYVKsmuoMrqEr2s6wZUntxrL7rNWepbjm3WFl5PtyTnKla5AavX01ipljEd8
	lp65JeCE3mp0BAWauBsBNt2TyU6VRWmKED55FTbQDXGS9TI/HZ5Y5gTqhy7hM5zF4i5YOBHm+pY
	GBI6QcVVkaGe2ELkjBxtbtf1SBAXrg==
X-Google-Smtp-Source: AGHT+IHUjcKnMtnbUJSDeWX8qrwzEWB1VSuoCBiY+ifJK1zUBE9Y2OIKcqhsDU18MRlSqP+8kQWMtpiBrn1h0V8fX/A=
X-Received: by 2002:a05:6402:2755:b0:63b:ede0:2403 with SMTP id
 4fb4d7f45d1cf-6431a53087dmr5888118a12.20.1763045741398; Thu, 13 Nov 2025
 06:55:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org> <20251113-work-ovl-cred-guard-v1-34-fa9887f17061@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v1-34-fa9887f17061@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 15:55:30 +0100
X-Gm-Features: AWmQ_bm9FLJN1i2PgXqkvdfpZmBvWeK6Ox2XgLgnUUJhJDja-FzbEgVOjH_l4aw
Message-ID: <CAOQ4uxhW7FyzC8xvAviebM6K1T0R+1VoqWc+UueMncSmuBaRww@mail.gmail.com>
Subject: Re: [PATCH RFC 34/42] ovl: refactor ovl_rename()
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:03=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Make use of fms extensions and add a struct ovl_renamedata which embedds
> the vfs struct and adds overlayfs specific data.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/overlayfs/dir.c | 271 ++++++++++++++++++++++++++++-------------------=
------
>  1 file changed, 143 insertions(+), 128 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 86b72bf87833..d61f5d681fec 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1090,103 +1090,36 @@ static int ovl_set_redirect(struct dentry *dentr=
y, bool samedir)
>         return err;
>  }
>
> -static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
> -                     struct dentry *old, struct inode *newdir,
> -                     struct dentry *new, unsigned int flags)
> +struct ovl_renamedata {
> +       struct renamedata;
> +       struct dentry *opaquedir;
> +       struct dentry *olddentry;
> +       struct dentry *newdentry;
> +       bool cleanup_whiteout;
> +};
> +
> +static int do_ovl_rename(struct ovl_renamedata *ovlrd, struct list_head =
*list)
>  {
> -       int err;
> -       struct dentry *old_upperdir;
> -       struct dentry *new_upperdir;
> -       struct dentry *olddentry =3D NULL;
> -       struct dentry *newdentry =3D NULL;
> -       struct dentry *trap, *de;
> -       bool old_opaque;
> -       bool new_opaque;
> -       bool cleanup_whiteout =3D false;
> -       bool update_nlink =3D false;
> +       struct dentry *old =3D ovlrd->old_dentry;
> +       struct dentry *new =3D ovlrd->new_dentry;
> +       struct ovl_fs *ofs =3D OVL_FS(old->d_sb);
> +       unsigned int flags =3D ovlrd->flags;
> +       struct dentry *old_upperdir =3D ovl_dentry_upper(ovlrd->old_paren=
t);
> +       struct dentry *new_upperdir =3D ovl_dentry_upper(ovlrd->new_paren=
t);
> +       bool samedir =3D ovlrd->old_parent =3D=3D ovlrd->new_parent;
>         bool overwrite =3D !(flags & RENAME_EXCHANGE);
>         bool is_dir =3D d_is_dir(old);
>         bool new_is_dir =3D d_is_dir(new);
> -       bool samedir =3D olddir =3D=3D newdir;
> -       struct dentry *opaquedir =3D NULL;
> -       const struct cred *old_cred =3D NULL;
> -       struct ovl_fs *ofs =3D OVL_FS(old->d_sb);
> -       LIST_HEAD(list);
> -
> -       err =3D -EINVAL;
> -       if (flags & ~(RENAME_EXCHANGE | RENAME_NOREPLACE))
> -               goto out;
> -
> -       flags &=3D ~RENAME_NOREPLACE;
> -
> -       /* Don't copy up directory trees */
> -       err =3D -EXDEV;
> -       if (!ovl_can_move(old))
> -               goto out;
> -       if (!overwrite && !ovl_can_move(new))
> -               goto out;
> -
> -       if (overwrite && new_is_dir && !ovl_pure_upper(new)) {
> -               err =3D ovl_check_empty_dir(new, &list);
> -               if (err)
> -                       goto out;
> -       }
> -
> -       if (overwrite) {
> -               if (ovl_lower_positive(old)) {
> -                       if (!ovl_dentry_is_whiteout(new)) {
> -                               /* Whiteout source */
> -                               flags |=3D RENAME_WHITEOUT;
> -                       } else {
> -                               /* Switch whiteouts */
> -                               flags |=3D RENAME_EXCHANGE;
> -                       }
> -               } else if (is_dir && ovl_dentry_is_whiteout(new)) {
> -                       flags |=3D RENAME_EXCHANGE;
> -                       cleanup_whiteout =3D true;
> -               }
> -       }
> -
> -       err =3D ovl_copy_up(old);
> -       if (err)
> -               goto out;
> -
> -       err =3D ovl_copy_up(new->d_parent);
> -       if (err)
> -               goto out;
> -       if (!overwrite) {
> -               err =3D ovl_copy_up(new);
> -               if (err)
> -                       goto out;
> -       } else if (d_inode(new)) {
> -               err =3D ovl_nlink_start(new);
> -               if (err)
> -                       goto out;
> -
> -               update_nlink =3D true;
> -       }
> -
> -       if (!update_nlink) {
> -               /* ovl_nlink_start() took ovl_want_write() */
> -               err =3D ovl_want_write(old);
> -               if (err)
> -                       goto out;
> -       }
> -


As I wrote, this patch is much easier to review when do_ovl_rename() is aft=
er
ovl_rename() (which is how I reviewed it myself).

> -       old_cred =3D ovl_override_creds(old->d_sb);
> +       struct dentry *trap, *de;
> +       bool old_opaque, new_opaque;
> +       int err;
>
> -       if (!list_empty(&list)) {
> -               opaquedir =3D ovl_clear_empty(new, &list);
> -               err =3D PTR_ERR(opaquedir);
> -               if (IS_ERR(opaquedir)) {
> -                       opaquedir =3D NULL;
> -                       goto out_revert_creds;
> -               }
> +       if (!list_empty(list)) {
> +               ovlrd->opaquedir =3D ovl_clear_empty(new, list);
                    de =3D ovl_clear_empty(new, list);

so ovlrd->opaquedir remains NULL for cleanup.

Thanks,
Amir.
