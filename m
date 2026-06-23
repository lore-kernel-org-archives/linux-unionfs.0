Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492393C9EED
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782226352; cv=pass; b=aDQUveDNg9EttV2jRVglmUR+ghTae1FjQGVFQwVak3/jtNF0KDDu12eUgZMIDMnV3UM/OVDDO+CmM0kSdlComsuqs04I+8sAkgzEkSqZdNm5XCDOldZh+cADKtRbzzbsMH1cJiILe9jwLWTLhmsn9TBxBqsdlqnneQL65D5qVMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782226352; c=relaxed/simple;
	bh=ICkjq/xbZ1plX4sMdA6HTZKiR6LEZANYI9Hn7CqWAro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hTE+aVY5/bU/cjEjreu7ANQ1GyVnEERffjITFzNcrOF9Xb4EQKQyJVlpQsyDT5bzwXqTA5u0Pq7EhJIW3ugNryfDCD1eCXMtYZyLzNyqshKqAAueYv2p5QcJUhU/biVbsvcYOmdopC5zjf+CcBD7Ue9Xsf0+3n8YZabhit/cZhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UIUwt71X; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UIUwt71X"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c07a6520cafso644331466b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 07:52:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782226350; cv=none;
        d=google.com; s=arc-20240605;
        b=ZwkZO97uL5BaG4Wg++hozskCP8Gh05Ru62o1eFvVSdQvbXrs9qT0cV4c4DxIyWTlKx
         OPTq30r/vn5d+vSGs5Ha+f4dj1D0fYnKuKG+GOgm9LcHIRnJZFAzUWHHX3dVj0D25ie/
         0Jvn2EJfnlpHjPFlL90H2O/xbb7MWodi0jSx9TRjTyG/zuGveLS2vXvUAFLlgE4QuY4W
         BdTfW4pt3Qn7cKlcuUDzyzhtwO7cVNDY+Zninae3kkXaSRL19cMSaYBV0RM7V5V8AJUg
         oKvKlCUXoioQb1KSIqY/KmIsby8bqgyPoTcKahZxwKB9+6OiZxWikIwoMToqbe3DiTcZ
         MsTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ob4cx6LW2r4Q2SRjcadgRHtWdltOEKPfRXNYhy/X5zY=;
        fh=61FkAqnqMDf7rCCWXPk5rUfdcPQptMmZxv0yS2oU/bk=;
        b=YnrxVbZFLqKMkrRmt7CW6puIZbRrvHE6+CR5n8XVBg+E4nEesXUi9ghBd8LzLuv0Pd
         0Gk+XZVnJu7cOWByOcVhh3pVsXs/3UeMnkTFEguaDLRZ4t4O4nY1Vz6+g20sI1ozkkYZ
         TiP7CHW9+hn5mGN9M2H6H69vkpdcqdlNcAYT2DcMOmis27lUvOimm5MdJ2Jq122lsPde
         oXbVNUl3F4guJPPQQB0rwRV8jp1Wu6t8mLFE6g7k6ipBetlBQPrYI3D5jNCJTw9FBaib
         oVCRxmTfKOU86rieUz2SQ1HOvjpO0zYqDTXI4Zd5u8a811bgkVYCEehr9ik4z6scOCSa
         QZHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782226350; x=1782831150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ob4cx6LW2r4Q2SRjcadgRHtWdltOEKPfRXNYhy/X5zY=;
        b=UIUwt71XqkdCuLCdgEK8Nr6nkBg5M3S4VtIXLBPQ5r3vn5nN0JkVS5GaoAl+koXyvT
         8QZWEPo5JHJgDBgEpFtF8lwHslcPGmq4/ZHLfY7MrYZvzjt7/YbxEnJxfZRyVYQ5Eg/k
         KYeJL8pweX75HbvJ1zL5BN9hSPojrAEfr1+p713+CW/9MbYMNa5/R75bFz6agic7WU/o
         atM9mqt1WpuHkCYJ5coTScRNXvC1DqQdDJovU0LlXwiM/3O2afO9xDi+BbnzNx3P/Uq7
         3gVJ9Khjk2ppRWheMPJwCaoZLe6fwCaIYIddDHopar6J70ZR3x4hd9AgvsmPWbr4Jq3Z
         jDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782226350; x=1782831150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ob4cx6LW2r4Q2SRjcadgRHtWdltOEKPfRXNYhy/X5zY=;
        b=PNJGGbVl2zU2JhmIdCtAYdmAIDM6CKAGFpaLBzKdg3q/CR3cxORvy+IKgGI5r0WL3H
         wXPqV2bhvPWZRgqrJ4L518hWTVwMGCLCCgmrtsXCVFfbiE3pVfj+CM56xAsVVbVB6WoL
         MwkqPP7eVjLTw3LqiyULZEDqfUY0+OndTHNbFSIv/sKPbasMB/+MONiO7Me4j0R1Zg34
         mC59fZQgAnPQO71eJB+0ZkpK0XurMlyysktDk/7XZn8LZqr54cXSq37mu59kK+hX4V2x
         2WJlPij40rKR6CrTxnl9QvJSf82FITSxMaQS3xIldjUhVqLdzLnqrznfJwRoDm6t1dju
         2VyQ==
X-Forwarded-Encrypted: i=1; AFNElJ+m5lhlJruVGZpaP71E+4WVCjkTbHgVQy6s14r6ct7OCEU6T44FRUv1KrsbdGcsPDSofA3SQ7uo02T+8eCS@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx7pdyZGLhYGI3ivspgouEHZjpIA6GxNTkzY+3OO/yc+g33z/A
	I0zoZALrqFk6JJLPFKq4O09fcWqVsxj8bFMN6WZjMwpHSfDFBytEe87zp3VPkrfQJObozJSdFbd
	0XYt3Oj4u1U+Kkx2eSeDoTUt93gmOfx0=
X-Gm-Gg: AfdE7ckEU68lgJpBSEvb80Yk4B0/T/jGFOwf0dKs9F7IoooqbVl+S0c6qwjY5mKY7hM
	Yr8lhOnJMxcDcDb88K49qWPGKStuUA7eDCoy4sTNmeG+q/kPPW0HZ2WnItIiGcfmpa2fQFtfs98
	K7Uo/lPH1WnJE8v8iD8oRT9FMdzyGUsYvGCPmvUMttUI7YIMEHvZo3D4WdpidWlls8Ep3t1XI+o
	WqHCODvU82WaWrp5sp81TuMEbLkmMOonRJhs8I3k8OyyP4fqmvFSB1rush2K6MsAJ+fnacqYC7j
	GBUvV3nJMDCY+cB70ORNOzDx8/bSYJ0=
X-Received: by 2002:a17:907:971c:b0:c05:21a7:6b0d with SMTP id
 a640c23a62f3a-c0c666c20f3mr767424866b.47.1782226349556; Tue, 23 Jun 2026
 07:52:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com> <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com> <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com> <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
 <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com> <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
 <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com> <20260623134240.GA7980@lst.de>
 <1cc0931b-648e-4baf-9667-742175b3f9d0@linux.alibaba.com>
In-Reply-To: <1cc0931b-648e-4baf-9667-742175b3f9d0@linux.alibaba.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Jun 2026 16:52:18 +0200
X-Gm-Features: AVVi8CcjqEnIW2CG6GS3bOoBn4_gVy_UbGzZpgc9FUENLu4p5-6IMD_YoyDKWjs
Message-ID: <CAOQ4uxhURfuQWMd3y_W1iFebJms3aohn+koy5_sjxbcc4ZBQ-w@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>, Yafang Shao <laoar.shao@gmail.com>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org, fuweid89@gmail.com, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 3:47=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
> Hi Christoph,
>
> On 2026/6/23 21:42, Christoph Hellwig wrote:
> > I have no idea where this coming from as I can't find an earlier
> > version in the fsdevel archives.  But changing user visible mount
> > options through konfig options is simply bonkers.
> >
> > I'd also like to not that the submitter does have a history of crazy
> > patches including those to support proprietary modules and then
> > attacking people criticizing those patches, so I can only suggest to
> > every maintainer to ignore them for their own sanity.
>
> Sorry about that I didn't Cc the proper list at first,
> but it could be checked by using lore:
> https://lore.kernel.org/linux-unionfs/20260623084337.54344-1-laoar.shao@g=
mail.com/T/#u
>
> This topic is very specific to overlayfs details, I'm
> not sure how I could say the background in brief.
>
> But almost every single container user uses overlayfs
> now, so in order to be responsible for end users,
> container runtimes and applications, I used some
> aggressive way this time.

Gao,

Thank you for holding the fort!
and for foreseeing this containerd regression.

I also agree with all your other arguments that "volatile" should never be =
the
system/module default - it is too risky - one needs to know what they are d=
oing
when using  "volatile".

I will respect your NACK.

Yafang,

I agree with you that your patch appears to follow precedents
in overlayfs, but I also think that "volatile" is not a good candidate for
this practice, mostly because it makes mount cycle fail.

Since it is so much easier for your employer to live patch the kernel
than to upgrade/patch docker, how about applying this live patch to
your kernels?

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index c93fcaa45d4a3..2105a51d12439 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -155,7 +155,7 @@ static const char *ovl_fsync_mode(struct ovl_config *co=
nfig)

 static int ovl_fsync_mode_def(void)
 {
-       return OVL_FSYNC_AUTO;
+       return OVL_FSYNC_VOLATILE;
 }

Thanks,
Amir.
