Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7307D3346BE
	for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2026 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191276; cv=pass; b=LVcJdgAHktyPp4Sk99vSsphRelmqnu5+ofDnnIIvmQn5LflQiH13DnObU3c01x6ad8ifJDAUBup649JBoA4jvgZyy0puYjZPbU6fz/7YScoATpkBjtRLIbFs3OFXXJHkWefwU1TiG/rtx2UtFR7OOsIda8ej6piN2t4ghG4fMxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191276; c=relaxed/simple;
	bh=PeNNTUbxChRdVvLZjt65lvbSRv+y+xQXeN5Dp7nLS4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R1AhYj5LHoBvAKL82FOpbpvmSf1+uRqIiTE3ADDpBkFgw3hxFamn1POMFQoGv1Di0unHP/feR2PRlvAzWqs2OBcgR5lHuVPJuW9DaMjThELhA0opJcWEr5qzwii73oWVjp2mS/c7AbJ6WSCu9k4bZktr5LctSqLxvSCa1U+Qtkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NTUzHK2h; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NTUzHK2h"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so5984246a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2026 04:47:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779191274; cv=none;
        d=google.com; s=arc-20240605;
        b=Wu94SBkXkisaUL7soXbMXjdK2whAztmWPB1bm8tJLw8A8yhHG5BIUDRrN7LurN7CW3
         f1NemE9nDB5YexV6Cd6T7vwjFnArh6uZQvDeKbuQaVhOYrer2TUyReQxWPvsF0em+zWd
         McW+WTmYMst2Lq6D4hPnINeRDWR/3U6L9DoGn9x6e3olEe6eDst4wtwGlyBkCIuX5/oR
         rKdP5OIQthc44byGot2A3TAvgLMqtNhPgKyvZLIZXo8iPiDhQQqNH8rWBmpkbW/67hG7
         s+owcLbtbU++utg2hD7Kx8KoN7kpnVwRZ5x7+Z+KLIMVO6jNia8fMqOVG4IM67CC2ebI
         inTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0B2nDA6dNMtvxDIcBHzai6u1Uy3WHBZdoSKhG6gDPfw=;
        fh=6d+Hy/AViT+b7PycfZqxObpTW4K4gs/10uBF3CpBQFI=;
        b=cuL3hp5Fd7H9yBtHY33uina3u/RRKn2cZfiOl7GyJvQgeHEWFAOcug2CNwyh25Ladk
         hCRcqzdtIDWn6Ckdtf/Wtp94f/gmKWqsz4rM729OTMKl/WJSj/Z0xu4xEZnN6X3TMcAP
         GVOBkvtJYA7A9b4BUtoWwXdgshUZ3wyjd6tBRsfgQngftTqWJ70kh2y+4fr2LBTAxwD8
         OHalN70xpJYhYJ/xh4AqO/gqcnm9FFch2YQbJvOmoY+FsTBuTk8ztXwj0AjJkoY0CjS6
         HtnId3rmm5j2FStfdGmsH4pRasWaDhq7mpTQRM3YF1th4dK9OPT+nmcJYISb000pZ5hW
         iz1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191274; x=1779796074; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0B2nDA6dNMtvxDIcBHzai6u1Uy3WHBZdoSKhG6gDPfw=;
        b=NTUzHK2hhoQbqKLJBnFi6+azAqhPqdZvoy4FDeBPTRwde5T/buLxHMKmdWSaSrQr6g
         iVof10VM5eLnPSYlPApPcd0T5sVTdA7L3XCAnqpF/zrFbVybgt2+e9KNAYhUfq5m76kC
         Q7D7HbYQr2qcn6hoRNRS+9UGUDIYcaVb249261/yMmpw3ZC9khAsn1/9mHEptKO3JeYI
         /BSGIc5KI7hFkBAn1wcIwsJk+7pkc+YqfhyiOqPqy1FAcfNbp834yyXRe0OTREVr5ENw
         yktLZ0RmHFW4LnME++k6pnfzj1dgj0TuK6RabXHXsWhN/Av2NuMQizxoYwKV6bPFaoUl
         d+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191274; x=1779796074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0B2nDA6dNMtvxDIcBHzai6u1Uy3WHBZdoSKhG6gDPfw=;
        b=raOWRYDS+/p46nJVcZ10zTy8Z2yiHGit5Kirelx9j/Z9j4On2Jg02VmqjrH5aBtSmN
         lenb1HsMIJv7UQV9D8hRPt/XZ6ibWKB8cCddeeoudgp9rZbP2bgLSkGFU1rdC+yQYeEy
         7XzJJS2xDGkjc2/dZX/q2aYmI3Mp0yxdcWI8q1thloiGJ87vp+myFt/NP6Hi6YuwTRtE
         AJ+vR572ZMwfalA77TGy+TJh1H+ad6YQvCwa0P5xDc/dH9aNls2V/mCeHjrXEtDAa+ku
         0VmNA2ivzJ0tYE7DFBb7Sv12rOhgcZWqKoODoh+7Se6aW3Oft+3JWnygIe18WN2dtVY6
         vxPQ==
X-Forwarded-Encrypted: i=1; AFNElJ8vqSr5NNZyL3OU1nZdt8Ou8I+g6wvL3XSDel6GdZhaC3E4dT9Kkrn0WO/QAqX/nt9YMlyc4cY52VdPXyyB@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+1emJpd42RaVBTeZmVUWLbtQAd6w3cNIkeor9zym2MFeNhGiE
	cVP/zzs0bWzmVQnIJ5uuyXbaTLuDxujlB/ES24J+zZVFXyUx7mqENNb/skxHnDEuEA3EWGx1jdv
	dBkc1+9qhTzTUl/LHRVUoHxfNE6i+1/oDqo5u
X-Gm-Gg: Acq92OEXbooVcKEvkNUMSYT9J7Nv8l+uCvwsAQA4ir+wgwr40RyXPuhyh9Ijcc71ETU
	Ukn1nk/R3NeuS9C74RfE8ga821d2ZT/RmG0RMHQ/uXL51dDrvXctcHRgeN2N/75o76hiurU8aKf
	dcZvcw4tiYQeRW4YWM6+lbKIMmiSI7NwA4HvIgriTIvX3cYuqg/4mr4nzB88XzUijwxonzG4xFC
	6JPRsUAwB1Q/3GDE6eosN5xKdimsZTiWViwfVWVyNxRQRPNRuRlk21OwLk1VG90k+QJow20e0pQ
	X6A4VQUA7TbuvC3RrHPSOjcRnmc0gOMMT77/W4tkJg==
X-Received: by 2002:a17:906:5189:20b0:bba:3cf3:2ba6 with SMTP id
 a640c23a62f3a-bd51792d9a8mr795746566b.29.1779191273476; Tue, 19 May 2026
 04:47:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-18-joannelkoong@gmail.com> <CAOQ4uxg9WT7WmJqQezgiCB1jOX_heW+=UJbbFntbfDUdm0H=tQ@mail.gmail.com>
 <CAJnrk1bqfAczXnTxtb_rui2adksDpFKXOvJyj=zotGeWJoA5sw@mail.gmail.com>
In-Reply-To: <CAJnrk1bqfAczXnTxtb_rui2adksDpFKXOvJyj=zotGeWJoA5sw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 19 May 2026 13:47:40 +0200
X-Gm-Features: AVHnY4JCSAmM3oKClqSQO-mMHaJl2Mw25FZtaTf6mqtF1R_x-QV4G-cAKl5EvD8
Message-ID: <CAOQ4uxiXYmi+LUcETe_ftYzUN_KhPz9aNAe_yiX+kCBYt+zDXw@mail.gmail.com>
Subject: Re: [PATCH v2 17/21] backing-inode: add backing_inode_copyattr()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 1:21=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Sat, May 16, 2026 at 2:33=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Sat, May 16, 2026 at 2:53=E2=80=AFAM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > Move logic in ovl_copyattr() to a generic backing_inode_copyattr()
> > > function in a new fs/backing-inode.c, which other filesystems that us=
e
> > > backing inodes (eg fuse passthrough) will use.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/Makefile                   |  2 +-
> > >  fs/backing-inode.c            | 43 +++++++++++++++++++++++++++++++++=
++
> > >  fs/overlayfs/util.c           | 33 +++------------------------
> > >  include/linux/backing-inode.h | 14 ++++++++++++
> >
> >
> > Nice!
> >
> > Please add these files to
> > FILESYSTEMS [STACKABLE]
> > section in MAINTAINERS.
> >
> > Otherwise, feel free to add:
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> > There is one more cleanup patch required, now or later, to get rid of
> > some awkwardness in kernel fs code.
> > If you don't want to deal with it, I can take this cleanup later.
> >
> > d_backing_inode() is a noop from the day it was added and has 177
> > call sites. Those call sites should be converted to d_inode() and
> > d_backing_inode() should go away.
> >
> > backing_inode_security{,_novalidate}() are likewise unneeded
> > dups of inode_security{,_novalidate}() and should be removed.
>
> Awesome! I'm happy to remove these.
>
> You mentioned in v1 that fs/stack.c and the corresponding
> include/linux/fs_stack.h are pretty much only used by ecryptfs. It
> looks like there are only two pretty minimal functions in there. Do
> you think it's also worth moving that logic into ecryptfs and
> eliminating fs stack?

I wanted to do this once, but ecryptfs is not actively maintained
(odd fixes only), so the maintainer did not want to take any changes.
Let's leave it.

Thanks,
Amir.
