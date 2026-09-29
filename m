Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8142D73B6
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691319; cv=pass; b=l+SkZjS8HQ/C73hB8LaWREyqBsUPK9q5lw6y4CFvhIPmiDrnUry9amqku7VNO6PLhshYx088KPffoySqHglskk/dlpvPon6dGyyjN/dXKzWVjIHrEFvPYVm4CP8TJVSOkH3fD46VBZl/bhRzlnPA9b4BxAH0q9sPTTBuGeYGM+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691319; c=relaxed/simple;
	bh=WNPiWlZ8WpoGHZK99aHcbTTI4gKFUrGP6Bht4p9ETqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJ8cCC+07IBK7XEdYUNHNzXDntTxBKnfHtsl5uHcAs35K98J09qe3Ls2+9tKzLOHspRppaK2S8FkQuzremKOp1a2tYLtBcAopsEL7rPJXPD/Z5TAzYbtFanOIBOk0lLS/IuBkYUVKaEX7tSCSes9pxFDxZOb15uSSJ+l5etdW1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5y2zrvd; arc=pass smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5y2zrvd"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aaeeacce15so6494102a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 07:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790691316; cv=none;
        d=google.com; s=arc-20260327;
        b=a+knWq+7jaIt3xysx3m2iYzwmBwy/WOkyW31a780uu2ctJdvuHwHFHF4FGRAR92D4i
         fqG+nncB3J+XAsrqPh+ViYXYMUzGn33DiiGNA1JKjOMw4xCW6y2Y+LY2PvakjJdadL5U
         mXpn3j59wLgIIHvfoIgEty8smrKo/RjUb8IOMmvZMVqhuj+k5xahgj9mPX/ScRUgnvEn
         2pv80m2G5CYgtXbWZwxuzXFwsbL2o8oQK5B+F7Rk1fqMYhiU1H5VPYlaL5smOG/S3is8
         jH0JlqHOvv8Xw3jj9l1ry1q/ZBph6Pv25GDk98BWAYCRKuQAUic9GNe8Z7DJL+tPmIVB
         DXOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        fh=sOCeV26rP4LCewfvq/ftLqzeH2oBvvBnOCpGmoMH4cQ=;
        b=IcBuDyxc+kHCaC66DMPKd2R25v49LSnMEGqZXUfvjTeKgvVxrwCl+1MALSVQFZQi4v
         CXkUSnSib84lOQ5uKZ4pisT+d+y+5td0M+xNklR34xJ/6/aPreZH8+lKgtY00LZqv9N7
         RI8zkkPMsoWP5AA7JygmaXI9JEKdHk38O5IowTui1667+zIb+V9K006j7dVp9/+Rmz/P
         PayIHB94O+2+H1LURdUQPKBOWsTZdo5nqE63DPYi9Q8li9n6tNKe3T0nPmajOVA+v1HA
         etPQvg0x9rCS2u7MirI+b9H0MCdYqANFHS1tOflQwLMZ8HPJvYHqVPHw6Y6jFrqU/cAY
         QffQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790691316; x=1791296116; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        b=m5y2zrvdfKrrDlWmbGVWkbKGlBSJlMpl4+t0+q1faSnSoOJXN6vDuwrx7Q5hAD3Jpa
         TY1linw7bcIDan8EjtIzhGgc+cyoOOwyRE9RzgVeKFdxqJx0w4V70OU8Hj01JopcA6Hn
         WUcTqIB2KUfNBRFKNWoiCbphBarMs/ugh+VFmI9cyBvZd/KaML1Tx0RbvsQGKM0Zw7BW
         7Pw7XjOq/uRJAEVaeBmKNlOq4oCWmiCOwzzEWoGrPOkTbvUPc+hZQDS6ZR8C1hSEvJ9h
         mJ2XaYaEL0wMf1AGO+tJPkEy03kCRy0RMlpqaxhBeISH8gpSJDejJ/lXf8WFf3CQ9Ewc
         K6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790691316; x=1791296116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        b=PD1NW6XViV/oWvJLABhKgWMPJc6W5qX3MR+vMkST9VQzj1D3t5QCmKeT+J9ExuoqIg
         HOikxIbtxZ6mT6CCx+aWf2cJcrXLBfCFIwWa0dGddrAuFloXP+TkvxF+UIgNB0ITJMg4
         +vFXBLv+ZF6Zm/FeGRCHnzca273unSbAWIwLz47mWKZ+WKRLT4iS8mWJ+eAokttqoWM9
         XKlD8VWjDHYVO/SXY7wcYpRv+x4bZdB//ylSy2+CXKwtVED3vOEXyVYijRqnS0UTehmh
         CDWP1S5MECnKCagxkiWgJfyzlrXgsgcsHlO3tNb6wGKuugdA0K6PCg+3gMyPbAYzHtxE
         oBEg==
X-Forwarded-Encrypted: i=1; AKwUvBzxTHezvMoEtzQRBSJJTvUdaY/l5MT5JDwZiwgjO3fNz0YqZpp4CDOKqsAR7ZzeqBGYooW/HMprbNvNj1co@vger.kernel.org
X-Gm-Message-State: AFq9FYKeOBGz16+J0Krfp+Up/IXOLH5BciIhvRwQDufcGH7yaFpXE4s1
	F2Qq6dRxKzm0skOC4UJDcC8BZsNmJ97c3h53k3GdRy5cdwDYVYMUat7rBXCCxm4bmeu90RONWaf
	Qvan2n+fXwpTuipKZneonHomnCaEIdJU=
X-Gm-Gg: AYBFou1zuSsAMQKjfAs7C4eHj5znyGHjmWhpWXSEUkJRz8/S/j5Qxgcux9SbZPN3AEz
	cRfViGoplFSWfvjZsdba+3Vz/BQ4ZPvY1xCMTr7LYBm0fOsUKTDx0eyhEzK4cidzuW6DIcGTWpE
	pfV3n0deXPZbg7ykHwLaqO09EKS3XEPqhq7LXSpTs1mZXE+llfXiJFg2I5jb4gSTxDHupQleOM4
	3mEdyCrR3YWhFr4zjxn+PpHKG+YDRBNk5kIgN+fOP7hKg1DFqE5wnPMLKH8y7LM1HU5lWbaCfec
	QAWgw2tEAvHHFierlRxm3sbCRhYVLTdz380xNdYb7m1yPKvfoDCyak3y
X-Received: by 2002:a05:6402:380a:b0:6ac:bd84:2b84 with SMTP id
 4fb4d7f45d1cf-6acbd843b1fmr1090820a12.34.1790691315590; Tue, 29 Sep 2026
 07:15:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928213155.2612039-1-krisman@suse.de> <20260928213155.2612039-5-krisman@suse.de>
In-Reply-To: <20260928213155.2612039-5-krisman@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Sep 2026 16:15:04 +0200
X-Gm-Features: AclHuK8ytKjl4O38jVPReRqXBMm8kcLwbRELyjNeXdrdxLC7F0LMOcN0dvJ9ryk
Message-ID: <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, Hugh Dickins <hughd@google.com>, 
	Daniel Tang <danielzgtg.opensource@gmail.com>, linux-ext4@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-mm@kvack.org, 
	Chuck Lever <cel@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 11:32=E2=80=AFPM Gabriel Krisman Bertazi
<krisman@suse.de> wrote:
>
> This patch reproduces the same interface from ext4/f2fs to have feature
> parity, so users don't need to rely on parsing dmesg or trying +F on a
> temporary directory just to check for support.  Note there is no
> encoding_flags file, as none are supported by ovl.
>

Gabriel,

I am not ok with this API.
It is wrong in several ways.
It is not generic, we have already file_getattr() to get casefold status.
There was a suggestion by Pali [1] to get the supported xflags - statx styl=
e,
which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.
In Chuck's v2 [2] FILEATTR_CASEFOLD_TYPE was already suggested
as an extension to file_getattr(). I think we can still do that if we inclu=
de
proper versioning in the casefold type.

TBH, I don't think anyone requested this - you only mentioned
the need to know if tmpfs was mounted with casefold on and that
doesn't mean that etx4/ovl patches are justified, but ext4 can decide
for themselves.

The point is that this sysfs is not going to be the standard for all the
fs that can return the FS_XFLAG_CASEFOLD, so I see no reason
to add this sysfs interface to ovl.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@kerne=
l.org/
[2] https://lore.kernel.org/linux-fsdevel/20251211152116.480799-2-cel@kerne=
l.org/
