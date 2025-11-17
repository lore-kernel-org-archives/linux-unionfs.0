Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414AA322DB7
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 09:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763373261; cv=none; b=PqZz8Wr7flofiT1uMEXNmq3ADe8X+iZ+z5BQCIbszilZilPJZt4TfDMx8YaMPQxmX+NtvibcC817siHQfDrh2cdfAQYzLhqLNx82gZBKwULaAOzqSa1AKYdSbA+urBrwiiNwY5Alh5kYjqZa3V6aPzQPiVzTNg1vQhEJ4U2AS1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763373261; c=relaxed/simple;
	bh=XpD10tiL67OuczhG07tB5rMjTZ3p+wG4wDitY6/j4Yw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H6HVSxgr+R6GMZPTUkJqrG+BmQKAXbHwwL4j1ezAot5TPYLEJeQCTFVRa/pJY4yq8oEJI8tlxDZW6zA8Mhu934jazI/yclwLLmhsBgvlK6ISRSt/i8oJlTolQ36ss0ZhZb781PaZwq8x894aF9F5lxt0goXTg3FF4dbGseTvQGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UlP2bJjc; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlP2bJjc"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so5638380a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 01:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763373257; x=1763978057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HD+aMtA5d+3kAnU5X6VmlRARaW2JSBOp81UKZkZrVUQ=;
        b=UlP2bJjczXWv8dBJ70TDCTyqRj1TGklJh0H2uc1/icTX4tG1IGcHWqF6QXQNMC3ppO
         E7tu6IYijFyWH69W21cEdkLDYWVFWTB6YWCg8KS+1N+VjdT8Bwy/VeQkuEPuQaOT5juV
         /66bwmCTJjzg4y9tFCrqejwQxPXwxew02IBQBYpLjyYwlN8tEt79KTffB6zDSGiPMRKa
         c07EoKB8TJCnTBfWjC4O+CsNcMKrVXaMad3eyS8SLCkNyIlbTeqDDxR6kcfWIxLIHZjY
         15deTXqer+/T7tj9lWBhswP6YxxSWlAON8eD1PmNBJGBUIsV9ywsir//M0YQN40Q0qtq
         7xPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763373257; x=1763978057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HD+aMtA5d+3kAnU5X6VmlRARaW2JSBOp81UKZkZrVUQ=;
        b=k3pPUPp6kimEcFdn+yuZoXEPlQGK2rlJ0BD7L5b+FMpj8lZbvUa+Udtg71tH1vVGQ2
         QA7E7G41XJtR5R0KdMtxPP5A8KS+Z2dxd9I2r/A2dL2McrezYiRPwOlYuRpqG8acXJC1
         2YQONb2nZhHg6zYh1sGXTa32o+sdMj8vtt8XjhnNHZVS/kKPvpkCa5FqfB/wQFlbWOkf
         RO+aLBwtBQQn4xR3VA8c30bzS8GEPKZGved0zeJrkyWfQkahRhCUDfkGLm/JzEYzu65F
         KxOErxgmVXtjNOBGhZlbM/JcpKt+YmjviS2dge0fYtOamFlZLF2YqE5AYjzfI/YcTWEw
         kGlQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7kSFlpQv9FCKCDdXfiCEBnV4XTH/AooH6MIWtTIyIlE4r2JKjmWiFq2o9GEtig8IqJHvbkIIqU9se+DMe@vger.kernel.org
X-Gm-Message-State: AOJu0YxJJ1MzDOrdFOSH5YkKn2E9xYq/Dg/4+aPXz+elRQKyrNisHuh2
	5QFS4e7NI7PJdJytKWKhdyqv3a8+h7beZ0WtVaLvt63TFr/bVvN3YwvdusJG72stJWB9j6kF5CM
	MUyWYrZP4rbvw0Z3daBUT+fzMdO7jvAQ=
X-Gm-Gg: ASbGnctkzvxomu0ABAFsb+u0PG9JyXI51oKB8+qNgwke7YPTJIvN5jf29DLRoxV+A0L
	LLLOyd6DIWx/ciMEfFXCC7cd38tDV60egQP5uG/3DwQRmexrB6LD0j+3gwVYNSDUuebBZ6etJ0O
	Ab2uRghD3MTPmkMNoCs/piWDdEAXv5XmvtSqj0wau+yAKcZ3yE5A402s3eTez0WAGmUMwnhHkY9
	VXwgDmIDb30Vl51ODLeo9VVa2L/OckSzpH1x236NKDmV/i+P8JgkihNHukt7OAq9BSUYbogtYKo
	juK5lnCOfIRxu3irMCzW9uykUAeyocKjeZXrOZE=
X-Google-Smtp-Source: AGHT+IG6n4ozUH+cO6JSRqMPvuXVQ6UnZHL5xUh4dDtn1wIlyDY76CWkmb82XPN0XilBnywRUXWIrP0C6C3fZsKmm7A=
X-Received: by 2002:a05:6402:278f:b0:640:f481:984 with SMTP id
 4fb4d7f45d1cf-64350e11448mr10579248a12.2.1763373257367; Mon, 17 Nov 2025
 01:54:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117-work-ovl-cred-guard-prepare-v2-0-bd1c97a36d7b@kernel.org>
 <20251117-work-ovl-cred-guard-prepare-v2-2-bd1c97a36d7b@kernel.org>
In-Reply-To: <20251117-work-ovl-cred-guard-prepare-v2-2-bd1c97a36d7b@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 17 Nov 2025 10:54:04 +0100
X-Gm-Features: AWmQ_bn39cEAku2hzpiTGBhj2c8YelvGhTIUXiuenD0_FyixjGJkX38VHO88pZ8
Message-ID: <CAOQ4uxivPErJ1MmOXB3roFup8T5jd429HHgJcLmYSgqskhApkg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ovl: port ovl_create_tmpfile() to new
 ovl_override_creator_creds cleanup guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 10:35=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> This clearly indicates the double-credential override and makes the code
> a lot easier to grasp with one glance.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 3eb0bb0b8f3b..dad818de4386 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1387,7 +1387,6 @@ static int ovl_rename(struct mnt_idmap *idmap, stru=
ct inode *olddir,
>  static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
>                               struct inode *inode, umode_t mode)
>  {
> -       const struct cred *new_cred __free(put_cred) =3D NULL;
>         struct path realparentpath;
>         struct file *realfile;
>         struct ovl_file *of;
> @@ -1396,10 +1395,10 @@ static int ovl_create_tmpfile(struct file *file, =
struct dentry *dentry,
>         int flags =3D file->f_flags | OVL_OPEN_FLAGS;
>         int err;
>
> -       scoped_class(override_creds_ovl, old_cred, dentry->d_sb) {
> -               new_cred =3D ovl_setup_cred_for_create(dentry, inode, mod=
e, old_cred);
> -               if (IS_ERR(new_cred))
> -                       return PTR_ERR(new_cred);
> +       with_ovl_creds(dentry->d_sb) {
> +               scoped_class(ovl_override_creator_creds, cred, dentry, in=
ode, mode) {
> +                       if (IS_ERR(cred))
> +                               return PTR_ERR(cred);
>
>                         ovl_path_upper(dentry->d_parent, &realparentpath)=
;
>                         realfile =3D backing_tmpfile_open(&file->f_path, =
flags, &realparentpath,
> @@ -1425,6 +1424,7 @@ static int ovl_create_tmpfile(struct file *file, st=
ruct dentry *dentry,
>                                 ovl_file_free(of);
>                         }
>                 }
> +       }
>         return err;
>  }
>
>
> --
> 2.47.3
>
