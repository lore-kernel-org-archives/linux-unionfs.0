Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C732D97BB
	for <linux-unionfs@vger.kernel.org>; Wed, 22 Apr 2026 04:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776833576; cv=pass; b=DNYbs+q1RUqAjb1GC1dgnqEuajd+2dpndBnsLaqTa2LSSflkVBxmEABFp+QtKcxCpWgl69Jer0ZBtdVL9cY1YM71mSRFRg5vvZ2ePR1V9BS4I0GHY+7heO2TysQZvUCXXhG5QhB94/Sp1usOe+6aXPzj/MeEsfk7U53GSpOb3nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776833576; c=relaxed/simple;
	bh=q0Y5z69t7EnwFRmoQuriHXgrdZschTXv+jqPXtob9f4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j25kKe2igaGdV6fYdb+ydaUXMQdMcSdCB7mrXEiTykUEmk0pQksCIzHAUEak5Mmv7C1i4K4wbUdXCcPLGyXriqOeZFa93SiFB4ZWGEIqsJlCO6r8ZKz3nCNere+jFmF8F6Xsroh+2SM6cX9JkHcc8rZOTjFCP1NoKIMTaZtPbL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tCP3d4lr; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tCP3d4lr"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-baa8c78ac7fso125168266b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 21:52:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776833573; cv=none;
        d=google.com; s=arc-20240605;
        b=VjCaiTAs8C0i6fKDRbtHBs9ZsxNhcnOEMh2AYQ5EzdBOUgRmmditj3wPUrSJvYlvpg
         DS6YWsuC+eLtXgHdJGtdlM9pXpSSrSh3u7TcjkZ+japoNmHI0p3+1XXwtf0Su6Eu+kkQ
         5TQmGQExVFL0TTzhsQ8p7F5XuZGtW8meZXRs7rlcUrNSfy4UXbmfREPpCmlEMOTVIv7a
         +C7GcCeiAZ2RppttCM9Ktd/5CogwtQGb+7vg6NofbEdZ7iRyWQT4WPEjVdxg5VxXY8w6
         aPkigquu71o8V7dUlnBLlzKwCkjCQ4xSLag8spB3tvVffNA250mvAV1bsSN/2gD0x6/1
         Q7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Htvix0mRwzhVxf5R0Kf0KLjebkh+Pa0xXAtyZO4Zg+Y=;
        fh=NxRbilUe39DSrPZfOrnwUFWO9LbmebWVHyZCNOCCIxM=;
        b=epR8u/VsxH7y9dy/SPMecXgCT2ih/9VylR4z1o9NpV6vca0YiPgLE1VDvf84d4OZSh
         YkdSxyrjgDrV4/gV+048M38BJETrddaZYCs0NpOgmYoZAzODS3nKjQopmxetKuGRlFA6
         5/MIbQedKDwoyn5SlJIPIARvuNup/Wnn11m+T/4AszS3YPIvqkwcYziWUIdipKTJ0y3L
         fBygft+zTxFAMMD4RWZp29VAhSjxYee12ZRePB9hulJOVaqbkmjKK01LvhDRrgbeCx+d
         +UeZ0/5h+7eGT3aUEPBAQiZABbAInkDqAUEQM7RUQIc0t1aABn+R+D3UWs7P17D8hqZZ
         W/xQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776833573; x=1777438373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Htvix0mRwzhVxf5R0Kf0KLjebkh+Pa0xXAtyZO4Zg+Y=;
        b=tCP3d4lrYB+N6n9YLoONNGOzhjcyb0pRbOc3cMgVjAYsaFF2vLnSnSBP701tsAJbjj
         n4tuB13JcqV93ygi23WPz7zf+5gjpUyvJZpoy6IGj1hCG18DqNHlw8VFtY38148D6cBq
         rj+DUepD+WqTAtqPxXM5CK7lhmn6dZNi5gR6lRlsX3Ix8F2JmeTFFdPzzze2DupXECBZ
         KsSStF4FxJB1nfKa/VcqhyqEjIoqphPQ7tS7X5kXACdw92eQFXjriRZWkNumLTd6gTyt
         5YKIP4YREKgV2fxj5NWalDsqeFPzbmr6U1s1Mz4CxtNVbOldqQCLhodJSCvBE6FmL+4l
         XjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776833573; x=1777438373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Htvix0mRwzhVxf5R0Kf0KLjebkh+Pa0xXAtyZO4Zg+Y=;
        b=EluvGlyVAuKWCSnUM3NDtyX4aDmZssbT/icST7aKCMVkSh3JuO8CDD5uIqLwP4pWvG
         ZFj6gyp1O6gn7PuPCT8UrGm9m+EowwnnD0PDzMVePosFkQ8yD/t6MH8whSwLuH0tCRHc
         jsbV6sob05vQSx2WCClqBz8PCMyqSCHJdji3p7lF39SFaxbObmqIMkmNHNex7fI0P8S7
         zuTEd7uJX1C0cOqXATMlL3YwKxahNvnV7I7e14IRskqU4nH5oWVNwVtvxH6gAv16CzTm
         Z2cX21M5v48ibmK0pEmW2jj8lhn6C4+qve9yAeY8xgqLach+EvJslcjuSMYdOQm3WbIW
         hOcg==
X-Forwarded-Encrypted: i=1; AFNElJ+2avw0F/a/fiR2P+j2qBnJCO6qu9hEMGo8s8mTv/Pk6SFWJExPVTzXauxs5s0j9OVgE9VZK/ZxxAfFzVVt@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7MKqNN03oxiClQXYIGsxpejEmZBqCD9chif08jEukuToEMctM
	prmSJZcKokwNXdPCrm2Vzk9gVcmXjdXiGUTja1sp9vYrko130F0sRpmc7bEHX9g2OyOezGkW1Oi
	Ha6t8GwQssNFHxSoCsXLXSx0E0AJmpe0=
X-Gm-Gg: AeBDies6eSdh4aJR3eWeB/LShXt7J+y9r28a4m+ZQWZPJpSyJmwIfkeJbrcbRJd7rNr
	qrKpi3CY0Nfdq6lvF3UUbXE2Tw8VdAL59X4kl1vVDKvFwJKKUhWm0waTx9A5TjX9gX8gn3pHPHU
	8Rvzb28GdUdgp8z4tJ3kyJwvvHBLbl5uSYpFHZaEdaWYJIb8hO0zTenpQHCOh9RNYeAd6VGT61M
	G+ULhoptZrlbB4suk7zacfkZIeM6fwRwJK0ogwhkoj8v7JgAu7fPsECBGL3UJ0MsyXwN4GaUJuR
	bTnwOFefqvOwAr04APa1R5KHCZ5Ec9tzIgR5uLUxVz7REEJaGI58Lk499/XXcdY=
X-Received: by 2002:a17:907:1c27:b0:ba7:c8bf:dd94 with SMTP id
 a640c23a62f3a-ba7c8bfe835mr543875066b.33.1776833572885; Tue, 21 Apr 2026
 21:52:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHWLEDHfXZScF5jNDzgOxGXf-MBDcVNtqW0DbNz8Ra8rtcuL+w@mail.gmail.com>
 <CAOdxtTbwipkyAfDakLAB6aVp6YkPWtKpDdVDUTz88WDB-18HXQ@mail.gmail.com>
 <CAOQ4uxhUn6oCBuVJqZu+FcMx8XeAQHZbXFAGon4Xeg2SPLJW_A@mail.gmail.com>
 <CAOdxtTaWWu_7eJWu68zf28zHQP3Y--vXTfbGFsceO47BpN3qxA@mail.gmail.com>
 <CAOQ4uxhCNhGinePrnkSfT9Mtf4o5FmBX7mTA2m4miCMOt3mJqA@mail.gmail.com>
 <CAOdxtTZGFxaayJpqsiFQrWBqXvDn7oyxSL3_9TWP919k0FhWTg@mail.gmail.com> <CAE6nXrPes8T9Cn4ihTt43qmtgCCZvmMwYXo-yG_HJgNO7y+vVg@mail.gmail.com>
In-Reply-To: <CAE6nXrPes8T9Cn4ihTt43qmtgCCZvmMwYXo-yG_HJgNO7y+vVg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 22 Apr 2026 06:52:41 +0200
X-Gm-Features: AQROBzA7_yt5-Xb5zZQao-gRyDtlaRD1k1RwPo-4_dBxDZOooY6wSqAWKd1j_dA
Message-ID: <CAOQ4uxhfwOU7O_vEQsAvRGV-v3_Dk1RcMnwGx-xOpx-FYjoKcg@mail.gmail.com>
Subject: Re: [REGRESSION] Return change in 6.12.80+ with volatile mounting
To: Samuel Karp <samuelkarp@google.com>
Cc: Chenglong Tang <chenglongtang@google.com>, Derek Taylor <ddtaylor@google.com>, 
	stable@vger.kernel.org, regressions@lists.linux.dev, 
	Kevin Berry <kpberry@google.com>, overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 1:54=E2=80=AFAM Samuel Karp <samuelkarp@google.com>=
 wrote:
>
> We can fix the test case for the "volatile" option and expect either
> "volatile" or "fsync=3Dvolatile". Existing use within containerd beyond
> the test code involves us producing the "volatile" option and passing
> it to the mount syscall (or _not_ passing it, depending on the
> situation). This seems like it should still work if "fsync=3Dvolatile"
> is an alias rather than a replacement.  However, containerd is not in
> full control of the mount options; as part of snapshot (layer)
> management external snapshotter implementations can provide mount
> options to containerd which containerd then passes to the kernel.  The
> protection in RemoveVolatileOption will break if a newer snapshotter
> produces "fsync=3Dvolatile" and provides it to an unpatched version of
> containerd.  I think the breakage scenario then becomes new kernel +
> new snapshotter (producing the new option) + old containerd.
>

Even if kernel always shows "volatile" in show mount options
the scenario you described will break containerd but that would be
a snapshotter regression (w.r.t. containerd) not a kernel regression.

As I explained before, overlayfs could add a new mount option
fsync=3Doff which has similar "do not reuse this workdir" semantics.
I explained the correct fix to this situation.

Thanks,
Amir.
