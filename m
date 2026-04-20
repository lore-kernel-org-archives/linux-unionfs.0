Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B552D8DB0
	for <linux-unionfs@vger.kernel.org>; Mon, 20 Apr 2026 06:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776666678; cv=pass; b=AA3fdOuZfxstekARQRp/qiA43aIvhAoefjZsCVVsBdA8q8ydtnk0hxmdd4b076bfP4WMwufi5sowo21mksDdUS03zFgG2o59L9WNsVVTJTHcEngquSddfRTjNbKHIWiUZmb5dfrengll+DuktD8u9PfwmRj4wYsttC9Bl64WuZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776666678; c=relaxed/simple;
	bh=oWdHSX0eVcAgY4PHQuy8lYwoogzXG2T9LHnjRsCPmEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jdIvDumNdZJa6TWj+hUGQOP4/9tOR6Vetit9pkq/xhriayzVb02ZLzRxQ8sb/gHAjKhmvEJsA1BGowizr8BTrwxIzyHimp4F4s7I4Inih/hA8Xpw8861TuUVKG8C59+3vfTbory4nf4Dxx8XpwsVIQwSrEsZPSVWcKun4aOGqYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LVKASRqA; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LVKASRqA"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d6b393d60so1252131cf.0
        for <linux-unionfs@vger.kernel.org>; Sun, 19 Apr 2026 23:31:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776666674; cv=none;
        d=google.com; s=arc-20240605;
        b=W2WH9plWIoF6/RwPowJzFMyUw0IL7WYpOABiAhCuP9ssF79K1jstIebiDC+msYp7tu
         2hfq5C1m8xneNOVb/DrW0HkOQilsPg5HfruinLv3XNz4u17xqVCYC/nqgszxMNdu/eaC
         2RO3Dqs+NLo4Ttuh7K0xeleT08Patlt7z0XNj02dKmJDgEy9CgMHIYNV9SyhNtVk4GEE
         nIGH+fchwh+20l+XenIO+gbdMAFzZXcd9k2cXrzX+lfkXKvBo9iH/ubL2g+IIRJ6nt7O
         6ji/1iYf/FDd8HWYITsVqZJtCdUKa7sdaixSZBE8iZBojDRjGaICewCDFfIqV82Xk6n/
         Hspw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oWdHSX0eVcAgY4PHQuy8lYwoogzXG2T9LHnjRsCPmEQ=;
        fh=ybyIdtK/ZDeNON0iWVWkRIeRLI/wnXszk4UTU+OdITs=;
        b=DCJi7jfh/4mBaLZziPj4Qmm/3tPpEVD6bi5Pt++srfRcD/KEeeU1ZYNO6QdyrVKvyc
         AiGVZCxcXAiKjLQBS8dSKeX3qq53GV5/V3Ao8zmPhmVxOYeYM7nvS4gLps61iqMx4CWh
         7XDiQEc0XRPh6oHIkS0yxRLj4iAmCUxDlRvhuR9XRjyBRdu8PK3Gp4Yhd8tQFtVs0Ep4
         Ursmg0cM+CuiBrUM1s9xXSmyct8Oam/5GZUHo914xJ9OJ7vLHyz/tK5CX9hdtr3tUfi3
         pKJmJomMbnoJEhMTpvLe3JspBJNTRlkN6JISVVc/S/JVv52bfLzElN3e6YyS0+Vf3qoV
         GAfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776666674; x=1777271474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWdHSX0eVcAgY4PHQuy8lYwoogzXG2T9LHnjRsCPmEQ=;
        b=LVKASRqAjkmZ993zw7TsQBz66QcHWIrlR+4jLYhyTEapGTgh5o4CUxBvb3Wduss/Mm
         BHWKMV7iWQ9X2Jm86GCMbHwhUSdQy4JrJJkO4jn2GXQHSCHGZ49uk1zbQ0neu9WNS991
         fXsPGT1kWf1PsA4FEdxNe6bMPNiFsCzl3ommh097g8YqDNul+Py7gDsCwq7ZVjBt8rGT
         HhLGRh7afaN95qJW5eANMEBD2nrJnIpnKD8+TWFJO7xk0o2kOfY6eszC8hNN9BAGzRqu
         +TPClF+5+FM3I35S6TMH8SbIz9k342NyQ49/5TVifSaHfe3PghqSxLkpinAzUrFCVu2w
         tJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776666674; x=1777271474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oWdHSX0eVcAgY4PHQuy8lYwoogzXG2T9LHnjRsCPmEQ=;
        b=P4ESKBvQTS9WZHdrkbIRxjWM90ETtcZ2phnGMlljLsW6CdjrtQOynQXgt3iHIb4Y1U
         36awJ5pUKAVXCUyqyJej+5LbJbExwHs0hp7laQ01z7Tr5cEya0I/ggLCdPjRbC5tJ+lt
         +SypshiNo8l4QHghTPy+bmemBFXIlxYHq526Q5akWCwt2IpsrMfdheDst0KxFKZBYacW
         ilx/p3guCve3oLlR/k+6KghS7RaDXpa7bGfahwPds2+iH8gKM8cKGvkUVt8KKSL63un9
         nbJlcpWf/jER6Xeho6wnO6aq/ZONfojAxMB6UMe3pw72D82XyIK0YsTYqd6kDlWuwMy0
         F3Eg==
X-Forwarded-Encrypted: i=1; AFNElJ9eM/ruBQJpLGGlDkRYel/mX3bD6wwaKoCBYD29YkcfZoUOrk5Kfge5rIvPJf2/Y+JUG/MJK5K22oZMHM1Y@vger.kernel.org
X-Gm-Message-State: AOJu0YzQo2dJJNVO+dssShCltzX4oFTzsOLoLvGKZO6xZ1x3s8rpmQZ8
	GKJMd7/N/a5p4WZLgIMKntM29I9BkDbdfJ2BQ281lc2h8TksgIo1kVzS8f/F57aYKT16L3LGwv/
	ZwhFQcmTEuFvoAke5EoBAB7ObcjlaSHldJTYWV2iQ
X-Gm-Gg: AeBDievSlC2NRrymZ3W4QIkpzB5Lg34lcFQaQXiBvEFDRUrn3A4pUqhZaEjyr4hBvnP
	Fl4S2GHZCxbTa3WfhsUYsRTMItCU3jxjoTlK+OYbZclUcE0x4AlTn4/IE2r2VKuIkhTWLVpz5uH
	oa+1DSJjqfpA2/0kxDqS7VIbMEy0DtVbR6StGV7zln2CIDaHZkBcYeGoSwFwyseZI4x9VjepfPU
	XhoZWN/3lHCSXJyWDnJAyYtd5wKKyFBWJT7OmghQQQlmkKlra7VvdkELgvilZ8d7prz6aEJBZz5
	4mAXVFQilckJZbrf9D2lgQOoxzmR
X-Received: by 2002:a05:622a:4a0b:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-50e441d1391mr22856791cf.15.1776666673848; Sun, 19 Apr 2026
 23:31:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHWLEDHfXZScF5jNDzgOxGXf-MBDcVNtqW0DbNz8Ra8rtcuL+w@mail.gmail.com>
 <CAOdxtTbwipkyAfDakLAB6aVp6YkPWtKpDdVDUTz88WDB-18HXQ@mail.gmail.com> <CAOQ4uxhUn6oCBuVJqZu+FcMx8XeAQHZbXFAGon4Xeg2SPLJW_A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhUn6oCBuVJqZu+FcMx8XeAQHZbXFAGon4Xeg2SPLJW_A@mail.gmail.com>
From: Chenglong Tang <chenglongtang@google.com>
Date: Sun, 19 Apr 2026 23:31:02 -0700
X-Gm-Features: AQROBzDX4AAYXOOslqCZs98JMxceUov0-GNl39rBWIuX_y_Te2pwHmhQJ7fdw3g
Message-ID: <CAOdxtTaWWu_7eJWu68zf28zHQP3Y--vXTfbGFsceO47BpN3qxA@mail.gmail.com>
Subject: Re: [REGRESSION] Return change in 6.12.80+ with volatile mounting
To: Amir Goldstein <amir73il@gmail.com>
Cc: Derek Taylor <ddtaylor@google.com>, stable@vger.kernel.org, 
	regressions@lists.linux.dev, Kevin Berry <kpberry@google.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Amir,

Thanks for looking into this! To answer your questions:

1. Production vs. Test Suite Impact

The immediate failure we encountered is in containerd's integration
test suite (TestImageVolumeCheckVolatileOption). The test explicitly
reads /proc/mounts and expects the exact string "volatile".

In default production, containerd passes the legacy "volatile" string
to the mount syscall, which your patch correctly handles under the
hood. So the standard "happy path" is not broken in production.

2. The purpose of WithTempMount() / RemoveVolatileOption

Containerd regularly makes temporary overlay mounts (e.g., for
unpacking layers). Because overlayfs rejects reusing upper/work dirs
from a volatile mount, containerd uses RemoveVolatileOption to strip
the volatile flag before these temporary mounts.

Currently, containerd's RemoveVolatileOption does an exact string
match for "volatile". While it works for the default path, there is a
production edge case: if a user explicitly configures their container
runtime to use the new "fsync=3Dvolatile" option, older containerd
binaries will fail to strip it, and the temporary mounts will be
rejected by the kernel.

Conclusion

While containerd could theoretically patch their code to accept
strings.Contains() or fsync=3Dvolatile going forward, there are many
existing containerd binaries in the wild. Given that this patch breaks
containerd's CI tests and introduces an edge case for
RemoveVolatileOption, it might be safest to fix ovl_show_options in
the kernel to continue outputting the legacy "volatile" string to
strictly guarantee backwards compatibility with userspace.

Thanks,
Chenglong

On Sat, Apr 18, 2026 at 8:40=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, Apr 18, 2026 at 1:33=E2=80=AFAM Chenglong Tang <chenglongtang@goo=
gle.com> wrote:
> >
> > CC Amir,
> >
> > For example, containerd 2.2.0 uses `volatile` instead of `fsync=3Dvolat=
ile`:
> > https://github.com/containerd/containerd/blob/main/core/mount/temp.go#L=
91C1-L92C1
> >
> > On Fri, Apr 17, 2026 at 3:41=E2=80=AFPM Derek Taylor <ddtaylor@google.c=
om> wrote:
> > >
> > > This change seems to have so far affected at least containerd in an
> > > issue reported here
> > > https://github.com/containerd/containerd/issues/13250.
> > >
> > > In stable versions 6.12.80+, commit
> > > 6c0cfbe020c0fcd2a544fcd2931fbc366ee3cd12 with the specific change
> > > being:
> > > [*] The mount option "volatile" is an alias to "fsync=3Dvolatile".
> > > In this scenario, code relying on checking "volatile" will now fail
> > > due to the return being "fsync=3Dvolatile".
> > >
> > > #regzbot introduced:v6.12.80
>
> Hi Chenglong,
>
> Thanks for the report.
>
> Is this problem in production containerd or in a test suite?
> I did not understand the purpose of WithTempMount().
>
> Is it possible to fix this function to use string.Contains() instead of
> exact match to the "volatile" mount option?
>
> If needed I can fix the kernel to show the legacy "volatile" option,
> but I would like to first understand how bad the impact of this regressio=
n
> is on real production workloads.
>
> Thanks,
> Amir.
