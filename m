Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026B822A4D8
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763121878; cv=none; b=Ydj1Kq8oaD56GfJYn9yh3DFJodVNDu+ZUF5Q3+9HF4nbcwuGbdaKhaS8gp+tRazr8Nyyvl/rw87eKr3sOmCqMV6MDfqDXchrIMlx4z1zyVHiZ/mBoQbNIxT2Ei2MprLCUpj1D6zEMwkijMI9UOI7t/NirKe2tvg/rgDejPxoaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763121878; c=relaxed/simple;
	bh=x6xbQqDyq3/siOHNML7UHG7tz0oXBlvmioxxBnHgW8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XPOBrr0cef4PdqndeFJRR4AHJxlHBojUsfjhmAxAsZL/fjvwMZBXiYY+aSvQcJHCZl7UvVtEK8lZCr4KsHs4OgMcq0ITVrP/HNU919P2cPhHpt9AVo/boFYn/+WPeWga1cw9v1dJ0lglzgdnL8wICJLApN7bt/thspujCLh70Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ai9Olzdg; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ai9Olzdg"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so2986152a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 04:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763121875; x=1763726675; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+Ia0/YLClIePr23rrtQAMdjOjoBRt/r/u70odOG7PY=;
        b=ai9OlzdgiW9FiPgYSr1cAvA4wQ3aj0MPAgaBur6py3vt+hNo8Lo0d2JTh8YGkIDQpN
         lwoTQrXKDqa7e4+BqMWFOVETNgMeVhX/jSYAnvvmSZHe/e3uuDbFcCOWxMn7n1zNf2V7
         i7wOxISY2sSwXoUTS/onXfKLtzYT/FX4aPODwBqq4G73pl83pw7oli0oswpubCZV5DMG
         a1by19wIyQPwMY13myNbTgnWHkLMRO69o2jV3s10aE5mRJUFMzhWWcv+Y29+K6+Uzf5G
         5GqAwo6KtFUaQEVjTuJGL9W3OQHofQ60+MMd51oqUfON4JSq7JI33NtePJTec55K/WiF
         3zQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763121875; x=1763726675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J+Ia0/YLClIePr23rrtQAMdjOjoBRt/r/u70odOG7PY=;
        b=ePDuu3YMSGRCFC5WIsmgjpFq6uPGGig07KK5p1poFY3vMf+4WIexomW5ry1n3GCDkc
         q9+dJmX9vlc4vni7bOIqx9ZDR3e3a+pcIgxUxdtizjfg7cqWpuR4MwV3/hL1a7gJERPv
         CHBspNe8ri3jcquGMmqnuF+WQRKMGcD41nAHzrYaY7+wCohAUIku8vsXuAFXaNE0EZor
         eHGROrab1KyVs3sSWqW0TlzxebfomZ2ATuh3vtEtNkpH5Py9/Yb6R0mnvBLPYg724hqJ
         uEXiHObcdEKFp5K7Ipxz34c8gk1BEldywcpO+WB1gJLnWOVrB8dgOmVzgL0oPQLj1NTS
         4Qag==
X-Forwarded-Encrypted: i=1; AJvYcCUWQPlqk56XbuMRv7+Iu9OrthqMCXd8kUWpfzxJ3Jc1dpPzeRvhOb3moUnZ48j0fhiWoWjjabNT6MBbEU1C@vger.kernel.org
X-Gm-Message-State: AOJu0YzIKARn1iSRfyka2ifuGV8e2X5/cQVwT6ICQz8OQW6SKwj9nZ45
	V9TlGZ3jn4n+HN1fW0bF7mgF3V9Eoogz1UyaTDbYz4+EXpUQ6ZftgDpmeGWKecGFXrHmZ+HYs0X
	GeT+4ABBcf+22NQchbR0vf8OtS//LPTo=
X-Gm-Gg: ASbGncsAX92QazvecmFAkXkexZ3/HLYOCa6CA7xt08sjdB7b8kOrkvjiHWLQtTV4sbo
	hoHRlfDzBlD4OD/mRBOMG1Sx5ifUjOC8evKyRP4ZVizc2b+njKDxs+/ENU9pVbUsKNmthYJ2wKl
	4/I1KlIZ5BBCxIw/+V5EzXWxKP/EGvpaHbZW9hEiI8Ao7huUlxtb/7BeGglkxhGqp24MrKiovBJ
	XoDDMmnXM5m0324+HZoN2vqdTy2dkllCx6FUmPnw5d9BLUYsylfYYTAwK/NGaIMdjuyOBLbLYJC
	EEHUd9a5YUmgcJnPFUcc7nalyjq3Cw==
X-Google-Smtp-Source: AGHT+IFLPZRTeEBnp02A24BB11TzIc54P4/uz4OFeP6C6qvyCufMc0uePFFrCWp4el+uCuwHGruYX33UGp8Hti71IBc=
X-Received: by 2002:a05:6402:34c5:b0:637:e271:8087 with SMTP id
 4fb4d7f45d1cf-64350e89819mr1987517a12.18.1763121875253; Fri, 14 Nov 2025
 04:04:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114-work-ovl-cred-guard-prepare-v1-0-4fc1208afa3d@kernel.org>
 <20251114-work-ovl-cred-guard-prepare-v1-1-4fc1208afa3d@kernel.org>
In-Reply-To: <20251114-work-ovl-cred-guard-prepare-v1-1-4fc1208afa3d@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 13:04:22 +0100
X-Gm-Features: AWmQ_bmkCUnindwxUUrbK60hAuZ4mDBjDr7Rfbq7cP3I990uQcvef6d_qZPVQiY
Message-ID: <CAOQ4uxhpwpNKeTzR4D_LzOkwxMdpTrik0GmR1Z0UtMf16O29PQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] ovl: add prepare_creds_ovl cleanup guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 11:15=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> The current code to override credentials for creation operations is
> pretty difficult to understand. We effectively override the credentials
> twice:
>
> (1) override with the mounter's credentials
> (2) copy the mounts credentials and override the fs{g,u}id with the inode=
 {u,g}id
>
> And then we elide the revert because it would be an idempotent revert.
> That elision doesn't buy us anything anymore though because I've made it
> all work without any reference counting anyway. All it does is mix the
> two credential overrides together.
>
> We can use a cleanup guard to clarify the creation codepaths and make
> them easier to understand.
>
> This just introduces the cleanup guard keeping the patch reviewable.
> We'll convert the caller in follow-up patches and then drop the
> duplicated code.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/overlayfs/dir.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 0030f5a69d22..87f6c5ea6ce0 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -575,6 +575,42 @@ static int ovl_create_over_whiteout(struct dentry *d=
entry, struct inode *inode,
>         goto out_dput;
>  }
>
> +static const struct cred *ovl_prepare_creds(struct dentry *dentry, struc=
t inode *inode, umode_t mode)
> +{
> +       int err;
> +
> +       if (WARN_ON_ONCE(current->cred !=3D ovl_creds(dentry->d_sb)))
> +               return ERR_PTR(-EINVAL);
> +
> +       CLASS(prepare_creds, override_cred)();
> +       if (!override_cred)
> +               return ERR_PTR(-ENOMEM);
> +
> +       override_cred->fsuid =3D inode->i_uid;
> +       override_cred->fsgid =3D inode->i_gid;
> +
> +       err =3D security_dentry_create_files_as(dentry, mode, &dentry->d_=
name,
> +                                             current->cred, override_cre=
d);
> +       if (err)
> +               return ERR_PTR(err);
> +
> +       return override_creds(no_free_ptr(override_cred));
> +}
> +
> +static void ovl_revert_creds(const struct cred *old_cred)
> +{
> +       const struct cred *override_cred;
> +
> +       override_cred =3D revert_creds(old_cred);
> +       put_cred(override_cred);
> +}
> +

Earlier patch removed a helper by the same name that does not put_cred()
That's a backporting trap.

Maybe something like ovl_revert_create_creds()?

And ovl_prepare_create_creds()?

> +DEFINE_CLASS(prepare_creds_ovl,
> +            const struct cred *,
> +            if (!IS_ERR(_T)) ovl_revert_creds(_T),
> +            ovl_prepare_creds(dentry, inode, mode),
> +            struct dentry *dentry, struct inode *inode, umode_t mode)
> +

Maybe also matching CLASS name.

Thanks,
Amir.
