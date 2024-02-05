Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50A168B9
	for <linux-unionfs@vger.kernel.org>; Mon,  5 Feb 2024 10:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707128241; cv=none; b=bd2Tv3yHNsLaCJdIEruHeTtVf2+rHzBFXIJrtwgwmHQp5Hi4KJeYTIyCWNvlep93PL3o24M5b+0ZE195P9m3gWme5hKhC5J1i/oxqk8mnlCObFKs366pYmOkdsSYkX+1x614YCd/V2XSNTZ777kW9R/+FXHk81XAPa73x3wKFR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707128241; c=relaxed/simple;
	bh=fywxFhJ/XeYJ++H9Gdo1P8FsC5jnrJ8S/sYBcldWz1E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LgZ+Od0Njqbcktv1ZjsWByOL2bn/OM1PvXxYU82tTOf2wyzAIyUWx5Gkihpic5VXx8PwEizQqFQ7Pc6LVeUKxfXcMsp9Gk3rQuTF64Q2xBrDHVnE0UYO8W+5NJfJeoasMukVTlFdq3VJ+GviH2oka7zEMNIo+CV4IzOkPAvzF/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jAMuRjrQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jAMuRjrQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707128238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T7gJO+6YpkM0CJSOCZ7X4ROVaQnJs8/LWyF4MlRKYhw=;
	b=jAMuRjrQQUXNj1aolbwhA/4ZPHfmLcizXVNQIHDCW1mmNGQ+6E4t0Y6UjpwDs3SARbLqoD
	gQX6w2maCyW2YAajFi99N03Egmyf6hIokJevA1B3inwTU0djmXD5Te/MmbrpiXbcJaeH8S
	836rn6jCsYBOVmcLPUef2RGokaX2CZM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-oC4_jf8jMhWknBwa4NmQcw-1; Mon, 05 Feb 2024 05:17:17 -0500
X-MC-Unique: oC4_jf8jMhWknBwa4NmQcw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d07b5ee335so34676851fa.2
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Feb 2024 02:17:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707128235; x=1707733035;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7gJO+6YpkM0CJSOCZ7X4ROVaQnJs8/LWyF4MlRKYhw=;
        b=WpqrksmRhZ+aY1run1dabW5kaX8H4Jgipuj33swXNvkIBCGp4M7Axb2Orp8/W0lWog
         9EH/u1F/Vb/VfnhN6qQ5UBCKlsxj8AkbT5UqZs+RNpx+4HPmyPs9XwnTtsMgk0z7WpYI
         vdWiWEQqiPQyOzIlcFKyhW9iz/UnOhwd3dWNF1HCDJjn+4kg0lOhw+gh3xc4VwBRQx6q
         SVCT3Tg6RX9j1kpRYrjP7Q88LTv43bJeZZUuj+5YCd+cCVvff21uwjMMRw3QEdEoWoa+
         Devi7rkX1OvFHNHzZrwRttLnwDDznfpJ8A/Db9MCjTrnYb49c2bn/Xh/9gGxRvqEGTYk
         Tbmg==
X-Gm-Message-State: AOJu0YxpQS51S15QbnMZasMYBFjw0b8GJBDRzX6+NFlKYBN3LdDMPTo/
	S1f25Bh8gX8Xj83I0sGSRpaP9YPFC6JfB/DUZoUusZ9kKiuxWger3dw9jl0maZt8gVNfEZacwIw
	zrxN+ltqQdCTV901gGwX9AqYOpaJW0pTuPmgG7GHNz8jCFKJ+IlUW6pAPI5WGA5DtU5aSWER1Hw
	==
X-Received: by 2002:a2e:9050:0:b0:2d0:b299:9a12 with SMTP id n16-20020a2e9050000000b002d0b2999a12mr561189ljg.8.1707128235617;
        Mon, 05 Feb 2024 02:17:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1XdoqXv9tAmmqom77cwEMwjqjueE3Py7i/OXIK21KNaxxa5INY8CY5B4qHU2zLl7CvUqNzQ==
X-Received: by 2002:a2e:9050:0:b0:2d0:b299:9a12 with SMTP id n16-20020a2e9050000000b002d0b2999a12mr561179ljg.8.1707128235288;
        Mon, 05 Feb 2024 02:17:15 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCX6i+fneiQTZDJncq5vxD5zBjEb2L/A3hlte5kTMo+v2Swu/kNX7gx/NpVI9JxCOpO5fNRYBlFr7Z0NdHAYt+7u87fhk5+QozKDY0UOJxxXPHR5FKA2ZL9RuZGGpOTPcbTLgNY/bnqkML5UdrDpAgMj+TKYMUCqfxQ=
Received: from [172.31.0.10] (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id i26-20020a2e865a000000b002d08f3640b5sm957490ljj.11.2024.02.05.02.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 02:17:14 -0800 (PST)
Message-ID: <5820c922adf390c825441809b224263b2b4d7947.camel@redhat.com>
Subject: Re: [PATCH] overlay/084: Fix test to match new xwhiteouts dir
 on-disk format
From: Alexander Larsson <alexl@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Date: Mon, 05 Feb 2024 11:17:14 +0100
In-Reply-To: <20240203081228.1725872-1-amir73il@gmail.com>
References: <20240203081228.1725872-1-amir73il@gmail.com>
Autocrypt: addr=alexl@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2024-02-03 at 10:12 +0200, Amir Goldstein wrote:
> The xwhiteouts feature, which is tested in this test, was added to
> overlayfs in kernel v6.7.
>=20
> The on-disk format of the xwhiteouts directory was changed in kernel
> v6.8-rc2, specfically by commit 420332b94119 ("ovl: mark xwhiteouts
> directory with overlay.opaque=3D'x'") and backported to kernel v6.7.3,
> so this test now fails on kernel >=3D v6.8-rc2 and =3D> v6.7.3.
>=20
> Adapt the test to the new on-disk format and add a hint to make sure
> that the on-disk format change is backported to v6.7 based kernels.
>=20
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Alexander Larsson <alexl@redhat.com>

> ---
> =C2=A0tests/overlay/084 | 8 +++++++-
> =C2=A01 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/tests/overlay/084 b/tests/overlay/084
> index 8465caeb..778396a1 100755
> --- a/tests/overlay/084
> +++ b/tests/overlay/084
> @@ -25,6 +25,11 @@ _cleanup()
> =C2=A0
> =C2=A0# real QA test starts here
> =C2=A0_supported_fs overlay
> +# This test does not run on kernels prior ro v6.7 and now it will
> also make sure
> +# that the following on-disk format change was backported to v6.7
> based kernels
> +_fixed_by_kernel_commit 420332b94119 \
> +	"ovl: mark xwhiteouts directory with overlay.opaque=3D'x'"
> +
> =C2=A0# We use non-default scratch underlying overlay dirs, we need to
> check
> =C2=A0# them explicity after test.
> =C2=A0_require_scratch_nocheck
> @@ -115,7 +120,8 @@ do_test_xwhiteout()
> =C2=A0
> =C2=A0	mkdir -p $basedir/lower $basedir/upper $basedir/work
> =C2=A0	touch $basedir/lower/regular $basedir/lower/hidden=C2=A0
> $basedir/upper/hidden
> -	setfattr -n $prefix.overlay.whiteouts -v "y" $basedir/upper
> +	# overlay.opaque=3D"x" means directory has xwhiteout children
> +	setfattr -n $prefix.overlay.opaque -v "x" $basedir/upper
> =C2=A0	setfattr -n $prefix.overlay.whiteout -v "y"
> $basedir/upper/hidden
> =C2=A0
> =C2=A0	# Test the hidden is invisible

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a time-tossed vegetarian rock star with a mysterious suitcase=20
handcuffed to his arm. She's a tortured foul-mouthed mercenary with the
power to see death. They fight crime!=20

