Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792587657;
	b=VkGUWfiEDJT3dSGDfuKgfglwvsEF4XyzoWVC1ffDRJq/ieraQoFvdXY2b+MhN9ytc8xW
	 gs4hjYPdnGyBzk7XKSaRWoD+ZURKVkrzKaG59E1ltbwxUry5ZPvAhjhfhu59JtoawWHCR
	 gtqDPh7BDRZ8+MeoSV6cQjS1z98fyYBkFoWreVqCq6skacY5ZxYxObc7W78mrvI3/mcUF
	 rQ7lTI8GO9Z68OQiykGiaDvPk4IpnT2XWP/1bm84hA0GIC/BYZvz8/BPqTruJX1Sg1OTc
	 5NYtD3dB0Vr8EzjUZ8M2ywhUsG6spagycexTr9Qs3mDkFmZs3fptuGrlLUggaxd8d7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792587657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kXoYys6AGDFdddNSuFyoTToCIugSJAhRAIJkUtxGkCM=;
	b=2OqkiLCYI/tBTrW8qYmeEqxf8yiJm0I39D5KLosXz8wyLucCTbi7RxtBh7oZrBaNfVNN
	 IvuGcYSM7houX3RE6QmIEfRcit34x4wKYYXJKtikSBNJVAs4kEh9DmYkUt8iEfmWcKqni
	 WFyf1Tb0abPopJBuG7DYQMXMYUZPKCKFd+/DK/TYx0WwHbQKPQ8U9kc7VF8Tuf6BR0AIk
	 7DGQAfawg9Pl7b8AOxTgttlAX4rN0VG491FrOmAnaB+MSXkai55cyUNcKgEiG+glbcygi
	 InayfDitijG68a32LgZMwbuDhi7R7xi8qnv9+CJLA0prl7g9DzyP7d7mmxv4tvyrAOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ATuLUQhC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4BF606A31D
	for <linux-unionfs@vger.kernel.org>; Wed, 21 Oct 2026 13:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C4BF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ATuLUQhC
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so997122a12.2
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Oct 2026 06:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792587655; cv=none;
        d=google.com; s=arc-20260327;
        b=j6NrCzEWQD2KLaxN5aGmWwGyMYscGQtRJo3XPqdxELbeNtfvN8RYRik5hvzn5t9P13
         MNu+1MPPLmtMhuL3zw0z8OhbMGWTunzmgfvAfR4qOAxQoU8oThgOuqdERWIeF9nPdoL2
         VXepXHf2/uQu4sNGW6TI5VEZjcgsVvcmgClStbukUGYBUJzC+7//kg3zsSlENPjN/Svu
         KQJw9UjgQOIE5dbovxAqAKtGnlWeNuoTdVUkEQd8nNV2m4O3EHXfqQCcxPCHtQGyxNzz
         Iuk0fmEIm2Bn1+f2rS0xo8AFC44PjgmF99UKNrsJGGLOsdjrXIQU1ZW2RD6ats+r9HBa
         XIVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kXoYys6AGDFdddNSuFyoTToCIugSJAhRAIJkUtxGkCM=;
        fh=dzeikD2r49P3G5ezG/UYqha0Qo7+9V6QSujK8kPZLls=;
        b=EvWe2S81VYDgLn0N09tOJEcO/nUZpI//MF0V1FqHoGz3WCpY9XdicK4JhLei+P1LWs
         tDnUbe9Bqy2seJFNDLfnnKCbECo5pIcQG4+RKOucl8LTQu2JtqlK4/sHC9NBRg5h+ub3
         dXUN2r1LvNXUhvJVIKPsJxPHWkuPfGAx+c2SlLDy04mUtKXuOB1IWxfUKAa5neVP6iXH
         2NKN1C9FHwgdwtHqvvUgzd/PGBrW503wev6/MGSFdlygRzgkpLxTNZgbDgQ2TqbmTGvk
         9qRSAjtlnohyn7/I+UDOGMjaKTaIEmJjd88kfR6NMCGfWSGWHobRBD7VCDtviXRZn3eJ
         qayw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792587655; x=1793192455; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kXoYys6AGDFdddNSuFyoTToCIugSJAhRAIJkUtxGkCM=;
        b=ATuLUQhCm7bNIC7Md6XGQY4GFQFK3oqAfo6awLZkDZVz5OvwY3So3XmmwcXFeZlTQc
         BgK6u3qgRI7hnMYXmWm8GvYPSVi3782HLsc5x9MxY5zGwodRLFAjVgituIjKB7igSnfw
         HkYxVqgGTrc5cbJcX8MLQnQ1MXbYv0Om6QUndvOcu/XjVIRX8hwCj47gXOVGdXEMru0I
         BRPD3BDq0VVn/hf9bKWIHRLb0UsfBQjmTMIVWtBLCJTVvLojZnoSUiWMxnQQj/ldGL7n
         eCXROZHcz0+5Bbj/i4GK+B1jzceI04aRQUhDIepgcD+2NA4Fkf3XPCK+2MPcL5tA5C0j
         MAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792587655; x=1793192455;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kXoYys6AGDFdddNSuFyoTToCIugSJAhRAIJkUtxGkCM=;
        b=DIakLpFzd3O/e9ju5BcmVy0neI0u/7LbmciX11e7no/PHHEMCdGShOZCHggp2xFvEF
         AaRWUrK/YiDmgb7uytKLKdeZT7JiiMv1YmH4pBgzb7ZXsYz2QIeLQiTr9+iL9wY/uRzT
         TZYS3pWYPHtmjSazp1JxZ9xTwx9kxwmHqTxMEydS3tse+IVuOeNvdiDp9obsmfqjqXvD
         lSOe6kVOlay1qADEOiZAgYFj9+v36mHFksChmPB9JihHG6lePF4DTUcAxRd7eMje7kNN
         MJ4wqEwsl0xWXbeukQ8oXm+vBcNBuq7OMGsCaLkYbnv+81feoaWYGJQRbkcpEVMht19I
         qVug==
X-Forwarded-Encrypted: i=1; AKwUvBx5sA4etJ96/1ejGpsVQQsrqwH/2SZcE0MpnHynqG99XfzqbqVJax+yOfXjPiomqMtKJYWH0EEfGOI60qMs@vger.kernel.org
X-Gm-Message-State: AFq9FYIWwE3rR8sNpMUowmSMQ7eR1VvkVaMnfYMMiyazKPB1VJHnnDyg
	zuVktbTNttIF8J83EtYYmvzEX/NoXji20vHaSwpJJmPpSNFv9klMzVuyqkOj1is3jrFkQonbK1e
	LOGaDQ7ddJCdeH6sSGcj9dFEmQfwRO+M=
X-Gm-Gg: AYBFou06ZfPR9uBGzzAB6wYKVG8x/Hv9R+G9KIalJsyw4kxNe/ADH5FYhEbnyb6Uss6
	Ru2fs+OrkBR4Y7Ndivn1v/mxmlz2OjzgF/sNUpfuA9revqAJUCP6WxDMzg4gsR4kFJi9t2bS9GY
	p82buUwCxSfd+eteBmXL+LvWCEggrqI7XkzUtimUwE4otqiOcBh+PYPkVxH13QtlbIFtjF5Z1qo
	Vrtb6JGb5EMLx4FHRhOQ121Wk1sdwfYEEyhcbea1ggwOmLDDPe21Z8jF8LTf9A2ZrpzhdvMmYBU
	R9jJ+akQKTksR0w0PBYbUdGFMztKS0uIAUOC6NqciV7OLKH3Cr5YXBHAOk9Na8qz1AmllDURVtj
	Q4uuvKVGUMPmiAVHb8ekNatMpqZdJkneOO2Rz
X-Received: by 2002:a05:6402:280f:b0:6b4:16fb:b9ba with SMTP id
 4fb4d7f45d1cf-6b416fbbe8emr581616a12.36.1792587653646; Wed, 21 Oct 2026
 06:00:53 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260924112858.51392-1-disgoel@linux.ibm.com> <20260924112858.51392-2-disgoel@linux.ibm.com>
 <20261021-erbschaft-gefahndet-erklangen-085a518222a3@brauner>
In-Reply-To: <20261021-erbschaft-gefahndet-erklangen-085a518222a3@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 21 Oct 2026 15:00:40 +0200
X-Gm-Features: AclHuK9WcoBrCyRwmmWQl42Ua6CkryoBn_QB6lJW1f-3Kmj5TuvGleJ2mOxIsU0
Message-ID: <CAOQ4uxgO5xW39SfBEfM5yS4uV7M6_zZu7kVP++bNwML2s6ZPsA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: fix wrong layer paths in mountinfo for detached
 mount FDs
To: Christian Brauner <brauner@kernel.org>
Cc: Disha Goel <disgoel@linux.ibm.com>, miklos@szeredi.hu, viro@zeniv.linux.org.uk, 
	jack@suse.cz, shuah@kernel.org, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 1:56=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Sep 24, 2026 at 04:58:58PM +0530, Disha Goel wrote:
> > When overlayfs layers are passed as detached mount file descriptors
> > (opened with open_tree(OPEN_TREE_CLONE)), ovl_parse_layer() uses d_path=
()
> > to record the layer's path for display in mountinfo.
> >
> > d_path() walks up the mount tree to the process's filesystem root.  For
> > detached mounts this walk stops at the anonymous namespace root instead
> > of the real system root, producing a short incorrect path like "/l1"
> > instead of the full absolute path.
> >
> > Export mnt_is_anon() from fs/namespace.c to detect detached mounts.  In
> > ovl_parse_layer(), use dentry_path_raw() for detached mounts instead of
> > d_path().  dentry_path_raw() walks the dentry chain independent of moun=
t
> > namespace and returns the correct fs-relative path.  The path is
> > display-only; the actual layer_path used for mounting is always correct=
.
>
> I think that's nonsensical you might end up with complete garbage. We
> should think about a custom format so userspace can "label" the file
> descriptors instead? Amir?

I wouldn't bother with that.

I posted a patch (you will see it soon...) to fix the test:
https://lore.kernel.org/linux-fsdevel/20261017165103.2450042-1-amir73il@gma=
il.com/

"/" is an established fdinfo path for a "disconnected path" so I can live
with the existing code as is.

We could also label those paths as empty path "" to make sure that nobody
tries to replay those bogus mount options from mountinfo, but really I am
not sure it is worth the effort, considering that it is very easy to
see mountinfo
with paths that are useless for replay (e.g.
upperdir=3Du,workdir=3Dw,lowerdir=3Dl1:l2)

Thanks,
Amir.
