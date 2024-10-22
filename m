Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE18145A1C
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Oct 2024 19:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729623742; cv=none; b=NCPQLP2wTruEgf92rTDrFPgVYJOYXo6loARgP4oy0yQfJvQ/p0Qk6/4Slq0X2LITTrJrwdm4cN5W5iiOOPSKz/jf6I/vWKiG1ji2hqMgOg9SLn/hSzM9yEgZpP1Ta8lB2YnWl+VQzDaI6XPwFOeHTo/jLunMU1SRNKLHPTuVYBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729623742; c=relaxed/simple;
	bh=cipdGQLWeabSJmS+rps5RY9Wx9YIjctQRKwsbU6kEBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lwy4x1dDn3ZMtgEPvl+qhw7z+BEArhF/Ohr/R1FDladjn6+B/587RWOezbrpkUq2TRtxuze+J8PmYsAZHMMiZ1q9/RigE9MNYX3xF1rxdhxLLInA5fJCGkB44y4zAylWtkG6YLFIyTt37b/tZY06TTCWy/2sVH8bA0PNy94BDcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=GI2fQ5+Z; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="GI2fQ5+Z"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5daa93677e1so2990172eaf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Oct 2024 12:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729623740; x=1730228540; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHkFENIEludgcQYUwWLw1l+x2BOlw4j78pBbvF4jV9w=;
        b=GI2fQ5+ZkG7EWnnEpguP41kPdRbfLCJBARyi9FexOzuQ3zwn2ro/ZNTWOcFB4WKpVQ
         /LN3UFltm8tDPXEn0IjdRj7Mgudn1vwi3zFnEaHq5aCxsxkh/NxbKNctKowArLO+EOct
         9fhR7f9Zp1PDawJ7kd0nSbfGKdnqD0UZMFkxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729623740; x=1730228540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHkFENIEludgcQYUwWLw1l+x2BOlw4j78pBbvF4jV9w=;
        b=IdaMEtpoCP3rly5v7tgyIndtDF+igMplzzbOl4v6cZts3C8gyih2nZXoNox+wJvaEu
         PxzKaa1U8PohU7uit9IVbp0ptVdbzTsJe46l5cG92KJp6MEXqns8RQpOS6raBq52EqHq
         FGoGIh2p8io2mesEEC/fesz/dwXKFYwyc27oVgCbP/QlSaghwplntaUEoKxWmRuXdsYH
         O0/QN6xuNCSWZxhoyJALR1kopK35E6vfSJtMAk+z7SewFiqME1JQ1jFsAERESnI4wrTi
         biCYs1ORYIheBPiaKV4Tb2QDyxybSnnl1g6O0BIKCvjGbwkR8K8xYmHBGxuOoNMlGkD6
         0hBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkiXO9mAX79fBYn8rLZ94A7WNAzAhnlJRy2VPLXYD3dRLudiD2hCnXN4S06TxpsHtiahDET/4ImNJ30RsQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwtX2kdMRMcPWKd14H/j2Vjv+hOLxUSb97216WmbD+suDv51FKU
	Yvej2MZxIAM51QDdHrBRBSI9BaaGb5l/1m3dkVNs++ArcNmCFiJkWvswWHvkkTSud+glPTOwUT9
	J6Gt8P2dCQXZegyQ3qgYEPxpTru6n1kR8aNFedw==
X-Google-Smtp-Source: AGHT+IE3iY0Di4GQ8Yag3rTeVnxdAOts9zvjd9o/85oc2h4spujRgXAdOhjzE7V2+cQ5fyS+ZmLcs+FfMez5dVXNdJo=
X-Received: by 2002:a05:6359:4c90:b0:1bc:2e87:f1a3 with SMTP id
 e5c5f4694b2df-1c39dfecaa3mr682204455d.16.1729623739847; Tue, 22 Oct 2024
 12:02:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241021103340.260731-1-mszeredi@redhat.com> <CAOQ4uxgUaKJXinPyEa0W=7+qK2fJx90G3qXO428G9D=AZuL2fQ@mail.gmail.com>
 <20241021-zuliebe-bildhaft-08cfda736f11@brauner> <CAOQ4uxi-mXSXVvyL4JbfrBCJKnsbV9GeN_jP46SMhs6s7WKNgQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxi-mXSXVvyL4JbfrBCJKnsbV9GeN_jP46SMhs6s7WKNgQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Oct 2024 21:02:08 +0200
Message-ID: <CAJfpegsYanxpkYt9oHdqBuCkxe4p5usSU=u+3rNZZ=T=HmpJug@mail.gmail.com>
Subject: Re: [PATCH v2] backing-file: clean up the API
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Oct 2024 at 20:57, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Oct 21, 2024 at 2:22=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> >
> > On Mon, Oct 21, 2024 at 01:58:16PM +0200, Amir Goldstein wrote:
> > > On Mon, Oct 21, 2024 at 12:33=E2=80=AFPM Miklos Szeredi <mszeredi@red=
hat.com> wrote:
> > > >
> > > >  - Pass iocb to ctx->end_write() instead of file + pos
> > > >
> > > >  - Get rid of ctx->user_file, which is redundant most of the time
> > > >
> > > >  - Instead pass iocb to backing_file_splice_read and
> > > >    backing_file_splice_write
> > > >
> > > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > > > ---
> > > > v2:
> > > >     Pass ioctb to backing_file_splice_{read|write}()
> > > >
> > > > Applies on fuse.git#for-next.
> > >
> > > This looks good to me.
> > > you may add
> > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > >
> > > However, this conflicts with ovl_real_file() changes on overlayfs-nex=
t
> > > AND on the fixes in fuse.git#for-next, so we will need to collaborate=
.
> > >
> > > Were you planning to send the fuse fixes for the 6.12 cycle?
> > > If so, I could rebase overlayfs-next over 6.12-rcX after fuse fixes
> > > are merged and then apply your patch to overlayfs-next and resolve co=
nflicts.
> >
> > Wouldn't you be able to use a shared branch?
> >
> > If you're able to factor out the backing file changes I could e.g.,
> > provide you with a base branch that I'll merge into vfs.file, you can
> > use either as base to overlayfs and fuse or merge into overlayfs and
> > fuse and fix any potential conflicts. Both works and my PRs all go out
> > earlier than yours anyway.
>
> Yes, but the question remains, whether Miklos wants to send the fuse
> fixes to 6.12-rcX or to 6.13.
> I was under the impression that he was going to send them to 6.12-rcX
> and this patch depends on them.

Yes, the head of the fuse#for-next queue should go to 6.12-rc, the
cleanup should wait for the next merge window.

So after the fixes are in linus tree, both the overlay and fuse trees
can be rebased on top of the shared branch containing the cleanup,
right?

Thanks,
Miklos
