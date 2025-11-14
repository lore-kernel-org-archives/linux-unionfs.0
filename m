Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69932727E5
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111107; cv=none; b=Vtr9ECA2aKyKTP9xRFd3f2UUyOnANqPguFpEN670oGIXdexSQXux2ywh2ON3jE9Tp0pqfYJsE9heHilwNsIhLtZ5QliTEFJjUU1JJn/aT+hikOqlWJ4L26TrKNoi0iFqPnQduKdddg9A3HTk4QDPh+Q9Jh8RN5i1XxRuccgpUls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111107; c=relaxed/simple;
	bh=O+Dnn8DMSzYrt6UMUEKlwnSeLcmgzuVwwGhUjPYAj8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tSWqktvyyOXIfjSRSQklXkcz3WZwd8MOyahFQp/VCcLvpuBXnsmyIxY5f1uOjheFgLmm7a0apPluPswJLKJHiC3BhmjTh8QR3WiSz2CdL6ZFcUDqdsYixQ7pPFEHrjNBl53Yin9W1hij66meAZMgJdhjElbIJNFyJih4zMRXv7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dWj/V3ye; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWj/V3ye"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso3240964a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 01:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763111103; x=1763715903; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=590P1F+Abi0Ye9e5UOfcZnWB/iYAfiVbOd0H5hq8/hk=;
        b=dWj/V3yeW8M1X6v+QYUndZ8HbwQAfvyQb1dPqc/IAvoHI+Jo/sngV5gHs6klyOKDbh
         WgMlUNQdwbFYb8nNWqqqcPFQvLfbrmFZgbGfZDR2pexvZYrsXwmWJuEy/4E2dR8iKjsP
         KyHz3NY1hBlwEQX1mdoxgKeuUmhjPvP8VSKY1mqM/ZElQZMhZaBO9rvSmswaReIhei3X
         lEo+E/ZU4rKSjfy9suin9W0OZWfP0zO/yqxn3GFD/rdVPApqoBrgu4LJxxNRr+/Rn7EF
         BVBgj/CTw9SoPu1OVQ/YYKrA7cFDk939V9GGqj+cwb7cFtEtKgjIt17dRVr814+n3hOw
         Nhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763111103; x=1763715903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=590P1F+Abi0Ye9e5UOfcZnWB/iYAfiVbOd0H5hq8/hk=;
        b=X6OviGaDc8D5JmbUj+rLYR3Jrm8EkOf581WpxoqCajcSKlnWPV3PmKQQ5TzHCFFoeC
         03lCCgo5gZSOlpJTNj39xITA6mo0Q02nyJogdUS+NNTg1g1Hnv+IC0hkVQOXye8wyTBX
         BZurns34mORH4el4NEpSYlOCfdu7EOZLSEoZUsddU9WCYkas8wU9XD98TTWwjH6BjSRz
         0ak1nTyWNb9xjXaicuY7Ut5huhQ29EBoqgzug0ezWW4c8Y6sgFKFtW/LFwyLZIXJHOWe
         8NoDOWbUG3nhTRkn33JVnqyTOfPNQxbghxZ5bg01fXrkIpsQvDoeX50/E4aY6lMImuCK
         l/OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBM/k/U905xi0gACAqzmqsFlDY1NM0uP/Gj8mIsrxSRoPuX7Br79xXjHXtu7SlgWxv47tE0NWt65JqpllI@vger.kernel.org
X-Gm-Message-State: AOJu0YxLRwDTTwVC+CyMlCijX4QKtwE/d1cXn1hFOrsuxCCmMcUZaRP5
	2cwzYgejfufh5aLQIQGev+0vZpUM6j8nRAdYEY22tgyIVEnpFSdnBmAMS4LpcgG3FFt5n81GGff
	6k3LmYw9F+xktjuSgO88J6c6XrfxNLQI=
X-Gm-Gg: ASbGncsfGamSCaL+lP6N1/TVRFqKLyu4QBsFKl1qDA/HnEnRwixZ6EZJV8T54tuYxmi
	1C26mAsrDuS/DvMHYzZeQuIWSTEHWOocM0miFO5V1p5VlnfHUNwVt38LKcKeNaoRTtqi077Kqv2
	G+rkb55VezOOzwarWyOBLCVcn3JaS0TnQiSyovmYRzyv6qzGP+ExqwsNVMfmD2n9f8i7mWymIQB
	x+pfBfqJD5S2NAk8Kv9PY2Ud8WyEs3KXsFNLYVHrtuOvgXiRe9WFH6p28k6D+hL0+WENPjoQ15u
	StKIJuu6WOLEW0CyEXY=
X-Google-Smtp-Source: AGHT+IGJ6tti4Eyass81p7nkkUH/cydyjrRGJiP54q6aqUvgHP/ozurh6DWM/0M/PH1dD6Maf+Q+g5hXlU1S0OIuQZw=
X-Received: by 2002:a05:6402:278f:b0:640:96fe:c7b8 with SMTP id
 4fb4d7f45d1cf-64350e04747mr2080919a12.2.1763111102773; Fri, 14 Nov 2025
 01:05:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org> <20251113-work-ovl-cred-guard-v3-33-b35ec983efc1@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v3-33-b35ec983efc1@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 10:04:51 +0100
X-Gm-Features: AWmQ_bmvSOUE8XS8-dGx_2PJjILVwNiUjTy11YSzEFCQvJn9yJuc8ogg6iVVInQ
Message-ID: <CAOQ4uxjeZC0V_jWA=8u+vTw0FDWehdu8Owz8qzO8bTqYVb6A_w@mail.gmail.com>
Subject: Re: [PATCH v3 33/42] ovl: introduce struct ovl_renamedata
To: Christian Brauner <brauner@kernel.org>, NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 10:33=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Add a struct ovl_renamedata to group rename-related state that was
> previously stored in local variables. Embedd struct renamedata directly
> aligning with the vfs.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/overlayfs/dir.c | 123 +++++++++++++++++++++++++++++------------------=
------
>  1 file changed, 68 insertions(+), 55 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 86b72bf87833..052929b9b99d 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1090,6 +1090,15 @@ static int ovl_set_redirect(struct dentry *dentry,=
 bool samedir)
>         return err;
>  }
>
> +struct ovl_renamedata {
> +       struct renamedata;
> +       struct dentry *opaquedir;
> +       struct dentry *olddentry;
> +       struct dentry *newdentry;
> +       bool cleanup_whiteout;
> +       bool overwrite;
> +};
> +

It's very clever to use fms extensions here
However, considering the fact that Neil's patch
https://lore.kernel.org/linux-fsdevel/20251113002050.676694-11-neilb@ownmai=
l.net/
creates and uses ovl_do_rename_rd(), it might be better to use separate
struct renamedata *rd, ovl_rename_ctx *ctx
unless fms extensions have a way to refer to the embedded struct?

Speaking of Neil's patch set, I did a test merge and ovl_rename() was the
only visible conflict.

Most of the conflict is about the conflicting different refactoring prior t=
o
the actual start/end_renaming() change.

I think if you guys can agree on a common prereq refactoring patch
that would make life easier for both patch sets.

I can give it a shot at providing the common patch.

Thanks,
Amir.
