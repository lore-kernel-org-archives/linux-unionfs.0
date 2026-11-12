Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794482405;
	b=Cr25un5gndW37u+Jq20V4rKVbPE+jBMdH4aWNM05jtr+JbBee4qVlRALfHTA6vTF+aza
	 MUoyHILtnOQVHyWm4syxXGkOEGYNxCw11hXU39f1H+HeZE8BPUf0FasaoiV5XG2RwgAVL
	 DNVqs1B6HywFY5ZMJtSihAvgYgg0uWJZNEi8cNVsEFNLSJL+QNVgj8tsfacQtYZGMOD6J
	 Xc3ZcKJ7kofH3c/Wi0m2G8xN1IL+ZM7zuKeE8darHzyo8sov0gKjBgIC4mHS5O1oxxxKy
	 cQgGesscgK79OdEAnWPCN8XbcPDS85fZXvF/4eeyZvaRlyiwCdWrUakxDksxi7qWT9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794482405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VTglXy+2krUMdtb0w6gPQkgMvJl6AypaaGv2IAF/L+Q=;
	b=oXY+UL0whtu1mv4Kr2S6oiDo5cJuJKoRAdiiuC1rlsuQpnMUKGbisay9OnpypmkK7vAp
	 +6+um4tg9vC8ELfduwTNNtQwWbYVkfbGh5xO0Ew4TDiPh/wNSDqZvuK7zankrPtgh79oz
	 5JTKZybhgzpr1q1XVWtDdVhud6UUg6RkFl/+2BJXXbbGkG/smye3UCs8PvAJE5X8FHVQp
	 2ccssbfXy/plI4VhksOmhjf8cg9G59UaEmOvhvTHDyQ5ayjk4NeaFFhhrt07AetTjKBMl
	 IwmKQcnPMm6GwVnibAUbDbJ5aT3PKd9b7Jf+WQChvYBkmAULbrYC0a2cEM1mVNYxK0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Og6lJkpC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E646B606A33E
	for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 11:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E646B606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Og6lJkpC
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so1116527a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 03:20:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794482403; cv=none;
        d=google.com; s=arc-20260327;
        b=B0kdN7gWOaYsCfBAlHzxis9Nrw7EApIVxdBrtauy5rYbqq0xCUSV+JbNY8HFikYXp5
         XutjITVatRFwPEM8SW6GIlHEhdLSKemlKgsnTOO2iDf63WUyTc7nBpFecVkDHnOuvddE
         S7Y2xQkTNxL1ixwWqVI0nFJuZ/VBubxN218k9l+gi03qpzD7bom1ie/dsh0fL7fguSEL
         u4qZjfJo5ZtvyaOEYR54Ieobqf0CBcivMw82UPLDCaTCw+dCM/B3JkGBonmW06hd9B5z
         QhwINjjIw9CcRQq8USKVftRfcT/ITvB99ODsojwE8OlVPguTeNdQPR8/FuMOD6gC5GC0
         VGQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VTglXy+2krUMdtb0w6gPQkgMvJl6AypaaGv2IAF/L+Q=;
        fh=HaLpOlXk0VldQ2mVzGy/K+rLEFGfdI2xaqhOri/4pIM=;
        b=eiPw/frxCCWpXmeI9RzR70cA0P/NVMq3CrH7yWte57whe9Ye3kQZajLGFnOMAvEvAE
         rQkcwOLOYfipizb8YmWCXoQX+7mx6pTBXFrLARgSbgXR5TJehnqEYKXVSv2PMM0/neCx
         phesSBZNqT1IhzjugqQ+vW6tjXMNQwlFw4OZL0RCiHTJBCQyn1YkfSheKW2qc3jF+Jpa
         KKQU2tKqgTgqb01Ah8JrSbSWusuAqFpd+1a+9kIaXqTCDwl0zr0UGHEZjnzTftJ0XqxB
         AuJbaP1YDk52ZGzHeWatXHZDCNwfecVM+drLa5ikZd2J7GiwuaqHAafDAbivSlAlIHBq
         h2ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794482403; x=1795087203; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VTglXy+2krUMdtb0w6gPQkgMvJl6AypaaGv2IAF/L+Q=;
        b=Og6lJkpCZGCCzHQTeJDBK6mCfPw/+14zn7hZpdGDsCRyNlI0noaa65X8fQV7eRtck1
         ngkY58NbKFequQki+Zyazn6wM9DinrOu54k5jj7Hf/jwuCFIkWIxI/phPPsJkoyomLwG
         Ujh65QQxC0tnTo8DYW3Biv9Zpny6ZrZsPVsJHCyEhYH3xckawZpu3el8ZJTLJHznnvSc
         kp+5W4TnTa5zkyDDyvNQTdwntvXGSpOF80bNlepXmIHvg2rH+U7trMQRzqhkACD8ERK0
         6YekgRSfib99zFP4X55Yfnl6RrtgT0OgKgGE43YbUbH+N397W0abwzw3oLI/398Hbj1B
         eaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794482403; x=1795087203;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VTglXy+2krUMdtb0w6gPQkgMvJl6AypaaGv2IAF/L+Q=;
        b=ZFxkDgkDLDT1THWRKQGNtluEcZKFd3naw1+D38zr3r1KnKGnrtlOQlBPmSk+2UebLE
         sj6ccWIADeiBiEzn5rkp37U5+wOBUQVvH5ukPpd3QEQK1T5sWpOr1rbqfC5UedRIIaGo
         BgrfvQJCSgt86iSjSgF8iRtz4O0IPCfY8maYSefv/Dt4RNbiukeJ2Kul73zIXKTNN1s7
         Tf/XT0D3TXoT6t8/emQXkqaKhT9fSn0UAwLdkk7jRAF9AwugeebEES+Qy+wjl6+QhRV4
         96zljsBQxvutxiHY3GNfa/6LXr/SDqjhfONdgPBYZCP2lPx0JEHVKbZ+O/nGZXSfFVsP
         yFoA==
X-Forwarded-Encrypted: i=1; AL+hErFNTgeQwv2gpJ73ERidW5iisXNsSM5JP09VnxRiOcrJZlsHVYEoX3rwxrEpzkFfgn2nyftIWN/LSY/jTyxa@vger.kernel.org
X-Gm-Message-State: APuU4Z+R5RMPY6qoTD72u1HP5caL0KXk47yz425eeLDXYxE0O9kxOb9g
	1TJ9NSg2AvcyrOLn4htfyiPQl0Ym2tEbK+ziKJ81t6qRfVrkuiw7FwkDoUCH87jVQ9txGf6IOCj
	/r79Z3+huFPugCA32HvbYj8VAlxPoIt8=
X-Gm-Gg: AYBFou3LJr4HENsjH3qQUmWmz5ItAlq/c6df1o4zih1rPMlrZM69bJ8PUMkztzssfPH
	5A2TdBq+0RO9IgxQRWm/mrNExcSXFPqvRSdA3KyyuijPDvE79+Q/5RvnjO5LOM6GFZqSH2GficP
	ebucJW/6wZ5cWLUHZJ5EsBuLHNI0lqL7bgV/ElfrHA+b4pbtwzaC7rViPVMiVK9TP9xfH9DfhXV
	lOr6VG3cFlOJjtOyDWOFYfVgLY8xED1i9NSTly1pdHdgEbDCpKKg+OboPp45Vo5aNZVy1yra7q4
	1kTHOiRqBFKwgfI7y+vu2ICNR2EiFIcavarwErf6+9+Ffi4I7qGPMVbroO1muGBN8Xj+RwjA8TP
	Pp6BvbkiOIO8h1Fo5JkFK2pemsLsGQVmzfzPUI9naCG6O9zqTKYIAxCBdEvCC/LGvUeDcow==
X-Received: by 2002:a05:6402:22ca:b0:6b4:21f6:ff48 with SMTP id
 4fb4d7f45d1cf-6b7773418b6mr3084143a12.3.1794482403134; Thu, 12 Nov 2026
 03:20:03 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112-ovl-link-impure-v1-1-7804905610a9@samsung.com>
In-Reply-To: <20261112-ovl-link-impure-v1-1-7804905610a9@samsung.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Nov 2026 12:19:51 +0100
X-Gm-Features: AclHuK8j8C1jDU01PIIaLNz3c4Dysks-pyFxlkXuClWCxYjHTCcGRwGH-vgdal4
Message-ID: <CAOQ4uxgZfKXGDn=MaMZTXh2nUu=LZ5Zu0JDoJQhXfVcSA69bSw@mail.gmail.com>
Subject: Re: [PATCH] ovl: bump the impure dir version when linking a file with origin
To: daejun7.park@samsung.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 4:58=E2=80=AFAM Daejun Park via B4 Relay
<devnull+daejun7.park.samsung.com@kernel.org> wrote:
>
> From: Daejun Park <daejun7.park@samsung.com>
>
> Linking a file with copy up origin into a non-merge impure dir does
> not bump the dir version. readdir then reuses the impure dir cache
> built before the link. It reports the upper inode number as d_ino of
> the new link, not st_ino.
>
> Pass whether the linked file has an origin to ovl_dir_modified(), as
> rename and unlink do.
>
> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-98f207b6-3936-48e9-a40f-88f20be4d=
b7b
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Applied.

Thanks for taking care of this!
Amir.

> ---
> Tested on ext4 and xfs with default overlay options: the new fstests
> test overlay/013 fails without this patch and passes with it. So does
> a script that puts a whiteout in a non-merge upper dir before mount
> and links over it (ovl_create_over_whiteout()). Apart from
> overlay/013, only 079, 085 and 088 fail in overlay/auto on ovl-fixes,
> with and without this patch.

FYI:

https://lore.kernel.org/linux-unionfs/20261111132836.3495981-1-giuseppe@scr=
ivano.org/

> ---
>  fs/overlayfs/dir.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index e0a164e22d67..8fec18dc5fc7 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -368,7 +368,7 @@ static bool ovl_type_origin(struct dentry *dentry)
>  }
>
>  static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
> -                           struct ovl_cattr *attr)
> +                           struct ovl_cattr *attr, bool origin)
>  {
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent);
> @@ -393,7 +393,7 @@ static int ovl_create_upper(struct dentry *dentry, st=
ruct inode *inode,
>                 ovl_set_opaque(dentry, newdentry);
>         }
>
> -       ovl_dir_modified(dentry->d_parent, false);
> +       ovl_dir_modified(dentry->d_parent, origin);
>         err =3D ovl_instantiate(dentry, inode, newdentry, !!attr->hardlin=
k, NULL);
>         if (err)
>                 goto out_cleanup;
> @@ -491,7 +491,7 @@ static int ovl_set_upper_acl(struct ovl_fs *ofs, stru=
ct dentry *upperdentry,
>  }
>
>  static int ovl_create_over_whiteout(struct dentry *dentry, struct inode =
*inode,
> -                                   struct ovl_cattr *cattr)
> +                                   struct ovl_cattr *cattr, bool origin)
>  {
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct dentry *workdir =3D ovl_workdir(dentry);
> @@ -582,7 +582,7 @@ static int ovl_create_over_whiteout(struct dentry *de=
ntry, struct inode *inode,
>                 if (err)
>                         goto out_cleanup_unlocked;
>         }
> -       ovl_dir_modified(dentry->d_parent, false);
> +       ovl_dir_modified(dentry->d_parent, origin);
>         err =3D ovl_instantiate(dentry, inode, newdentry, hardlink, NULL)=
;
>         if (err) {
>                 ovl_cleanup(ofs, upperdir, newdentry);
> @@ -647,12 +647,12 @@ DEFINE_CLASS(ovl_override_creator_creds,
>
>  static int ovl_create_handle_whiteouts(struct dentry *dentry,
>                                        struct inode *inode,
> -                                      struct ovl_cattr *attr)
> +                                      struct ovl_cattr *attr, bool origi=
n)
>  {
>         if (!ovl_dentry_is_whiteout(dentry))
> -               return ovl_create_upper(dentry, inode, attr);
> +               return ovl_create_upper(dentry, inode, attr, origin);
>
> -       return ovl_create_over_whiteout(dentry, inode, attr);
> +       return ovl_create_over_whiteout(dentry, inode, attr, origin);
>  }
>
>  static int ovl_create_or_link(struct dentry *dentry, struct inode *inode=
,
> @@ -687,12 +687,14 @@ static int ovl_create_or_link(struct dentry *dentry=
, struct inode *inode,
>                  */
>
>                 if (attr->hardlink)
> -                       return ovl_create_handle_whiteouts(dentry, inode,=
 attr);
> +                       return ovl_create_handle_whiteouts(dentry, inode,=
 attr,
> +                                                          origin);
>
>                 scoped_class(ovl_override_creator_creds, cred, original_c=
reds, dentry, inode, attr->mode) {
>                         if (IS_ERR(cred))
>                                 return PTR_ERR(cred);
> -                       return ovl_create_handle_whiteouts(dentry, inode,=
 attr);
> +                       return ovl_create_handle_whiteouts(dentry, inode,=
 attr,
> +                                                          origin);
>                 }
>         }
>         return err;
>
> ---
> base-commit: 0d5e729c515f4ae4eacc179dbcf350d9b499a161
> change-id: 20261112-ovl-link-impure-8624810156d8
>
> Best regards,
> --
> Daejun Park <daejun7.park@samsung.com>
>
>
