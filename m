Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792531683;
	b=JFClLoWZIHw+cUFnta70QlBsm6+R1SeXkxaY4dEguM4aJEu4u23kPfXZ3h4aWNN+I3Mn
	 Hf3jxAMutHEWym45X3goCUwvRsP9JjvfNTk7IvPOcrq7dWiGhh5MzNybvmV0c49UX/+JU
	 jK2FPmwRX0Phc2wy/m7LyCq5tjTCVRODxjNAR2AHYPrTM07iw4e7iVV9l8Ut6qYjOkixg
	 yFTtJYwmRHb63BA3rKRQbbAv93xn4Oka6/lSFfOzTv56s0UPak2ELSWMmzaz0MDEU9DXh
	 ZF+92i2OGHVZxmXXYBuMQYEy1AQrnXjVic+GmV/JHee3RpFeJIZ/hDVGO2Mlm/Q/3ug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792531683;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
	b=PoOhbp0c0v4gE4kxANFzPzuWvhKqCLdoDBgs0M/1bJUndojGMHVNQBR/UVfEmr21KCeM
	 OpAQUgHN7llkxmUojMpkyF8QgTXN5eURmk5F1jpL4eRxXQMICT+pmxwUIIjR8Zyqr0brZ
	 Sf8I2W0YAdnlKB/WQaGh4Qf55u60g/dpDVSRCICULKDskLnCGhhvjjVKH+JD+VjJEc9PC
	 av/29rQlUK8GfovcBpveuRXfYryfufdLk7mOFi43++98jI6KjE3v23MOovkcfv+x0EK8A
	 2D281tCS/AYRWUVWWmlXJU3xc/ceVyJRMIAdTGZd94rEunFBcKhuVBKh9AjW89A1ixA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cc4Ei3P6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1037606A31A
	for <linux-unionfs@vger.kernel.org>; Tue, 20 Oct 2026 21:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1037606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cc4Ei3P6
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1f4d8e09aso6832a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Oct 2026 14:28:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792531681; cv=none;
        d=google.com; s=arc-20260327;
        b=UwePt5o2GKRsmKXewBBZtP13B0KJBWLDMKe9IyU6jqzlNRiZF/nHhG4ZcgIYb61HvT
         WXfZPFI9CknDZsRkbTe4DqfzULCAyRJHKMDp3uDgcj4F/vbcicrAF8oOPL/WR3EKvJ+4
         5xGdKOnugHiCHslMa1pX4P9ASO0cwrlcp4kkqtaFGroLWq3X0X7r5j1OZxOXy0ZqPJHo
         eFxOhmP+f3zlu2KQwQbi4qkf/v4bRGzyyUAWkLpHO/9Qp/QmInSqR5/V2R0c8yD/J0Y1
         1kIYi+EQSShGI/1NT/jr4jHoAb6Di5lxBl9co3wDXWltKWltsQrjjZzVlmqflI7Ih/P1
         O/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
        fh=7WIaJzk79Sdp0x/xbivk3jXYJuQadb5XkDowDM2QfiI=;
        b=kox68XkFUCZrBvYXowPIaUX8JWq/fPRIE3zl8eESuePFp/Qs0A5yJ2V1l/yQEFrBrJ
         dAMO0myeQrtkt/vsIPklWbsTKFKMOgtV5KrU6zfTim7yqGVpTDXznw4/h7h4t39argzY
         9yb/X5N5t+om5ufeatqsHWFRZViXmF9KbB1qpfZlntvG3TUCfih+0lP8tKinnXELZgut
         UQ1SDtr03QMwmnfZ2zW/p5t7iyyAkB/lbdvdqK2X5YjQZNJ2TC/2Lt0UPZ8zYaV8buYE
         r67oqwLPa4ZrRUcGCblbQ1W9M/+etiMr2N+P1dtuL+gR3mH4FDA9J90YKoTwrbRGf7bw
         F/ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792531681; x=1793136481; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
        b=cc4Ei3P6HzngZNuiymktrEDw8AujBjDnaMFaXmgzNr+GTiyXeVt264YvZkd3CYd97b
         euP9G0gdn+uTT84htILcL7FMez5JUVFCiFiD9zR2gi0I3Ao/AGSt1CbUAUVJLZOxPT9n
         Clz9sldd7IeZMwDgamoUaAiwA5CoihWWl/7BVA142fJeMLL39fsIUJnccGqS3MTopNA9
         BEsHKMTZMIGPdHD7KjPEnxiCee8KCDllj0xuI7rfZOeuzJ4CEgebEV+oT7LgIOZbAI8M
         n+a4jvG392hNF07KR2ItVWZGFPWTTR1gmbUL1cbQxoKyx6y/AEI4fHG6DhWzLRztgg8K
         JXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792531681; x=1793136481;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
        b=nwaQXC/Y4smNH//XHsPTa3Zmn2aGKYywliM+Ekfu8l3XLL5ixi53JqHYYUvsI1Hxih
         WBfvQQU0BqYPaLxFiS+AK7Xa4kcf36WRd7AYoHDNdJ2ddFdqb2WYDK4+9QfyI5LudAFv
         sMEzUiuCmm+NlveK7jI6dUfPCensoC5eKC6+zq4RNR6DC6ldbsmN16Pypp0Dzc+bYAlj
         qwnIntei3XjHT7KHG7NpdCuR0FUbhKjxZLSI9BraqSTPDwWFL+mKAWvseDL69HDi+vNv
         f5I4TeU+jVr71qVqxKE2Sy1GhiYruP7/AiZVMXzev8tPbrdA/VsHz7PYGr0qFPMjSRfk
         fC3w==
X-Forwarded-Encrypted: i=1; AKwUvBwYLqZ+rRRb/n227JT4cRN7AjFa5UFan07BXZRsunTnbB//CMopzvPG0Gb+2vwtu9WgWVXLet6WYSqF9JNZ@vger.kernel.org
X-Gm-Message-State: AFq9FYJsjg2xcA+LLmes40YkUYyoNFKYfQ3idDl2fLNnRYBU/2XoLYHq
	os0EZCBshdpkdVKD0RfqoydsTgugLkKGhokNKaMqF7+rw/NqeMDGUQHBxlzuDZ9A6rmxpp8llKc
	CE8cBGLRJ5aoYVazv0i7h76upkyjN4G8=
X-Gm-Gg: AYBFou1SHfh6JbH0CkXLhV8ldYbcZ3Exv+EKbLuVZJ6UbUyj7UXiUelpBDBfGI9Twmm
	ULkK+Q5Vqj9TMZ/b7P+WXnm6Jx0iFT0Fb0gez+llyFHuOIFOnwM6xiTtgZ3Dh0LgnrFVRuiM8Nw
	UA7Szjf2AmFJRVIq1+zeDGdlEG090xjXHFQG+Y29fXoko4IB64qCnCPgqE2gG4KVpI9oGTJhA5B
	RcusRSKTD0Z/TSy+wBVEpM5CASGi1UQRd2smlU1PBTXVgN05f3KLDsgAGEV4q642drt1xIhOcZP
	0EEPO/4xfDncJyXQhI4941gq9WrW2e0pMA7WgRLwETeGiE9B0GgF
X-Received: by 2002:a05:6402:1f03:b0:6b3:84c7:efbc with SMTP id
 4fb4d7f45d1cf-6b3a81d6c67mr7787609a12.43.1792531680694; Tue, 20 Oct 2026
 14:28:00 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
 <atbfAjLsKxhkqW-q@mit.edu>
In-Reply-To: <atbfAjLsKxhkqW-q@mit.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 20 Oct 2026 23:27:50 +0200
X-Gm-Features: AclHuK9PVHbkB9QEa2qrctoA2a3SO9z_q9FaIo9kMIlvASMOLwNA_ijQgQ0d71c
Message-ID: <CAOQ4uxh9+pa9v+bY1gS5zCGzHcF-9rgSr5tVCVP07LS7Dt_aag@mail.gmail.com>
Subject: Re: overlayfs: unprivileged writes can use ext4's reserved blocks
 with the default resuid
To: Theodore Tso <tytso@mit.edu>
Cc: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>, linux-unionfs@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 6:55=E2=80=AFAM Theodore Tso <tytso@mit.edu> wrote:
>
> On Mon, Oct 19, 2026 at 06:03:17AM -0500, Claudio Fernando Pinto wrote:
> > Hello,
> >
> > ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials wit=
h
> > the comment "Never override disk quota limits or use reserved space"
> > (fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
> > default reserve owner, the second half does not hold:
> > ext4_has_free_clusters() grants the reserve when the allocating task's
> > fsuid equals s_resuid, 0 by default, before it looks at the capability
> > (fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
> > mounter's credentials (ovl_write_iter() sets .cred =3D ovl_creds(sb) an=
d
> > backing_file_write_iter() applies it), so with a root mounter the fsuid
> > that reaches ext4 is 0, and an unprivileged writer can spend the blocks
> > reserved for root.
>
> I'm not sure why overlayfs is trying to override disk quota limits.
> What's the background behind this?
>
>         /* Never override disk quota limits or use reserved space */
>         cap_lower(creator_cred->cap_effective, CAP_SYS_RESOURCE);
>
> More the point, why do we have creator_cred in the first place?  We're
> not lowering CAP_FOWNER or CAP_DAC_OVERRIDE and fsuid is 0.  So if
> we're allowing some file system operations with the mounter's creds,
> why is CAP_SYS_RESOURCE special?

To put it briefly,
Because vfs enforces CAP_FOWNER and CAP_DAC_OVERRIDE at the vfs
layer on overlayfs inodes.

vfs does not enforce CAP_SYS_RESOURCE. only filesystems do.

> Also note that if fsuid is 0, then
> regardless of CAP_SYS_RESOURCE, any writes will be charged against
> user 0's quota, and user 0 doesn't have any limits (often it doesn't)
> there won't be any disk quota limits anyway.

Yeh, that's just not perfect code, but dropping CAP_SYS_RESOURCE
doesn't really hurt for overlayfs and it obviously helps when creating file=
s
with the user's uid, which is what overlayfs does.

Thanks,
Amir.
