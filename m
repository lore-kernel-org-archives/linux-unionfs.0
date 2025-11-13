Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3D2DE717
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763046008; cv=none; b=VsJymzuFGWk2urCPGZOXWfPDCxwtA9PMaRiAeh9EDsaqA3ncL3T7XSAOKs1fBGJfKaWnLevprprtkqeIxU4c5G679NQ+hH+WvBi/agRwK6mS9H1Sm3H9kE1v+djfHBSo6wyz922HxXrfsHAlAZwUCiRdfbioEwIa+Vw9EP/pdeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763046008; c=relaxed/simple;
	bh=O/yCT7PlPSFi+823nhk2sKmN9yyj5JOnUSuTqphJE/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bKbxdNsdGq/ZfjjrJyUuAt1SvGBdCgIpelGBM0eoEN8S/+vbNJEtPlqYlszwCWnV5S1Kzm19yifztRydcn+ZTk6virXHPP51LhKLv23Um3Yt66cjpYOKl4OxVwKrLPAQqb31dsgI5irN/s2E3iT0qWaAL/59vcrW6T6CWokxF34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iAxpsHAi; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iAxpsHAi"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so1537728a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 07:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763046005; x=1763650805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/yCT7PlPSFi+823nhk2sKmN9yyj5JOnUSuTqphJE/I=;
        b=iAxpsHAin1M98Rd5jXgyyAd8ikNqjHHPehBjtF/dggU4Bd5OBt581GClGCcuwp6PHe
         AIzgmAv9SLMCkOoEWsK+vLUh6prLhzeHGQKEu8tNgDB+2CrrUFzP3zljnofB4sY3kCcx
         IUXc2lAbkmTxkMrUHbep5G5UkXt1Ek65HRvmBXknUUoVIQn1PEw75/nWIIFJqmPnH7VC
         RIMzh+8DEvz0V8+nqIJsaYIp3/uDT30ByHvJXFUBZrnsBjhqP9exKY1HkiIvCl4Xh6fQ
         iw50HfdA27ktmNMeYTQp1U89laDh7cbb+MTvg2+fpNCrzcKrvZxMH3ZEjyMQu+y1lefh
         Jmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763046005; x=1763650805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O/yCT7PlPSFi+823nhk2sKmN9yyj5JOnUSuTqphJE/I=;
        b=HVUx69KNtQvgCO+ckHe0+9y4vuxxs1iqbeksbIeyzJyG8I6NjRKz6KsIxM/mNWOT3P
         Lkn+QDGsuH9tovCNvU3/DKPWd/AbY4iYofvklT6fSB3LuTv/kXDVFv8IcNTMkiQwRcQB
         m5dd7onmurGDSuD8bhFx3QgA1uaZVHhWPbCikQewhEefhXs9QYM3aHR2mliukEPaJXQH
         pY1srAOFpWVF0kKlwXj5KbXTVbogMRSxT7pGjp4g/WpsZrpmtBykA17hWZn5l+5kSlGi
         O7Ll7uHOjkVwbWh1kr0DzPna/O0WcgOCIGXW58OVwVZy+LlT33fORetn2JNWfgWZCP6T
         yngA==
X-Forwarded-Encrypted: i=1; AJvYcCUIDYAxPTj2GYRF9E8vYamwwtd9tgYBjjfBFlh/JaYWozNYNe/JV+aPY6ajwNHiXrao/PpRCYQnALZlgV6U@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx/KZ/10dE9Q/Er6Qydqh0bjQ4ZQefWW9fi9mcOWAyIVm7Dh9l
	Hzmm6xZFjIXho1q00NgUGLEYjNsne95l6VBenWPat1cb2fSBmH09sLWBXs89XApD7ybBW19iN51
	FcsDjCfRpUDVCi135YaWPXyELOMfuiN78dJVBohPtSw==
X-Gm-Gg: ASbGncu2QZz7wwEsirw3q7US2LuVWJ14C1MnHFSC5Zvlgl0MoGYSVwTy4A7qDRyhx9/
	OA20fq7oB19IW+61l58+21D/B9vUjxfIyT2nYsFuMVZlpr4rsHoyL65PJ9l1kCmpiQj+5gwv2ea
	Siyklr90A07x/aZiLzT0SxrQYupRwNxu/VID/rz1s8vvg7JnziD6dHZtI3BEWhZgxYH0k03ml4D
	1mEzDLtCB6exr9qX+/TEUg9xLPih9+WyF6+OhWWck+2uysHcYE02jBZBpxhuiyLPFEUMLJafLxj
	QIEUkz2rFMSb4KCr4q8=
X-Google-Smtp-Source: AGHT+IEDnnrdyjK2JdHgeBEZ5BnpsnIko9j1ObXf9NNoM+/cKdcKVuz+jY+fl+ySjZunGU4KLJ2MUywEqhqb58AcRWE=
X-Received: by 2002:a05:6402:5350:20b0:63c:3c63:75ed with SMTP id
 4fb4d7f45d1cf-6431a55e44amr5574505a12.22.1763046005246; Thu, 13 Nov 2025
 07:00:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 15:59:54 +0100
X-Gm-Features: AWmQ_blxDDO7DcV-76HHqY6hmEjNFx9_5jUOH2XhLsxh9hm-3Edqln8C5IadzHQ
Message-ID: <CAOQ4uxhUMC0+wy1oVKfemy-ia8tAbWe7rezdFy8MH3eB_4C5ng@mail.gmail.com>
Subject: Re: [PATCH RFC 00/42] ovl: convert to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> This adds a overlayfs extension of the cred guard infrastructure I
> introduced. This allows all of overlayfs to be ported to cred guards.
> I refactored a few functions to reduce the scope of the credguard. I
> think this is pretty beneficial as it's visually very easy to grasp the
> scope in one go. Lightly tested.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---

All reviewed now.
Only minor issues found and one ovl_iterate() refactoring patch suggested.

Feel free to remove RFC and add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

after addressing the minor review comments.

pls provide a branch for testing.

Thanks a lot for doing this work!!
Amir.
