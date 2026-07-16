Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091CF3F1AA6
	for <linux-unionfs@vger.kernel.org>; Thu, 16 Jul 2026 09:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195653; cv=pass; b=t6xQycVQHz8r9RgFRJy3P4QIXbzcXt60t5kjOA5TlDQ35F5jUsrTYIcsOCQz76UUSNmW0g63wVk1J+L9Lyf/WJdk03KwCDYV/77eZr9sFThIO1DIW4MU68oalqhq6CVNczxaK+1mXtQt/3OsdhN7Ii0ngQwK7QDw/QXHk05VzjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195653; c=relaxed/simple;
	bh=7L8oIlIG3rf4WDazhnd/H7jHQ5h7vpxRD/uz7HCetnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWvgzorbLL0w7Jw/5eaL4uYv7HULdSyRnyaZk3dDKUTE75Xgih0L/7WSrvc0iaGhifCp0+Ex4Wua4wQWdELt/DcUpu518qvg3d15uH/2fvVnZqbX6yXxnnGHDcXELDWftB+CZOtJ9jfGug97bmirLCooFZyQMnk7BYiGFtK5h8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GaYHEdTh; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaYHEdTh"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6976b0c5adbso13376366a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Jul 2026 02:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784195650; cv=none;
        d=google.com; s=arc-20260327;
        b=aVgq06zwRTeMN9QKTrjqvZ89VAjc60kVl/qvEl7TLH1xDtwV1suSJ+SHbNBlpsYJIn
         duEEukchzuE/GpJj/x4v7xDoc2WqCsWLihs6bdhqY1SBJbWATeLbth6vRrnPj6Skp+9R
         4IelVsM+NyM03Tfx78HgNu6OqCstOKBSEx0dsaXQInpHeFDTHA4GUfieLH4SWiCQacjj
         9aiEK8nzDgQ/UO7ZGHcZNXRHOr6LezTBNdlELBGQ657XG7U2K8Ed12E+dsj8zJXJUYXd
         uP4aM8vk8mhTl35/rlmPFCE6PMlrWbw0jUv050AP9zZP4b7Yd2YseHhwbqz79DL9fTdN
         iz2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Dja3c4miyO18wybLh+8+ev1hbutgDwS8v/XSKA2LxPU=;
        fh=GlVgun4FG1/N6/u7IHBzTqHTxnW3y/HvznRaaqeo+xM=;
        b=rq+byerEEoSHA6iiN5YfEtSKt40b0dHd2cBHMxctdMX6VVW+QEztYb9jx7U8XvL2ZI
         d8zjso/H0LI5q1JK2FSu6jxCwPK8zj9KKdEAu5c5SiZVIVh3WkQlvjikLasRDvlFaCSt
         grCZ2u1v3fq/ntO55XrGCWxVraMs0yzImdcwEEOh9ySBOjpJE2bF4+R3A0LWIRnul1+p
         5q6WjZ+vpF2SySbWHdMpYEVGKONYh3C1kmCZc+nTNiMcEpRzGWSpwe8FepADQPXovPEk
         kjfi/r8c9HzwvKKWLbYZUd9VxknLdVaqUj8m7P9pxk7PPPgZswePoHmR/tEEThXVMOqB
         6jPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784195650; x=1784800450; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dja3c4miyO18wybLh+8+ev1hbutgDwS8v/XSKA2LxPU=;
        b=GaYHEdThr2KjAjOdDyuhg5Ng6XA6XPhZRexc96lxiVyOzcULHIsDMR8PKEmC0+4AEq
         Ljw8iAuTpomaCSzTG62lVBRK3M2KVzTRWt9CctJxiGtfi8r3RkyoUQku99jDJfbRVE0E
         37qvqjlU3eB4jCLYqqk6zfhGZC1+D9qoSjv1JHrPnVXPaBvjTcDvarRWhtTFlA40q6OB
         W2JdJZZk/7FXKcJk9VGrv0bIDbwwFo/+JwnBV+Mp/r2lxCsEKU5LWDc0yC7IThCx5CII
         RzirKWuE601P3ORG9wvBBpRajH5EOUbhsnnvz2nXSE485ufEg/ej60zARfh81LIx6cTW
         cBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784195650; x=1784800450;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dja3c4miyO18wybLh+8+ev1hbutgDwS8v/XSKA2LxPU=;
        b=dAzVYcLwKgoDZ91wMJumcykIsSOx839ZmxEgLapfi+EiFVKpR9XA1auxFZvqzyoYEl
         bZ4LZlJbNGxJjCgYZGH4s2FwjLEUp16CW/Qqf7H5/Gb1KttpZc6D1ufCltNWSI6GZ0fJ
         Q0Qlq8wMoHXEFtKBiO1MZbkbUzrxvRefqPsHhjBbqiH5isOcSmG/J05gMfir+7k+6KAj
         5sfHbDXlX0hNWhSwuY9ibf0YMCma5AMkh8mralH0FFQ20mVE1sssFIaz723VM9XcClML
         CoYZ91XCEOdZ6rme1rymCATm4lJUiz6onzX28vJ9Yqu2uvP+DQBKMSPX4DeuHnaZBpIz
         r2pg==
X-Forwarded-Encrypted: i=1; AHgh+Rq3yPo84LSxvmDtDX1T4xzd2KMmcgbmIqSMQq+SMj+IvUgJHQ4H7biW3Cm9TF8PZgaOLNJfrb5K2v32ztmE@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnsflw8Dek/uozqnAf2CyTtLQF4TabGtZlETwY5VRjZfWVqwky
	nlRUncbz0RjaWiwugs/2huEbIYeAOqdAkXNL1qHSMgzVW8ASv2U03wVUbIJQRd4Mvi+zG5+t4GK
	YWXx0ccM8hV+Wlxr9dhhFOB9frnk3q1A=
X-Gm-Gg: AfdE7clsic9e2bxvne+Id9xm2ZNfS6Sn/md8JSe6t4W+qzq3kAUXWPQ8MBadIhJIsiY
	T+h6kPc7ZmlNiTOpo1JVtgIGNcWKIrYnmwOyAQf9sQJDSxf0NYVH0gp4zdSGtQTULy7dv2HMd7M
	AQbS/M83AQns6IGZOScUCeSPJfxieOG1kNjj/dn+q1vj+12+P4Py0fhOrI6SfQ3uFN+RG9wdmbl
	tWC7ZmvBe3JD1+yAMDse5f7z9ZDT83BRm94WkgN6BHPZE7vCWd6AVGMxQPbdceke49tftB1eQ==
X-Received: by 2002:a05:6402:524a:b0:698:b60b:aac2 with SMTP id
 4fb4d7f45d1cf-69cd6c5e68amr5803177a12.4.1784195649954; Thu, 16 Jul 2026
 02:54:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716-overlayfs-rst-update-v2-1-ba25393ea7a3@teledyne.com>
In-Reply-To: <20260716-overlayfs-rst-update-v2-1-ba25393ea7a3@teledyne.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 16 Jul 2026 11:53:57 +0200
X-Gm-Features: AUfX_mxljFG1PQ75khiigBYEM4d9sOeUExffSBXjeTfV6o_GpeesgVl0GqmqzLA
Message-ID: <CAOQ4uxj66enKg9jK9gZtqTCxLOSHD1i1Yj8b0Fs+jv+SN4UApw@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs.rst: remove mention of workdir needing to be empty
To: jesse.vangavere@teledyne.com, Jonathan Corbet <corbet@lwn.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Shuah Khan <skhan@linuxfoundation.org>, 
	linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 8:23=E2=80=AFAM Jesse Van Gavere via B4 Relay
<devnull+jesse.vangavere.teledyne.com@kernel.org> wrote:
>
> From: Jesse Van Gavere <jesse.vangavere@teledyne.com>
>
> This requirement has not been true since v4.8 when automatic cleanup was
> added in commit eea2fb4851e9 ("ovl: proper cleanup of workdir")
>
> Signed-off-by: Jesse Van Gavere <jesse.vangavere@teledyne.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Jon,

Can you please pick this one?

Thanks,
Amir.

> ---
> Changes in v2:
> - Handle remark from Amir Goldstein to drop workdir cleanup reference
> - Link to v1: https://patch.msgid.link/20260715-overlayfs-rst-update-v1-1=
-70625a67880e@teledyne.com
>
> To: Miklos Szeredi <miklos@szeredi.hu>
> To: Amir Goldstein <amir73il@gmail.com>
> To: Jonathan Corbet <corbet@lwn.net>
> To: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/filesystems/overlayfs.rst | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index eb846518e6ac..ba41c0694e62 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -123,8 +123,7 @@ At mount time, the two directories given as mount opt=
ions "lowerdir" and
>    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,\
>    workdir=3D/work /merged
>
> -The "workdir" needs to be an empty directory on the same filesystem
> -as upperdir.
> +The "workdir" needs to be a directory on the same filesystem as upperdir=
.
>
>  Then whenever a lookup is requested in such a merged directory, the
>  lookup is performed in each actual directory and the combined result
>
> ---
> base-commit: 58717b2a1365d06c8c64b72aa948541b53fe31eb
> change-id: 20260715-overlayfs-rst-update-750d58792f79
>
> Best regards,
> --
> Jesse Van Gavere <jesse.vangavere@teledyne.com>
>
>
