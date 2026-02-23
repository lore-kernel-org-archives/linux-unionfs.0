Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA5934EEFA
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Feb 2026 09:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771839328; cv=pass; b=lXRcOXU44gaCYSu5G1KxKShob9L+QexmspWxZ3DUQveUPRkz4cnnaKG3zLX77MLvGpiwdTgEQtiWUzefi+pPV43Sarn4LNtAmoKwqESOfeqsb42hz3SmvHP1EBocmcqEPhEdYllOmdg8ZNw7E6SQYIEIe+lLCt/QgiNT4vKHRno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771839328; c=relaxed/simple;
	bh=mAAOjC5VpT1HkXsRAwtGw0eUE/35I2Skqe677nArRZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tvgkJLyGgNlE1jxFTKHuF08XuXeEBoAUS0TNyQ8C92mJWOkTP7B5gJU5lp8sLYPO1kpmLGclvSLrKHfdfAs+Ubh/L9pS4wrXmXL//b23kWDu+uvxuXxVklM4Lrc947eLv1Zz+dk4skdPpfBcJPUEcbgWivlCGjjmcSlDDsdyjfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvjUXwJM; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvjUXwJM"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8860d6251bso552912966b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Feb 2026 01:35:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771839326; cv=none;
        d=google.com; s=arc-20240605;
        b=IqvEdz2DaJtN2rwP0SNl9x9aOJslxUKHpPStFoDVLNPlRXeCLnGDxwvS4dLg9DDBnz
         ftGcW0ITRNmLKZPRHkH7t9dBuNqU4r/Stxo1ZkbH4XhsxY7bwkBsw3kvB67w/WbdqgpC
         854+/MQsaB3OF/3VKb588ivhwxN9W2/kBL0L10IJnwBVbZudvP51tJ9stbYpWZ1BQIxs
         uEsi7Iqv7vO7nvRS511dowFqc7y4cOs3vL938vJimNNGt0PyNxOy+0n3OUoi0854cFcC
         X9/DsPZx0a3R757WrpR5xUVV1gR4HdcNzsMYeVCG1cEB3gJEpvQ47okobfG9bxIR7sw1
         ni2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5/tsVKpvOF9hjEuBModNYiVpSPXtrrKrMQ519faKcis=;
        fh=JQoiw5crek0nUCv1Nj75njeNTRhmGQQPezteehx2Hjc=;
        b=lr2l1rkmWdZvTxD6u5Ij2JkVz8m6tRaKbpTuex+SkPgtitALUMrXROnbwMArK7WvlN
         6oMRDUUL6yoakGOV1VtmNd8wTKrpkZDnZzQtsTCUSq3HTsfgMsR4gxSt0ssyuFkgTWCZ
         VdCbfcYvZSp/ccUFD8s3itkAh5uPmVsolUaPDE4F8ImBgw4+cCNA76N8J6fSRJ6ax4c6
         0ixZoZu6HllzbZVcz3PdNHX8/+bUCWCfAHrqo5X80S7S+ROuFxZkXiCnvIcNqLtegbEQ
         oiYkCTCbjTfIqCRvmYZDEkFT12Dv4IkYDTEKASYiMUJMOCgeuI/RGFvvi7FrU0SIeuWZ
         +ing==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771839326; x=1772444126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/tsVKpvOF9hjEuBModNYiVpSPXtrrKrMQ519faKcis=;
        b=lvjUXwJMFDUVNdE9/6JGFIIEgXAr+NW/nxJYiNKP83A2h2rSdOYnS2Qap5SEi8qvuc
         Xvv8mX7Ib5UTjZ2Ntgfe8sP1Y8sbStPRBVlVXYlUG96b6S34FcSJuKZLdABzCTwQSawB
         6kEeAv1Xy3QQTZBXYrCOuzdG6KW4vFjs2HUXgSqvz4TtzIzp1VaFIlsTAa6b5Sp1Jd34
         8+G7qchOZolFb2NrtqZ2ma6izvwW8ElQncc0YNDtZAtfeVwNdlTIquDlE1K/HvvMVBW5
         MVSWix+ReYo/KfT3GNcH4MXXhrxRSIQZW2RW+9DJtcTlAkJOfHQiKIYj+U2ejfaspoaD
         g7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771839326; x=1772444126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/tsVKpvOF9hjEuBModNYiVpSPXtrrKrMQ519faKcis=;
        b=Ang6WcIjsPmt6XWwAKmMBJnzZ+3xHMGmm40DpIhJQZ/PQL2FEOfmDFAaOMkxr8o6lP
         NNyUT7iyr0Fr4iUBoX0B3GZOYheIrutS1mhX1zBiRSMmuJv8hgu6JVLBvRmjKrgMhiKl
         kBS7ukdTHkr+hMgvpLN2TsxWH0GLWxIAz71z2HVFkGt0uHr44WXeZdSrMFDk5bXdbFOj
         x/oRt1eZnP0ifais2SiqARKZFUKcg6b6fgmx6EywjylOPtbUWa+nRZ/6f0zNlLl49AIz
         QeBQ9HfGmKwiLBtQLOh58y+IUy9bBYHd+21pXS5ElLm9zgAyPt2hVF/C/0IA4cHGHq+j
         xYIw==
X-Forwarded-Encrypted: i=1; AJvYcCXbL/tonJnryFBwuodMeWHRp8uiSphYP7/cf9dNFdJa/iD1iLVSfnom4PQTvEboFGQkBkxKGCNLttlwUoI3@vger.kernel.org
X-Gm-Message-State: AOJu0YyM74GxZaJqORfj9BcS/gAQWEWXTjzJo2ZsDQwYVkEMfoFSWkBG
	cj6JVWuYwK3agllxhJfoSuytJGntdLKxcQv1EadmPSai17/emOrulLn2pZutsOVTXobOh+kkqEm
	4MdoIuYQCEz1kPQaDsOUTnbfKdPKAAFY=
X-Gm-Gg: AZuq6aKmT9JtmCLJA9NmU9zEqAUS1ZDdbYBZh/pKHtJJeDsEBhCOc2rJYXYtNWj3jH4
	Uk1ja14wkGiF00KE3NiCVMX2dadhid1TQBJThHrPGPAAfk0BRxCWqdIegv3/Fd0dKj7m18yzpM4
	383cnpFU7NGKwNmhr8Qu2SkVIQTqXD6lqRFswsN9970eeFvjKCR2Sh88CjdST6uqX4PMXX1gad+
	kGGW7OFF5fJKHCbRtuRtgB0doNnbx+fgAf8B3vwnDrhzuqoJ5qevBqvHyNxKCgJCbY/eNzoAIeW
	9n8lMzkqlMbMDmiHBa3YFJUKTVFS4RIGfBzsq6SMbg==
X-Received: by 2002:a17:906:7307:b0:b88:5002:50c0 with SMTP id
 a640c23a62f3a-b90819db296mr564028666b.20.1771839325394; Mon, 23 Feb 2026
 01:35:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223011210.3853517-1-neilb@ownmail.net> <20260223011210.3853517-12-neilb@ownmail.net>
In-Reply-To: <20260223011210.3853517-12-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Feb 2026 11:35:14 +0200
X-Gm-Features: AaiRm51zLgcrRbPb_4HmwkH5uY0J9aukMWrvlX2vP_E-cCHRJFMZshxY7_A02Xw
Message-ID: <CAOQ4uxibL=2Z0FZMz5wMAo=JMaJouOVo3p7t3Fi3FR59U5Tu=g@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] ovl: pass name buffer to ovl_start_creating_temp()
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
> Now ovl_start_creating_temp() is passed a buffer in which to store the
> temp name.  This will be useful in a future patch were ovl_create_real()
> will need access to that name.
>
> Signed-off-by: NeilBrown <neil@brown.name>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/dir.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index ff3dbd1ca61f..c4feb89ad1e3 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -66,10 +66,9 @@ void ovl_tempname(char name[OVL_TEMPNAME_SIZE])
>  }
>
>  static struct dentry *ovl_start_creating_temp(struct ovl_fs *ofs,
> -                                             struct dentry *workdir)
> +                                             struct dentry *workdir,
> +                                             char name[OVL_TEMPNAME_SIZE=
])
>  {
> -       char name[OVL_TEMPNAME_SIZE];
> -
>         ovl_tempname(name);
>         return start_creating(ovl_upper_mnt_idmap(ofs), workdir,
>                               &QSTR(name));
> @@ -81,11 +80,12 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs=
)
>         struct dentry *whiteout, *link;
>         struct dentry *workdir =3D ofs->workdir;
>         struct inode *wdir =3D workdir->d_inode;
> +       char name[OVL_TEMPNAME_SIZE];
>
>         guard(mutex)(&ofs->whiteout_lock);
>
>         if (!ofs->whiteout) {
> -               whiteout =3D ovl_start_creating_temp(ofs, workdir);
> +               whiteout =3D ovl_start_creating_temp(ofs, workdir, name);
>                 if (IS_ERR(whiteout))
>                         return whiteout;
>                 err =3D ovl_do_whiteout(ofs, wdir, whiteout);
> @@ -97,7 +97,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>         }
>
>         if (!ofs->no_shared_whiteout) {
> -               link =3D ovl_start_creating_temp(ofs, workdir);
> +               link =3D ovl_start_creating_temp(ofs, workdir, name);
>                 if (IS_ERR(link))
>                         return link;
>                 err =3D ovl_do_link(ofs, ofs->whiteout, wdir, link);
> @@ -247,7 +247,9 @@ struct dentry *ovl_create_temp(struct ovl_fs *ofs, st=
ruct dentry *workdir,
>                                struct ovl_cattr *attr)
>  {
>         struct dentry *ret;
> -       ret =3D ovl_start_creating_temp(ofs, workdir);
> +       char name[OVL_TEMPNAME_SIZE];
> +
> +       ret =3D ovl_start_creating_temp(ofs, workdir, name);
>         if (IS_ERR(ret))
>                 return ret;
>         ret =3D ovl_create_real(ofs, workdir, ret, attr);
> --
> 2.50.0.107.gf914562f5916.dirty
>
