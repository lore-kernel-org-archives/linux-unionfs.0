Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E9716402
	for <linux-unionfs@vger.kernel.org>; Tue,  2 Jan 2024 20:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTjP/OFw"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-680b1a2c966so13823196d6.3
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Jan 2024 12:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704227240; x=1704832040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EwGIxvtVyqQwUhP2czujK5kRiCumNkJOvjc4nAC87c=;
        b=nTjP/OFwyxg7Vdj4eZrgJDd2+T+8IMI9DJCf+bl5ot2DR3WnXwXV92veTpkNoTYEFd
         lDlXzh5ZYSX5v2xcdDulRcbIUJJMMPlzPMvQKxUGg6goymLAFkCE1ILjpovHlZSEW3W8
         6PUEN8pQOIKh3anYGTeD8djUhg/+rqVuqtpV9wxuinlaCgjDnXVUfbiOwCZ3gM0um5Xk
         +TVa59zC5Y0G9maU1lob1NaPHD9gM0/TLtfe3SqLRgllPr7jxMFrzGUA6ttqVA2OaC1w
         yqErFeo81rAzW1Qql0e/DP2gnzA+5w4TeGjSlDZnhA7+rJT/tljFuSW8Zi9CrqmdRA21
         UaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704227240; x=1704832040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1EwGIxvtVyqQwUhP2czujK5kRiCumNkJOvjc4nAC87c=;
        b=MZ52g1LKb+VSyK9VGa4OXJYiztthQODdInKpUsKHijlSxaPS1WexrLy/s3sqOa+r6k
         ICwqTiUnS+rxm5XrWwgZ4icj+tSxhjA88xdq+y4ydHVOyso584CyxsPCVzhesYd9xay+
         3oiLAqp689Z90q1tQdb5iK5CM8WL5gsi+dMMf42UKeDX+obpgv3xZtKXBo3QMkMbapI+
         UcNgVRqB2ocq5YXw/IUMI1OOiTpll8/5HvifphsPT4QkiBwD5QhSXcoSI6EsubdzKVeE
         JiEUAG9k1KNHxsMDKGCKSbCQpaQ8oz5uPaZx2udcWBv+BgusefW5pCX2TSHnp7g2fVyO
         eJsA==
X-Gm-Message-State: AOJu0YwIZpR6yv7LA8l8l4dl+X9phMmA2+OZrTcGfxiaOiSDkpyLdoqP
	QeBP3ELwZmm1uS7EBLNyjakFqE15Zpqa8n8Szes=
X-Google-Smtp-Source: AGHT+IFW9r24IvxoOANGGR0b0WBIBHY6z6m+wpHBLcSAq1EV2PVfw0fR26W8etqXoIB/dSC6OjoXCsubDohyzhNNm4w=
X-Received: by 2002:a05:6214:dc8:b0:67f:143d:b8ca with SMTP id
 8-20020a0562140dc800b0067f143db8camr32519460qvt.44.1704227239712; Tue, 02 Jan
 2024 12:27:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPPzL72iBRiUcaL8P=NQ+kMxpDW+4A5bbPku==Z+TitdbN31pg@mail.gmail.com>
In-Reply-To: <CAPPzL72iBRiUcaL8P=NQ+kMxpDW+4A5bbPku==Z+TitdbN31pg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 Jan 2024 22:27:08 +0200
Message-ID: <CAOQ4uxg9U6AKakvLgfkrOYR5nWOs-L1rUbEQtBzbWQJTRBm7Pw@mail.gmail.com>
Subject: Re: reg: Stacked overlay support in Linux
To: shanthosh krishna moorthy <santy.accet@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 2, 2024 at 12:16=E2=80=AFPM shanthosh krishna moorthy
<santy.accet@gmail.com> wrote:
>
> Hi,
>
> Is the Linux support for mounting overlay file system over another
> overlayfs lowerdir still supported?
> In kernel 4.1, this seems supported but not in 4.19 and above.
>
> //Create lower directoy on an overlayfs mount
> root@device2:/# mkdir /lower /upper /work /merged
>

So /upper and /work are also on overlayfs?
Even if it did work, I think that some operations may have
unexpected results (creating opaque directory).

> //User the 'lower' directory as lowerdir in overlayfs mount
> root@device2:/# mount -t overlay overlay -o
> lowerdir=3D/lower,upperdir=3D/upper,workdir=3D/work /merged
> mount: /merged: wrong fs type, bad option, bad superblock on overlay,
> missing codepage or helper program, or other error.
>
> root@device2:/# mount
> ...
> /dev/mmcblk0p9 on /overlay type ext4 (rw,noatime,nodelalloc,data=3Djourna=
l)
> overlayfs:/overlay on / type overlay
> (rw,noatime,lowerdir=3D/,upperdir=3D/overlay/bank_1,workdir=3D/overlay/wo=
rk)
> ...
> root@device2:/#
>
> Could someone please shed some light on this error.

The specific reason is to be found in the kernel log.
It may indicate that some configs or mount options could help.

Please check the difference in CONFIG_OVERLAY_FS* values in
the two kernels you are comparing.

Thanks,
Amir.
