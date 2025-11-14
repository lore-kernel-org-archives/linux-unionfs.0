Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1132FC896
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 08:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763109036; cv=none; b=eWJlx0pX6QM0QgW3e+X5+yc8hs/lwhUv4vfDLEkL5kvrK0ZW1o3zAj+twV0S8aub3z+xa006GTmXYzkce43DS4XdRV9z7YIRp4op4qNE7/iFiJF5P5x5mTlp3N/EZVCr6qVpS3RUlGVCeQK0ZDJK7psrP3o69nm9EKykfrMpetg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763109036; c=relaxed/simple;
	bh=dpGwO/dDpqblq40ZZzxMsdYunoWqO5M+mx6i+V/UK/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j913aj0DkPV3ABlT+Mw3ZY8CXlJdXjsTc4irJB67dxuRA3KU6L+2LXtTT6Q7a/d3MMfJzx7yJM66yWcpl4vl5Cor+L+Hnkx20DFGNpZgw0wyPDaKJkZqFxt+0ib246H6lnvAfSgkma7qkq8bdogkPSHcd/Khos9IHH6kpvnM4Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FnKbBJHl; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnKbBJHl"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso2737133a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 00:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763109033; x=1763713833; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvsitE/jkDReCyki3DDP+osIQvy0ssqSWLWRa6XFyU4=;
        b=FnKbBJHlRx9HVTub0Y2Ro1oyZSkxBvn47VZifpZGld+HfXtPXt9pH7KLvwX4Xua0dZ
         9KIjAaUvLGsu15FzuTvTwIq41Nw1oa/BdKuKdkw8gMQlsrArxvWcxqaVCETqwLvMlIrd
         FLWZd451yH7Bia/exZf811T+K/OMvLAUmLHvsTjmF24/D50dEQdacHBKU7Am0oPXaxSE
         DmhChaPxX0ItRkWvGONdEjRwMqWMEPYhaI3P9ALRG8f79Kthz/Junzz8MY3BNaiGvltE
         mrO/ovc9QpAng7dNNnvqAhV6tEnYkeH6nraQY0YwEIRla5i8U0GVBanf21hkx6myYrxN
         HD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763109033; x=1763713833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xvsitE/jkDReCyki3DDP+osIQvy0ssqSWLWRa6XFyU4=;
        b=bV3pgQitBeVnKzYd1sQUrJG5KcAKC4IzPp0iMSwTYzEdRBQP6byv62jL8T5yJ0g1+1
         K5jHXQDr37Km7SFf1aSk4RNLxNCqmIpZC8BeoY5eewwb4eMwbMTnjMtv8kC2sybXTDsm
         OQ20bY7mXWmmh27McevyClM5OVSXU6Ea6iEawKgN45Fy6bNUUCYzFAzpkHmzSAA+AE/A
         WTnVrA2pu1yK+FgJtsCw4YkfXmnGdadMqIiP9QVy3lg8F6+762bDplWjfRF0bnRr84o7
         7DWsc8saKA9byb9OWF+kzRBU0wAZE2Wm5SEsiRe9UPBYGYABZX0aaFuGIWe214/Ot382
         sntw==
X-Forwarded-Encrypted: i=1; AJvYcCXNwyMLDZrDXC3WdVtqd9DPNLS5Z7GhFOQhXB5a3glSWkFwWZQxxxRXHlUmzFTfI9eAIbq6kLefOxDAL6CE@vger.kernel.org
X-Gm-Message-State: AOJu0Yy84sP6oqJ9ZjlnD03zpESbs9c3MAGZWRoeMWYx/bz40Uj5mKXt
	Ke/GuZVJKSRGIiZVFKkfggIhqA1VUV7sS5r5RIlOe8yCLfYMl5xWl9C9XOiEtBX+TZVi3i4Uw6x
	YuGHED4yCr/nDwyI1N7im49f7ZZ3+YZE=
X-Gm-Gg: ASbGncs4gH/zlUOIV3x+Yknh7F4AWK0f5fw+4yNkxaX9tDKypyulIOpNflHuSJ/s6Al
	Suh0GYmNnn/KKq1VGArn6XLuYyiz5rBZODEUk3Jt06dZQBCNtaf9aU51iRA9OA43LIQ26bzfv4v
	TCCVrDagzfhY8jKPW1zOOK7TXv1AKw2CHw41oSDUozNV5N4kmz0wH7yy6FqUVAWqalqC2xhduQm
	ZFVVAcIfmltqQNbfYvQT6s9V9H4tAmF9rvSnhcWAcVtOYUNMjdqIQKwOqpszmhcwGSMcTcfBvX6
	Zw2zUrCwu4r1m77vPIM=
X-Google-Smtp-Source: AGHT+IHJzxaRK8Asq9YaSnj5S6fb8s20cE+M5GB90hqWyC4wd8jjiwWd5GK8I52z4fddlgZwkTRI0FkuWBOoXguztG4=
X-Received: by 2002:a05:6402:3592:b0:640:7529:b8d3 with SMTP id
 4fb4d7f45d1cf-64350e2321amr1745928a12.9.1763109032759; Fri, 14 Nov 2025
 00:30:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org>
 <20251113-work-ovl-cred-guard-v3-6-b35ec983efc1@kernel.org> <CAJfpegv=yshvPv432F6ytAcuBLWQnx5MvRQjKenmzg-WafZ_VA@mail.gmail.com>
In-Reply-To: <CAJfpegv=yshvPv432F6ytAcuBLWQnx5MvRQjKenmzg-WafZ_VA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 09:30:21 +0100
X-Gm-Features: AWmQ_bkLyDK3lLIqHSO0J6tWhga_AZhxGu6KUzn_hLeMHfPqFhRW3IoEmQaNGzw
Message-ID: <CAOQ4uxjejHF5mp_vRdQG1W6HHdW87CphLH3tJ+Sucigo3hJfxw@mail.gmail.com>
Subject: Re: [PATCH v3 06/42] ovl: port ovl_create_tmpfile() to cred guard
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 8:18=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 13 Nov 2025 at 22:32, Christian Brauner <brauner@kernel.org> wrot=
e:
>
> > @@ -1332,27 +1332,25 @@ static int ovl_create_tmpfile(struct file *file=
, struct dentry *dentry,
> >         int flags =3D file->f_flags | OVL_OPEN_FLAGS;
> >         int err;
> >
> > -       old_cred =3D ovl_override_creds(dentry->d_sb);
> > +       scoped_class(override_creds_ovl, old_cred, dentry->d_sb) {
> >                 new_cred =3D ovl_setup_cred_for_create(dentry, inode, m=
ode, old_cred);
> > -       err =3D PTR_ERR(new_cred);
> > -       if (IS_ERR(new_cred)) {
> > -               new_cred =3D NULL;
> > -               goto out_revert_creds;
> > -       }
> > +               if (IS_ERR(new_cred))
> > +                       return PTR_ERR(new_cred);
>
> Same thing here.
>
> >
> >                 ovl_path_upper(dentry->d_parent, &realparentpath);
> > -       realfile =3D backing_tmpfile_open(&file->f_path, flags, &realpa=
rentpath,
> > -                                       mode, current_cred());
> > +               realfile =3D backing_tmpfile_open(&file->f_path, flags,
> > +                                               &realparentpath, mode,
> > +                                               current_cred());
>
> Where do we stand wrt "chars per line" thing?   checkpatch now allows
> 100(?) so shouldn't we take advantage of that?

For the record, where I stand is
I don't like to see code with mixed 80 and 100 lines
unless debug msg or something,
so I wouldn't make it into one long line,
but otoh I also don't keep to strict 80 anymore,
so I won't break lines like this just for old times sake

and while at it, why are we using current_cred() and not new_cred
for clarity?

realfile =3D backing_tmpfile_open(&file->f_path, flags, &realparentpath,
                                                   mode, new_cred);


Thanks,
Amir.
