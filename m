Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBED18C10
	for <linux-unionfs@vger.kernel.org>; Wed,  3 Jan 2024 09:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbbvkun/"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6d9344f30caso175989b3a.1
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jan 2024 01:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704272622; x=1704877422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from:sender
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7+J9xJ/zVgNKTSQzSpz2oa56I7qgNF4ok/G4OoXTMs=;
        b=hbbvkun/ObppY6VmtLWqLZvvtKaHPtFWxezU3TFoBh02MBkhsWb10uwgj540WV7iM3
         X4azjSYcQmonhpgBJYtsipkyqOVXv/zVs+BE6JNSX7oOqJIYV3WQoZw6Z9DOdktyi2ti
         Flda8RLmdCns/3vqt7R+GN9YWq2ie2oo2wMnaxQGAQwEjYC9lXlBWH0Th26Wd2CPPxX8
         yx08aGFwQYqPt6bxyi/arShqBq645iQMrFC8cK+HxwO3mUuaHna4dcpzI3mfXTHYvMNC
         2eg1wTOc6J64Y9nlflT93Cgs8VJji1bMkfzviLBDfl+gr/bVWVXznz8E9wMn7Mal1A9n
         x/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704272622; x=1704877422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from:sender
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7+J9xJ/zVgNKTSQzSpz2oa56I7qgNF4ok/G4OoXTMs=;
        b=C4JnKKTg/AYIqJASwHHpmhzbIZ1K2e4kWeVdxTFhEOQrdc+Bb8nvBCPsV16Zk5fOjo
         7/YEpxruaYUMvGupcekRP6Tk/2WmVi7CByHHuDPYISymfuqPLQ1VSCiHVBirg6jpleHh
         8BWg2cgphclVTUKlAz58hst6CFJDRGmX2+Vk5+lSFJgH21Zgj1SAK7/mhur/BMzLznW5
         WXHmCyotewMm8aaB1TyAGTaq7NeEkf2evSMh+zz3PlrUF7pVDYtjq8oFcTyGDMhYhNGm
         kvkxBbJfXk+lKVqtUpyocXc3yAiGOWidoUqV2bR7iW8TC02N/iKV1KPCqo2j8ZqaIX2G
         UasA==
X-Gm-Message-State: AOJu0YxO/edYAsulsyslSAcsC20/ABA+K9RD4mcShrEKewor//kFg7EN
	3qdNXTZkJGSq3By+rGdMdn4GK85je7DikjnXRjuWSdQEfM0=
X-Google-Smtp-Source: AGHT+IH1hihKPkG4RKn0WvtGls747LF9xPosyxPI5F9NNbIDiv0IuJpnnTKk0Ql5D7T9xoPtAMOrso199aig9XA03XA=
X-Received: by 2002:a05:6a00:10c1:b0:6d9:acb2:29ac with SMTP id
 d1-20020a056a0010c100b006d9acb229acmr964817pfu.23.1704272621902; Wed, 03 Jan
 2024 01:03:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPPzL72iBRiUcaL8P=NQ+kMxpDW+4A5bbPku==Z+TitdbN31pg@mail.gmail.com>
 <CAOQ4uxg9U6AKakvLgfkrOYR5nWOs-L1rUbEQtBzbWQJTRBm7Pw@mail.gmail.com>
In-Reply-To: <CAOQ4uxg9U6AKakvLgfkrOYR5nWOs-L1rUbEQtBzbWQJTRBm7Pw@mail.gmail.com>
Sender: shanthosh.rk@gmail.com
X-Google-Sender-Delegation: shanthosh.rk@gmail.com
From: shanthosh krishna moorthy <santy.accet@gmail.com>
Date: Wed, 3 Jan 2024 14:33:31 +0530
X-Google-Sender-Auth: jWst5bXpidUM-JwzvhEoWn7l_14
Message-ID: <CAPPzL71Y_g2M7Nuxgei1sx8NkmYPvsDDK-S=f4v4QyjnsVki2A@mail.gmail.com>
Subject: Re: reg: Stacked overlay support in Linux
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 1:57=E2=80=AFAM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Tue, Jan 2, 2024 at 12:16=E2=80=AFPM shanthosh krishna moorthy
> <santy.accet@gmail.com> wrote:
> >
> > Hi,
> >
> > Is the Linux support for mounting overlay file system over another
> > overlayfs lowerdir still supported?
> > In kernel 4.1, this seems supported but not in 4.19 and above.
> >
> > //Create lower directoy on an overlayfs mount
> > root@device2:/# mkdir /lower /upper /work /merged
> >
>
> So /upper and /work are also on overlayfs?
> Even if it did work, I think that some operations may have
> unexpected results (creating opaque directory).
>
> > //User the 'lower' directory as lowerdir in overlayfs mount
> > root@device2:/# mount -t overlay overlay -o
> > lowerdir=3D/lower,upperdir=3D/upper,workdir=3D/work /merged
> > mount: /merged: wrong fs type, bad option, bad superblock on overlay,
> > missing codepage or helper program, or other error.
> >
> > root@device2:/# mount
> > ...
> > /dev/mmcblk0p9 on /overlay type ext4 (rw,noatime,nodelalloc,data=3Djour=
nal)
> > overlayfs:/overlay on / type overlay
> > (rw,noatime,lowerdir=3D/,upperdir=3D/overlay/bank_1,workdir=3D/overlay/=
work)
> > ...
> > root@device2:/#
> >
> > Could someone please shed some light on this error.
>
> The specific reason is to be found in the kernel log.
> It may indicate that some configs or mount options could help.
>
> Please check the difference in CONFIG_OVERLAY_FS* values in
> the two kernels you are comparing.
>
> Thanks,
> Amir.

Please find the dmesg log when the mount fails:
overlayfs: filesystem on '/upper' not supported as upperdir

//Linux 4.19 kernel config
CONFIG_OVERLAY_FS=3Dy
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=3Dy
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

//Linux 4.1 kernel config
CONFIG_OVERLAY_FS=3Dy

This seems related to the updates done as part of
https://github.com/torvalds/linux/commit/7c03b5d45b8eebf0111125053d8fe887cc=
262ba6

So, overlay over overlay is not a valid usecase that could be supported any=
more?

-
Thanks,
Shanthosh
