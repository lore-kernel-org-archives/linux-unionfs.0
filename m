Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21844405C4C
	for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2026 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779148916; cv=pass; b=NAEbOeZHdb/dwXNGvURDhP8A/izah5WzMAVnBmK0u6acit7eukYRsXaOO0z85wSo5Ga/PgXoMEdlsfRRnzxZ9LTyu8CvtLFxr4R8XotYYgh9Y3CjplWT0fQVfrl+q5YgryFbOyIdi/Ys8flJk5ZXPG9XuFp8+HgIKhV2h3+13Y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779148916; c=relaxed/simple;
	bh=cY7l1Ij5zQ3U1zGP4fqtEQwVnmsu108odect3fiSVlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fzg4iHs2pUMdgMTo1tfbN3IaaxsDOP3+x7yKd6pwwGhj3fQ6ni7q6D3Wl1eY1ZZKZ+97PRku+juJ+xPOKK1GzAeRsEQf3P2Q6lOeSJYYi7uGMFZypK0zAiYhsAVHu01nMKmUToRPZMvW5Jq8WYbON2pt/FZPnQJxSjA+ea6/3Dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CV+sEsrf; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CV+sEsrf"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so16525595e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 17:01:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779148913; cv=none;
        d=google.com; s=arc-20240605;
        b=QTOn+B7MTNZFSvIKBIEjHH5BSB9ZsNJZNN0ofXcpyatlERPIQxOK+XV+CcyY1P2XjF
         fLSHQFa//ZLAniAF0PvMH253gFVezrr1tAxBZl7EcbAwEkH25x9d3NAxlRSU9aLodaGL
         MgF+kW2Ub5XJiIsQ68OWOTRBraRcdxPjdV+dSELgv3eV9IXuUfRJnghIyGpeAoNraxZG
         RUmq+g/PbBTS4FqkGkBwyWq8GrZUnkxp+C+lVvShk5nMF0bAqqUENQDp9KvTFbOb6NsL
         GCF5SsmCM1RBLSEFwRUNT4cCEsc5gCMfGCdZzNiIk/CxcPtsQJtlVK78jHrKZVL3le/Q
         PaBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sCNABeao7jNEZWws74B/pC8MJAjwnqZTvtKCDOtjNlg=;
        fh=iJfc5hw6mZdhWXpNpc1o33jUsXcBXuXqjSyLCqtf2w0=;
        b=aG0CqTN/7nwwZNcbJZQPIU5g65r/wXYWIpUaSaV3OTMkp7hrQP3E8NJEKBwoeCoXyn
         +GzdFpC72QlTHgOYqw13WEj09kCnQPMLohYiL0AqkYDPF1Pg0L9TGQQbIp5NfYpVrnlL
         4pH3h90YzmX+K1k9u0HR5BkTSZXqw3cYMSiwvcXNyESxo/4IB+XYh5SuW+WgHPRhd7E1
         fNp6CJn3zpLexX2Lu2KtGFN5OpzfSyleeRPenkXE9uJkIZXJwdz+7z14rYN9ocL6eEPY
         fza2JMc3b0gNQf3FA5i3yBUYhriWliG0w/xBCpLORm1FzVPLHpQ3udGt/SbhsCJt47mY
         jG2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779148913; x=1779753713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCNABeao7jNEZWws74B/pC8MJAjwnqZTvtKCDOtjNlg=;
        b=CV+sEsrfhRNd8ZQzSetMzjg3OWVpGSP7/2VlEhE110586LmBu0clXRwsWBkSUcwZMN
         t90QJW1g+Pc4xJG2RA9FyIPk6x/jBuB3dVUByKs3gWJFdQ051nFHm8mChtxLwpojJVun
         mdUEEVk3ZyMYgfwYyxV51gm8kAcyhBvYvE17kQvRSjwVfoL30PYF0ERayN0C2UEB/BMu
         m+PskAA+wlYR48U2YW4O2qeTZoJa9mFi71HNcLqdOVkZk4pI/FXVuRn9c4i3yG63cJg2
         EgluymSvUMlhynNwCWovtEEtMxHeLYMm2Bx0Q4xcrZ/4XSiebuoue2QtWBOajN+7Mq+z
         i+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779148913; x=1779753713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sCNABeao7jNEZWws74B/pC8MJAjwnqZTvtKCDOtjNlg=;
        b=BgdgM+F21Y91ks031x36Z5g1Uwi43qj2QHAhcMjB+1Wq5YqEI/o8q7JuFUQGPoLsZX
         DQLtzllqVrcdNNFi9uGQL8GCxMXjTcc1BV5zU9PgdF4VDSNbL2d/wS2Ysu6W17nFEucO
         gSgzBIC1ZgH3ipKV04vx7qnkUr0fIddXt45lt5DlPBYwBppuLKy/xVeeYxB1qSp/jzWn
         SJqDXgJR6oT4EMHQZQP4UQJbhrx5jtK6aOPIWSgjMF8AWU7Q+rcys1OIp+tqpvjkmQja
         Cp22ODpRCBMyFf40GlaEl5f7fxNzbGe3/zBpmjf3cUZp13sps7Dq6XHibcdvGwf4fvqB
         f3Pg==
X-Forwarded-Encrypted: i=1; AFNElJ9krY+nAgRMFIIK9rLZ+Q6SR3Vw0jgZevyOM4ETR2UAgKe2nagLJckNqKA8BaTZNMb7bEBhsvupmew7SIt5@vger.kernel.org
X-Gm-Message-State: AOJu0YwVEnC1u9qq9B+jj8W1/FzHhPXWPVFaZwqTg59if9ujDeTy1TaM
	WACAeUqZXamaZZ2OhMr01aNcskqAFmSEqheU3OfVBgwUToTVYDjQM5iHpnbaGJr9XYei3B6Mtv+
	8X0qSkYpEGZID1N3zkfdMwn6MyurjiXI3nTZ4
X-Gm-Gg: Acq92OHmiv3dlwan3rEhNM+vPV5Lgo6ZsfagsSc3fdJjGBjTqlfeTtCuZp+1OqnrWJi
	u69f52SaskWGTQhKvBNPVd+Zf2d29hE+PuvFq3Xev8lUWfZ7oit0AyCQW0lsqAzf1q6bfrIoRRc
	NufYTPtJGo4v2U955dba+xbVrGQq2ykT6RntP6R2m0MvvqPe1xf3mv4Ilm83YsPykyf3GCow1dm
	e3ga2dXTmX4pjOpvJrS9owjqA/pDChkyREF+4OlY0ynx2YG//VH7yEYWf9N+pWFJQIzNXajmuKP
	FgDp0A==
X-Received: by 2002:a05:600c:1688:b0:488:c21a:4754 with SMTP id
 5b1f17b1804b1-48fd646b8a0mr219247475e9.18.1779148913485; Mon, 18 May 2026
 17:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-21-joannelkoong@gmail.com> <CAJnrk1a9_MLyMebfsDe_=Rcd2+TaiD87pW4fd4ve8ZBQPCfGcQ@mail.gmail.com>
 <CAOQ4uxiJaLtcuGNrYej6WCzTfu=fFfy4VLj7pUmfM+hHT0Z3Pw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiJaLtcuGNrYej6WCzTfu=fFfy4VLj7pUmfM+hHT0Z3Pw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 17:01:41 -0700
X-Gm-Features: AVHnY4K7aLJXgYL7Z4ZYreCRwJgT_2uDJMFU082Qq7wg0A9bzkAxvr5ElbNXQSs
Message-ID: <CAJnrk1Y+YO79e=yvzKaBT9XcCV_ht899nQjzhQnKzJMjt4UVFw@mail.gmail.com>
Subject: Re: [PATCH v2 20/21] fuse: use passthrough getattr in setattr
 suid/sgid handling
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 3:23=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, May 16, 2026 at 3:20=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Fri, May 15, 2026 at 5:53=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > When refreshing i_mode for suid/sgid kill during setattr, use
> > > passthrough getattr if the inode has that enabled.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/fuse/dir.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > > index b67b3b334e69..fd1b3fd86968 100644
> > > --- a/fs/fuse/dir.c
> > > +++ b/fs/fuse/dir.c
> > > @@ -2524,7 +2524,11 @@ static int fuse_setattr(struct mnt_idmap *idma=
p, struct dentry *entry,
> > >                          * ia_mode calculation may have used stale i_=
mode.
> > >                          * Refresh and recalculate.
> > >                          */
> > > -                       ret =3D fuse_do_getattr(idmap, inode, NULL, f=
ile);
> > > +                       if (fuse_passthrough_op(inode, FUSE_GETATTR))
> > > +                               ret =3D fuse_passthrough_getattr(inod=
e, NULL,
> > > +                                                              STATX_=
MODE, 0);
> > > +                       else
> > > +                               ret =3D fuse_do_getattr(idmap, inode,=
 NULL, file);
> >
> > I left this part untouched from v1 but there was a discussion [1]
> > about whether to enforce that setattr must be passed through if
> > getattr is passed through [1]. I think there might be some use cases
> > though where having only getattr passed through and not setattr is
> > useful (eg server wants fast stat() but needs to intercept attribute
> > changes for access control or policy enforcement).
>
> Of course there is. I think I was misunderstood.
>
> What I meant was that *specifically* for the getattr for this purpose
> of killpriv, it may make sense to ask the server's mode for
> calculating the setattr mode for the server.

Ah gotcha, I misinterpreted your comment from v1. Thanks for clarifying.

Thanks again for reviewing this series.

>
> But this is just a hunch.
> I could be wrong and I have no strong feelings either way.
>
> > I'm not sure if you
> > still feel it's better to keep it simple with enforcing that
> > getattr+setattr rmust always be passed through together, Amir, but if
> > so I'm happy to add that in.
>
> No need.
>
> Thanks,
> Amir.
