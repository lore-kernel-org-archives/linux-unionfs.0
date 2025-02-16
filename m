Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBEE14658B
	for <linux-unionfs@vger.kernel.org>; Sun, 16 Feb 2025 08:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739696025; cv=none; b=P+8mW/yb3h2GCnetvKqBMrTA7/Juernm1y9+jzTm2BPagnzs3EkamnKxE4ixqL+/uEnif5YBGIOdxCxUkc3/Z1A/xi0ypfw1wEAHmyV+WZtCwaZaiSn8TpGR1do3RYv4rcIdP4qse4Q+nBKeVYuB+Qu+hgaF6MYFPWIBuyOFudc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739696025; c=relaxed/simple;
	bh=GuMxNn4r9TViUwC/hloNjQcAEhCjXfflP0E+b4Ik0dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbelYDkJuzo7xaixCvEBmtrYSBrGdIHbiLripQ2y0peB9/6uWjPRTGR9RiR18wm2MSNIO6cT3K5UFPmsWjH5/WsUaRevg/t6S6GRd1ypTB/c7I4BqudpAS3vpwdd9YTuS1RlyDv4MIQWmAck46tcDdQ7KM4KSwHtP2Ut/nMPAgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5v/mJ4z; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5v/mJ4z"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5dea50ee572so4992734a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 16 Feb 2025 00:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739696022; x=1740300822; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xoblHRhh8pZWFtG5eF681K0l5qy4RepyyusjVMWLiMg=;
        b=c5v/mJ4zztEmmuJn5GGVJX6vQ63C3Di7BvuC9jVTsY0DQRKB9x+1JOf9lLidWIgvQY
         xM/nB6w7iyzKT7jzaVzXWiZUKwV7tSXUOtuDYyRBVHh4z1W+1wvLAMpXSDTt9GsND4vz
         xmd4xQ3XqxXIzp/pN5onG1nTZ5s16DpB4VjIYIraIIUmMQXT2AabSedUJZi3SJ1hC/Ed
         NWid6Y0fIXnayK/wsrDqAim/atRV2CZuled4zx7xYH8G6MCeZdSlqIAQ0JZj4qkIPCod
         706Is0YAp5QwqK2/4UIdkgKB4rtkzEx5K0lMer38khxHKkmuD/n6jK1XQlTHBz41QsvI
         fYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739696022; x=1740300822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xoblHRhh8pZWFtG5eF681K0l5qy4RepyyusjVMWLiMg=;
        b=R6n6rs6qiqx4E4yVm8w71CEvWkVEC8TE+erLlKRW72lpUUsfTgU3Ti7/RWXY2hhQTw
         Qcc9/QjAfVW4NrcAZqlC8PPDqWKBA56pAYHEYtYW2bVL9eL0iRzdC9QFJnNJYqN4G3uS
         tT5d4WSNurIFd6V1Vt/1X64AcIgCn9VVrBPYyZc7IAFcFDpgW8jMj7EukgRb9/0YBcZf
         2XLlvJrjZQlgog9WYd56SpkAwhQRgLM0FOH9DZ9xl4s0Dx0NN7aS+5kNKYdkmYtiMl1H
         Rf66T4hKf5Crp3WatzsLYePSd1c66etoQYdBOyWPuothzP+7k43SN40m/LRHbvNImG7w
         sGLA==
X-Gm-Message-State: AOJu0YyaDBU+NPmKFFBfwUxJ+bjfKknmOv4KW/+GGOQYnvFA8Y3mgMfi
	bo4cxUYrEY2svF63uca+IA4o10v2fD1pbcSyh8yCaFzfQXu2NxgGzJ0LODvB1MdV6z9Tsxj2761
	x0qsrzJYwBsCX+mAjdjCH1tIq44s=
X-Gm-Gg: ASbGncvvfBGrxKTPySM8yusaOb63I2uWBhMQhX9WQwD1AlgLW3NXKuvUUPaJfLcqhsK
	WLdgZQQ8qFqTrBoAHV9jmgU1+TYY+fkq+2CzlrOeTR9CxeHJXXZe4vrF7cmWKgeQ0JRsPXSxr8r
	k=
X-Google-Smtp-Source: AGHT+IHsICxDxuwclM3ekKBaSlalDqIbObosZCw656NVHpsdkgW6pQ7dKQZLR2J2HDIJ+uWmL3hHSmTtKEdhEtOiKig=
X-Received: by 2002:a17:907:7716:b0:aa6:6c46:7ca1 with SMTP id
 a640c23a62f3a-abb7091d089mr592092566b.10.1739696021992; Sun, 16 Feb 2025
 00:53:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACTE=go+F-ZcynMgGmZTkmEMKw-eoQdD1x8iHacD2c+hebskvQ@mail.gmail.com>
 <CAOQ4uxgYnY3DffCo0qyB3y=rJzgQBKo+dTcLgSwKhgHoMrU_Zw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgYnY3DffCo0qyB3y=rJzgQBKo+dTcLgSwKhgHoMrU_Zw@mail.gmail.com>
From: Jordi Pujol <jordipujolp@gmail.com>
Date: Sun, 16 Feb 2025 09:53:30 +0100
X-Gm-Features: AWEUYZlyXn_s4vql_HU44NrreecF5SmHLXUj6Xq6DDTrPokYXPnmn_Oho8zv_QA
Message-ID: <CACTE=go0gbHDbjkYO1gSCD1_WcUTSzPSLBqR=YMRdhCKUb_W4A@mail.gmail.com>
Subject: Re: overlayfs doesn't sync from version 6.12
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,
I can't reproduce this problem, sure that something went wrong before.
Please forget it,
Thanks for your attention and for developing this tool,
Regards,
Jordi Pujol

On Wed, Feb 12, 2025 at 11:35=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Wed, Feb 12, 2025 at 10:45=E2=80=AFAM Jordi Pujol <jordipujolp@gmail.c=
om> wrote:
> >
> > Hello,
> >
> > I allways work on a Live system that uses overlayfs, and also remaster
> > the pristine filesystem using overlayfs.
> > After upgrading kernel to version 6.12 have experienced several
> > filesystem problems, thus have compared the overlayfs code of previous
> > versions.
>
> Thank you for the report, but we can do very little with the information
> "experienced several filesystem problems"
> Can you elaborate?
>
> > By intuition, have found that these lines have been removed from
> > version 6.11. This difference is key:
> >
> > overlayfs-sync-upper.patch
> > --- linux-6.13.2/fs/overlayfs/super.c
> > +++ linux-6.11.11/fs/overlayfs/super.c
> > @@ -202,9 +202,15 @@
> >   int ret;
> >
> >   ret =3D ovl_sync_status(ofs);
> > -
> > - if (ret < 0)
> > + /*
> > + * We have to always set the err, because the return value isn't
> > + * checked in syncfs, and instead indirectly return an error via
> > + * the sb's writeback errseq, which VFS inspects after this call.
> > + */
> > + if (ret < 0) {
> > + errseq_set(&sb->s_wb_err, -EIO);
> >   return -EIO;
> > + }
> >
> >   if (!ret)
> >   return ret;
> >
> > In latest versions the filesystems work like a charm when applying
> > previous patch
>
> Please provide an objective comparison between the behavior of
> "filesystem problems" vs. "filesystem work like a charm".
>
> I am assuming that you are using the "volatile" overlayfs feature?
> otherwise, unless I am missing something, the removal of code
> above should not have had any effect.
>
> The removed code, would have propagate the s_wb_err state from
> the upper fs sb to overlayfs sb, but the only code that checks
> s_wb_err state is syncfs() should be returning -EIO in this case anyway,
> so I am not seeing where the change of behavior you are observing
> is coming from.
>
> Are you using a patched kernel or an out of tree filesystem
> underneath overlayfs?
>
> Thanks,
> Amir.
