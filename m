Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793361291;
	b=IXuxVc5bLHMhB3T7YAVShYoPNI2S3Qsw6kYXtWfqsGZrXzXTSo7GuKDAK78GpAf4IjyC
	 0yct0GaDBvy+eqI4EgC1s49Mo4rEgPm3nsJ9rx3LyqfLkQMsPs6uFsKvYIW+11A6G2rCk
	 Byeqol1f1949a0CiSoeILtkbgJoE0dVCo0Db1QGH5dzkTSE7kUAquM4yZFOUT0JLjQYN1
	 93gT8vi9K1icdAuaeVRRkpchuT/FTWrX4BiFlSQj35dllxa3jtw5ppHQeECTE/uFimWIc
	 VFM+Ntqx8+6OFlkO3kO2ckm0wCrXGPapZlV5aPLgxpOufUWJY+YXwQ/3ZsgHNU1/Ltw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793361291;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6bQ6ZZpHabfRvZSQoIyHAduDOey6ACVdCtwVDeTSY98=;
	b=eFzkGiIBw4gp7ajO9kDLOXO/rgAxXxn/FX1WW6zhNBIz+q8fH4VPrL4Cyg+ly9ZTH3aD
	 pensB+LqtpsSP7fhoOj87+l9SpubSi+8w4MY98Ef/0z82z9qtxXHkJoxduvD8DktF8rBT
	 KToF/tUYQaLeBkRrAt/DnPXdqW8CGi7FgwTirZKtc9u5KTxYWPjpWJfiojxz+vJ8TQOGT
	 Oo8FG4Sd2ZAPK22PmrIymI78exZIy+5pbrsqpyfzKoiXRc7yjqdtDH/+s5jscjIPduL55
	 +xxu7bj9LKCvjRjki4U2htqeH/OuuqQIm51Ur7nzLvdCUicL6hYZWKB1QmXCzAVVHrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zgGFeFit;
	arc=fail smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DE6606A320
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 11:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4DE6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zgGFeFit
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so750826a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 04:54:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793361289; cv=none;
        d=google.com; s=arc-20260327;
        b=jPILfbcGEgMPAEX1Vn4VPwjYICPXkiEJQbw8H+CSdXA6Y9XR/QQht/kN6JuO/REu4n
         ygOvLOzmHQzlquaqw6VtoADCwVWu94WVQW5pwhOy49M0D0Ptfltj7tobH7pzqs2JNgF1
         xYAypxi4AbXniyreifpBIGGyDzAZovznRdifDkott/EzU2w44Jw4Bv1GK1Mt6cq6oP6n
         iKLnYig5AMyix3nVwQxxxQ2sjwd4dL33YyvPs4RMBgzD8aT9iY16lkLdknEchwYE43bN
         QAGCKfrMmXEJnWypShZr1/GEAVaD21jpHHET0MR4SA/Ylyn+R5l619V4IctyvprxIJle
         svwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6bQ6ZZpHabfRvZSQoIyHAduDOey6ACVdCtwVDeTSY98=;
        fh=iewtzOKlMaBZWzDFxaJt9+HTZ7gPec7bJxMhzGVQpjY=;
        b=Gt2A7qeEC9KHQzGOTjEGKE+iE+x+SK2MzJDrXwpiQJaXqxe+XYN4Qjl52M6Gn8dbp/
         WI2SN4PBgrgyG1jPYXQO6CnT6DWp+J6Mj9NETb2ZkM7bVlMZSSdhMw0cgy1aWoy29qGX
         neyZQpvqUr6KBv5hMmQh/2WCU7tLu/URoNwKmrBRl1fVPT7WiQjFfCxa6YQDjdyciElX
         3BjPT7vQN0DbYSHvQaOgWyAnYAA8Sjx/+mZJkZDDY0cs8o3YDpIvM4K7rtT+OYW8Ky8A
         QAxyJCeqrK/8AUQRXxoAURobK23Ch6h0+cR3Kwf/2Fi8LRmPXgfkYShVxboKiL/i94GD
         cmkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793361289; x=1793966089; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6bQ6ZZpHabfRvZSQoIyHAduDOey6ACVdCtwVDeTSY98=;
        b=zgGFeFitjhi7kxcPB6FMZKpTVSC9dvTTT0WJh4vIqa7n8Tf4cbObbLBmGb10JuGBKw
         7g/oxsMH9G4Yr1y/d5skhpqjy7b+xJjMr3I2rvEnaGOdOKalZJE8MNVY5jqUpL6aF6li
         y98TRUDk75NrI/mkrQh/8jihmyVZCdeevpBcZKR5TcQJp2K+xfmHmhsCACpp40/8HCg/
         enOOeVGRANF2+jZSyKYJShpCPRXMb2VByF+N4tnBziKBONSIrkX82P+NyZAiqHPx5FOs
         EfEc0ZALBq5DW3HVORMPVjJKRdUdk4fILIYmvHYUH3Fh3G+SRhIbh1+LB1UdQuTAMwNl
         /dtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793361289; x=1793966089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6bQ6ZZpHabfRvZSQoIyHAduDOey6ACVdCtwVDeTSY98=;
        b=Z3MmmTOijWQMQIs+nPCJaa8IjdwkecaK1VVkrFPhwJYiC63VAVTvskFfMt3DJTH7u8
         3eOoeGpFjPmLn9UZ4HqmZeFm4bhs+D0vDecboM35ASgCiepUVj8SF4LSiDQU/5VgDApU
         7njb22Obk2XyTwohT868zzpU8fSaf0rQh5bBSi42uSI65MKnaV6zMorRzYHS4bbLf43F
         ZehN6gvVZ0IczjFNLNjEqN9oNBNQhqK5YKC6V0Ism+SREADMdwTInwcDzkoL5ASETIfD
         ZorSV2WEuTSPXXL7AgizDAQkz6k3HJMqbE2/+5beDPuVd+bEzBQPEIfHpmcu7PD6Yqsy
         JeaA==
X-Forwarded-Encrypted: i=1; AKwUvBy1r8o2E1+aCl/tby8fkC7aXlSHBfovnPis9yFDIom9ArRJVgnzRvHNpvDPElJX8ub/jdkxWsXb1XBIpQcP@vger.kernel.org
X-Gm-Message-State: AFq9FYLQzrqVUnTnsv3Fnjc6D9XfRT+NpAs8P5unMSfM/AOpncje9apu
	Yo3GTCxxzvdq0yhrBnyni+2Ijl3FvdKPhI/zXK5K/deM1WWOgjgZluZtAKJD4Zw4qf0qAJIJU2b
	0/Mc8iZP8m8wUB7WIKHrdUWPq/TF7lFE=
X-Gm-Gg: AYBFou22ItatbOkrD17x3ZZF5DHVbyTAUIcry1BIkOT9EvVzVv8AOeQwiDjXZ8bj25c
	GH5X4X8J03O7j8aK+tMs+XtBqOdmvv0M6/RL4JDkaLh9eyHAKOn+og4dZ0j00nXZKfR1DyKB3fl
	c6T9QmO1mI9H579JRE+Ij1Ktv9hcLUncXOK6nQdvksQo6KoV2LkLLizLAexcTzQz1j2OeV3u4o0
	0Gtffy+wIydOSZvayfaMrdToVXdiyoZsC+vXRCv/VlihbDVMSSMVWyB24O5OQmvfaRUHMsrnhmB
	1FiuuOnvgQ+fHEAiolopAUwh0b7gcxJTFjXSgBpLmOOj45pMGFfVxmFQmNy8I9fbmrPyXBIxJLy
	cqeZThccvre4B+db4QEUSHsqHOiS6/Wl+ADhw9mRDeqNahCLAmSz2wGFXgb1idYXfa1B8SQ==
X-Received: by 2002:a05:6402:c4e2:20b0:6b4:2b70:4a7d with SMTP id
 4fb4d7f45d1cf-6b4d5ede191mr1079780a12.40.1793361288879; Fri, 30 Oct 2026
 04:54:48 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028154008.67451-1-dennylin0707@gmail.com>
 <CAOQ4uxgDmhddqpFawaK874cfWCp4jVDnE67eqXyDA9eumpMEpg@mail.gmail.com> <CAGEkeHdXVTQU7VS=TxPqmsXMtFFeP=LWw-y04NmcRWJrwHa8mg@mail.gmail.com>
In-Reply-To: <CAGEkeHdXVTQU7VS=TxPqmsXMtFFeP=LWw-y04NmcRWJrwHa8mg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Oct 2026 12:54:37 +0100
X-Gm-Features: AclHuK-sTd0BhCfu01BaFX8UFonq1_wSWaurS4GV6csh_oR6EIVobO4gUcofd5o
Message-ID: <CAOQ4uxihz0G5jAijCOqzipLZ3=-iPd=8AUgxnwZYvFm+Dpkapg@mail.gmail.com>
Subject: Re: [PATCH] ovl: restrict casefold consistency checks to directories
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: miklos@szeredi.hu, andrealmeid@igalia.com, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 5:44=E2=80=AFPM Hungyu Lin <dennylin0707@gmail.com>=
 wrote:
>
> > I am asking because I got some patches for overlayfs casefold which I d=
o not
> > prioritize because I do not know how widely the feature is really in us=
e.
> >
> > If you are interested in reviewing or testing said patches, let me know
> > and I will send them to you.
>
> Hi Amir,
>
> Thanks for applying the fix. Please send the casefold patches over;
> I'd be happy to help test them.

Excellent. Sent you 3 patches.

Thanks,
Amir.
