Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE238F251
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Mar 2026 23:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773877624; cv=pass; b=MmV8Z3BZ52PV9aN7Sn8of4YJOLfKvhNCyHE0NDuUiKrBhNMR5RnPvlfDtwFTKH9IEcjvTyApMQ6NMG/HBN0butkduIYv/E/Guawe6U7OHF2zFIbsSUPQ3VbQqlHXgVqlVXs/FnVklzifW97MvXqiQQmfLhzrHGHTaIZZ1MxSrKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773877624; c=relaxed/simple;
	bh=goPdRYRb1QYfjLs/QmPDwV3Kh5LoPgcZM/xi+f3fGd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pIQW1vd1JpISY0/46IXDHjFOQrnDJGQite0/srlBBR18V+nK8QoBgHMiOyjG4EuKqsTjvjAo8/Tjf/LOqQoNgD1Sh0wADKd4AK6775qrbq8OZorz1tASOCxFkrQiViQkVWeh2dwJnyLBEsYu/SB6+c5gg3i1kpIPezBpFPXMG3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=AKLsHbzP; arc=pass smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="AKLsHbzP"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b04e6a989eso2633335ad.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Mar 2026 16:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773877622; cv=none;
        d=google.com; s=arc-20240605;
        b=H/isDwPCA1FrksrHM582uTnQqJElIrI/QSdbfvv8J7H1ywU0k3O2hzONtX+aZGoftP
         v1iLrPP+D1CCoiI6dBgs4dyRus7FaXOeBjB0Gn3j5mzRqJG3Sj4bFuZOlnZ8okyH+d1f
         G5vdfowwOKirW7OPB+wY8tswkOgP64eJmaWZ1je3xHx31pkjAVeFxQKCHFFGrJNTxjQB
         3S7ae7BB1bB1QnxoEXVDXqI/FxgGZaiJyg4UuY5AjNKt8TDfoIcZjGaeY6MVAj0gvJA7
         8L1WW7VJdUpLdjKFVhJLTIAkpGJHJ006zp3Ew4OEzV9wcTurpDVPc/HbiB+fANqWjFZp
         Pl2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SKdeu+6dCkvAUwBQTZO2KRv3z1lv0eoszoXVMxx1Rl8=;
        fh=q8OIytilscGOCYTFBVg6FsJnbbZXGyPRauoNcBoWmm8=;
        b=bI6RkfAxD4m3HW8tBfV7n8F+sLm5Gj49H5R8Qj2p7QLEWdo0UZv/ftKeGbxLMxkD6+
         I1uNY6hH47jN6stc7szoWtcdTteyu5C2RSpG+WyfvEgf3EhYRvOx2qFO/ihJFrbfdjSX
         vjJai3itg9OaQGpLlsxePrONtB2WTDBiANmSSFM9eRD165nfpDZz30lrLtOz85ylpNiv
         J0QSQpF4KlCkJfsBk7hvnNbilJexvUN8+NuuTrJu7jvBJXaXtNpvtDA75eRUp+Ngmniu
         o6QHtniOs4dqVYX3ntIc6jQTueJcfOcGqh3u9X+oqJeBMAm3/PuZUAh1VJwiG8XarS7T
         5CGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773877622; x=1774482422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKdeu+6dCkvAUwBQTZO2KRv3z1lv0eoszoXVMxx1Rl8=;
        b=AKLsHbzPe/UFGdaly4ZmKWfwEwmrHjd1DkZL4IVkQuzIErZyEfHo63QiPdDZocQ1er
         TDQuBHxvJGfj7ByZiLM4PkfV8rNk5V/3NumordXmOjXxnaeC+X32rN8w4u++FYqMJ922
         qiHl419cOnkMprBN228Xaq+2531KkoPltl6Xoo3Vp6WW2pPtOlttG1dg8+rgq8J+7Dml
         4EjE2vHGePmPhTt2w4gTd6ctMcC6LeWCMahkdppjXGiyBMeMN+uX9UjHwZhkMaO5oXpt
         utlaZH6uQCma0rd7bqSMOrjCIguHzeb4LLkVoaJxpS4oP3XYJDepNYXITJJxfvyktN/S
         yLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773877622; x=1774482422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SKdeu+6dCkvAUwBQTZO2KRv3z1lv0eoszoXVMxx1Rl8=;
        b=rffTuv0ZKcFoYptdA0kQO/4QiUg0Z1PLqsx370r8aGc+hrAtZwGuc0Ad7NjIM5ySll
         efkXp7j040G97m4TeFLucgXw3riiaKDwQy4drb8pt1rjkwxBfHHoLz2cKoDtCE5VIo5c
         KL/r0cGfcWhCST+gYS+SxZqP9/exT6eh6lBgfwNp3bBq7bcOCUiChXAK7SsQSjoapD6O
         VkoDR/RlK0UKvNGqgczVbEUU2HsVzl3hyWStSN5lGK/Ijd46iG5y7NxVxE036VZujkcj
         auDmvYlCn6LiEJsB+XwWRI3xhPwp4LBifum41fFBUvl00FpfWO03V+ZRxR7NWFALsdfN
         DxCA==
X-Forwarded-Encrypted: i=1; AJvYcCUvgAClr/BtjriGkJurfKLeIDs7cdwflUPj0KaR7YmXprylCLUFYliWNsXQWZLCwcldZgWe556s1UuJ5ABB@vger.kernel.org
X-Gm-Message-State: AOJu0YxHO0rBOZZ12AXYN4jtzgn9RmHjFWo8W8aoYc3+ech7Mxbnav7+
	3oDzi9HS4YJIonFfPYWb8I6dRGFMu8a8A4/I1NjK8ZLJvv2jzHc8Kcy9pGWv5WDRdUCNFF6JfTx
	hdZqFEX+EoqRjyjJU5Va8mRFCr2LDdQur2fxZx/Jl
X-Gm-Gg: ATEYQzxPEo7KphsqT0o61SOlqtuyXszqxKPxheT8MwA4pGi2HwY8w2RXeVzF31oMCi6
	V12EtNO+r4syd7Mr9qVKqis3iWSqlHW/tHpZPougI4InObHYfAfds2D7wIMFB0hlJL4S/j5/Dtj
	RpCIF5nc7EDvwd1GOvBPHHOBBswXsOkRwEBLmv/BBcoPxs0Bq03PNkk4Wf3QIUZfs55gNbZX31i
	IaGT7KDrOOxL95z2LTnXrEkyynLZVNYns3EaKJdHtfN3LDyN8PdgdQRCcxyxB7Bd3ZnNixvlr5u
	SyIDKWU=
X-Received: by 2002:a17:902:f547:b0:2b0:7177:d5e5 with SMTP id
 d9443c01a7336-2b07177dc04mr35425715ad.43.1773877622532; Wed, 18 Mar 2026
 16:47:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318131258.1457101-1-amir73il@gmail.com>
In-Reply-To: <20260318131258.1457101-1-amir73il@gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 18 Mar 2026 19:46:51 -0400
X-Gm-Features: AaiRm50UCF1CurPQjVXbzqdFj4rL7YmqoTti-AfxH9o9diMwAaN1iIjAFrpAzkY
Message-ID: <CAHC9VhTKvOzMS2ZyawE=qBN-EpyucfxvwcHZYjXF5zugRhE2rw@mail.gmail.com>
Subject: Re: [PATCH v6] backing_file: store user_path_file
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Gao Xiang <xiang@kernel.org>, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 9:13=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Instead of storing the user_path, store an O_PATH file for the
> user_path with the original user file creds and a security context.
>
> The user_path_file is only exported as a const pointer and its refcnt
> is initialized to FILE_REF_DEAD, because it is not a refcounted object.
>
> The file_ref_init() helper was changed to accept the FILE_REF_ constant
> instead of the fake +1 integer count.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Christian,
>
> My v5 patch was sent by Paul along with his LSM/selinux pataches [1].
> Here are the changes you requested.
>
> I removed the ACKs and Tested-by because of the changes.
>
> Thanks,
> Amir.
>
> Changes since v5:
> - Restore file_ref_init() helper without refcnt -1 offset
> - Future proofing errors from backing_file_open_user_path()
>
> [1] https://lore.kernel.org/r/20260316213606.374109-6-paul@paul-moore.com=
/
>
>  fs/backing-file.c            | 26 ++++++++++--------
>  fs/erofs/ishare.c            | 13 +++++++--
>  fs/file_table.c              | 53 ++++++++++++++++++++++++++++--------
>  fs/fuse/passthrough.c        |  3 +-
>  fs/internal.h                |  5 ++--
>  fs/overlayfs/dir.c           |  3 +-
>  fs/overlayfs/file.c          |  1 +
>  include/linux/backing-file.h | 29 ++++++++++++++++++--
>  include/linux/file_ref.h     |  4 +--
>  9 files changed, 103 insertions(+), 34 deletions(-)

Still works for me.  I'm going to update lsm/stable-7.0 with this
patch so we can get some more linux-next testing.

Tested-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
