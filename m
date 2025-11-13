Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FE6154BE2
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 13:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040870; cv=none; b=GeSR6CY0MBm+uH/1rVsom6EkpTRENeMZDLHm0CbyPVTX2DFuFyDchF+KKB1x0WrILxwZhDc3tfu1S/RM7XhcyBwNYKpyJOT43+I4mt4MLqL9zwOuj5opvMaYZh7UCBrYDNcRKiOlX7E9eLy9nmJSLdRcsLsVRqFopsOHKoi1uFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040870; c=relaxed/simple;
	bh=xSuAWsrB+GTJiuXftbiTStIICDoDtQ0BHogVwv2YUEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KazILE6JnKAVe7ZCb2hkBqIPs+02sl2IvgADZa/nlvHl5kzbR7GttYpAVoZ6evcOYqlP3n4IB5jz5NmIhghZQGjvqIp60+EOieB4NfzcFMy1iEVwi1zF6sYoDRO6M4fkSPepPyOry17VgDd5+xmH9d6nIEM2ixiKmdgdKp2DGTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vgp13ZU6; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vgp13ZU6"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so1438201a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 05:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040867; x=1763645667; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSuAWsrB+GTJiuXftbiTStIICDoDtQ0BHogVwv2YUEs=;
        b=Vgp13ZU6bWVPwi//9XGBzu7or398DAv2lpAdurSFoWrjKeKhpbT9E3AxFquJC6u5OS
         3Fjw4lviWwbWruFNvjfq2Ycf5LOMiSkwekR5jAR8EVzVn7fwJerNoTlc40wabFEc0n0q
         GbOtIq5cmrrxRCFZ5GnpDmU3zbH5EHjEf6VMYX+qO85jIgwc2Os2GCB4prlrIgyKr0fp
         CpcSKgi8AfSlvUCvs0c+ElD+7bkkwfD4njCdrRtp6kJ/lxY6CU8F47fvM4qrk9d08/U2
         ECrt3/fHCh8LDtwd8lD5rA0X0tPNRqPe/GkVdwJA5Xs2y7ueLHd0pqemQDrfrgmRvOV0
         AITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040867; x=1763645667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xSuAWsrB+GTJiuXftbiTStIICDoDtQ0BHogVwv2YUEs=;
        b=k1t7FP0K0dhdLZ6/EU3COJrYNttv74X37egyOUls4/3l8Gjg9PS6+alJZMzXKg/V5Y
         01IJNiDu2JxJgSD9QLa6rvw3qAPa6rfrb4z2yHnpSTpL4FkqgXRdAmDhwXZ6k38kXWcZ
         NB79kE7DSEpql87waKGNR4wP9akG2fv3c2m1hul4GPwOvENQuIdTf3jZLJjyaSIKeT4d
         cgPcyXTvlDZS2aqo+UcZTQNOBxogvVt8m+yCcgyQuJTu4e7+4SGSFoLd1sb8C0Y2yu5J
         YWbBCVB88QZIweMlrOm8j8Xd/OtCZ9FwfGGWR+dcH2Y6+rI2g4hVc6Opb5ddtBOMGSQk
         1mdA==
X-Forwarded-Encrypted: i=1; AJvYcCXLqV824rlbBOD+I8JI9yX40jTFFtfjS8TwDQ6hw2LzIrTgaHxbJsubEc38m7RQf0YcqULqeWDvEiDJno6p@vger.kernel.org
X-Gm-Message-State: AOJu0YwML4kqUuSWJtxkfXSP58NyckVCM9QB2q7plodIYp2q7tJMKRzI
	TJsh8uOX1qFNnvql5sVmWCaOScEGLULuaE+SYTZ+L9SmKVRoXeg2isl8VTu9EIWAjMvcDvK2v3F
	h3FJPuZqCqYY1QacJ49uZ/DhAc2e2Nrk=
X-Gm-Gg: ASbGncvHfXVJl0GeHieEtRH43cBJlnVVaKo1qkyHv8Oy/RRqLNQcgG4IktDvoB7NJoM
	DJAgT9gx0zLHS2mpbwSkg3kwzaMW/+KsjuC+CE8mDfE3SMAkSTckaMkeLJwTWDfCvM+CUohIo21
	qDL8l5866586klunsrGlyes8uHZhtzEKQ5B64HV41QRlGoPLXmGXrcaMWwJnmrd40V804DIMQEk
	wsgI6iX/ahTMay8Ea6Lry7eLVOstuuyMB28+XPdiAJCW2KnT9PMc23muc1KpmXSxo6JZb5WiZcC
	aDC0xaNNoDD4goA8gsBq2kFlYX5sLQ==
X-Google-Smtp-Source: AGHT+IGF6esb7kGa/crhjmb6/aWLvTJVqnAAYAvGO0s6QczR+42b3/p2M4bcL9sRn+PV69DMVD/y4dimDrwFh8MqTEw=
X-Received: by 2002:a05:6402:27d0:b0:640:c062:8bca with SMTP id
 4fb4d7f45d1cf-6431a5481f8mr5585662a12.18.1763040866928; Thu, 13 Nov 2025
 05:34:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org>
 <20251113-work-ovl-cred-guard-v1-3-fa9887f17061@kernel.org> <CAJfpegt9LQe_L=Ki0x6G+OMuNhzof3i4KAcGWGrDNDq3tBfMtA@mail.gmail.com>
In-Reply-To: <CAJfpegt9LQe_L=Ki0x6G+OMuNhzof3i4KAcGWGrDNDq3tBfMtA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 14:34:15 +0100
X-Gm-Features: AWmQ_bn1bXyA9VHVc-NJr9ApkEqL9TN4PRjFv5uuLP4grJaaT47tUE3C-uFyGpM
Message-ID: <CAOQ4uxjnmLiLzM-a1acqPpGrFYkLkdrnpuqowD=ggQ=m72zbdg@mail.gmail.com>
Subject: Re: [PATCH RFC 03/42] ovl: port ovl_create_or_link() to cred guard
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:31=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 13 Nov 2025 at 14:02, Christian Brauner <brauner@kernel.org> wrot=
e:
> >
> > Use the scoped ovl cred guard.
>
> Would it make sense to re-post the series with --ignore-space-change?
>
> Otherwise it's basically impossible for a human to review patches
> which mostly consist of indentation change.

Or just post a branch where a human reviewer can review changes with
--ignore-space-change?

Thanks,
Amir.
