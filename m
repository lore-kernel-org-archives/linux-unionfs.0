Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0939D33B951
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Jun 2026 07:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854126; cv=pass; b=Pa1rsaut4shDwfh/l8h5h6Kvu6yD0dyrbGWTId1ZpJmQ4DHnt8g4V65RwFvQwJwTA0I90o5+xOqZYDRRycrZLR6qBK5ACYKjvBrQTPA3lSGpMMvaf0A3EQPr430C+qpQcwxMS7ZeVq+Qj1xzkdb7f22oGzsQ7B+hHSBcOn+HHS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854126; c=relaxed/simple;
	bh=PLjuf5U1Ldp+lKMspivltGTyqfvutQwDbWwFfF6CvPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBeLyryBmqRviRnju4nkmhg9HpOdKw02F4Ra+gdXlyXxaHYJcZfeuIzwX19e4htO2wEh/+lIuFf/XMxOtDtHE2eEBOIhH4Jd5pxtahqz6Rgh/A2tb2qUpR+PYwLk6jA3LibGolC0f2M1hiTHZlGGjQnZUwf6stnupN3F4i4l0FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKTQcXfm; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKTQcXfm"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-695427c153fso2478254a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Jun 2026 00:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781854123; cv=none;
        d=google.com; s=arc-20240605;
        b=CEfljLjpNDJtmH9uCRwSRe0mM+IJpn23xNGhkzOytFNHgN6LHIlfU9hPXMP/af7LVg
         nVy+A7J662247eNzxhYBWShHiOSCIMHDSjXEWRZwdrC/40lzviixHMDEEfTKTu5gdcTI
         xSiOQdnZ9bIIvJL0LRQ83C6SOsqDEVkG4lvQyUG4SIdn3E13CzsAxsYy6XGmInAZNOZy
         BM2FoNt61sCadxP6+qR2hBzPrnxZXHGIb6vvaqPdSoPquvQtsOsDPn0n197hERRxMf4R
         eFxYUZFJlc1qkl8IviVyApE1UuSWJZFOfhFp8ZmGMHcHNTUc3RrEEeFwwl9aTXoBLXdZ
         qS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        fh=g7IvkRm193p+DOhXR/wvcgz7JWYFvUeF5vr5vIUcjcw=;
        b=dP+sMrXDE/sgP80rarts2x9zYSSEv26SbfLfX5++dRrs1g7jx1ApYvqKHxSSkYW2s4
         eeL2dDb4hnXz5RURVqCrLPyuF0pUoWIchf1n5ylBYUMFDJ627lJ+bUPnGcCOM1JVL8GC
         vggAUEW7mcE4Yc+S+CADuTB+xZYw1lyrZMHeed5z0y/Eb3MFoWDHSAcQhJfp6mHQVrVP
         H34QtPHMPmD7/faP5HIvCDZu/hRH5RGf3bW7lMweLtXZF6UDGGV2A8FMSS28hQOGfy3x
         FSNg00X4ch5UFtromE3uBwKtJ8519DVCId00zhMo5bkOtghcxKRT0W3RIOHa2COSXbcS
         ikHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781854123; x=1782458923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=EKTQcXfmTpSi/O7oXABloqzK4/JL++I7lANtSI92FSwbPSaHSyI+Ly8uLgGGwc1czJ
         YtYQI1UH6Uizdt0GwLZqdw2hO65NG7CfVB0eP71OayhIh1bgU1DaOg15/9a9kMa2zgBW
         zdQNfNRTcXpnOjFC0pWD2Qy8AAunFSt5GVlRmax9ecbpzBv06uE4YFJ4+8celdU/Mj1B
         MGNL1NDGi6M4Os0QZhfGMRwpocG1MmdFdOgNugrBvNpnHeADOFto20dQ5EA6cQgJtC5/
         S6OL7JKPrJ0cmvFh1esu4XnUeP+wn0wTEaOxYUfcyAwVCO0NjXfBZnXTUOLQKFc0fC2I
         AXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854123; x=1782458923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=SyG1jzFBXSnTTHsjdUZKin0ImcHLXE1/fOz44veJgi1n2F0vGH4g49ZAh/nqH264zF
         S4cLPL3IoUKjYsWEixsmnHzUqlxPF6fE65WVOROZyKjb9Sj6ldM40W0kGb1V9/NRTPqs
         zA4KcSWhEPhXvWYeoiAKlkD2osiUWW2WvoJ72T8VTXaWCDry3jbzRHegVad75bkZyoIs
         HJIRx1lgnKROmfAKrFfuWWMf+3VoBGVKgBVJvr6mavblQHQRBxKzsyE8nEdvwO9k0Q7a
         DaXJaaJtBhkXPdGu/h3EFN5NNbT6MLHFQ8UqeV9YKT66CFreafpSR2D4jw/N7POVNk5P
         nHjw==
X-Forwarded-Encrypted: i=1; AFNElJ8Jklv7ZZu9vwegRE0F94pGIIxLOZqeD+WkKWTZ/PfgHkmAOTPJZk6oVtoblE/UZEQ8TY9ew/V1+G7N2Y6+@vger.kernel.org
X-Gm-Message-State: AOJu0YytMAtm80QNLAg78uN0kQo5+fxyopKDbg36ZcIAhXWc0V/++Il1
	V1jKdxdo9CfwxeA1xtqWw2fpN9L5wkiywgysPssMiERtw8TGU9/2X2FauEM6INT6WECaKrVsmhW
	NaqNCMIAQs2Sh3G4Avoey/oo8ornZBRc=
X-Gm-Gg: AfdE7cmodXe7SYhmyU/SJZ4oBBtlx2XuVuNXExKGF1q/yCv9o5cgpP0BJXiSNFQMKuL
	IYMXaCVk0tGNkChLXovhjfotlOBZx+OzT3V3s3DdoLuDXuB0dQK1js59W0ZRHf5H2p2xD5bBZWm
	s/5CmpT66F6maPKaXAyeVhYNcDiQhAoqAV/jroB7OARRDts1T/d9FtltrQA1wU6GxD82a0gNDQ8
	X9ewRQCJp5LTdWxcaJjp7i6MF51fbIiRZgnQ0U8eHNuPuDl/U/Ffo86eq+JyIsTplbceW9f2RZl
	716BxtFLzsIR1LNH6iyi5yJSHBKYvBqJo7HiDsa2DA==
X-Received: by 2002:a05:6402:5107:b0:695:572a:7ab5 with SMTP id
 4fb4d7f45d1cf-69711e00675mr1216968a12.19.1781854123208; Fri, 19 Jun 2026
 00:28:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <20260520190719.GB3424023@google.com>
In-Reply-To: <20260520190719.GB3424023@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Jun 2026 09:28:31 +0200
X-Gm-Features: AVVi8CcyPPKNjODd0CeG8qbXXsZeOsRanxA9PmKFMYeTLACw7w0uBX2gqOCDc0w
Message-ID: <CAOQ4uxh_hfiSwMw8ABhhrz7GguZWjHEiBmvb3eq16Wfqw0+ZrQ@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 9:07=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, May 20, 2026 at 02:37:01PM +0200, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/util.c | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
>
> I'm still confused by the new implementation of fsverity_active() that
> got introduced by "fsverity: use a hashtable to find the fsverity_info",
> though.  I should have caught this during review of that commit.  For
> one its comment is outdated, but also the memory barrier seems to be
> specific to the fsverity_get_info() caller and probably should be moved
> to there.  Anyway, that's not directly related to this patch.

Eric, Andrey,

Did you see the Sashiko review for this patch and others in this series?

https://sashiko.dev/#/patchset/20260520123722.405752-1-aalbersh%40kernel.or=
g

It annotated some review comments as high and critical.
For this patch it is about interaction with fscrypt.

Please take a look and say if this is concerning or false positive.

Thanks,
Amir.
