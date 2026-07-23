Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09033C9EE5
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 13:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811939; cv=pass; b=flBh6wxVGySRXPJl67gYl2IHlSkSaNQtgDKcgi2TShpIkCofQNqg/Wn8VDWTyHrPDMI+qEQ80wjHuUlvLT4nfvMgPi82RTJkeDTzusoi+l7ja1g5IM5kxQxgXMfFnqmEhyHpZg6xmuApHwZDy7l5V5IA2Pk9NQ6I76ekPJX8qwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811939; c=relaxed/simple;
	bh=/4fm2fLiIiNTAePr7znlAXofmEYIJW/1wI/ZsofAPsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ua/v1mxRngaFwuQtN/V8sk/eHy2W+FbfArhAOnpQj3C30mJxmiUT1nstjWB4Znbg7r2lcXHkn6RpzkDtooLLU12GhvCaEJ//zxO2LyjB+kCUSgdbnSfmF19kf48Omm+Yid7duar7algqDBofkfc9yycUBfXdsPk1E2oYlRLe7ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csiIwXKk; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csiIwXKk"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9ecb1e13bso236506a34.2
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 06:05:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784811927; cv=none;
        d=google.com; s=arc-20260327;
        b=onuFUXhJW24bYiFiR+0/wYLyPwy4hHyTMYwKJX3A6ofUrqCyM/p3Rp5WgNaMJHndKv
         0GOqj5n9DPD1xphofPoJ6wY80Dwxz29V9TXIagFUzTVkqbYLuYowUS3kRvQ4UTX0rGvS
         36nco3tX7RkFxGV2/MdnRhxlflAzVZQBS8+qElv+xZd8XTQj3z7kmnnVGyvBd41MxTKl
         albABltPLlG9iMVBbp7AJj42BGs7Z60/a9iBF7Q68ocVYTG3OTSQgNcuS2jlGUCtblqD
         E7kNzeU61WWXLB9tNaKFHbohCYfV6eeioaAIQee8Ayn7PDz4upKjwy2QXD9fqglxYLV+
         Vgpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4C5V4EO0BxW93DEU9+ggAWGxFKYimvpCcl5jO1xW0aI=;
        fh=PclzjtpixC+xAqDpmKs39mmavkisJDjGXWxcRCabIpw=;
        b=kmoosmEKI5Sky0hL5HRCxIt88IKbJSnyXo4XQSTesTGgHHlB03pZ6RAToWMllHJcj9
         HyE+hbe6Cy349NThhiLMs0yDhMRoKlMO3E6EvbbiKFOB7sEZLsnEZHoNgdMR6/8iu9Zf
         2FlGi4erhkp/lHcZ50KcfOORXiPVaUbCUIH8MTELAtXkt9QjDhzJBMgHeu2hNhPoAZ0g
         NhVLvs1cqXxHPtgu7cCe8QZAkb/y5q919c8P66gn4FgBst2QS8pKtuzMkgdbPbo6PRYe
         3mFijGCWKTytyPvQh/Szy5S/ZGhq7iYJ6QkA5hsaIRxcHF5iqjbYmRk9DVOr/h2W1LAD
         4U8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784811927; x=1785416727; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4C5V4EO0BxW93DEU9+ggAWGxFKYimvpCcl5jO1xW0aI=;
        b=csiIwXKkXi6LFxNkJ/xf61FFnm9hsYvdyBHc7AFnWJwkr0rxMiVLEDntltigSaUc4X
         NnB/Lp7Sy/KzmV8s1ZhZaSAYlR8Cr7wqZTJzbQk1gLItWv1vcLKHNH9y5cHR7lFvY8i9
         eZ1mzXg/xQWj7wy1uGD+r8aBsaPsg9o2DlfSic0Em06kmFup+NsCA3co7JveVcSYxpCT
         0SoNu5uvR/2ClhaqfkG1DWXdkuXXhwIRzTlZq6YWAVseilLp4q5YJYQCH0iw/6EuNxt3
         5Tgj8x4y29hwVlcbkLCLiB2bDEi6U2Kh/qnlyWXun9u8uEqFRT0DlXB3GlEtcQyM89YY
         OYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811927; x=1785416727;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4C5V4EO0BxW93DEU9+ggAWGxFKYimvpCcl5jO1xW0aI=;
        b=HgFaq4v1o1fnu3FWBY9y9URsvacz+pBF3yF9bR7UBUNJirvfmZjg0tzCTbyCWJOXrX
         6VUlSkDci2S+Z9LB4nO8nMpEt1j69LQG2RK4T1m5moq5otrF4iGzUWSpRB6KQ7+vo2lE
         +Dhu6iOn0F8sdpFvN4YtYrCRkk99oRRFqn6cJcPKjeIYS4/Hu5yOj5S04Ag8KOvtvCG2
         QSs0NXxFLhjhnKTVplG/OlzRy+nIA3X11pYB7RuPiRCiQFcTuxP/eqwvF6NYS3A5RWIn
         PRvBD7XPAZXU2WfFFWJ4wx+Xk+KpARcrPlNbG0jFAnmyr1CH4qgxuiit6eQlbKdOYpZx
         W8aw==
X-Forwarded-Encrypted: i=1; AHgh+RrJ4EekALRy2Cj6HWACE/8+19QK/1w0nzrPefr9a/b7a44Ptm64p5WnthrRTFGuD/pW/uB6T4B7MDHYH7zl@vger.kernel.org
X-Gm-Message-State: AOJu0YwHrhH8rLRuvAaJ5M79naPEt4n+lIXZNYzDxcet7pXn/DrWOKZy
	3VJfCEft4qyg3n5GPZnloWwKblhZmkpcx9i2kseQiX3gMtlWl87P/RDhcU62BhBTqZhXD6MVaVU
	H0vCPncdzNjuWA15UwS7P5yUJ54gOIlo=
X-Gm-Gg: AR+sD11g0ug2RenLWEyNc2qHXn3L+K/IHbXuO9+zGWcVunXVthYDC+Cmwx84izhidtS
	g6SwpWpJJm7H5BeEuOd+jqBm6Ra6O/zDBjmgzsrR6XjVGVZyK8QEeNEtChmWfwJRdoFaPGmIcXD
	kyB+BTviwdDJDoxm0fTV/Y1umTV4+fljnamiPIlQKzxZaczTpfDjH1Atcv82vinRrDKjz+zds+T
	S2VBP2xl0EtI/08czupMH941WGr3ZzGd9mb3eSDXVQ45UFgUGF0WAUHfWAoR058ng59npseaasK
	Pam0cKziPIGMcHW9vOg1KyeGX+7lLPLDiCcDtd/1Kg+t/LjXcPYuv+pmEJGSUZvkW3VRhAVVzTc
	TNQ==
X-Received: by 2002:a05:6830:4182:b0:7e9:b4d0:53a9 with SMTP id
 46e09a7af769-7ee44209175mr1579151a34.26.1784811927392; Thu, 23 Jul 2026
 06:05:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723114848.1212429-1-amir73il@gmail.com>
In-Reply-To: <20260723114848.1212429-1-amir73il@gmail.com>
From: Daan De Meyer <daan.j.demeyer@gmail.com>
Date: Thu, 23 Jul 2026 15:05:16 +0200
X-Gm-Features: AUfX_myEei0bzutzXlBHitMsWfFiaQmYM0otuAjagzJ4Rt_DGQ5CK8JsnPe63ok
Message-ID: <CAO8sHcn=b94SL6KTfPtnqau++-g9CXD0LOpPjp4L+b9cu8mMSQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Proposal for Cross-fs copy_file_range()
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Amir,

I tested the series on top of f6cde11eb46e and cherry-picked these
selftests:

https://github.com/daandemeyer/vfs/commit/0b0e47d408311fe2b4a3e1711656f836b56e10f4

All four tests failed.

The accounting test reports two reads and writes, and 128 KiB
accounted in each direction, for one 64 KiB copy. The outer and
recursive backing-file VFS calls both account the operation.

The credential test fails with EPERM. The explicit source check uses
the source mount credentials, but the recursive VFS call checks the
real source again while the destination mount credentials are active.

The permission-order test times out because the real source
FAN_ACCESS_PERM event happens after the destination inode has been
locked. The process handling the event cannot update the destination
while the copy is waiting for its response.

Finally, denying that permission event still clears the destination's
setuid and setgid bits. ovl_copyfile() removes them before checking
permission on the real source.

It looks like the root cause is that OverlayFS-to-OverlayFS is
classified as FS_COPY_SAME_FS before the FOP_CROSS_FS_COPY checks.
That leaves it on the existing recursive VFS path, so these issues
remain even with the series applied.

My (admittedly much larger) patch set does pass all of these selftests
by moving most of
the authorization checks out of overlayfs and into vfs and can be found here:
https://github.com/linux-fsdevel/vfs/compare/vfs.base...daandemeyer:vfs:push-zolnnszvmkry
for those interested in taking a look. Happy to post it directly to
the list as an RFC if that's
preferred over a github link. That patch set also lays a foundation
for cross sb copy_file_range()
but I opted to not post those patches yet so we can figure out how we
want to deal with the above
issues first.

Cheers,
Daan


On Thu, 23 Jul 2026 at 13:48, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi all,
>
> Daan De Meyer requested a way to do copy_file_range() from overlayfs
> to/from another fs, where if that fs is the base fs of overlayfs layer
> the copy could be an efficient clone.
>
> TBH, he also requested support also for cross-fs clone_file_range(),
> but I am not happy about providing that.
>
> copy_file_range() already supports cross-sb efficient copy (e.g. with
> NFS/SMB server-side copy).
>
> The current limitation of staying on the same fstype is mainly an
> internal technical limitation (choosing the right f_op), which is
> something that this RFC is trying to address.
>
> The overlayfs implementation itself is pretty trivial.
>
> Thanks,
> Amir.
>
>
> Amir Goldstein (5):
>   fs: clarify cross-sb copy_file_range() code
>   fs: add support for copy file range from another fs
>   fs: add support for copy file range to another fs
>   ovl: add support for copy file range from another fs
>   ovl: add support for copy file range to another fs
>
>  fs/overlayfs/file.c      |  35 ++++++++++++
>  fs/overlayfs/ovl_entry.h |   7 ++-
>  fs/read_write.c          | 119 ++++++++++++++++++++++++++++-----------
>  include/linux/fs.h       |   2 +
>  4 files changed, 130 insertions(+), 33 deletions(-)
>
> --
> 2.54.0
>
