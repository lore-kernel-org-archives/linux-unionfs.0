Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964772030A
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040784; cv=none; b=A2rUB7c0E9BHiINnuIjlE/UYKMVX9W6qyBMMCvkYGjdb8bWW8/qAdlMBMP13+5bir/Pvq2gT+KRdKIi/1CcsAVHu2W5aIrTMoITdKP/JWydXxvNClD2dSSpejqx+zuCGqbBpAcnA46K/HVk+fCG5/uNnejV2rm9s9kuTqRMUaBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040784; c=relaxed/simple;
	bh=PWdWtpMwm7TK04XxRu0ZWopcsf9EJ+150nhJ8g682Ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IrO/we3+qvdJdPu7O0BPFmwIq4JLVF/rBqtxZDxeETZMivuMNY0xb/4n1I90fhKhiwBS0q29Lr+btwWAyX+QYlUm8lHGtrsvQ288eLWrFjIgGPHgEagZBbk9T6J4GMnPFgPNRxg8fHn8QbYXYcAlyxyXN6Ov585pI4FHku8L3No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OAsBu8BO; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OAsBu8BO"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so1478992a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 05:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040781; x=1763645581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8LGqwMAvQKE3C9UxWHGkwnvKdBLEoTQWuCK/v1mU08=;
        b=OAsBu8BOrOHMKkotWz7ZQhQNQm6yBcK7y8MGEqmW4H4ZvkXGCp8dPulCN/9gwIJx+p
         ZDIQoW00c4mVDafMeO+iHWhi4CRh4/5Wwu7KuXD9IMCdfKEXNTavmMiZV94ycqeTy5DR
         9C+lKGZA3yIovCGPPS4qIELCSUVl//+g9vW1QU+lABbaI0+zvBDTU6XaO1e97HUKXHM9
         UizEpUv3xYG0TQtOlDhLbJQtmDnQzlFNe5bv07DoFhY4avhzMXI05TFtVyLfaPj9yHZc
         ReO5eKjhY+TyVuHiixGojzZs93HhVLkVGTNY2Fp3Tt1vegGFIog4Ps4StLpIp1k5HKjQ
         6Vpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040781; x=1763645581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E8LGqwMAvQKE3C9UxWHGkwnvKdBLEoTQWuCK/v1mU08=;
        b=FC4rVip1d05ZmfKXInnTFcHuDjLS+xpk9o48hfcIsI0pEzay4XHZvT7j6ydqRLQxdL
         37Sj+fQdCpufwJzzOtYAHMT3/TDVNczD9FqVwH+amMOXbv3z+uLWtdTVoZMB/uQxwU1J
         NgRG7l3Fy68ZpP2Qga/EPVka+TG3n1y/zDGbwCpejqYGu5FCQ9D71uzyBPXvG5eFo2pU
         UA23uXgWP69I39VhEAcybVoyzOkS/CGtQJXLzugkPRFs22EqLHvcr2qTFJ//A5z8pqua
         yLuTIGh4PWt4TeHT9K94jIqv925gt+sSacIdih/pqm7AaLCOYvnRRS+KGmi0a/gAg2fJ
         Yugw==
X-Forwarded-Encrypted: i=1; AJvYcCURESd2OJBICZdDcUN+y7WGTbyet5T91UoKMUna1uVc60frEFuwUiwy2/cRjj3rFIfDp7FErhdbKP0b0anZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxhfaFBkZEV+SImfixXitZeeCh/gl9XfUwrfCCQwM22b9eLq3d5
	2KP8Lcr8JARZgpa5lFwfgVevB4d/kBOoxIByYlwZL/HTKCf6xzfKc/FGbeInCNbtaW7VKyzi/WH
	V5kg5NlvZyUYOvg3u5+BaEQL/IfMFScA=
X-Gm-Gg: ASbGnctiBf3Koa8V6jI6hw4Rs64eQfPG5bKBbAN3+lSQi8MGHqL74rQbCrq9ofNwjEw
	eouXx6u1a8C9UKcqVLuLEPbN2wlBg5yRqNA5SURu9LnbdM/iHVJaud73fuf0HaEy01Qzb0AAWB1
	2r7V0YTcIXE3juVqDQzG53mTVxvQ2030Vo8GIUYx/NZCl4aW1TvmGEPyG3iQpx50vy9Y09I4Kpi
	RmZTJP8PDpn5Xs3AzeXXmau0cCMAECoTb7RaYLUBkwSd9WL9p3UgXVG1VkyTyVQxMsuxAvcQrUL
	CUCCICS3SuRHrFzYKKT6xNngg27hqA==
X-Google-Smtp-Source: AGHT+IEaxOVDhsc9jZw1RYkKWH1/DrDjRSkatluW7LrAZDlgm9qz3UetakvQdTrECJNNy1tI8420S4+sCqsaHLVeMDw=
X-Received: by 2002:a05:6402:42c1:b0:63c:533f:4b25 with SMTP id
 4fb4d7f45d1cf-6431a4d60aemr6052357a12.15.1763040780787; Thu, 13 Nov 2025
 05:33:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org> <20251113-work-ovl-cred-guard-v1-25-fa9887f17061@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v1-25-fa9887f17061@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 14:32:49 +0100
X-Gm-Features: AWmQ_bllksn6y4glJIYhv-nklVzF7xmCVMWq03fTJp1rH6xOsLLGpbql0Ta6TgE
Message-ID: <CAOQ4uxhehyGUYS1rSs=8Qo9PHuHAR6S=WkY28r4o+jAjZ6UObw@mail.gmail.com>
Subject: Re: [PATCH RFC 25/42] ovl: port ovl_check_whiteout() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:03=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Use the scoped ovl cred guard.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/overlayfs/readdir.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1e9792cc557b..ba345ceb4559 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -350,26 +350,22 @@ static int ovl_check_whiteouts(const struct path *p=
ath, struct ovl_readdir_data
>  {
>         int err =3D 0;
>         struct dentry *dentry, *dir =3D path->dentry;
> -       const struct cred *old_cred;
>
> -       old_cred =3D ovl_override_creds(rdd->dentry->d_sb);

I think that ovl_override_creds() here can be dropped.

The only caller ovl_dir_read() must be called with mounted_creds
because it is also calling ovl_path_open() and iterate_dir(realfile

Thanks,
Amir.

> -
> -       while (rdd->first_maybe_whiteout) {
> -               struct ovl_cache_entry *p =3D
> -                       rdd->first_maybe_whiteout;
> -               rdd->first_maybe_whiteout =3D p->next_maybe_whiteout;
> -               dentry =3D lookup_one_positive_killable(mnt_idmap(path->m=
nt),
> -                                                     &QSTR_LEN(p->name, =
p->len),
> -                                                     dir);
> -               if (!IS_ERR(dentry)) {
> -                       p->is_whiteout =3D ovl_is_whiteout(dentry);
> -                       dput(dentry);
> -               } else if (PTR_ERR(dentry) =3D=3D -EINTR) {
> -                       err =3D -EINTR;
> -                       break;
> +       with_ovl_creds(rdd->dentry->d_sb) {
> +               while (rdd->first_maybe_whiteout) {
> +                       struct ovl_cache_entry *p =3D rdd->first_maybe_wh=
iteout;
> +                       rdd->first_maybe_whiteout =3D p->next_maybe_white=
out;
> +                       dentry =3D lookup_one_positive_killable(mnt_idmap=
(path->mnt),
> +                                                             &QSTR_LEN(p=
->name, p->len), dir);
> +                       if (!IS_ERR(dentry)) {
> +                               p->is_whiteout =3D ovl_is_whiteout(dentry=
);
> +                               dput(dentry);
> +                       } else if (PTR_ERR(dentry) =3D=3D -EINTR) {
> +                               err =3D -EINTR;
> +                               break;
> +                       }
>                 }
>         }
> -       ovl_revert_creds(old_cred);
>
>         return err;
>  }
>
> --
> 2.47.3
>
