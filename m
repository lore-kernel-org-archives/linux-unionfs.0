Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793271808;
	b=KMM20ZhAosMgR02f4iGut41eIoOfhYjnhnYFg9LJXNZqwOROo7CpBZDzwnezjY3I1ALX
	 KgjmMA/6bkFtI3ADeDZL/3+Sw32QZfIdQQIgVizyH50NXM1LJRl4U3fhADflkD606iA7Z
	 E5QFbffJNh9RSnjBxHYXdfMjiDCj0jXz9ZUEl1D5dFbILdkTzA6fHj3ITAoCb0Ibfui5A
	 a39hlKB0zoV1dZ4DbqyRn+uVSsSrqB+GfJ4Z/J20YhB8ClwoVpjPfNz4Gwmbx7eZoXbA2
	 nGUCnYUEmt5c04cxjJ7gREt5Cty4lD5yqV2CabCL6MlwZKI8EecQOYR4nE8w16qk/2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793271808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+oFxDAll8dGtyrd+E10y47gRwGYiWN3UeaM2jcZ9GXw=;
	b=q1/4qBkrkIvgw9UuOYtnqa7oqnCAUuDbk/tN9vz2+jVroADtl+YBF4cHsy5/Wz+T8Ki9
	 21IK9g/YfmLFFbk0VcEUoE+ad6KoBymSosEnLAAm4NzNqgavhXockLTb8TgzhwFycsGhH
	 kqG+eRgV3JgO9g20W9bUgIBVhqoBLDu9PWpUqFZ6dQV3JhE2wX9z+e8/uKrYUbehLcIVZ
	 0UeyE20ZF5pnd1P+tsj2yEsiK9aGV2l72ECobIhpf4LKr90Ibjbc3ZXDuB76VF5oSpVqX
	 r26NXmHpennfIoF+i9Ns6AXfFxv+Cx9JWN64fGlIWMUPzv+J7PWCfF/Iy74AHkR/c0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XAmXfFyx;
	arc=fail smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE42606A31D
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 11:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FE42606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XAmXfFyx
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso2453142a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 04:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793271807; cv=none;
        d=google.com; s=arc-20260327;
        b=dD55jOaVzIc9K1YPIqFzZ7qLDUqal8DGTrgO7CaYNQRH0ucDW+9qdPDJxQL8TwhoIw
         rMxDKDwEB6m0u2JgzyXoA2Th3qqgx2Urf6HLuHqWQAJg/6gCBOrJ4Gm39OpMjkM7vfOJ
         dqJyxpkyLUHxpI0dFgcGW2MskOBub3GYPOUFbq90WrQZjjLozvA+pTLJASlSc7wK5iPR
         A6hveCl7a7zpKeRpoX79EL4CgLkgWFwdVnIDCQ+pvXFgXXs98OL8DgqAOlvky9+HY5DY
         ahyYxKqSDjRc8tTMfjLGY83oNRYXUW0PoiF1yjwqaPqwsVfYxeKTUJh/ddkLCPjRRnwd
         U3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+oFxDAll8dGtyrd+E10y47gRwGYiWN3UeaM2jcZ9GXw=;
        fh=b1hZRVouzWUVFcEkn6A7Ub2gxGPJI87/b+n+zXZNQB4=;
        b=hqqRTxZcNSYPlcY6oquSDvFIvr/6F+ER14RoOfg3X5MHK9NGYK2OKay4sAMCWDOxbP
         J4uCdr/jVHZZ7r3iWCWFAIw/FTh6nXQyLOaspqOdEWojNKCat/55dr1ozQzTMHSp/gPL
         AzsC5JZfgbSbLFoUHnzyFwPRAB3tZJ+rAF7e4TrbvsrqSX5pZHJenH5nsSDvzaWhfhZ9
         t5gbxQtujWBoPldNwEA2Yj4BZZcDg9zIVBsYe2BKssrx5r/cLItn+sBBwMcAupEuYIXb
         OHsN7R6eF6n+kz7RLYl1pc+tRp3wowSmJVaoLJxKs9oLPIbRuHA+kqVU98i5Am2yay7w
         MdCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793271807; x=1793876607; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+oFxDAll8dGtyrd+E10y47gRwGYiWN3UeaM2jcZ9GXw=;
        b=XAmXfFyxR37ur5ieYkpUjtc0G8B7XfPmNN/QJVLMm40nz0G3ycyjyEIPX5tjlf59il
         CMGtoROgxaFWYpUVFtqBpQDXWF1CsXLq+YWIoYLDA0ssMCFszt51ULbe/IWEYIFWg+Jo
         wePXQyzQIx1rz/BHtW0ZJjKH28dy6w1RgznDWiXhbKjdwaVbeVDt2iYCTqZzqf5IKows
         udP5s/lqTK7Zj/ZnB2Eozd+J+NE4iBmFlcY7jskXteh+vNhjd9YO5jz3M5dvrhRH4TUk
         aGo418N0Lq/giIhsVKwF6I+PbWa84+LNxtGwB5VavIQgheX3c9hpH2FaguMfjlY1Nx+k
         q8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793271807; x=1793876607;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+oFxDAll8dGtyrd+E10y47gRwGYiWN3UeaM2jcZ9GXw=;
        b=ZY9Bo91GANAR0ImO0shrnWBivhLByD9UrkCK6/nDBLtiockmyUi6/0X3KREi7Kd3vC
         z7qM73cl37COgfo/TUGlAsXOFeG1YTgrd2JdRzdyyBS1S8L3gIhhoC3NU+SOX7dw28DK
         27w81ESYEDdZCeViFh0YJ1Bs2IhxKzsyaAZ+lSCs37m/Ke9ewuWWBX3Qaxsnw4RWOVxq
         396pNIRDmjaj+lHGgV+T36PQY7HLE/frCaEpLlK86flJX/+ljfghVCDBAhcAPAkTdhn/
         Li1BC3p2Nu1cHwh9z1Oj2z4TiGV0FMF0A7a1orUrq8yOd/aXU38XrqPWMRbAAMwsG6PP
         aLCQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZxqScD6cuw5vvvjdZFKsb3fswO6hiynK99qSn3lZe7ZjJziVYjjOxddTW41WOfgpvfJG1rEmnJ62xMsNx@vger.kernel.org
X-Gm-Message-State: AFq9FYLm699CBCYAAZKa4o7QMurPPis8KcwVxpftGr90pDSq7OgmWuBV
	d49CneqM6gpoAUj8DlY6sW13M7pWU5yI3USpbRhMs5byex835FMn8QtOmXXVxpO0Ebp0Q1Ce7+J
	D/Kr1gIw14sCLibieZSrGxO7p20Q0Xl0=
X-Gm-Gg: AYBFou15iMEkgB8kOlTSrD0MUD8jHTc1anOvarMGXE14EXk2tm81artcLUMZdj63jng
	+Tlozm9beaVAhUbvpLSI+FedEqGSzw+pXxFAmGi0puNLWScLUduQJH/ftG0SqFl27O3FinleASH
	B1KTcGnX9huTWItSQoRInnMFOJptEw97CZ8MVOF4shhv7OMd1jLUIAYjnB0hN1Ak216HJV3LVs/
	H3D9Ru4Jh04WuB0Ls0QyFCEneNao5kguQwvN29GStF4pO47/e9rq9RaE+Bk1kQmxiMXr3ziANIu
	55mjInuQy3IYI6cc/6O16GiAl2v+Koz+rrgTh9AcDuEoQcQHBSwEdfqhKKbH6DKrW3OOrWUWaXz
	tpxFLj6dJGtSOIxPYcRFKo5OO8+660lgkVFwxhURbpXKCIdnotk34q7XuOSR1Nu07BQaQ0Q==
X-Received: by 2002:a05:6402:34a:b0:6b4:1037:2bb1 with SMTP id
 4fb4d7f45d1cf-6b49cbe7cedmr2797089a12.22.1793271806191; Thu, 29 Oct 2026
 04:03:26 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028154008.67451-1-dennylin0707@gmail.com>
In-Reply-To: <20261028154008.67451-1-dennylin0707@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Oct 2026 12:03:13 +0100
X-Gm-Features: AclHuK_jPOxWwcTntrGiyWxXQmQ4_F2fFzrd1WHf0WA2kaDI5_4JgryUKHV6fdI
Message-ID: <CAOQ4uxgDmhddqpFawaK874cfWCp4jVDnE67eqXyDA9eumpMEpg@mail.gmail.com>
Subject: Re: [PATCH] ovl: restrict casefold consistency checks to directories
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: miklos@szeredi.hu, andrealmeid@igalia.com, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 4:40=E2=80=AFPM Hungyu Lin <dennylin0707@gmail.com>=
 wrote:
>
> ovl_lookup_single() compares every positive child's casefold flag with
> that of the overlay. On casefolded ext4, regular files do not inherit
> the casefold flag from their parent directory. Looking up an existing
> regular file on a casefolded overlay therefore fails with EREMOTE.
> Symlinks, FIFOs and whiteouts are rejected by the same check.
>
> Restrict the child consistency check to directories, along with the
> corresponding assertion in ovl_get_inode(). This allows nondirectory
> objects to be looked up without rejecting them or warning about their
> flags, while directories with inconsistent casefold settings are still
> rejected.
>
> Fixes: 16754d61dc69 ("ovl: Support mounting case-insensitive enabled laye=
rs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  fs/overlayfs/inode.c | 2 +-
>  fs/overlayfs/namei.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 63906b3dafcb..4428c50c3185 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -1278,7 +1278,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
>         }
>         ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
>         ovl_inode_init(inode, oip, ino, fsid);
> -       WARN_ON_ONCE(!!IS_CASEFOLDED(inode) !=3D ofs->casefold);
> +       WARN_ON_ONCE(is_dir && !!IS_CASEFOLDED(inode) !=3D ofs->casefold)=
;
>
>         if (upperdentry && ovl_is_impuredir(sb, upperdentry))
>                 ovl_set_flag(OVL_IMPURE, inode);
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..023966d89f74 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -266,7 +266,7 @@ static int ovl_lookup_single(struct dentry *base, str=
uct ovl_lookup_data *d,
>                 goto out_err;
>         }
>
> -       if (ofs->casefold !=3D ovl_dentry_casefolded(this)) {
> +       if (d_is_dir(this) && ofs->casefold !=3D ovl_dentry_casefolded(th=
is)) {
>                 warn =3D "child wrong casefold";
>                 err =3D -EREMOTE;
>                 goto out_warn;
> --
> 2.43.0
>

Applied to ovl-fixes.

Hungyu,

Thank you for the overlayfs patches.

I see that you are sending patches to several subsystem, so I assume that y=
ou
do not have any specific interest in overlayfs casefold issues particularly=
?

I am asking because I got some patches for overlayfs casefold which I do no=
t
prioritize because I do not know how widely the feature is really in use.

If you are interested in reviewing or testing said patches, let me know
and I will send them to you.

Thanks,
Amir.
