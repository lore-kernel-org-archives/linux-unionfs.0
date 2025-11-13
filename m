Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDAF351FDE
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040546; cv=none; b=NCNRjK/o2VaSkjabHTo4kJi5deIB2DOqjaFH444NNkIIss5dsUOked5yEPvE9tkLCAoPzvYVzcQEGrVzxIgzVL5uzKvJlqATO6JV5ay3HHBkWBIt4/Wok7MNvgFKt5GgnnaCSFNzNuFlRrTJVq2Z17IJG26kEeSuWvApP0PKXS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040546; c=relaxed/simple;
	bh=X2R+F/XRtaKhmUDSKPMYcTX6v8IAEUkyS/OWFpx+E2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uq1UImOl1q8WnowHpoHKTz9SKAksWYXFIU/O2Q5WBt9EtuzkIkJ5i/Aw9C2m6B3mhD7/vNhFWx+0ySl5FaxTSrEhMFdyaLg39Jr0/CoefOUJtYVebjdEhW8GNVUmjlZLjBp49IMWlGk69O+LF18jIlprS1VtdR8N9QTiPKQMco8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eUf+W6FA; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUf+W6FA"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso1518711a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 05:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040543; x=1763645343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oY71TIPYVN9PuTiZ3OlvZTDSV+me+lv0LSynZBsnDaM=;
        b=eUf+W6FARmBejhLDTdbSSxh8+IN5pl4cUzj7BTggr3MXR8y26RgddMXJ8LFw2ZSGHz
         iebTeyqOE+ghXtuw3N4h0ZqY3naaCk3Aio5UmtawkwpUJ8XcMd/EPVEot02OBvNCk/28
         NWkCvYTVifpUy1b627ojojUjvtNO+GlhIW/pQoBOEJydxzoJYjyDS7J464WWR5n5rcf7
         OZhdCyp5ulxhLZTqcSyR3zmeTUnFF3nNHbG3QYtYLNZ4Bu6IPaR073h3jN7Zk4A0AZrs
         OehtGsDbTXCWxy6TMrHPA1EaTc9z3YL44YnKa+LjDjMN403gnRELCZO8s2Q09RTRnBwU
         LVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040543; x=1763645343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oY71TIPYVN9PuTiZ3OlvZTDSV+me+lv0LSynZBsnDaM=;
        b=j+Sz1/NjjvM7Vzmch6U1gRx2OznO3QSPHq9tyxXr08dWzs7lyiQ23KT9P3CxkIp8my
         fnmcGyebNGRBoWqxbguSiVyRLEh11oqtIZ6US2akn4o2IdLtJUYhakdTvQx3EHZluP4L
         j4qilDJSGeokGN+V5qB2qay5nVmbe1bgULdQqxReMDjq6ZW6r1Y6co7akih9nkqeTgdI
         cBLwqULXsicjY0/hCLUlPnxcHogSv7VHtYNrRweB4PWqt/pfpNb3pzduytBPdIOsblDz
         UyF6CRAp50ud7tPeE13DAIkrarAiutUK0xn17m9tbE1AtCeLitCwJ0WixpiEqYaaLgTa
         Lr8A==
X-Forwarded-Encrypted: i=1; AJvYcCU2BXcwwQBEdyWCqeu+4rH3RjebuHQ5eIy7Byvv0ev+XW8WgfqrXKvjas+FDPpehLPn8HKg7ShY9Gz7R0GL@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr5kY0hMusYADwlgq54pQA0vwMH3wn/0koUhAZVkOEIwbar5Jk
	GuvuTuoVoOF4l/8ibAcMzavFFfuQqQUK29ro9harmOn4C4E/hXXBPqxlsYpcr7/NHJEuM5fJnqO
	uRVBZIs5cHRzngX6NwDI2GD/+cnmfTD0=
X-Gm-Gg: ASbGncuYNceeDuDHPpjxbdKhoSD1glza8SpfGEHmnOOMPhrIzhsG/0sAuDv+Pbi7vw1
	cGR0nNfX4YWzgjT70CplhrDKA/riLKTN8c04XPAEKSpydFwTCpeoOW2Ek+IzoV/bpGbcqUD06sn
	WaBdunrdseVjrrHuAJ/KlieJe3j3YWeYRWUs41NH2avQuL8ArMFW792OC+G2b4trWpQk7j/Njxk
	9NBQBLnFr6zj270s9EoGWAFN/jXihG8drEgzy5u9DH71KkBODtZhT3PWMSn36fR3kuRjI31R+Fu
	tzezL2oHANWMcnLBpjc=
X-Google-Smtp-Source: AGHT+IG6QRdFBuSfgkoabmXTvXE8ZnDE+eQzyviPPzlvtafhiPqXkvftCkuT4MQoh0Za7vLQNsP91nL7FaNQn+LD8Rw=
X-Received: by 2002:a05:6402:1cc1:b0:643:46cb:dad6 with SMTP id
 4fb4d7f45d1cf-64346cbdd85mr682950a12.19.1763040543274; Thu, 13 Nov 2025
 05:29:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org> <20251113-work-ovl-cred-guard-v1-15-fa9887f17061@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v1-15-fa9887f17061@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 14:28:50 +0100
X-Gm-Features: AWmQ_bmfC3d1_ow-oZGvxLTAnQ7gAY9RNR8soroa1d8l0d8d2H5GDHsMtZAD7qM
Message-ID: <CAOQ4uxjGAz+WR0iseLLrMskseqGgQGEoVrJo1Jm_yFCnx=W3YA@mail.gmail.com>
Subject: Re: [PATCH RFC 15/42] ovl: return directly
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> No need for the goto anymore after we ported to cred guard.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---

The subject is too generic ;)
but I think this one should be squashed to prev patch

>  fs/overlayfs/inode.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 5fa6376f916b..00e1a47116d4 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -178,7 +178,7 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct=
 path *path,
>         type =3D ovl_path_real(dentry, &realpath);
>         err =3D ovl_real_getattr_nosec(sb, &realpath, stat, request_mask,=
 flags);
>         if (err)
> -               goto out;
> +               return err;
>
>         /* Report the effective immutable/append-only STATX flags */
>         generic_fill_statx_attr(inode, stat);
> @@ -204,7 +204,7 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct=
 path *path,
>                         err =3D ovl_real_getattr_nosec(sb, &realpath, &lo=
werstat,
>                                                      lowermask, flags);
>                         if (err)
> -                               goto out;
> +                               return err;
>
>                         /*
>                          * Lower hardlinks may be broken on copy up to di=
fferent
> @@ -258,7 +258,7 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct=
 path *path,
>                                                              &lowerdatast=
at,
>                                                              lowermask, f=
lags);
>                                 if (err)
> -                                       goto out;
> +                                       return err;
>                         } else {
>                                 lowerdatastat.blocks =3D
>                                         round_up(stat->size, stat->blksiz=
e) >> 9;
> @@ -286,7 +286,6 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct=
 path *path,
>         if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>                 stat->nlink =3D dentry->d_inode->i_nlink;
>
> -out:
>         return err;
>  }
>
>
> --
> 2.47.3
>
