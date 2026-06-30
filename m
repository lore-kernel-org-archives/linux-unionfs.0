Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3DE3F1AA7
	for <linux-unionfs@vger.kernel.org>; Tue, 30 Jun 2026 10:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816979; cv=pass; b=SS0vN9PEZX6xI2/NBn/ioH+KqC3kG6iKOF3xS4LR7SmC9se7bmCCNuJyLAQjka11pZntyvmV3w9LRKkVuDMvxYDCcycIwhfi900m/AIkzoXhQ1IYT/yusN0Cwl8s6BqypHtGzNvzFYf4d+XQrb6QA79NljjPTYHVwAHzwASNXc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816979; c=relaxed/simple;
	bh=Orc7+0NqtvmGA5vexJkJx3paGEv0TuaCQx2/aawkYMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O46sHCw5CmejoJrAyDrEEI73IZAN6wokojpMn/6JEF0zI80d5A9lIzQMIbCqrH0rnk9bI0bQeLDZEoFOTJdf3U1UPipAa2N9x541jgh/45K2ZyjwpuWyQn/8xd5tOs37RLi7rd2Xiipi4AWL1CrAi/ZVilHoq1rd9YBNf+HlcMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DSJQnwGS; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSJQnwGS"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-697ebe536b6so6975131a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Jun 2026 03:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782816973; cv=none;
        d=google.com; s=arc-20260327;
        b=XLdJfCwUGqr8xlXy7m3JLL7ztgHF3hrhx4ekZT3cbUQ3I3R7yhYwuswFy/fdBJbiQ1
         aH7qqQEvwpJ83sVlwlokSnbCVtuTKaD2NjzEQo4kVeoBs5H5jH2LN33WurITmnuLnDKI
         0nWmbrEX7kzjUevJDlSkr0dYa2o8YHkcOYUYnVj/0nXP3c3t440OqvyytzaQlR7JsLh6
         s2nJ6Ha2qOhVkSxt719AUETxqqgVY+vNYiGMXEkV1jTbv/sCJZWXIHq8iKTjd6+DKaOS
         j8lnH9dkQUH+H3HwURrgk2MEMgUijMwYSu68l5RIgr80DuQ8YFpXPWS3pnHDEnq4fY3+
         kaOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p0A4syWLh4jWZqK6Nlb5P1GnOuC5t+TuDmqTBq/uuSo=;
        fh=ZlwKLIDFfy6pXfR9hK+io/jS6XmVheiGU4xwe4yPA0c=;
        b=AdjlhXwsf1tjDw7wsqDKQ84jVlSBasNs5mw3I8NOSFZ3rQjZfGdbT7Zv5RjllOraDx
         yoLTqSoOP2joe81Do12WD8X6FGgo3Kt25rONBFS5wkgj7Couz+o86OJ4uCwYNR63kSfL
         z4bi36rzsgEq/8eoPXX5orZFnijAC1dw7njL3SO1zq2nMiX3yCTNEJbIf29EoYq0zMNh
         Qzbpxa0/dqadVColY0Yz+IBP/4QI2t8i4i7wEkj+oFaCGMNe6aH8BOdI4Vdipvkx5+FT
         9+DqDE752/TyconjRQcZrwHx93T3ARYwdswM22R1XQKDQr4hZbQKKqZJ6VMOtcDfUFUT
         mqKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782816973; x=1783421773; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p0A4syWLh4jWZqK6Nlb5P1GnOuC5t+TuDmqTBq/uuSo=;
        b=DSJQnwGS0ZuZWFsBUSJ55ryVDr7IBWBum0gRHOr3dr+efvMYrKz/ZyM3P9onhRZKua
         6nC3VH6UFjVCitUlXogqVEKbnr+C50LNbGvSyh3cyXMdh5qcAyx7s1v/JY4L5SqZj9D6
         4sWuYSCXnmq3ngFrnPiG0W1psqR44azq1fBIh/4Vir/X3xXlwuIvBCu51B5j59thHJbG
         9c4IcOk8PO+qGHzBhqMjVg0yvoDnvp4rJDRkWb7/EFjr43CZBHU6z41j1vz/oj8d8cGn
         iisZuPMyV+CeF1VcTywbt48Hym7ibK4Po9LwkaLgR+qiCHeB2FCSVzCFYmG9niYOYbrR
         uYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782816973; x=1783421773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p0A4syWLh4jWZqK6Nlb5P1GnOuC5t+TuDmqTBq/uuSo=;
        b=So7711uP1XE3TeXPzORhGzmcsVcmeidK5j4FUwWRGfOfP/ZxCbwLHcToBEzl8q3fvM
         8dkjzVl7rWHR7zXsUj/Tt1YIlQxPfbT6idx9k/VU3E2Msnus1PxQbq6srq402TZRkMfn
         GjDKS7lCQHCpKJoLLDzwsy/KP7OmnRxhskQL4SosW8w+J4j1uPQxJcohONPfD6XDR31b
         RUqurV/HdItgPQCV9u8KfPlXRIFhh0bLi0m08GkWXmXeOGk7OpXsV2EhUfI/C5qlV+xQ
         wVrRpIbyLaxv17AQmVpiViHdlJWduKJ2a5kUk4btG7nIUeh/ts0f8ViAOkF1d6x13dGW
         zvbw==
X-Forwarded-Encrypted: i=1; AHgh+RrilpOFa+iTcPsWT90caarU+MtkoLsHlqSZIu2rGESq2OOsB5MV3NQY5jhr6VwIWmtp/Yi/fil8OBk64q+D@vger.kernel.org
X-Gm-Message-State: AOJu0YzsVv9tLuSY0wcmcmx8QUnCfAnlRQP6W4NadOUkqO/wq0/GPbRO
	epE/U56AqIIuPvUa1zhi8AniDqkXx7WXRYtPiuEmgTmyVdnKBxf8xjWOmw5s/YSkRyg9fHd9zQ4
	kpM+WvAhmV3dtRzRICTuXDQkILFb1tFk5pLKDs/4=
X-Gm-Gg: AfdE7cknV7gZ7U2jfk5ZaJ4Vp6qO7YNVb1KYmq98Nmt+3rGZgDLc5bzMqdJXYnSOk/V
	HSQ8JOX6Ne40rMf6nfUbDXK3oKnEQ40X1VlE3lA3h9sesn7jBpzz2qjYBbl03mxfh0v6zOkwA4R
	N9VT0+B6DT70EypU8mWwWWyqR0kImBisUVP7ekYq68/Qm+SX78dzhJfQB/oXUQFy6GmTlLz2PJc
	uCa3ihr1s7DIZrN3x0YCjjCGhT78F8nhvVzI54x3+fSeI4YIhciOTCQjwxEGv9aymZeduxl5Rzj
	ilfxLmfaTVDE/xTTOuxb0pPz6gWQhnQ=
X-Received: by 2002:a05:6402:5487:b0:698:bbe:9c8 with SMTP id
 4fb4d7f45d1cf-69879de69bamr1227728a12.15.1782816972468; Tue, 30 Jun 2026
 03:56:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com> <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com> <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
 <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner> <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
 <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
In-Reply-To: <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 30 Jun 2026 12:56:00 +0200
X-Gm-Features: AVVi8Cce_xT1IqdadZbbNXWS9V0ahfJfi6147JUNn_XGlol1jGtfRLAq44glwps
Message-ID: <CAOQ4uxhN_K23C359OLpF9mTe8-90qBvKS+dTwf5+WVvxr-0Jsw@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Christian Brauner <brauner@kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 9:55=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On 2026-06-26 17:18 +0200, Amir Goldstein wrote:
> > On Thu, Jun 25, 2026 at 12:36=E2=80=AFPM Christian Brauner <brauner@ker=
nel.org> wrote:
> > >
> > > On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
> > > > On Tue, Jun 23, 2026 at 4:55=E2=80=AFPM Pavel Tikhomirov
> > > > <ptikhomirov@virtuozzo.com> wrote:
> > > >
> > > > > On 6/23/26 15:48, Johannes Weiner wrote:
> > > > >
> > > > > Yes, AFAIU in overlay when we use realfile we should always use i=
t
> > > > > with_ovl_creds(), even though I don't think there is anything cre=
d related
> > > > > in filemap_cachestat(), I still think we should follow the common=
 pattern
> > > > > other overlay helpers use (similar to ovl_fadvise() and ovl_flush=
()).
> > > > >
> > > > > note: Actually some places get ovl_real_file() and use it without
> > > > > with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice=
_read,
> > > > > ovl_splice_write. But those look more of an exception than the ge=
neral
> > > > > rule. All other instances use with_ovl_creds().
> > > >
> > > > Use with_ovl_creds() is a good practice to keep the mental security=
 model,
> > > > but it is useless if the security check (can_do_cachestat) is not i=
n the
> > > > vfs helper (vfs_cachestat), so please move it there.
> > > >
> > > > Also it kind of makes more sense to check (flags !=3D 0) in sys_cac=
hestats
> > > > before checking permissions.
> > > >
> > > > > Also there are simingly no other file_operations which return "re=
alfile"
> > > > > for further processing, mostly the operation from fsops simply re=
places
> > > > > general operation with its own logic completely.
> > > > >
> > > > > Thanks for your review!
> > > > >
> > > > > ps: Hope overlay maintainers will correctly if I'm getting this w=
rong.
> > > >
> > > > I don't think this is wrong per-se, except for can_do_cachestat().
> > > >
> > > > Just be aware that the real file could change from one cachestat
> > > > call to the next (i.e. due to copy up).
> > >
> > > I'm really grump about adding a new file operation just for a
> > > special-sauce system call which is under a CONFIG_* option even. We'r=
e
> > > not going to set the precedent of piling on custom file operations fo=
r a
> > > single filesystem everytime someone adds a new system call unless
> > > absolutely necessary.
> >
> > I had a similar reaction.
> >
> > > This looks like it could just use a new helper in
> > > fs/backing_file.c that the cachestat thing can call to use the correc=
t
> > > file.
> > >
> >
> > I was considering suggesting this as well.
> > Having f_real_file() complement
> >
> > but technically, can_do_cachestat() should be checked against
> > the overlayfs file/inode AND also against the real file/inode with
> > ovl_creds.
> >
> > I'd love to be able to provide a backing_file "template" for
> > operations, but I don't have a good idea how to do that.
> > Do you?
>
> diff --git a/fs/file_table.c b/fs/file_table.c
> index c68b8c0a4097..d93059d53e88 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -57,6 +57,8 @@ struct backing_file {
>  #ifdef CONFIG_SECURITY
>         void *security;
>  #endif
> +       unsigned int flags;
> +       struct cred *backing_cred;
>  };
>
>  diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 27cc07738f33..64e07ebc43b0 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -50,6 +50,12 @@ static struct file *ovl_open_realfile(const struct fil=
e *file,
>
>                         realfile =3D backing_file_open(file,
>                                                      flags, realpath, cur=
rent_cred());
> +
> +                       // Raises ->flags |=3D BACKING_FILE_CREDS and set=
s ->creds to ->backing_cred.
> +                       backing_file_set_creds(file, ovl_creds(file_inode=
(file)->i_sb));
> +                       // Now add a helper that performs permission chec=
ks on
> +                       // both creds for that cachestat() thing and retu=
rns
> +                       // the actual file to operate on.
>                 }
>         }
>
> something like that?
>

Confused.
It seems strange to have backing_cred in this scope.
I would expect having user_cred same as user_path.
backing_file gets you from the real file to properties of the "user"
facing file.

The cachestat() syscall has a reference to the user facing file not to
the real file.
The helper would need something like f_real_file() to get to real file
from user facing file.

Anyway I am not seeing the big picture clearly how this could turn to
be nice code.
Maybe lack of imagination on my part.

Thanks,
Amir.
