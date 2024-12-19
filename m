Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB2279C8
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Dec 2024 00:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734566835; cv=none; b=HCGPnkTd8SCbhslIOE7lOEXTnN0NG/1AmvuND4TViB9+FOw9jlKgxq41Xw1PpmMDB9FhjzS0T9CN2WYRM1BDNGA7P5UCZfwLSVB6veWuwL0yDIZICqb6hVdLccK2AqulPWhCfZcDyXiD4aWt7fTEW07wI03Bumobp2wb0vh1Pi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734566835; c=relaxed/simple;
	bh=WZjFe8wKOL9HwNoK06l8XbFhX7n71sn4plvP9/2iTjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9z0UmgCYeuFAMw+kCdgQ9BbJHsiPec48zNsjSIF7ZWSMNnlDGQzXWMFC7LQzGA3A0LyWRnwfOk/JvHIynCMmeNmzEzmFT0p9T2nK59z/08ZAcxUWkTxE501S25UwehENSpKCL5NtwDXGyEigaWiLB0spwkN0gTIAeh44HiDFxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com; spf=pass smtp.mailfrom=arista.com; dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b=hkiJAlp9; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="hkiJAlp9"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2166360285dso2232755ad.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Dec 2024 16:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1734566832; x=1735171632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52jSfl4KCvUw98t3zaToufia/m4p+sDIn4ah9oFu/mE=;
        b=hkiJAlp9OSd+0qqWJGJE5AC1z6HxX8AEf4HJJvo/nZstoJnYL8C7fX9f6N1mvZnZT+
         xxYVNS7/lX0qr/BKr5+KXFVCkJYyryz7tFLLT4PNvm73kBzz1JQNoPrwLKCU/TDO5y5F
         9lWXabqUK2vYxF1CRnBogYYekwGnzunXH4ZwOCSzGw4IltjbEpiKyxcu3077C+FFT+F0
         dNqO1dIN87Ozp90+W1dbR07BDK6dTao7q0M/t7Y5cVVuCcEnILmeWCC5bUtedIx5exGi
         71A1Nqn0rs/zyy6UHRh3Rx08ICbvXuPpnfz8RFOs4o3xEL6+zj2vemqMJnmk/1u+cZdd
         kgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734566832; x=1735171632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=52jSfl4KCvUw98t3zaToufia/m4p+sDIn4ah9oFu/mE=;
        b=tLgUaOp/My6uPDlgDkxKfxswWGXVz8JJmTw7Z42xClV2dHyvFyf2TnBD49I2ExbwzK
         7JDFUAG/1ii96BEgPp1XQ2Y5xAYnaixvU5v1dcyTObp081D/Ae/FGaY+RsICViTEMscl
         6HwdoFRdeAlswjwIC/jDIzqpGCNuaBoSzsRtbdaXMqUPnKJlLg0XY48Sm0Is4f/LtGhR
         S9Q14ffpTP8w9+4UXAIIoa4v1yLq++moKyzsUij8wPgo4/5gTdAUiFcVip5XdUI+1XPf
         /IZTkbmKM0FMy1tWqmdsHIUBLU+lz9W4ISMMPk4cWu+jhFHivoCY0zL393koyZGR9XDf
         VUOw==
X-Forwarded-Encrypted: i=1; AJvYcCX4CRacZA3wxjQQeMqmhsfHCIAt/ThzgdnTSoebICNJ2SI75ZDcLsppord7oopc2nc+HMITipuJmke186Ic@vger.kernel.org
X-Gm-Message-State: AOJu0YyufYkylzox18F9JtS9fqK8k9kt3hG2VLmlQkDDO7q02CJtaFDy
	q2eo+FnAMKsHG9tVS5l4LyXFUmN6arXwxl8oKUmK4r/A14g8sEFLQbm/lmpQvWyov4ZTnjEtnF7
	bOTGFHMDgcbBqef4n7m5XwXteHMCJRFzS5Sqq
X-Gm-Gg: ASbGnctvjCBCfbhdKiYNsRTasvJ+ZIS/pucQEYN0hM6jdpBnjvGifwSrec/4O8aatyS
	Aqn5JKHs0pQ2LDfelUos5+HqLbWMkK7Ppwuh9DUI=
X-Google-Smtp-Source: AGHT+IH27pDcSlJ/F9QtGxlBr64hIGr8CjwP89Du+IuSyaexLxIUAC6fi4ZA+ID+3TD8nm0/w2mtVIk8rsxRiigAxtg=
X-Received: by 2002:a17:90b:5202:b0:2ee:d63f:d8f with SMTP id
 98e67ed59e1d1-2f2e91efcb5mr6521474a91.13.1734566832471; Wed, 18 Dec 2024
 16:07:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGrbwDTLt6drB9eaUagnQVgdPBmhLfqqxAf3F+Juqy_o6oP8uw@mail.gmail.com>
 <CAOQ4uxibFVCGBEORDHjUuB_b6ELq8NdGaNv+Srz9rzQAdh=4OQ@mail.gmail.com> <CAOQ4uxiie81voLZZi2zXS1BziXZCM24nXqPAxbu8kxXCUWdwOg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiie81voLZZi2zXS1BziXZCM24nXqPAxbu8kxXCUWdwOg@mail.gmail.com>
From: Dmitry Safonov <dima@arista.com>
Date: Thu, 19 Dec 2024 00:07:01 +0000
Message-ID: <CAGrbwDQUVEEh4wYDEuRaZvBDAzjn41h2DZLNzHYRAXKCJnaEkg@mail.gmail.com>
Subject: Re: overlayfs: WARN_ONCE(Can't encode file handler for inotify: 255)
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, 
	Sahil Gupta <s.gupta@arista.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Amir for all the detailed information,

On Wed, Dec 18, 2024 at 4:26=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Dec 18, 2024 at 1:10=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Wed, Dec 18, 2024 at 1:23=E2=80=AFAM Dmitry Safonov <dima@arista.com=
> wrote:
[..]
> > However, I am concerned about the possibility of exportfs_encode_fid()
> > failing in fanotify_encode_fh().
> >
> > Most fsnotify events are generated with a reference on the dentry, but
> > fsnotify_inoderemove() is called from dentry_unlink_inode() after remov=
ing
> > the dentry from the inode aliases list, so does that mean that FAN_DELE=
TE_SELF
> > events from overlayfs are never reported with fid info and that we will
> > always print pr_warn_ratelimited("fanotify: failed to encode fid ("...?
> >
> > I see that the LTP test to cover overlayfs fid events reporting (fanoti=
fy13)
> > does not cover FAN_DELETE_SELF events, so I need to go check.
>
> As predicted, I added a test case for FAN_DELETE_SELF over overlayfs
> and it fails
> to get the file handle of the deleted inode:
>
> https://github.com/amir73il/ltp/commits/ovl_encode_fid/
>
> fanotify13.c:174: TINFO: Test #6.4: FAN_REPORT_FID of delete events
> with mark type FAN_MARK_INODE
> [ 2967.311260] fanotify_encode_fh: 23 callbacks suppressed
> [ 2967.311276] fanotify: failed to encode fid (type=3D0, len=3D0, err=3D-=
2)
> [ 2967.317410] fanotify: failed to encode fid (type=3D0, len=3D0, err=3D-=
2)
> [ 2967.320933] fanotify: failed to encode fid (type=3D0, len=3D0, err=3D-=
2)
> fanotify13.c:268: TFAIL: handle_bytes (0) returned in event does not
> equal to handle_bytes (24) returned in name_to_handle_at(2)
> fanotify13.c:268: TFAIL: handle_bytes (0) returned in event does not
> equal to handle_bytes (24) returned in name_to_handle_at(2)
> fanotify13.c:268: TFAIL: handle_bytes (180003) returned in event does
> not equal to handle_bytes (24) returned in name_to_handle_at(2)
>
> Note that this is not a regression, because FAN_REPORT_FID was not suppor=
ted on
> overlayfs before 16aac5ad1fa9 ("ovl: support encoding non-decodable
> file handles"),
> so I do plan to fix ovl_dentry_to_fid(), but with the holidays coming
> up, it could take
> more time than usual.

This sounds good to me, there is no urgency in fixing it for us, we're
going to keep the revert in the kernel until there is a fix.

> If you have an urgency to fix the reported WARN_ONCE(), then do feel free
> to post a patch to remove this assertion, because my fix to ovl_dentry_to=
_fid()
> may be simplified to deal only with unlinked inodes, so it may not be eno=
ugh
> fix the use case that you reported.

I mostly wanted to make sure this issue is a known one, as WARN*()s
are considered actual issues with the code, rather than just warnings
to the user (and they leak kernel addresses). So, probably it's worth
fixing somewhere during the release. Also the report could save
someone elses time, who may observe the same issue.

Thanks again Amir,
            Dmitry
