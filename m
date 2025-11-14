Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C802FE074
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 09:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763112513; cv=none; b=hyvlVPCjafzZxRZPC4X66jhD46DZgqifdYDb2+pzBuSLYAmKnBbtm7SB6alLdtVWFFGEZKLK67L1YXYobzlow9JT4w/u4KLhZnQq45BbhrSUhgGSffQeRmHD+EWHgJ3VJ/tTWw1CshVptxNrc3KmHsxDum+POKD3517TPc6jlH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763112513; c=relaxed/simple;
	bh=N2HsaVvo0KSEbbEZeR56wpGL3gW/GUIlv6yaZlxQ++Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IhpPhLVLd6uIxPYPtLxE2qEoG2hCw0k6rWGtGlGzHGenufYWTmWoKQ1GnyjN7hl8xMlY5+ezzAguuQE3XDJyH/K8SVQsavp3DC7UZDVUz0DxViUKub23/w9xHMW8YtZwMylFBOcRybHGvMi2S/mLQw7BVZGkYnOYW+mWhQqzdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOY4qmsy; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOY4qmsy"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b73161849e1so295436366b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 01:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763112510; x=1763717310; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdMtsLR/yBE7DI/ay1aYqX9mhRKvn8Ih43ILpIKpzlQ=;
        b=aOY4qmsyrAn331tkkY5sSZSlo379tqHRGwG2A5xcfT9l70PiBxI9dANnMKUPzRuElt
         pX7dcfJcV2cBbB92BoyK9H+EucsC6wSYribHEJ0VavesYBpqW8IR+4g1LN45kBUzKsnt
         9bszre3+CdceeAqKXFbwmg6w0uynebZ9xT92a0cLjGJZp7Nx3uRjbkAdrbSQ0pUIHllX
         kLRmcR8DT4RRJq99MhCmYqL20R3GDDY2Wa4dxnF7fogeE+Mn5athPbBdK+QmZta7uaIj
         H8+4A2N7AxH2XsKUtAoRiYNFqS35/7SnABy0kYhp9f6cJAZj8iJZZx7nY8Mlw7CRt3Rt
         6YmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763112510; x=1763717310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mdMtsLR/yBE7DI/ay1aYqX9mhRKvn8Ih43ILpIKpzlQ=;
        b=ixIDaw6OO/TXIY/+ccliCS9Ei/c+Se1pi1DQrM5UNtuZiIURKBVlscxjaQYnUrfOHc
         89tewSPoPnh0wW6HXjomJOIj9zCGQ4wk1GLd53y1VNXcjKfYFC8tY2ELZZDVAOQlMxN4
         e1c2Zj3YBpKNwQLqqyILYcYnAwgEGo16+T5DjFW9nK5g8XW7ottbQDvhMRdzKc6AmYoQ
         +3FdhwijE/otm0t0ErrHFcCjR7YY5wG2GTSGKsYlrin+bYrOL1vdG9ws4FxFZCG1YgmP
         PTLW6k+NnJCgK2U5sZEIeU7wd1uIv5L93b47VQUqj6Ivme6X5PCq7ihvNLtisyRuJp8v
         yeQA==
X-Forwarded-Encrypted: i=1; AJvYcCWvJ28QHnm0xJ4j3wwSGzQmOKqAiS+zhDM9/McEh/gfc/zxjD9/HiYbXjRMjKHloswqC6clOWB5xE4SfqIj@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Ty8HGMO0iILaKDV5sSOkgn7bpgG+ndL4O4V40Zql++5+GxHC
	OnZKwAgD9bu93RmIdx2rKq4YnfftqPNiwGsDdyamvqPQK3zEqo7K14MBi66lTVUPQhnEKs6WTQ9
	9YDfyPGijhr3DRjVQWlwVXuBgvdZa5kE=
X-Gm-Gg: ASbGncuTv3DeZUPbBWZNcXP2tUgj7+TgiPyNf5c+AyNYKY8QnpkNaitjM43oKQNKYiO
	lK0SdlkTIiMeiO3jhfx4hVDpBG0pxsdD1WbcnrEKHw74blCNenffQSnlzUOB46kvMMWiCfJh+Be
	h0qTDng1GvWMQ2/j0KEhtheqkNFtU86VoLpKWWAktddh2nLTPvuK9m/5ZgNCjqOrViR+NBIwwUq
	kzEO+lSj1l5e2dzchZ97dLGyXtz/aVs64sH9vZUIENbWK/NNaAro5LUn8hRyzCcWa2tIEwUwC62
	roFADZXAiYQeCTf40TKW4938OiI9UQ==
X-Google-Smtp-Source: AGHT+IEQn9wcqUkGIDv9+SWfVNmW1suJw4n4ETUx4HO3uhrfcZ4SvLzlbujzxBpT/QeYEKI2BB8t32Aqd5/pM7fQaTo=
X-Received: by 2002:a17:907:874a:b0:b73:6f8c:612a with SMTP id
 a640c23a62f3a-b736f8c6f46mr99527466b.11.1763112509488; Fri, 14 Nov 2025
 01:28:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org>
 <20251113-work-ovl-cred-guard-v3-34-b35ec983efc1@kernel.org> <CAJfpegsdtHgiGFi5EEjaN9but0A7VTZA4M2hSg=Q7ynAozhqAQ@mail.gmail.com>
In-Reply-To: <CAJfpegsdtHgiGFi5EEjaN9but0A7VTZA4M2hSg=Q7ynAozhqAQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 10:28:18 +0100
X-Gm-Features: AWmQ_bmGihuGYGvIZV5ONblHyPajU4eus5nTPeVXJfYteHaXhQN19O77H7b7y5s
Message-ID: <CAOQ4uxhjwt7oKEmoumcf+BidgKNCp7yX57T4CrYi-OWx=+0EnA@mail.gmail.com>
Subject: Re: [PATCH v3 34/42] ovl: extract do_ovl_rename() helper function
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 10:17=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Thu, 13 Nov 2025 at 22:33, Christian Brauner <brauner@kernel.org> wrot=
e:
> >
> > Extract the code that runs under overridden credentials into a separate
> > do_ovl_rename() helper function. Error handling is simplified. The
>
> Hmm, it's getting confusing between ovl_do_rename() and
> do_ovl_rename().   Also I'd prefer not to lose ovl_ as /the/ prefix
> unless absolutely necessary.

I was just thinking the same thing as I was trying to refactor
ovl_rename() to ovl_rename_start(); (something); ovl_rename_end()
I will try to think of a better convention.

BTW, we also have do_ovl_get_acl() which has managed to escape
the ovl_ namespace and has the same confusion with the ovl_do_ bunch.

Thanks,
Amir.
