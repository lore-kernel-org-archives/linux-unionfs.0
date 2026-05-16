Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E845405C52
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 01:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778893465; cv=pass; b=gbOsze5UnWgkUVY8K4562VrjrJYJFZZyp7wAOtVkEps6M5pB16EUIyOqU80wTLkGQC3nb+Q4YLxbv9mxM4Ul4A13lZSocN4jeBR3UPJADlU25YWK1oM+nArVT/9al5l/Iqn0X0G56tmJErLEgSc8+u/I5E4g3ogFPEJ45j89Nv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778893465; c=relaxed/simple;
	bh=HjfXyAreThSB7plifY/0RnO87buo4k7Jm7ynrCfd/68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtvTp5TfnRij61yIfyZyfHNPjFl7jCRpJxyf58yfYjrR/QgnX4j5Tg5jjgx2E5RCMUnDe470BbXtMNVnIkIcEb9LA8ipPHhyxRorAfbDSHoqr39K4uzmmmLpW1cRwscW2bUTrUAHkUUqktamuYXR3MTTenwGkHtAsX2FWGW2+0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QGZI9dum; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QGZI9dum"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488ad135063so2726525e9.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 18:04:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778893463; cv=none;
        d=google.com; s=arc-20240605;
        b=CrYZDz8HtbKR/BPy32wqY6A/3N4aSNFUQtIjL/V1J44juTw1IzPRZybrwOv++1szgu
         M1o74WI29F7VvkHR53eQU8VtosLn3d20GQv6lXTqu3sDfP2cxOxjiOAfwH8TaW07xLBi
         qc68WfZNLxJBsZE5AYm2K3TU7Z8cXgQNRcfCs2cD2WVKba8ZD2sFitLxj4blGBZA9qGs
         r5worGdr3RwtAoY077Y+L0XPiPfZtC6abpT9AADH4G6W2RjELnm2d9L5m1YZavMCLeBy
         4O/Z7/hjr6AyuX5tKqQzgwNAxUHwUPJV/LLP7buabEhqHu3xTS8ziA1ohT6bAuUpdqOq
         gOOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rMAbpirgAMOxyu32qU3H1eARc33X7yqH04nuIA50Xlo=;
        fh=/WqT6EGqZ5W8KNKxrMwf+7UNUNZ309uPROG2xo/CzoY=;
        b=NWHPcg/lnCxiR1MT6zho3xJJ/3LNoEvmJ0O/TInNxf/iGsIB9ChsbWiR9mzQaDxPvv
         LyaxWsTHAhw1zVHVNOGadnNLbG3o6/FbiggnZJiwQxeedA/EuUGbzCxnqLRC2QJMCJjq
         v+BLiNwtFZJH+snjbIUbHPKl/mzXUaXUphRGiaJjeKVWzZnODA3vpo+NM/DPxaHYZu3w
         4YFEtliPHhS60lJBwk9f4WmDwIfw3uOqthYJPjR4KK9clBGrIt27d0T0rGag9r8ImNCa
         ZJNWCW+visgg/pZ/zY90h0j14PvJv4oFAOhFF/Yz4l6oGBx9iv93tw0j18FVJbME+X8u
         08eA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778893462; x=1779498262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMAbpirgAMOxyu32qU3H1eARc33X7yqH04nuIA50Xlo=;
        b=QGZI9dumjWAXfgUaVkAO3e7m/LD2siBd4dF8Yoxw1blvbXL3lxq1gGP5XSXvlABd0p
         jbO1yRlX0XkSO9bqTVubj5Yo+NFIZLVHMfayMY34GIuBlw6vQu85u+BxsxUtU2T1DFIn
         pZpnijCJx20wvuVsi5peKYrIcqDoFnIJAVjvbFnNj1sPoBD21X5Sybv2eNrAgHQpKHVQ
         qnG5G5QpQSLGS2h59DDIx1XacXmtHapY5aw/JftPm69yaD/QQWZhOeBpDvvggwVOHeJE
         dLisjcBYmHmiv821VeWyPcnvTxZ8mm0i24BvaJYvsxyx4nRFKcjmxBUCm8n28gYWVZks
         iaGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778893463; x=1779498263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rMAbpirgAMOxyu32qU3H1eARc33X7yqH04nuIA50Xlo=;
        b=put5fIVcneOHy3Qxoj3mcUf0P8s713qdxQAlTn02KJU3IBZc1iGq387tGnGk/z6V7F
         v1WHvlGVdzGcNkeElynEdJGV5dliIpIvBLizOqxrZ/EZtKDYGhZ+KG3nWM+eUrJevN7H
         xd534jYCdI5VsvElzkFyRabVcJcfK7qRM59duYlSkHrq4TR/COgahUtaQG7OVr6hWWRf
         C4w8JV+HFWj7b2YqIYPXqgnoGSzcLjJGcqTneluM15BtusErYwYHHAx8aXEpIZKO4RgC
         hUuqgtgmQVJJpKkGI7RddseglGfJ6mSlobXqTc132Q1Ks8vPQL+VZjvHxOq024Uekhcj
         hRRw==
X-Forwarded-Encrypted: i=1; AFNElJ/J8C5EoDtC7D6yeE0cV51KdQtoQkxuNtMqe3d52UO+/hphKluSjLDq1Ibg/yUIVxE0izHbeb9fnm4IxHTg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4p0566X5DLinBOr+jnST144nrLIZYRL3bwQgC4l7YdBiylPo4
	HpfbBfgN//e7isMEMV6tngm6QmeqcVdTHQHPSW+b5WtoQWU8xy1z3swi2qF6U+D7rIKbgyVnXn7
	hxxtR2g3FnJYcyN8ixTut+B8Xi6HRuLg=
X-Gm-Gg: Acq92OFZkK0iX/LYqkHS8JTVBf79bktX70KTN+m5dvUcVq/lInLV2mN9M5nzK0V41RT
	sX32pW0plWy+2FSTfs6I3pZM9vhDLEZsZtHVaighMAnDLDXasFWObEWQc3bOkFHsAQRUJp9MLVA
	GlxfFHexwUQ6YAPG1IOARpVtvqc7LNTd8XSZ+J/jX6n5n3fEz9CPyVzwkopW84pMqTUNpUQPp50
	p1YDvbXKFkVys7m3tuea4Soxpdrfj2rR/67u9CJrzMWQHS5mTuWDf/cGIu/nyZlpm37j2uQB3AH
	1aY6Xg==
X-Received: by 2002:a05:600c:3e11:b0:48f:e230:c3fb with SMTP id
 5b1f17b1804b1-48fe6626a8emr94789465e9.33.1778893462397; Fri, 15 May 2026
 18:04:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-20-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-20-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 15 May 2026 18:04:09 -0700
X-Gm-Features: AVHnY4KoZdiSGJG-4wYSni3XkLB_-aOuD-lXy6zSI7M5cwElKh-O7LAgLIiFbp0
Message-ID: <CAJnrk1bm=QOmY9MNZf5rbi-aTLaYetJ2Ziu7A5q9m4MMy5-Y7A@mail.gmail.com>
Subject: Re: [PATCH v2 19/21] fuse: add passthrough setattr
To: amir73il@gmail.com, miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 5:53=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add passthrough setattr which sets attributes directly on the backing
> inode through backing_inode_setattr() instead of sending FUSE_SETATTR to
> the server.
>
> Passthrough setattr is checked before the
> handle_killpriv/handle_killpriv_v2 suid/sgid stripping because the
> stripping is handled natively by notify_change() on the backing inode.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dir.c             |  3 +++
>  fs/fuse/fuse_i.h          |  3 ++-
>  fs/fuse/passthrough.c     | 28 ++++++++++++++++++++++++++++
>  include/uapi/linux/fuse.h |  1 +
>  4 files changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 4c7e3e1604af..b67b3b334e69 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2506,6 +2506,9 @@ static int fuse_setattr(struct mnt_idmap *idmap, st=
ruct dentry *entry,
>         if (!fuse_allow_current_process(get_fuse_conn(inode)))
>                 return -EACCES;
>
> +       if (fuse_passthrough_op(inode, FUSE_SETATTR))
> +               return fuse_passthrough_setattr(entry, attr);

In the v1 discussion [1], there was a suggestion about gating
FUSE_PASSTHROUGH_INO on FUSE_HANDLE_KILLPRIV_V2 to avoid the
non-atomic killpriv path, but I think we were only encountering the
non-atomic killpriv path because I was calling
fuse_passthrough_setattr() in the wrong place. I think we can avoid
this altogether by just having the backing filesystem handle all of
the suid/sgid stripping atomically through its own notify_change()
path, which will let us skip all the fuse killpriv handling logic in
this function.

Thanks,
Joanne

[1] https://lore.kernel.org/fuse-devel/CAOQ4uxipQJt5zskb_THxueGi_MXpFdywFiG=
pd_nmWeY_sMHwzQ@mail.gmail.com/

> +
>         if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID)) {
>                 attr->ia_valid &=3D ~(ATTR_KILL_SUID | ATTR_KILL_SGID |
>                                     ATTR_MODE);
