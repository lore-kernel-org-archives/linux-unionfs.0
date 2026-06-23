Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7037E37DAD6
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222405; cv=pass; b=Y6rVUbzcojGHblNUpZqgFUEDkMM/8c2TneH48d4TLdf5DCWq4It32d3X0Qp2lYCpF5p3BxLo+G1Tot+yJibjt0y9ksXSfXgmQKCSkSKwH987/dZ9V58uIxRmD6UJrqhrVlcoOb723jkakgRHVyRnbgz9C41fCojSHDANjMAAvaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222405; c=relaxed/simple;
	bh=naGwHbf/OnobalARAnj+vTp84DxAOFSvrLt6sASGyEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AywefJR+Y3KHhYKm3OS3BhVarTjUv88NSIpP01pmwDsxfFvqgiElAYGhAu/cX8+BrzNdhHHEDgp6TMqGTYD9gUrkIXc2AbPJXrHrkmmWLEcwqOP15vHjBKRb8pF/poa/ugqPaR9UUbZbao2DZDFzFvex3TQuijsXcd4xadxyOKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a1a9n67J; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a1a9n67J"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7dc6fbf3e86so62268967b3.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 06:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782222403; cv=none;
        d=google.com; s=arc-20240605;
        b=LjFFVfCHB2pPrG6Zg6neWckmeAU77PuGEq80qdtDA1Cp7Rev1md9kfyp3yZXvL2a9R
         DCB0AhkJ8pH6LkVSKg7OWlDA/NKhVefteXt8ug069XAHe3l+6SZjiWJiapzk/l6kaoAG
         bZkb5lH1yMClJrzTB87tL8u1trTh0v9iZ885v5S687lQLO5Bg1FsmbIoHP3q1xWO8WRf
         cOQBCxovAiMdcDtg4EbW/YLXNB3UsUYoeoJHXqeySg1hCTY2WSf3J9+/GIuRfBqYn7N2
         lqTL+vE2HeezxC2t+Yy+MH51jJwmHc2WLLf0+80NMUM3jyjkZlsGClWImePuEnvufP3j
         Q9OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OVDAhCaa7kVcjIMaILCocP+xEUoBfbfXNIP0jnyxE2Q=;
        fh=0uAumYfVO2ZgEQ71Y22TdcSlnnaRSnDNnb3MxmQj24Q=;
        b=hR2xGzOQUg+n4V45dwnR0+FqIRTJkWDpoH18p0mHiJhK7UZBPNdU6d9nR0NrV4aEK/
         OyUOvZDlopj6FURp6WRTLV6QU+EXUS5U4R8GvIWom6gakcwS/UQpkZzBkXhKCDDTZXo2
         Mf/qEutsQBTMHG4Y+GHC2FvymbDhtbiZiD4K0dwyeTcT7cksBzBp4+k7tO4zKCqQRtQr
         drr/G5TnT8Hf1HyJl9PXeQKCkLUxfhm2k3JnC16UU35sO+en0oy4LEUDQXSRFxvLZWh5
         nHynEXDS4ebzq+I3ooLbbunFSywcQ6fNRC9nCr98Lgch03kKQVMqpCWk87mLRLtVEk3P
         RYxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782222403; x=1782827203; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVDAhCaa7kVcjIMaILCocP+xEUoBfbfXNIP0jnyxE2Q=;
        b=a1a9n67J2YqEfodl+hgpP7MzAeKgIVpfgGp6/VoHkbGrjqxOdcZXfsrbsEkDYQfI+p
         QWOp1mbszOBllLc9/W02H2nACjsGYJgeLA2fsXoil6QyuWno3pk9Oh0cwNedJ5dSx6EI
         SfXLwTGLrQ7KB//eF1ObISogQvNDjTQuRhy6sDSLHct/zGkAp368XwU5eXSh7C8IeVaO
         amHpsayvlubsGovy5OIEEHwBOIhVmWBmviLSX2gO3VzKiaRJL6jf8XVY69vJ4n3mBYtm
         bOB5w73qQBWN15HLqDxiFoH4pCeFzAJIiBYEBePqt39k42m32uusV+2KcvMibfLojREm
         f9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782222403; x=1782827203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OVDAhCaa7kVcjIMaILCocP+xEUoBfbfXNIP0jnyxE2Q=;
        b=p8QWtqxJC+86PokywlZvov2dSTOSRn/Nz6BKnbSHVedqgODfUCLk6aN/+XJLWyKFrQ
         xGtuoWOt45r+9fFojTdZGi84vs6o6E/Smt4ASREEY0ghtK2yd/TtIsTjuChLRk8RJ87g
         ODS3GDBA0R/5qCuVbiwtx482RRoxjVm3V6gHy25khwhucGLcrPDwtbSPs6lYcyo3pMXf
         bxkfuu6DS3Ch60tq49PZrA34Zf9ObPcw3mYgww3/+xFizCGytTdFkCjl7ZQ/LdUDrRvT
         S1hPDP8/aWiPnPlng2E5HIt11ij3akb4DcDSIQcvXnPTG1GZW8nUasRgpPzSAOx2a49y
         UgnQ==
X-Forwarded-Encrypted: i=1; AHgh+RpVyxtJGfibl6iPvGvgEb2sWXI0+TbCOs95mY9eEQKZCJr1i8zBBWdhgncNflEnckwpGSFh0upZ6oO0y7DC@vger.kernel.org
X-Gm-Message-State: AOJu0Yxem7TgAMkZaX8GtlJRRG6yYI7bhUh5sB/oVPkNdPz/oRAcrigq
	UCZljwa4RbXWN5Ds0UVFyMAYZcdpexz73pqrBw4dO/cqgNsYKc0QatF/WF3cAVy7/ShBPD8Y0y/
	yCUkghqdEEBZwmt/DXPIIj2wZwwGparU=
X-Gm-Gg: AfdE7cliKiRy/Fo8EDsJyPTj0/e42ty5qeWWm1AQ7OBp+wkgE40Nl5Mn2PqJKpJYXYI
	ndSSgtQ3WcIfSn+xtY7KDzaIyL9VjJwwa+8FXZQMZsBskLDpYEl2P8BlkVQXaUhldLnItFktxQm
	4jmeMPfnMLb1b0zomRE5sjyZtU3hymwKHbND9bNA98pwoJKB9tvhjsnp0u9PWCOHvO/xyksyDkC
	gvbP9T4BOHK3auyaKDVjWTORni13rwe/Nnp2o0OlADK1lEtQEB8Syw9Yys80A7w+AVn4yW10QUn
	7+p15g9gNQTrUvnu4awHiaJYU0OTdA==
X-Received: by 2002:a05:690c:ec6:b0:7dd:3463:6872 with SMTP id
 00721157ae682-806c43f4cf1mr29454637b3.41.1782222403602; Tue, 23 Jun 2026
 06:46:43 -0700 (PDT)
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
In-Reply-To: <20260623134240.GA7980@lst.de>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 21:46:07 +0800
X-Gm-Features: AVVi8CejP5RTOJCGiaz8VdxrRrJhsIxtNpWREFVOphTzfzYmjTnmZ8-fngNkRF4
Message-ID: <CALOAHbBA0i7pX-rbtvu0krN+5BwJ7hTvBo_tmOLTYOOqT6fsMQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Christoph Hellwig <hch@lst.de>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, miklos@szeredi.hu, amir73il@gmail.com, 
	linux-unionfs@vger.kernel.org, fuweid89@gmail.com, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 9:42=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> I have no idea where this coming from as I can't find an earlier
> version in the fsdevel archives.  But changing user visible mount
> options through konfig options is simply bonkers.
>
> I'd also like to not that the submitter does have a history of crazy
> patches including those to support proprietary modules and then
> attacking people criticizing those patches, so I can only suggest to
> every maintainer to ignore them for their own sanity.
>

Honestly surprised you haven't made it to my spam list ;)

--=20
Regards
Yafang
