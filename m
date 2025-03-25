Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A113D25742F
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742903883; cv=none; b=LvHpOU5g8FfBcG7rpB4OUCXXLLz0x16QvNawgClmNXWRXF3NAn6rlbDQu5X4Zm9rYTuKeQGAWF5qCVEiId+f8W9iBa1m2ODrcOD+0KDsB1HuGvMPYqJ08BWSQT6ud+3As8jAA19CNr2h2QyjqJKLUkP2li9jzxS5ggNkrjxRB24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742903883; c=relaxed/simple;
	bh=EhkCcKvMO5FXE+BxXjdos8aDqMsGvPPSOVvmXd199Ng=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G76fjObxGd1ASrkLfisLTYgNWcXjZ66BP/+Qi0yoTydr4KcGVtUHqWxgP3PcNCftMwjSZVxuV4KgBfBaNcjuWg1xiTwbl1qUsMUkW2dEJcKtxOVfMbdqEQCr55CTG5NyCMBUjviE/9Xw6Fl4RvImp2WAdyJb6YLgeefdLfc88wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YoGtcwGW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoGtcwGW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742903880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=66ScJ5U4mFltzfqo02WJQQOu9FrvajI5Tu1fFaDtkl4=;
	b=YoGtcwGWlxXcBPkefsVhMcj+YflSAOe01Pm/3x11FvKBL9tUMqdcdpCrM9EVMqQPDYlDoE
	SuSK48HSCFV4PU1JI/hO13UoHcytkPpgN/fQU6rZy5NtgfG8RMbp3sTt7rheAylY6oP3qe
	MljvtTvZwf64jCk6dv0KapwA8a1hPQk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-_hLzfBXqOIiRw4g0qH07wQ-1; Tue, 25 Mar 2025 07:57:58 -0400
X-MC-Unique: _hLzfBXqOIiRw4g0qH07wQ-1
X-Mimecast-MFC-AGG-ID: _hLzfBXqOIiRw4g0qH07wQ_1742903877
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-30c165885fdso23043741fa.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 04:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742903877; x=1743508677;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=66ScJ5U4mFltzfqo02WJQQOu9FrvajI5Tu1fFaDtkl4=;
        b=QkUoiPwBQCD680v1hc0bdj0M3Ks5QY5JiwkJw9VP1yq6XD89Dq07Jpm1b6Mv2hv2Uo
         JYw+xXzAyldOQykpZBIDoygnfW50V5BYnN5KK5YlekGH9xuRRnLZmLtgnTHmAL2AEi3n
         q2S3W4ecA7af48GyQRN9ejh4407kHYtdc8KHuRdU0IIXAno11ai8SLzu/zpuhlQwaaZI
         cXpA+pDnGR+Kbc9st4M+TW3gwus2ZtfhG6bjbdC3p0WDFUr1uytLjLEPcHPk00CzAbrU
         W68yUP14P5kXn6dqpe0ktHWQny/ZBDGtXBztYnxNP8s/YFl/XbbiF5cMWRuuaE3Z5yI6
         sEPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3v6p41kBvAYXb4fTVIMuk48PMmCNqSdKy8+6/I1nCzcoJyGUEe969zNvjzPkJ2OFVMEItidW7M4+pW21Z@vger.kernel.org
X-Gm-Message-State: AOJu0YzBwl2nmRnPwgQzRCM7VMWgqC+szoa7X7Q0YNDDB7PB0d48+IE8
	1dK2TAAOSpSZlhsWS4q9miW7ee3FP9Hgy+ck+E61gKo1hEU41UZ6qilx7wtkx1mVMD4ghIwBNPX
	N5MFd8ABVfb4VMzuYEguVdWY7wGRkzfse2MFRW6vBHtcYGcHu0c1BTYTg9yWObpQ=
X-Gm-Gg: ASbGncsmE/kBa0VeDqDTnvkVQR9fY7bY10hiJhUeNMlx0PLMfy+Bx9aiMb9Is18+q2q
	kqQy7JOK6u1Aoh9/GCtemn1dj2U8A+QpV7SxKsqJo54QXUEXvgEa3RmzHfwCMQ2FVGt0X2Qn9hF
	5FpQ8rBBXefFahrhjZC6pFjscrXCrY3XfSDr6i+wgrkWq9unnrWDMRbkVRWyZeyjkA4b8fh/qSI
	V8KCj0aPbwiJH9iO2rmGT/7FvojDftJ3+ij3nzFRp4RXnJj5Ngaz2VLofs8Q3wpGEKyZC1CBefG
	SlvT5ddz5RSKRrwX5N/E4A1paCeEwmO9BI6HnFKegM1ruuYWjTqnbGI=
X-Received: by 2002:a05:651c:170d:b0:30c:460f:f56 with SMTP id 38308e7fff4ca-30d7e2349a2mr51836611fa.20.1742903876758;
        Tue, 25 Mar 2025 04:57:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFsVQ5ThcgNl6aFdF7RZUEJ9ftLWGxPNlNQbEsFkk48iEQQ4ebeeG5mcwR88P3gcTTqWHXCA==
X-Received: by 2002:a05:651c:170d:b0:30c:460f:f56 with SMTP id 38308e7fff4ca-30d7e2349a2mr51836521fa.20.1742903876296;
        Tue, 25 Mar 2025 04:57:56 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30d7d7c1d8esm17547331fa.13.2025.03.25.04.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 04:57:55 -0700 (PDT)
Message-ID: <636546d444306b8af453cdf126453a8a1f0404d1.camel@redhat.com>
Subject: Re: [PATCH v2 1/5] ovl: don't allow datadir only
From: Alexander Larsson <alexl@redhat.com>
To: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
 Giuseppe Scrivano <gscrivan@redhat.com>, stable@vger.kernel.org
Date: Tue, 25 Mar 2025 12:57:54 +0100
In-Reply-To: <20250325104634.162496-2-mszeredi@redhat.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
	 <20250325104634.162496-2-mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-25 at 11:46 +0100, Miklos Szeredi wrote:
> In theory overlayfs could support upper layer directly referring to a
> data
> layer, but there's no current use case for this.
>=20
> Originally, when data-only layers were introduced, this wasn't
> allowed,
> only introduced by the "datadir+" feature, but without actually
> handling
> this case, resulting in an Oops.
>=20
> Fix by disallowing datadir without lowerdir.
>=20
> Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Fixes: 24e16e385f22 ("ovl: add support for appending lowerdirs one by
> one")
> Cc: <stable@vger.kernel.org> # v6.7
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Alexander Larsson <alexl@redhat.com>


> =C2=A0		return ERR_PTR(-EINVAL);
> =C2=A0	}
> =C2=A0
> +	if (ctx->nr =3D=3D ctx->nr_data) {
> +		pr_err("at least one non-data lowerdir is
> required\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> =C2=A0	err =3D -EINVAL;
> =C2=A0	for (i =3D 0; i < ctx->nr; i++) {
> =C2=A0		l =3D &ctx->lower[i];

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's an obese crooked filmmaker trapped in a world he never made. She's
a=20
provocative red-headed stripper from a different time and place. They=20
fight crime!=20

