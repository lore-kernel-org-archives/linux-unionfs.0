Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A431DFD8B
	for <linux-unionfs@vger.kernel.org>; Wed, 28 May 2025 11:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748432871; cv=none; b=HANJKHHi0M+9sqwNKTBFjB//+NhuAE0+Ea+uR0tn99/X60FoXxqwxJscXWftgEUhkySM+usOmq/00RBI+/h8KNA4f+6mj/yMtOvJB+lHFzlfnY5lv0p1aVjtexGegwoheBJQoO99UdMtqpl1MjADQVwsoSToXtqjarCwfdAS+j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748432871; c=relaxed/simple;
	bh=TTy22rgWBPKbjZSTe4uWPN+pN85sITjqdiiRx8uuXRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G0YGe4avjq7hqJXIh/z1TGlXXHB7ENZlSFqJD8eV3vFYgle2NTLTBdxEwQ6soFrDImRO3UGtK/7IUOZwUz1Qm4PmeD0gCpISRmVxDWFp0RY30cqQA1Ab9ZSgvuiEtdALR79DiNWG96vu7JPzLxEqWnoSBaVam7Fg1qbLTuA5+Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=DyWzg/NQ; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DyWzg/NQ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-476a1acf61eso37344541cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 May 2025 04:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1748432868; x=1749037668; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TTy22rgWBPKbjZSTe4uWPN+pN85sITjqdiiRx8uuXRo=;
        b=DyWzg/NQryUaWnXZ1a9i97aiUzETKk9mCYJm4NokxCMBDndk3vAXcZq4UzPq0MdH6m
         6Edi3Ya5b1of56EQNXx0Qq4rdrUwcNu+D4/eUvDyUnr89VtI6K0gzkROkHyWvWrMC7vR
         3PSAgMLFlpKsZxl5X8kGUh803h/SWxBcxCRVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748432868; x=1749037668;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTy22rgWBPKbjZSTe4uWPN+pN85sITjqdiiRx8uuXRo=;
        b=IyO3D5ED/sKEYbTa9N/C+E2378NMXd6srp5AsbRWSGsrDh+8bBr/xr7EFlHjD+/Z3d
         0qMj78hmQuwqBxwKY9qxf4Gn+k2upRcExdgklG3hd6nDV4qH+DVkgrOgyxIBzxgPRxcu
         syHN3AGk8e1dzg0V+2gzf94/deB6nu/87Xcnag3vVRNGk7NayE6inGEtEVv1WYE854gK
         gs4hf4DFEMhUPEHVoW9gBlph8SdQHIFVwevq0VFtlLRLqGCoXjPSwUcmj9uqPsFx4AAg
         vhgJPmJLlKbC1Tzz3XIUEiR0pqAk/9DwuTl+DBoOPrelSxA8JI0XRBhXzFws9HdG7HQJ
         ekAw==
X-Forwarded-Encrypted: i=1; AJvYcCUd6HSPqxOr1Mc3M69mfDeMxlP2m1ZjwHopftMGSMJXhMjB2BdQlokjO2VK5BqCo3qwZRUrBg6dcIuqSSel@vger.kernel.org
X-Gm-Message-State: AOJu0YyK/3zpo6sc0NsKpea4jRZElE8Q18LaCpo4VbRCkNeDd7kVf22y
	nBwyPPUQ8hwRLy5eNv8IVVxQ8hR2mw4CirHH9QUTdgaqEE4E3a/FZUWGo5Zt0wtE1+M6ZgnsSW0
	NxFNKtm3kZOrPHWOW8RKHBWXmAL2a4fDpajtvjnegyA==
X-Gm-Gg: ASbGncsjv0qxX/IIStf7t3c76Ev2L307/rXsYqE2Ny/yREKuX9xs5207bELk7JTPKu8
	iowSzMGH2xPoo5gueT/0QA1taQVUFXmv+4gadL7/jZOlQjAVRrPxBx08hB4ScfcsNlqDnZ5iyd9
	NjLtlaoNgsRTo/+yv+TC7ixvqQQxKsIY3ju7Q=
X-Google-Smtp-Source: AGHT+IE+3pNaJ+H5/u/9c4yjQaWkOWYwsiGhi+DlHJjO4epJsVha4CJwHyPCYXCzT0i6Nujm1AMi0Orm5s3x0tUFcW0=
X-Received: by 2002:a05:622a:c87:b0:48e:1f6c:227b with SMTP id
 d75a77b69052e-49f46e306ddmr293044501cf.26.1748432868268; Wed, 28 May 2025
 04:47:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526143500.1520660-1-amir73il@gmail.com> <20250526143500.1520660-2-amir73il@gmail.com>
 <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
 <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
 <rjqagpvze4mwnil6tck6jnyqfbcgqszy5bjgu4fqzdtq7e3idq@uizmifogsqyf>
 <CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com> <urxghfhdccjg6v47h63btu77kyxnsxbrmxdbhb7kx3oiqz23og@plyznhi36omp>
In-Reply-To: <urxghfhdccjg6v47h63btu77kyxnsxbrmxdbhb7kx3oiqz23og@plyznhi36omp>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 May 2025 13:47:37 +0200
X-Gm-Features: AX0GCFvbR3_g0iNsB3oltQqJIifcokeo5YRw04-1DG41L2BTc5h2Moj8NrIcUV8
Message-ID: <CAJfpegv9Evti_MmWR72Gg13s9XYsxJHQ3WSJRwLrBy5O8aVHaQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
To: Karel Zak <kzak@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 May 2025 at 12:55, Karel Zak <kzak@redhat.com> wrote:

> Why is it fine for mount(2) but wrong for fsconfig()? This is the
> question. There is an incompatibility between the APIs.

Where is it documented that the fsconfig(2) shall have the same
replace semantics as mount(2)?

When I reviewed the new API, I certainly didn't think that it should
have these semantics, and I'm not even sure it did have it back then.
But of course I may have missed it.

I think this is just a bad accident, and I'm wondering if this could
still be fixed in a way that doesn't introduce more hackery.

One idea is to introduce a flag (e.g. FSPICK_REPLACE_ONLY) that makes
the filesystem initialize the fs_context with the current options.
That would work, no?

Thanks,
Miklos
