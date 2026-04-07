Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6DA226CFE
	for <linux-unionfs@vger.kernel.org>; Tue,  7 Apr 2026 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775572514; cv=pass; b=CiDWE+QWh6w9EOu3Jp5oWKQWfl3fITJ2SKwnCUJt+tTR9iaIZ27uVGGO16wmSd5mNIURcuIDpCSEuqjXSJEGJAmFnYVHZE45aHmzwk0i6QyBcvgLjLDwR9hdJkJ8qn/ATbw7rsgUY8pzoUos6pQGKv2zyClB55gi3UbZpdtTd+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775572514; c=relaxed/simple;
	bh=52zpGg3kueHgGet8IztKdLA8+tZp4VM8MiDQmi08+vU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X3BR31uwDLW1m1IkGY/VWzUdPHQjdSOfOeYMbhcNBxu4lN3+tVVHDF0rQB+wEjkynSyiYsOOmq62ASNJmjU2420HllGYYlGzViBd47LlyrQEeVeZUSGeSZKYMHeeTjF3mcapIIW+9PRISVlaxZaFUN2kGl29WMAegz51Jic9dQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=MSeCwIrQ; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="MSeCwIrQ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82a893d289bso2199673b3a.0
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Apr 2026 07:35:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775572512; cv=none;
        d=google.com; s=arc-20240605;
        b=FCmRRu32QjnQ/sEKDWgahOZrT2fxGZRm/eTi5wpevQGhEFPkHvW9TUqKXx1wdw9+4P
         0GxpGjCmvVoT9WENvfLANZ96m9lqa3gw+FUAoqpLVyC+KvmJC4ykDuhkPYLHVgcTS6dH
         V1ik+6h7b1AI2a8mqvtQxMiRijmJzqTZ6tzd2of3G2hxqNYPd1doQoNmeYoyGHCsjvT0
         dyjQI7jVTs4D8cUXaDs+Zasb1ANA1TC84g667b2EMr+VvTXtAmponn/lbp/nOlAlRL5R
         kXeOiNZe+GjP1MjkwlQoRfMvj6cOEyl+yGV2jAVsF7tqn5UECDSiKcQp9+WmlEjkU4KG
         0pPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2qC5HIWFMfgCC7dxk8CsqfkMoXma/koXyhFD7US+Mog=;
        fh=BmlWt5/CNL9KeBOO+MFbXTS/74TCp3Yv+Ah7VMEKTrM=;
        b=OB8gDwh00OUOKt525w54C4cm/zTTSIDMSvctQFlcXVFW0JhtRTWcbBY9BPVoXSboIe
         eqG2svlh04i+TwTbLFNxX7nZsFAHKlYJNXb2YVxcSBr0aJGq428ubgSUmKFJApLciEA8
         2ZIYyEARVoUSUsgJvBHd4yIUgMBX3KIbXsCylaEibAi4Kv2ekLjdvQ2RMx5WfVwGp6Lm
         XivfYlfzYMumaXL4nmdUeG3q1NYsDUoWgeoPVcwwG3a8qLEveoJTQUfW44Y61+XtuEvm
         wWGXu58dXFbWZoR9SV/rijFfpnuFkoZQlpF3nzE1fuSgDN/wo0ej8R7oAbu8f7BtfrrH
         zOiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1775572512; x=1776177312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qC5HIWFMfgCC7dxk8CsqfkMoXma/koXyhFD7US+Mog=;
        b=MSeCwIrQe235ez7W8m6HlUnnYkAayZ4Ym0rsusDeGgjvysabx79GAswgymvMDwdX15
         FZci+n28iUiJBkB94aYRm7cQN12xS5bQ2IvJ7vp9ZFzi01QrgKVQbOKHprEKQycHOx8g
         SwVpNT39z5mwh+sxkYl8XfXHIQ9jVIlGYCnWPXnZEZpiWl4+pK++qko+6KngzKrbFYmN
         zgQHd4/KTK9qCjAsNh4izeax1jtfpXnjJn6T9gERrt5c5odoNSP2z1QDpX+Z7Erj5g4t
         g4zNjphNUV2pniRnLFMWEo9qP5FZzGWUsKuGfgyxQNrK71fbqKDP8i8JNOaOfLepmYl+
         xAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775572512; x=1776177312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2qC5HIWFMfgCC7dxk8CsqfkMoXma/koXyhFD7US+Mog=;
        b=aUd7JQnUMXu3I1nUfqynflhP1IexHQAdiFMucG4R3gOH5HKWxhTBPgMIQdQBlDZqML
         Vdu1Sh7li3lTudoDw7hcS/Dn4v91dQKxXs0bfmHUAln2Tn3ydcSCe5FQVKYm/JZQBeeu
         a4KL7Qug31/q0WfX5oQ8kxk9t+RNDBBOn9LtD3gQqWptOFsD/Fkmvkni1u18ljfEVBFE
         qwSiVUDBxB8rXdLgy84PRzIcBncFUMcTD1ADWynw64f1ORGhytFhuxPWPsdWplF+aKnJ
         uZh+RjxvEa26DWc4gtdUd+aK3sPZvlh2wUvK1AkdyJuiyieafo1ZhbfqBD//8LDJ4Pqy
         olcg==
X-Forwarded-Encrypted: i=1; AJvYcCWchhP35tHna1IqdjRPAiiUwkhU0BZIHmn9NjOyYLhFMRwlFOfMrXOhTtuzj1u9oCTXTYBeTsQuUZZr6GSh@vger.kernel.org
X-Gm-Message-State: AOJu0YzBIgJw0Z8hR39gCL3rETL1PNu6o3GBZZxTDhcJlSRj0vUY2gdS
	9wufYM1FK1BBekP3oNcs9iHm3VCqIrMEUP3jgBK+ZEciv/1onQtlTpvGXFqEWwsnvgFMgPFcfMI
	0obMhzYCEL5XKGR9wXSgu7LRAy7iB0P46yHC6PLAh
X-Gm-Gg: AeBDievq7Bp6g+Ei5U5AcNiVMRK4jQc0gPxkvUdHb18rJ9beTGu3kAnrH+rkFkumKJO
	RMoLBdzVJyeOLVvJn+EKCs4bU1CsCV97jnKlnHI9z1v9oeGOGo1cw6Xhu/BUOkT3uWNO00vi7LI
	0rms3Ing3Q37EWtGuJ2HklRtXBIakgbcrAunOngeaQzngvTf93wIar3/4w8nUlEi4hRy9mIAAMj
	he7KJ/pOKpTwAHj7JRVlVMhNjT79Fh3HeXpVBvW+7608VSHNcS0xfHCfgikB+VUBcFa3okjlrrV
	MaxxcfU=
X-Received: by 2002:a05:6a20:a91f:b0:39f:75a6:16e3 with SMTP id
 adf61e73a8af0-39f75a642ddmr6186836637.2.1775572512468; Tue, 07 Apr 2026
 07:35:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403030848.731867-5-paul@paul-moore.com> <20260403030848.731867-8-paul@paul-moore.com>
 <CAEjxPJ4nqeuPhve3Fe-tFuNW9R5grnWwfYJv7q2cRu+UPQ5c4A@mail.gmail.com>
In-Reply-To: <CAEjxPJ4nqeuPhve3Fe-tFuNW9R5grnWwfYJv7q2cRu+UPQ5c4A@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 7 Apr 2026 10:35:00 -0400
X-Gm-Features: AQROBzCbJor8xEV12qkCxYwq58fXkfkjQP4svTBOSHpDEN5glYblz9lJ5v7xffk
Message-ID: <CAHC9VhQnA38-9wDeVmOMxAFPHnd9y6x5LXtD3cSquGiL_MDDpA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] selinux: fix overlayfs mmap() and mprotect()
 access checks
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 8:14=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Thu, Apr 2, 2026 at 11:09=E2=80=AFPM Paul Moore <paul@paul-moore.com> =
wrote:
> >
> > The existing SELinux security model for overlayfs is to allow access if
> > the current task is able to access the top level file (the "user" file)
> > and the mounter's credentials are sufficient to access the lower
> > level file (the "backing" file).  Unfortunately, the current code does
> > not properly enforce these access controls for both mmap() and mprotect=
()
> > operations on overlayfs filesystems.
> >
> > This patch makes use of the newly created security_mmap_backing_file()
> > LSM hook to provide the missing backing file enforcement for mmap()
> > operations, and leverages the backing file API and new LSM blob to
> > provide the necessary information to properly enforce the mprotect()
> > access controls.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> Do you have tests for these changes showing the before and after (i.e.
> failing without your patches, passing with them)? I tried running an
> earlier set from Ondrej but they failed.

A few months ago I sent you and Ondrej some feedback on those early
tests from Ondrej, but yes, I also had problems with Ondrej's tests.
I've been using a hacked up combination of the existing tests, some of
Ondrej's additions, and an additional debug/test patch to ensure the
labeling is correct.  It's far from ideal, but I didn't invest time in
test development as I assumed Ondrej would continue his efforts there
(unfortunately it doesn't appear that he has?), and I wanted to focus
on getting a solution as soon as possible for obvious reasons.

--=20
paul-moore.com
