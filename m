Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7556B195985;
	Fri, 30 Aug 2024 12:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725020611; cv=none; b=tNOmy7NplYUAZTx7F2H5zaOPKdJFkWOneCSAwAi09IwMCHa/cO1+Kbizp43XlL0P0+Xd6VGVrshESH4YPv2rINCEV9zoz5Iq8zunfqdshkslEV6pIMiYvP3wB2TsC77kD4hzY/BL/zrpfmWtne8vHtw6QkZO9KMQVw60vRB2MeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725020611; c=relaxed/simple;
	bh=BlLyslQpDGEzBxuUDe8Cov1IXreDXWei8o6rlcjjJik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CRUj4bKoFhBUWkwz+7xSAmHLhCjX4yMMxB4W/FGi1E0idksu1dl3LYqv+4/qwX/oLU+M6U73AeL3PMp6c7NhXJ9Ah9y0vfzAUu69cTGKtlST/zRZg/X0aX+0SoFM2FYSMkWbsFGw0S2KrW9QmtOhReKKB3NBaOb4iwy7m6GFWso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kitfTdpu; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kitfTdpu"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e165825ebfdso1734266276.0;
        Fri, 30 Aug 2024 05:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725020608; x=1725625408; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ubwn7IgLAh1kgKkNxqu475mnJWVnidsj1Cts8mO7ZEg=;
        b=kitfTdpup/HVzomLKblsw9asQZfTrh3xqonw0VFYnWJYvUsunVGHRoe+i1WmkVYIKD
         hmJ0ozueT3PKUXxsUBU9t1GQL9JvFz261gRTnabFxtOXfm3KJjFMU9BvGfqogwZLDnzg
         1a5exs56ojm7WZUJvtJaC5sySdevTcFcQHkb4J4A9Fg8vMDSgbG96u/zoHGFh5XkZa3V
         O+erS8gID3bXKYIgGG5mp49QZp1qoXKGKiRDLVHiCU+wDVFnaYoA/LHZ2hZP8mXOj05H
         XLcsNn8gkFwR4X/y+gooD5AnkR5SEe3WTHjCrsL6Fj3TpeTSE7yda0oGn11Xh7+bYAX8
         0Sdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725020608; x=1725625408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ubwn7IgLAh1kgKkNxqu475mnJWVnidsj1Cts8mO7ZEg=;
        b=wmj+51Xeid78pFxcp4n6IF1KDDmjUPgI3Cc+XuZG3zGTjGSEGVBO9Al/Zd/MWnRbzF
         KabclFzELwctBzqapHVsn7gWbOT+ewJ7hnKf4ughLMTmdVcf2z+31R1k3nIdbtD10LDj
         tbQsuIijQPDWk+S+v5Nx2l5GuRMOXJQpMDrfu+py1tMYxrnEInRAknVf0gL5cd1a3Qir
         sLf4oFa2vjsegetDBxSSfsEsLFK4Ry5varKbaDtS3WFcj3+JrHDyrO2y0V98UgWCa79r
         d/xqI2mNDTt/bz4HZdtTIaT62u7subQA/b+8MxkFQkg6ImmG5Ur2LxXs/KQjkNA3WZJg
         6d0A==
X-Forwarded-Encrypted: i=1; AJvYcCUDRpyBWyVDeueaiQcfRM/DoY/AAEQ6LkCnRD8BigXivOXiHCO9txp/yrVo3kglpol8dfS3Q1tMHDfqTMPc9w==@vger.kernel.org, AJvYcCVlhzdYo/eoZXXRBV65ENSvfM1bfPgwsZiLoNIYYdRwk8F64nRPZp4iao/AAuo5OghlprBKtQJFV3K8fjw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHaDshTt0noqqGIlCRj3E61Wh1xSEmth3teH1e5cxZ5PbEKF26
	87w6uO0iLgsSjXlKulxSgvmo7KNKSdBTm81dcvDFvmMt7rrdBXF3sYMhE4Ovp9lu8Bd/6fzdSUg
	9yDyDlhdJzNKoBR+/k/xv0vX4H+/KDCZv+CA=
X-Google-Smtp-Source: AGHT+IHTB+yOd4+mCdfPLF2/afYOkSh7cvSfBcQPadfdS+q/5wmplT1oDdKEYQtNW+IxYUeKU7q8XY1eQti43GTMalg=
X-Received: by 2002:a05:6902:2586:b0:e04:e298:3749 with SMTP id
 3f1490d57ef6-e1a7a025ecbmr2129733276.33.1725020608094; Fri, 30 Aug 2024
 05:23:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
 <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com>
 <CAOQ4uxi-BuKU-AbyydVB2c8z0DiPP-Ednu+bN3JB2Cqf7rZamA@mail.gmail.com>
 <CAJfpegt=BLfdb5GRbsOHheStve8S57V9XRDN_cNKcxst2dKZzw@mail.gmail.com>
 <CAOQ4uxhtoAL43d5HcVEsAH2EtgiT8h6RkjymNhTcP5nnG1h09g@mail.gmail.com>
 <CAOQ4uxjkVcY7z8JCshmsCfn1=JUcxDG8vyJQ+ssdeBmGrZ=eKg@mail.gmail.com> <4ec356a473294dd3aab94a66c528eb2e@exch01.asrmicro.com>
In-Reply-To: <4ec356a473294dd3aab94a66c528eb2e@exch01.asrmicro.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Aug 2024 14:23:16 +0200
Message-ID: <CAOQ4uxgKC1SgjMWre=fUb00v8rxtd6sQi-S+dxR8oDzAuiGu8g@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: =?UTF-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	=?UTF-8?B?WHUgTGlhbmdode+8iOW+kOiJr+iZju+8iQ==?= <lianghuxu@asrmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2024 at 1:52=E2=80=AFPM Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=
=EF=BC=89 <feilv@asrmicro.com> wrote:
>
> > On Thu, Aug 29, 2024 at 6:23=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Thu, Aug 29, 2024 at 2:51=E2=80=AFPM Miklos Szeredi <miklos@szered=
i.hu> wrote:
> > > >
> > > > On Thu, 29 Aug 2024 at 12:29, Amir Goldstein <amir73il@gmail.com> w=
rote:
> > > >
> > > > > But maybe we can ignore crash safety of metacopy on ubifs, becaus=
e
> > > > > 1. the ubifs users may not be using this feature 2. ubifs may be
> > > > > nice and takes care of ordering O_TMPFILE
> > > > >     metadata updates before exposing the link
> > > > >
> > > > > Then we can do the following:
> > > > > IF (metacopy_enabled)
> > > > >     fsync only in ovl_copy_up_file() ELSE
> > > > >     fsync only in ovl_copy_up_metadata()
> > > > >
> > > > > Let me know what you think.
> > > >
> > > > Sounds like a good compromise.
> > > >
> > >
> > > Fei,
> > >
> > > Could you please test the attached patch and confirm that your use
> > > case does not depend on metacopy enabled?
> > >
> > > In any case, I am holding on to your patch in case someone reports a
> > > performance regression with this unconditional fsync approach.
> > >
> >
> > Well, it's a good thing that I took Miklois' advice to make the fsync o=
ption implicit, because > the original patch had 2 bugs detected by fstest:
> > 1. missing O_LARGEFILE
> > 2. trying to fsync special files
> >
> > Please see uptodate patch at:
> > https://github.com/amir73il/linux/commits/ovl-fsync/
> >
> > If there are no complaints, I will queue this up for v6.12.
> > Fei, please provide your Tested-by.
>
> We do not enable metacopy.
> Tested this patch and it also solved our issue.

Hi Fei,

Thanks for approving.
I added Reported-and-tested-by and pushed to overlayfs-next.

Now we just need to hope that users won't come shouting about
performance regressions.

Thanks,
Amir.
