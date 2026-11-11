Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794401543;
	b=h7nkmKDWBmWdIp0vxdn13aALwIW/QBd1X0lds8IQSl8X46naLGs+G6S2PjPLaVXBnRYt
	 lWzWv9g+Kfplq01ny5fT7sgentLEB+6tdBLrs9hMPKJ0BEm8FU4u4r2z0RAE58JuGBabi
	 bO5y02WC1d9MleN8UzYxUJb52lA+UGrAuQ92UXiz/59E89kCQQTFSA7KBSbx31OHva1WN
	 1zsrqFxq2ybJMeAgNdxipYjPfCBedCkRXNIVEj9BB4wjiF8YDSEUEvoiJOgpfCokSytjQ
	 OfUg58fCaHTmVaWF0g++pnl4+4290VZFc96QjGqVkFhWmDUVTu41Zhlz7JuiCvVjHLQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401543;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yyF1k+Nl8WkujwkQb8UMfUacg2rnyls+UTesH4TGVLk=;
	b=sDO5FBjE6jwxOsCf1gGNuHW5Pt0jcz/R4sJBXFy3YDElfvOQhn/o+h1MX+vQZvPqjc4T
	 XqIwhn7NsQvmnhIxr10VMPweZb3ankFRXAqiV8ltTTQvfXh5JSRW3hIrNgNxDkilsnf2y
	 xuVvTIGzSY1Ou3N3IQinzwCEN5xpmNXVDw8zciHl+xbyKhcxai4e1ZTHNpmqFhAzUjDh9
	 hsLctJyEjKVRt4Ahm2Q5zW3HrkZi78ol9sA8eD/4jixKvioSsL1Dd/CixL7P1Nt6JTUp1
	 iE+OelKp3l/CL1BJccsF3ZzQYns6MiDubTKC6z1dLvq5klkzzM/vvclYcL1tFGylo4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g4i3qHDd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18CB606A31C
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 12:52:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D18CB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g4i3qHDd
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so4513820a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 04:52:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794401541; cv=none;
        d=google.com; s=arc-20260327;
        b=FrCOrbdYCadS2W14YC6YWwa8oFIx1oV1uZbS68VfwzlCyAndjUVPHPC5XSgPbwRLia
         mZ74hD7aL8EEQw1KsfH4Wr/y+gdp/G7UVzw38zffOcVRMAfs83J38/qAxMx2/tgtwNIp
         qBGX3mrvYAs+XUtZWLSWGokQclVYJe4WBz+hpOmIUSeZedKpNb7EBNPCuV0MZNZMTxw3
         Y8ml8z+hvfaMaBW8x78eKkmYu+0fewMHnqO4/vZuYpp7PDux5OYV6zCvk7nbRcEeY3I2
         XBR9vlqAAqPN+x5vP3mBF1c3P3AL4f5Uy7pJ9Qi2dYRZ0hZeT9tK35fccJ1tg5muTNat
         iuOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yyF1k+Nl8WkujwkQb8UMfUacg2rnyls+UTesH4TGVLk=;
        fh=U/gkdZNTrBqF6SUazQhBsvoAF7NVhURdXT9St4rQPDQ=;
        b=GOIo7DrtgTY/KaB/xCXBxJ/PfHu/BEnCXEfS8JatNa5a4KjW3BBWjSv8ZZr8juIjLO
         dWyUtUcZBy7aTLQq8/jiI86Hn72vagOCMUE4hGaC9KlTGuYxHxGz0OjdSWT6jCNgLv4U
         jRFMYf+o9k1T/nghJc7vf1f/wV0IuIfJ/NFH4UeguGAiprRLJS1KblqEqeB9XODq6Y4K
         G5TTQQMAeNSL/COeh/YWEU1avkk9aIMYQ4xia/VIb1dI0V9x4BNhl/rq0DpT4O21oKhO
         UlUjkBWlHPDouVxEII1Eimf3s7JjFpHcMYl6fUx59lIDIVv6Q4Rh4lOHzQoYT1XUQoiv
         oycQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794401541; x=1795006341; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yyF1k+Nl8WkujwkQb8UMfUacg2rnyls+UTesH4TGVLk=;
        b=g4i3qHDdm8tOW+UktakB3jIBXjvnUY7croEIJ/nS8RxV25Re+B3cTM0wjriY/WVQYF
         GcQzq+zJYI8eZB9MX2A0R0ueBumXnpF3/98FDYzL/sYyUz3H69K9cbXkvQ+hfzG7ZNxl
         4AKyJnBVX2rzahb8UMFqFe6/C3KEr+Z97iE9qd7+lGy0w0wnycXp7FhRVtHOs/Zrplwz
         ArgV9Y3p/f25X4752UoeKq4zdxPcTvHciiwSBCRFEM9//ZpZ7ysLMSf3z+QcUVgh1ON2
         vMyzFEHoEYAE8Id6G8+qT3vn9/CQLq2EEyio9NriF/koIWzqsrABOzL4fV71z/BzV2az
         rraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794401541; x=1795006341;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yyF1k+Nl8WkujwkQb8UMfUacg2rnyls+UTesH4TGVLk=;
        b=fE4khhaXrTvlP954K3ERBEhtFwq9tcsOfuOImWbwgRl1SqmCwh1rgQ+6bx0IaXmCOK
         uY2M/aygSu2xhQMAJNRWbyRYm61sJEu7fY41Vnf/KSqBMkLbScV4ZVFNpnQiPUvva79z
         hO0UN3X05HDrcOBuG0RbS8LGzvP7+6VD/CfmN2CzvbKGf4ckdBkDjYIpm39lHurGoa8w
         IC4sDSXsMHOvdhP7ZS7ne3/rC0/dbtYq1mzcY3ociP1ukPjTHa+8ufVzk64ksYlTRFOx
         Iu43r+/B0GHy7s4TjRmXk/L51m/j763Aa38iUDjS3ikNKh/+7nXZSg69Xl9tRAMJG1vx
         WheQ==
X-Forwarded-Encrypted: i=1; AL+hErFmYanMk0bHu5H6ixGuH6yGH2e4hefLFL/sL83zch2Ymeg12RZ+GxJhvMyyOwHGqOtXIdoXE2nOd07aHqeU@vger.kernel.org
X-Gm-Message-State: APuU4Z8VMyzlOBTFJnOkMZoiJ5achSh2DpBvpZf1IRo3WbW760hWKMja
	R/A8MbqxqO5Y3TPU2Uj8U7YwQwhj9w0LEkPvvM7gYJ59Q733qicIIr8f9FPferqKsFfiP4gH4IL
	nggOnTm3i4fR9rK2pn5uSb1QDzRpOdZc=
X-Gm-Gg: AYBFou2P6G8gHpOtNi75YRfX+A+pX2vpncZ0nm2BXCAMNmSrNiwNgRqK+WFTfubHK6K
	nRgYK86Vt0TAEBxbNzOICwytc1AHruQJVbXFQxH7ym1KOJOh/WnRJGWS8NgzhHu+Xl+ZKtPqyYn
	c2PJk3f0LrppTdVMcoos+LBcEqaclytZXK1XsOwX0CTYjEsHdyhZ9K5xcyQ6uMm5bqxwqgacQM0
	KC5tMa4XV/OuW0G37brgko0n3LARfrdO/vZiuHzdaCsFcxEQ4MOkfGkHrIcf0VyVaXdHHsIc2kn
	1DtnSFI1JoOqqy3e+ro2f0Tz2ml+bsNNTXzM65g8zyEbJFab1FCXDcVSt2SfoNinCi2IFUGlvz/
	ypIZxncj2IlqWxvOU4S8WHghbkv2MzA1uCkQIUn88Ujc5NgcIDLqHA1DR5GvSc6xRaRUgew==
X-Received: by 2002:a05:6402:20c6:20b0:6b3:e4e8:74ba with SMTP id
 4fb4d7f45d1cf-6b757202941mr3723463a12.13.1794401541131; Wed, 11 Nov 2026
 04:52:21 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CGME20261110080419epcas2p24eb47374d80929645076c4d81f512c62@epcms2p6>
 <20261110-ovl-impure-stale-v1-1-1a4c2039e89d@samsung.com> <20261111045026epcms2p63d9818fa6ad5600eff4f74deca4a6e7a@epcms2p6>
In-Reply-To: <20261111045026epcms2p63d9818fa6ad5600eff4f74deca4a6e7a@epcms2p6>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Nov 2026 13:52:09 +0100
X-Gm-Features: AclHuK-uEdGqwVqtGF8NVHS7HnR8ycc4aY5yKZJoiyodA8cJpAP3s_D7QBW26qk
Message-ID: <CAOQ4uxg3h4h1TnYA0xyDoOUqN-otWUn=1r0mXaaFdbj+HEkkmA@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in impure dir iteration
To: daejun7.park@samsung.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, Hungyu Lin <dennylin0707@gmail.com>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 5:50=E2=80=AFAM Daejun Park <daejun7.park@samsung.c=
om> wrote:
>
> Your mail below did not reach my mailbox, so I could not reply to it
> directly.
>
> https://lore.kernel.org/all/CAOQ4uxgxYZqE=3Drv5ZYrbyB0cYi_qS-bv_4UCbDwGJo=
MGg1iNhQ@mail.gmail.com/
>
> On Tue, Nov 10, 2026 at 04:28:32PM +0100, Amir Goldstein wrote:
> > I am sorry, but this is way too complex to deal with a problem which
> > is not important enough IMO.
> >
> > POSIX does not define the exact behavior of readdir of a directory
> > being changed in this way and I don't think that the current behavior
> > of ext or overlayfs+ext4 is a gross violation of POSIX or that it could
> > break applications.
> >
> > I would be happy to be proven otherwise.
>
> Thanks for the review. I'll drop this patch.
>
> I looked for a program that breaks on the stale d_ino and did not find
> one. Of the d_ino users I read (find -inum, gnulib fts, glibc getcwd(),
> nfsd READDIRPLUS), none does anything wrong with an entry whose file
> is already gone.

Hi Daejun,

I think your patch triggered Sashiko to look at existing code and it
found this issue
which is a long lasting d_ino/st_ino inconsistency:

https://sashiko.dev/#/bug/linux-98f207b6-3936-48e9-a40f-88f20be4db7b

Would you like to fix it and send a test for this case?

Thanks,
Amir.
