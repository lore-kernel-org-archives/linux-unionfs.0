Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B873368AC
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783517041; cv=pass; b=IH7Rnk76TA9845jL5fScIk2S8z+dMa9PjM0oEPzx1LvWWWoKcIm+8XrUUijMASeE9YApx80hfSbdBAT6270r4DPfk3jtKyuEDF1H5NsDEDY0tySxflX6zwllqqrRhn0lepaN8YfdmI7RAl1QlYrxuo5UyyHyuLCsbwwkcnBPvxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783517041; c=relaxed/simple;
	bh=sjbOYxpVLmqz8Fxaja/dycqeJ93n3DJ33hs2PVMtNjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kKXlMCDdk1og1tC6NKmXMXWzrT7GJ/vsvU0hz2S1wdvQHSLc0D8XphY3P46SYya3OB3hje9sVYzqOzhgBnX0u9JOeLffTK443cvaYEpeQZ+xInDFCiGljWno0QwiO9YaR4Kk3iPpMwGRYuG3lrxyO8yXk/aavocGE1HJGZIFTYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRBzBWCa; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRBzBWCa"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698a9f11776so1150083a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 06:23:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783517038; cv=none;
        d=google.com; s=arc-20260327;
        b=nWyTSDwAZUhTcdM8gay5eN9mhb0Yxvm37jZ2dTz+VehHsDRQOwekLVQPd7/HSXHkO7
         7MnjwZ6Cz3GmeNpdhMCENBqpW2vG5vt8rjSFcQG6BNUHxnOi55uWHIEXUmLYMXTrbNq9
         vx01LSilEFTUvbeGZhFyibPIrdRFPto+9adwTFSdGrziwUggwS6BVILMZvBK+AkMUl3e
         w2ZBGOLslrZQKHZTSLHs3XCJJim+8my4sLS39GNzZAcu2e5RLVQLwiCQAglCEJJcohpN
         hTdFxgKpl07DRzPPXlicPtPvIolET5PU9ln8CUjasEi332xK65hgoMD8osl6IObzZ6Jh
         /28g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jfSl458gi7ZwFhfzOLWI1yj6B78Eu+Dovf3nllo+0R8=;
        fh=tAfF1j2Gk13o+9AisHL8ztF7K0HiFbdcvPhPXQI4iSQ=;
        b=rPdWmtTtMqGq+ykrdcHSs4OTR5jPBgAJs6D7bC5e09J6NWI/SSacccAAjvK2vqk+xh
         tW9tWF/H1bUuhFZKiymKhuA7LMcRUt1gBjZyxNPSKif0XkMnT4QJAgtp4HvlcG2sI6mX
         lIPylmSIixcOw5b4yUkNOoT8IGIgQxbgcZi1YD5d6ii2szx3djDeuh5LbuLqhzPWUO2N
         mfSQINDCxW2dsmWglVlR01EUdtfMexNNT9goJYPeNPoHQshakBLXPJDJcV3y0lWbwqsU
         ZaLs1cIKeiebOIkzzetl4MZvgTUMNDra7jyTfftqSAFNHIU5JRJyjJEVZ/IXTr8AoG1e
         GZGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783517038; x=1784121838; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jfSl458gi7ZwFhfzOLWI1yj6B78Eu+Dovf3nllo+0R8=;
        b=WRBzBWCaoMmUjliAlmVrzRTG6jLTIn0C0lrrOMCnjGOwUQGxQACCqC3UoASw0gi8Mq
         0kmtqOFR+EWsGqPydf9z4jsGtocX8TuuWBMjBWXW0xh+iO9cdFJnSltUsSvQ6X5c2NSH
         w+jUxPuiwT1QKqyRB+Xl4HeTDuhMgpptA99HFJwH/HSWfxp9sBQlvx8fsS4g9+u3jH+0
         2UJgvwiNmqlyJQxk4pKiQzwvgKmW/O2MTbg+7eDsBMzSebJ81tupkzxV1eyUdUV7IGzO
         6/wa1Lr/sShT5kn1azvdD1IXypQIMf/kAikFWyp6vYVEDotZY4cnMD1Sgar9YHtN1Wox
         1b6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783517038; x=1784121838;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jfSl458gi7ZwFhfzOLWI1yj6B78Eu+Dovf3nllo+0R8=;
        b=cK1HUUPazX9LJVXwfQ63U0MA+yQW5EtBDyIWpFfGCPB0FYQHOmPDSnH2iOPLDzqZII
         nv6wr62TpOF3NqnMr+lgWXtd9iTPTR1dgu7mbS609U4Fx2jmDpRM+aOdM1c82yRqa2tk
         S0SuUrQkRWa6Gv9+doxkD6Fbyq8pi8XeMik2krfKkvPaKg8GEqALoleXLhi7yr3KoOKR
         3A901MrxSA5tPXX47PGVxryE2zpbvVQXWrOEDxFCoXZVQbj3zUXGuG8JsWfO8Z5Eu99S
         x2JyJDkQ0nqTMhlL71Ew8NHsFZRcnvxa0SJEQEQIrLpscwTX+YhUuKbk/y3yOpWLpr2f
         OQpw==
X-Forwarded-Encrypted: i=1; AHgh+RpGNwch/zrIxYvlFb1xUFwDSY9Q28gUGKAFgI48Jwmg6UJg2j89Q8OkFbuAlv29X7iuLoIggMdzExFlEr37@vger.kernel.org
X-Gm-Message-State: AOJu0YytniSGAU168vYbY+pBLEwvRRoOepNepPwruqS7A1pA4OfsSVZb
	lOhYgqLS9KRdOI1nM1iEN/trznSQXoHTJ5rwluqGN/zh7BKzY0VXCraLpMKaOM+YZP9tgqPkYNo
	iyfJcXB3BtAWJCSTEO1BZGg4H+jlppNNPeqD5nFk=
X-Gm-Gg: AfdE7cnIehnx75oAcb+vmORuyT6ihKIPGmJDYvJUtIdRIP3GYjQZofPzlF9CZJt2zs8
	vJoUzf/1+BvHKkiv8yLrbpawZ6wuXPonjBOeaiqe0lZyQxm9i3CfO8DNdOSmw59BgywTNds30ON
	zbIeoU6FVQgFUS7RnfjCUQAbDEAlIsUXUmK1/9gnnmEH3zUmYJabDM8wsmRYOwzjim7/O4GPr4k
	3B6OmXVNYOHFs1vAMdHlqA/DbShLg2821r9psywsWh9TemVmze0Y6rfxTeCj/ZqFoIM1TyebQ==
X-Received: by 2002:a05:6402:1950:b0:698:3e08:29f8 with SMTP id
 4fb4d7f45d1cf-69ab4460d0emr1057676a12.11.1783517037915; Wed, 08 Jul 2026
 06:23:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com>
In-Reply-To: <878q7l8y4y.fsf@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 Jul 2026 15:23:46 +0200
X-Gm-Features: AVVi8CfN8aTjKTMMtRUKrgssp38DeN4Cvtt__3YWqnULwffjjbw8Yi9jHHKR9_c
Message-ID: <CAOQ4uxiiVsp0BsdqfH3rCrpP6fBi-vTyfXd-TcVmFcS34MxzUQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 2:31=E2=80=AFPM Giuseppe Scrivano <gscrivan@redhat.c=
om> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> writes:
>
> > On Wed, 8 Jul 2026 at 12:00, Giuseppe Scrivano <gscrivan@redhat.com> wr=
ote:
> >>
> >> Add two ioctls to overlay filesystem to allow userspace to retrieve
> >> information about the overlay layers:
> >>
> >> OVL_IOC_OPEN_LAYER:     return an O_PATH fd to the root of a layer.
> >>                         arg =3D=3D 0 returns the upper layer (-ENOENT =
if
> >>                         no upper is configured), arg >=3D 1 returns
> >>                         lower layers (-ENOENT if index is out of
> >>                         range).
> >
> > We could do this with a plain open() call.  Something like the magic
> > symlinks we have under /proc/PID/fd/.   Question is where could these
> > live...
>
> is there any existing user of such a mechanism?  I don't see any mount
> specific info under /proc or /sys.
>
> >
> >> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
> >>                         with numlower, numlowerdata, and has_upper.
> >
> > Isn't this info obtainable via statmount(2) already?  If not, it
> > should be there, instead of a specialized ioctl.
>
> no that is not exposed by statmount and I don't see any way to export
> file system specific data through it.  Do you've anything in mind?
>
> >> --- a/fs/overlayfs/ovl_entry.h
> >> +++ b/fs/overlayfs/ovl_entry.h
> >> @@ -35,6 +35,8 @@ struct ovl_layer {
> >>         struct vfsmount *mnt;
> >>         /* Trap in ovl inode cache */
> >>         struct inode *trap;
> >> +       /* Keeps the original fsmount file alive for OVL_IOC_OPEN_LAYE=
R */
> >> +       struct file *origin;
> >
> > Don't need to keep the file open: the only info missing is the
> > original vfsmount, everything else is already there to reconstruct the
> > file.
>
> I didn't manage to get that to work.  As soon as the userspace process
> closes the mount fd that was passed to fsconfig, the anonymous mount
> namespace is destroyed and dissolve_on_fput sets mnt->mnt_ns to NULL.
>
> So whenever I try to use this mount again from userspace, it is not
> usable because the mount namespace is empty, causing check_mnt() to
> fail.
>
> Do you have any suggestions on how to solve this problem?

The suggestion was to store origin->f_path->mnt instead of storing origin f=
ile,
because you only end up using the origin vfsmount.

Thanks,
Amir.
