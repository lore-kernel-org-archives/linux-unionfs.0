Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297231864E
	for <linux-unionfs@vger.kernel.org>; Wed,  3 Jan 2024 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGjIm/Kg"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3bbc7746812so4692744b6e.2
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jan 2024 02:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704277034; x=1704881834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmGMYvk/b5FPeZn2XmXA8/qMTZp7zBCx9/1kFz/mbmM=;
        b=lGjIm/KgvQsfcIzaywRT5+9NMHwE7GzdiFnn5ztmcZfd6UhTaEZD5jVfnJdKFil/07
         pnPg7v32wBugxiLhbqaQtMdNX3XYXtEe276OtNJmtcKpn1udbZTBVzSZ2HGZfSSMcxeL
         6gxNStVJmbXaPW66JWTGZtSD79IevmI3noYADT5M08Bf6mfWuGWDUgZ9BitSyI2fGK1/
         kjkJunq0MRR5zJ+Y3oQ3K3BLTY+0KSazxWoONZdnYxs9J87LRF4ZRsnkC0JD1fmMHAjm
         VqOk6rGm12vo/m98CzPHKROP6jTM/U/qE1CjzzXoSiUrl9svBORtk20VBCAdwSvrbRWM
         ti7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704277034; x=1704881834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FmGMYvk/b5FPeZn2XmXA8/qMTZp7zBCx9/1kFz/mbmM=;
        b=trjJc0zGJl5IwN1ITSV85QSlgZF8KeeRkSm162RKbChXg230yrmNWBKOOjUZbPUyaj
         IrWTRXSdEUngOP59FpaxS1YqUmko1zJBIWdm1dT30tYi2PM57EiFfAFZ7Li+MykmCVs0
         03tzzYa2cz1C6PXl2yB6Ksi0RcKsQ1WcSUR3sswJfwabZ++hOGf8fmwwdCYRP5fVTsUQ
         SK8Xwr0I9hUK2sHfL20GvmMF4c63OHaanYTsAvNH89BjrGzUKOjFPmT9bJIbjxnXEUoO
         wNbZkBEcTy9BPCUjL8LM70QNVVYB3dI2mDfCDnp0tNHHLf4bI+LqjqR86/RLm6/zCg40
         mj7Q==
X-Gm-Message-State: AOJu0YzGwQ5S8n3P1MH+2rJi9ZJzLenKxBMVvgaUWIj3/W0Iyk4WmcKu
	0aKOpsqg0agGARFhFcbbR1RlvUYyOJQsheMxdij7nV2h3BA=
X-Google-Smtp-Source: AGHT+IGHapL5BgyQL0Ai96BtjdzVvV4sEfmpcVltZiedJHFMo/AKRSq/utE7BuIE+Mysb9Uw5isMZTrOWCbzUfLK/Yw=
X-Received: by 2002:a05:6808:228f:b0:3bc:25f1:5212 with SMTP id
 bo15-20020a056808228f00b003bc25f15212mr799086oib.12.1704277034083; Wed, 03
 Jan 2024 02:17:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPPzL72iBRiUcaL8P=NQ+kMxpDW+4A5bbPku==Z+TitdbN31pg@mail.gmail.com>
 <CAOQ4uxg9U6AKakvLgfkrOYR5nWOs-L1rUbEQtBzbWQJTRBm7Pw@mail.gmail.com> <CAPPzL71Y_g2M7Nuxgei1sx8NkmYPvsDDK-S=f4v4QyjnsVki2A@mail.gmail.com>
In-Reply-To: <CAPPzL71Y_g2M7Nuxgei1sx8NkmYPvsDDK-S=f4v4QyjnsVki2A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Jan 2024 12:17:02 +0200
Message-ID: <CAOQ4uxg__KvqL6==OoaP8oVqG=M+xi-8gLQq_WY2N+qK5xvJ4g@mail.gmail.com>
Subject: Re: reg: Stacked overlay support in Linux
To: shanthosh krishna moorthy <santy.accet@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 11:03=E2=80=AFAM shanthosh krishna moorthy
<santy.accet@gmail.com> wrote:
>
> On Wed, Jan 3, 2024 at 1:57=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
> >
> > On Tue, Jan 2, 2024 at 12:16=E2=80=AFPM shanthosh krishna moorthy
> > <santy.accet@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > Is the Linux support for mounting overlay file system over another
> > > overlayfs lowerdir still supported?
> > > In kernel 4.1, this seems supported but not in 4.19 and above.
> > >
> > > //Create lower directoy on an overlayfs mount
> > > root@device2:/# mkdir /lower /upper /work /merged
> > >
> >
> > So /upper and /work are also on overlayfs?
> > Even if it did work, I think that some operations may have
> > unexpected results (creating opaque directory).
> >
> > > //User the 'lower' directory as lowerdir in overlayfs mount
> > > root@device2:/# mount -t overlay overlay -o
> > > lowerdir=3D/lower,upperdir=3D/upper,workdir=3D/work /merged
> > > mount: /merged: wrong fs type, bad option, bad superblock on overlay,
> > > missing codepage or helper program, or other error.
> > >
> > > root@device2:/# mount
> > > ...
> > > /dev/mmcblk0p9 on /overlay type ext4 (rw,noatime,nodelalloc,data=3Djo=
urnal)
> > > overlayfs:/overlay on / type overlay
> > > (rw,noatime,lowerdir=3D/,upperdir=3D/overlay/bank_1,workdir=3D/overla=
y/work)
> > > ...
> > > root@device2:/#
> > >
> > > Could someone please shed some light on this error.
> >
> > The specific reason is to be found in the kernel log.
> > It may indicate that some configs or mount options could help.
> >
> > Please check the difference in CONFIG_OVERLAY_FS* values in
> > the two kernels you are comparing.
> >
> > Thanks,
> > Amir.
>
> Please find the dmesg log when the mount fails:
> overlayfs: filesystem on '/upper' not supported as upperdir
>
> //Linux 4.19 kernel config
> CONFIG_OVERLAY_FS=3Dy
> # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=3Dy
> # CONFIG_OVERLAY_FS_INDEX is not set
> # CONFIG_OVERLAY_FS_XINO_AUTO is not set
> # CONFIG_OVERLAY_FS_METACOPY is not set
>
> //Linux 4.1 kernel config
> CONFIG_OVERLAY_FS=3Dy
>
> This seems related to the updates done as part of
> https://github.com/torvalds/linux/commit/7c03b5d45b8eebf0111125053d8fe887=
cc262ba6

Yes, you are right.

>
> So, overlay over overlay is not a valid usecase that could be supported a=
nymore?

It is not a clear Yes or No question.
Note that the restriction regarding upperdir is that it is not "remote".
Not every overlayfs is "remote".
Overlayfs is "remote" if any of its lower layers are "remote".

OTOH, even an overlayfs that is not "remote" does not support
creating whiteouts and did not support storing overlayfs private xattrs
until very recently, so trying to use a non-"remote" overlayfs as upperdir
is a bad idea anyway - it will have some strange behavior and none
of the new features (e.g. metacopy) will be supported.

Could it be supported? I guess that now that we have
bc8df7a3dc03 ovl: Add an alternative type of whiteout
dad02fad84cb ovl: Support escaped overlay.* xattrs
we could support upperdir overlayfs,
but I really don't know if we should.

If you have an option to create upperdir/workdir not on overlayfs
that would be a much better option for you and the only option
on stable kernels.

Thanks,
Amir.
