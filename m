Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9B23502AC
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Feb 2026 09:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771839596; cv=pass; b=XU4lHZdLveuE/W1aLHZMC0Bqx+v7HTNXpAp8+8UNlB0v4FkJUe3dUi+ZWMOmkBRx34C3TIthHHi61LUW8ngXoTlQNb0S0dod8WmGx1TPKQEq/RvuNXpHUNRyQNUuhdkToxz5xqSswl5nvbsRvxwwRuYQKx8BCxtVgYHwl9WP8ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771839596; c=relaxed/simple;
	bh=NJ1uYV6m2U72UBoxmR+vF6VYrkEMBf80jlLMxt8Gixw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H8bHBk0xoZhQSvc+Quf2gbuUfvhOb463E/MAV8WBm65uQ7ndx0eUhGjORjy1NLGzgZ6OlRTF1Zf/+4vmjvxl3TMO9lsYp8u+DndjWELKiyVAuaTZdLqlav1WhzNSrJ0ouEN3nF7wZp+X3QBLqYAuhMSFaQDtWlRDKipXu6VizKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlcmmsH0; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlcmmsH0"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8fa449e618so652813166b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Feb 2026 01:39:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771839593; cv=none;
        d=google.com; s=arc-20240605;
        b=OmcJ20Fk6YAihE3NWajZ5GlC+vRb5IYBnDjNvacgrozW4HK6SWrYtV3yWaNnnPr4Ef
         hc1qXdK52TNGtzoOCYHuEpx98haLY7zXHfkdyHV4Waw78GV4aYTNfvBtX420VWT/2iHq
         QTyXRbfMSiWyF0a7ef/kOY91oJcq2aHpTCc4P+ztAk5YHUoFu0xfDbwT7UA9vtt8/U9X
         SeCRsbzA+tSjzSL8W7lemmoXlJYxpbcLZ6jciAm9rtvRplLI147elFTtsgvSGwkh2UDJ
         QQgSJQgSjtD/jNXhJYQ+NoMzIYkoMzxMm1b7Sly8usb42mOT8Osobk1I9VHnhqbafweo
         RZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CdIlV/ChuwGIF+GC1fBCbGy0HUmwCjEnTpmiQxTAsXA=;
        fh=gMJ9YNeFPfLS5vFQioxr6ExhgawFr/dxPX57uzDli1o=;
        b=VnsJIpIFU8NNOo93lWHlUxMq72QOSxK20Ggx8WKSxiEaVT6gv+X38dBR2adhcp2YC6
         eU9J8DUfz7lHtce7o3xCzeTklEipVGdsjWqY78D+GUIMKdtPIoHI1xqBMXd4a5p8+lOu
         cXxBDf/HQmXjXdhXH69ABcYvQprxlr6FQ95/67e2hNYcwEL5rYG92+VklaEne8peAUmQ
         P4PL2BeqP3dgOZLZmMES6Irn+kdGW/NONnDSBc7Bl4sKS7vcPgxBr5uyk2yTPSUvtPQb
         +xHuV7DEYWBOy1yIB7HK7SuRyZCnhl5EBQpTuHvrUQzM4xqXMnnjA/V/4Lqmq3gCrPIg
         Ij4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771839593; x=1772444393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdIlV/ChuwGIF+GC1fBCbGy0HUmwCjEnTpmiQxTAsXA=;
        b=XlcmmsH0zYD1X+yTHYMl0DcVs05x8iUOXogK5G9f8wY0DEuF25CYT0GMXhDFKEuj24
         RTwLnoN0prIew4m/ZpnwcNyNFGlMTLSCAb7e8KwXpSSqE9cLUNifwRVfQq69l4alOrO1
         2QispWmwpHhMj2NREr2qGt6mxiCJ0HsjhyRHukTMp3fwZq4Nv5WLeHKhI9qb3I1PsLBK
         4vyDryBbgKURNa31EE63S2dvlHwbem47p1xQHyzuTSdE7Ai0FynjEovHgY9aECY5Ymrf
         pVQUBeHDK6s3jt3Qf+L99uK6Vx5jog8HVabECYxA8zYQdSdJfSkOFLvEfQAruRD62wlR
         2rYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771839593; x=1772444393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CdIlV/ChuwGIF+GC1fBCbGy0HUmwCjEnTpmiQxTAsXA=;
        b=GGZEuGIHD5LgRIwMqE/XiVOJdReicIj94FMp/PAklM9eQPhV+mLJQyfcT1szlBF6O3
         K3X0+1d8q5rcxuWzXPQk0hJ9dzDsIqXELyTb+afoafeLO6T1B29N4JZ7uFTO/c7it6z2
         ueH6SkVnhCXxkVoxiv6gtJUWokf4YqE/HsjUgr+pfFi1om/4fhdrRrozozsXDZLkpetB
         Mo1xsJC7s5Zq1EHZ4zfltO7d4nFZPHzvCyju1pTxXIOi/rGH9fjag+77BdyvbCi2F5Ea
         cfPk7qarnsBbsOy6OWEDsRN4XDQiSLvT/knHMt8dBTVk8L/gvwwB6rQAIbUvVN2P1s14
         ObkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnNI1wr+HtyK4Fz8qSDvD1OJf7OxbhPz7L/pXR0VV4Q01zI6QMkeSI3o74HusGx8dIzwlSh4gqgkgUFdYY@vger.kernel.org
X-Gm-Message-State: AOJu0YxS8Xf+JDJ3W9yZl6vVbAQtrfKPqnV5lPjIRrXXOxH1nyvKqPKj
	xDSSDi74P+Sh3KDVgL3IHbe5yjST2gbmEkksC1MOuototCNDHyZ75fcdyT6S5D/bG9PbPRRf42d
	V4l3mYm4HVaXe9sxb6sOedkevcx+LvGU=
X-Gm-Gg: AZuq6aIwWvE27wh2l3Uw9POwla9EXFqlsStfV4sgnRv16sRg6F+w/sVH0bbD+hySKiA
	DgjhO9+4SZdknpnysJkSLtg9iqmkovQkOO0JVZmQHGF5gr/seENiShAo7gpDlr9jHP6jKpoi908
	r61A0DfpgP9LVfQhoyjYfwlUCbUztS0zTdo0TlhyTb17KeIzuFxYd0GjTnKRfDZHD80WCpg6hZh
	XihD7B91VgaL1vp+lNjTyQnflVeIxUq7TC09gRb8YaFUTfhmj1M8zp+30SzVwFJli3dscmiewej
	nEQTiw9ORaqoLlvwg08fV237X6BQF31jub3xgeOXzw==
X-Received: by 2002:a17:907:1c82:b0:b8e:9d66:f5fb with SMTP id
 a640c23a62f3a-b9081740d0dmr424886666b.0.1771839592396; Mon, 23 Feb 2026
 01:39:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223011210.3853517-1-neilb@ownmail.net> <20260223011210.3853517-13-neilb@ownmail.net>
In-Reply-To: <20260223011210.3853517-13-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Feb 2026 11:39:39 +0200
X-Gm-Features: AaiRm520yGF-zG-sk2MFqVbrXx4CSPHjFRw_GQJQRDsdMUgjtqZIz9W0G6HtkPM
Message-ID: <CAOQ4uxg0k2TMdmxoTL5-HW=5njZijX=FzMgWgVBa2GuHYV3-Zg@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] ovl: change ovl_create_real() to get a new lock
 when re-opening created file.
To: NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-kernel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 2:14=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> When ovl_create_real() is used to create a file on the upper filesystem
> it needs to return the resulting dentry - positive and hashed.
> It is usually the case the that dentry passed to the create function
> (e.g.  vfs_create()) will be suitable but this is not guaranteed.  The
> filesystem may unhash that dentry forcing a repeat lookup next time the
> name is wanted.
>
> So ovl_create_real() must be (and is) aware of this and prepared to
> perform that lookup to get a hash positive dentry.
>
> This is currently done under that same directory lock that provided
> exclusion for the create.  Proposed changes to locking will make this
> not possible - as the name, rather than the directory, will be locked.
> The new APIs provided for lookup and locking do not and cannot support
> this pattern.
>
> The lock isn't needed.  ovl_create_real() can drop the lock and then get
> a new lock for the lookup - then check that the lookup returned the
> correct inode.  In a well-behaved configuration where the upper
> filesystem is not being modified by a third party, this will always work
> reliably, and if there are separate modification it will fail cleanly.
>
> So change ovl_create_real() to drop the lock and call
> ovl_start_creating_upper() to find the correct dentry.  Note that
> start_creating doesn't fail if the name already exists.
>
> The lookup previously used the name from newdentry which was guaranteed
> to be stable because the parent directory was locked.  As we now drop
> the lock we lose that guarantee.  As newdentry is unhashed it is
> unlikely for the name to change, but safest not to depend on that.  So
> the expected name is now passed in to ovl_create_real() and that is
> used.
>
> This removes the only remaining use of ovl_lookup_upper, so it is
> removed.
>
> Signed-off-by: NeilBrown <neil@brown.name>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/dir.c       | 36 ++++++++++++++++++++++++------------
>  fs/overlayfs/overlayfs.h |  8 +-------
>  fs/overlayfs/super.c     |  1 +
>  3 files changed, 26 insertions(+), 19 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index c4feb89ad1e3..6285069ccc59 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -159,7 +159,8 @@ int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, stru=
ct dentry *dir,
>  }
>
>  struct dentry *ovl_create_real(struct ovl_fs *ofs, struct dentry *parent=
,
> -                              struct dentry *newdentry, struct ovl_cattr=
 *attr)
> +                              struct dentry *newdentry, struct qstr *qna=
me,
> +                              struct ovl_cattr *attr)
>  {
>         struct inode *dir =3D parent->d_inode;
>         int err;
> @@ -221,19 +222,29 @@ struct dentry *ovl_create_real(struct ovl_fs *ofs, =
struct dentry *parent,
>                 struct dentry *d;
>                 /*
>                  * Some filesystems (i.e. casefolded) may return an unhas=
hed
> -                * negative dentry from the ovl_lookup_upper() call befor=
e
> +                * negative dentry from the ovl_start_creating_upper() ca=
ll before
>                  * ovl_create_real().
>                  * In that case, lookup again after making the newdentry
>                  * positive, so ovl_create_upper() always returns a hashe=
d
> -                * positive dentry.
> +                * positive dentry.  We lookup using qname which should b=
e
> +                * the same name as newentry, but is certain not to chang=
e.
> +                * As we have to drop the lock before the lookup a race
> +                * could result in a lookup failure.  In that case we ret=
urn
> +                * an error.
>                  */
> -               d =3D ovl_lookup_upper(ofs, newdentry->d_name.name, paren=
t,
> -                                    newdentry->d_name.len);
> -               dput(newdentry);
> -               if (IS_ERR_OR_NULL(d))
> +               end_creating_keep(newdentry);
> +               d =3D ovl_start_creating_upper(ofs, parent, qname);
> +
> +               if (IS_ERR_OR_NULL(d)) {
>                         err =3D d ? PTR_ERR(d) : -ENOENT;
> -               else
> +               } else if (d->d_inode !=3D newdentry->d_inode) {
> +                       err =3D -EIO;
> +                       dput(newdentry);
> +               } else {
> +                       dput(newdentry);
>                         return d;
> +               }
> +               return ERR_PTR(err);
>         }
>  out:
>         if (err) {
> @@ -252,7 +263,7 @@ struct dentry *ovl_create_temp(struct ovl_fs *ofs, st=
ruct dentry *workdir,
>         ret =3D ovl_start_creating_temp(ofs, workdir, name);
>         if (IS_ERR(ret))
>                 return ret;
> -       ret =3D ovl_create_real(ofs, workdir, ret, attr);
> +       ret =3D ovl_create_real(ofs, workdir, ret, &QSTR(name), attr);
>         return end_creating_keep(ret);
>  }
>
> @@ -352,14 +363,15 @@ static int ovl_create_upper(struct dentry *dentry, =
struct inode *inode,
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent);
>         struct dentry *newdentry;
> +       struct qstr qname =3D QSTR_LEN(dentry->d_name.name,
> +                                    dentry->d_name.len);
>         int err;
>
>         newdentry =3D ovl_start_creating_upper(ofs, upperdir,
> -                                            &QSTR_LEN(dentry->d_name.nam=
e,
> -                                                      dentry->d_name.len=
));
> +                                            &qname);
>         if (IS_ERR(newdentry))
>                 return PTR_ERR(newdentry);
> -       newdentry =3D ovl_create_real(ofs, upperdir, newdentry, attr);
> +       newdentry =3D ovl_create_real(ofs, upperdir, newdentry, &qname, a=
ttr);
>         if (IS_ERR(newdentry))
>                 return PTR_ERR(newdentry);
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index cad2055ebf18..714a1cec3709 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -406,13 +406,6 @@ static inline struct file *ovl_do_tmpfile(struct ovl=
_fs *ofs,
>         return file;
>  }
>
> -static inline struct dentry *ovl_lookup_upper(struct ovl_fs *ofs,
> -                                             const char *name,
> -                                             struct dentry *base, int le=
n)
> -{
> -       return lookup_one(ovl_upper_mnt_idmap(ofs), &QSTR_LEN(name, len),=
 base);
> -}
> -
>  static inline struct dentry *ovl_lookup_upper_unlocked(struct ovl_fs *of=
s,
>                                                        const char *name,
>                                                        struct dentry *bas=
e,
> @@ -888,6 +881,7 @@ struct ovl_cattr {
>
>  struct dentry *ovl_create_real(struct ovl_fs *ofs,
>                                struct dentry *parent, struct dentry *newd=
entry,
> +                              struct qstr *qname,
>                                struct ovl_cattr *attr);
>  int ovl_cleanup(struct ovl_fs *ofs, struct dentry *workdir, struct dentr=
y *dentry);
>  #define OVL_TEMPNAME_SIZE 20
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index d4c12feec039..109643930b9f 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -634,6 +634,7 @@ static struct dentry *ovl_lookup_or_create(struct ovl=
_fs *ofs,
>         if (!IS_ERR(child)) {
>                 if (!child->d_inode)
>                         child =3D ovl_create_real(ofs, parent, child,
> +                                               &QSTR(name),
>                                                 OVL_CATTR(mode));
>                 end_creating_keep(child);
>         }
> --
> 2.50.0.107.gf914562f5916.dirty
>
