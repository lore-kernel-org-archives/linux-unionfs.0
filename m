Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B1E3F58C3
	for <linux-unionfs@vger.kernel.org>; Tue, 30 Jun 2026 11:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817318; cv=pass; b=FRGCTf3Y3WeigYKdpbSIJzv+jnVcoK8TJza8SSn5IqTYcyiWhiUObAL8GyLh1iC4PDJhVRf4ohqyUKzhQ6kk9VauOAoO1TilrZhxdhiO8aM7qVYf1MdjawuD2EVTH7YP2rNIOKE+YsNsqwH44qZ4NWRjLDtAPHm4WYdBIU1A0z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817318; c=relaxed/simple;
	bh=XVMnZazNe6ueinmZJ6D34+lB49c1hHJgeNSRfW04Low=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f79FBm3oVFEpabHBh4IGj/0vgaTvySr23xGvykc+5bxP2XpqThlPmuEiRn4EvyZaNx2RIEXgtja2VpfYIQEyjzVS7McOFTEZYsLkrPEkhQO41KmHc+nXkchCwf5AWUzpi8v3HhvtxHU3GC5sKiT4foWOd/yS88rLu2YYCV5whv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vh/cOEk4; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vh/cOEk4"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6978f1eeb87so7947414a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Jun 2026 04:01:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782817315; cv=none;
        d=google.com; s=arc-20260327;
        b=Y3Q84gEAANgSfH5aSmH4BidxlhMBXEk7PkS2cOO5YguOyv4sMT60hv1IvVzk2RMNdw
         iBdFvridAyGsJ64LbLOfvDb0FTBa1D+FH313KcBkjd6g4porZ9VxtgTI9mBkT8vwWHmr
         IViB9/K08YcPeYkc0RkV+dguBFk949RScASvECk2pA1PsLzVZ3eXeVF/B28am5sK2DHn
         cLGZNA40YbyAOtYsqWxTfwS4nUm928UM9YG3wj+lMbwx+SCHHP8ricqmN5QWVpkseAlC
         dVhE8pfPQE2qbdh+zTWEWJ8qEXPsqnIKY8Zx4NSYFwmzUmGCb9J1pC6Fb9sSrvEfxXPS
         +chQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XVMnZazNe6ueinmZJ6D34+lB49c1hHJgeNSRfW04Low=;
        fh=RFDRxMzGiSQkbVx+7jIlzY7U6fkoWYTp5GH8d1rYTVQ=;
        b=nlowHstCEVfSPFYAIWi0PJj8JwepsI9SotCI/UnX0E6xZsnDeBtdLumnJq3EImdHlr
         uEfz6bfUsJjaJ2hH7JOSSrxUNJdb7VE3AB14UsZ1y3PVPl2iYWp9oZ6twrUHtC+j/1t0
         I5tnppPwKzuvym8Cq/1DKNB5K3SQXDpnfa/TMGenXGz5DLh5vBNURZLpzi3SjNx0/8ka
         5h6MD1eGjFT3nLUj1D16HRm9VtU0YRxc77nl/AWGHlWfXyKJGKCUSkGtfHxKPQXZORGL
         mIPoWV4X3nOJoXsIWq6lLq3DSMzO5UFMkUIJbQOJ8rWKHaAOFHgKP46ir2SmGOh206rd
         o8xQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782817315; x=1783422115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVMnZazNe6ueinmZJ6D34+lB49c1hHJgeNSRfW04Low=;
        b=Vh/cOEk41rYPNWUDRzL9fV6pGiGys+jgYv56yyVM5YLQG+CQ6HAz8bjg+2yhOi6Z0R
         HX5dq5MjKkDCK0F0V42AmSr9XYvoGMwSY8++X6KpGHvfsB59EyMe/afP90eBPd6RVRuU
         L7n25ctS5VPtXZFXOSehyvn8hizxq6TuElNJX8Iqm3lyuU2vWeZaWZSlzFn+po0im++h
         6dXOnUDzBwgqXpKdQxQeR6rYoXT3d9Jo00Fe2t0MpjfrJ99DhicDwTRG2/Uz1zEh9e4R
         eR7AWSSH51CU2MO3xvGY9EF+7aN4NbA4bV/dCilNCPOg4BUfkwmVFQbMOtZGFMCByYKP
         R3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782817315; x=1783422115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XVMnZazNe6ueinmZJ6D34+lB49c1hHJgeNSRfW04Low=;
        b=nMu3d2OwT/YPicDllDu24YlwKWp75YDgiZqKaFE/zA9wzs9ffu9WoZHChZ1uxTZ43v
         g64S44v/NJ9ACBjK3RNonMPidDIrvWZDUNh1xSuuKQT1sU9Zd6DIxF53xABFpg+DxLYt
         ilrYiBtId9QROngDEkTQE9++9t1QVK8Qjs2YQRVdnQX+3j6jQJQ00V5pgvlc24bc1tC3
         SKpp057C5CKEQehxj18IyCfX9Xnu2Ibaw1fbaSnslxe9d6C3oyBJOv9/Vo0poSYdauup
         I7wnxcbJBYFXh4UXF1SaBv4LI6xmhZkKXYM1czwrcJORKdbmAXNyA12Ge/48cd22Xzq8
         l1gg==
X-Forwarded-Encrypted: i=1; AHgh+Ro0mPlCO4anGLpYnScmvgL3779Sb6QO3GYJuM2m8B6wlOQoqU4/EuaoQpFrmlyBEKzTqTx+gLDWHK5r9YXB@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+kNakAFdEYlHjrI6uWjoaLqhtexok1Ia7fFDt3aZZbn2WDcER
	qqA4X1gnqsV5aSet8OZKtZ4RN/rFMVTrnMSuMDUmbt5QKm0LC6NuaWCjyMo0vMPuIlz3YgVIE+g
	GfbRG/4tM53zrb4aVniKb1MXoqEuSB/c=
X-Gm-Gg: AfdE7cnqGTMxZ7H6hrDw+udXnIj4153xAFf7AN+vRpuhC0/VjtfvuntNJjNNdVJ10qz
	G0UJnoSuMZY7EVpsSgUp99dGLGPmh2tJQZkN+/ekNYGi9hIil4ukm5FFaeEQtGhXiW4+69cg4PJ
	Xlie5TQHLkFjpE9V17kFhV09L6ArN9ruIazyYuIuC8W6i1iMkzvTa7Li0Xzdl0Lp4AOGtDPVSIu
	ZNo4CoM+MqaXKQq/GBtcS2Ih3CX4hhUkpeKMvim6qsNeYvfdtf1bgpxW0CqQWWwVl51hJ8VpOSC
	obvtwJdEsMOttjmoy83ET69uuuFMcVA=
X-Received: by 2002:a05:6402:5248:b0:697:4307:991d with SMTP id
 4fb4d7f45d1cf-6988789244bmr120235a12.19.1782817314715; Tue, 30 Jun 2026
 04:01:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629070653.580879-1-caixinchen1@huawei.com>
 <CAOQ4uxjcD0-PHqqmrpEvkLRgtKJGe8-n+6DQyBngjN2TorwU+g@mail.gmail.com> <f4c8f5fe-30c3-4e7f-8512-7a2befdd1ed3@huawei.com>
In-Reply-To: <f4c8f5fe-30c3-4e7f-8512-7a2befdd1ed3@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 30 Jun 2026 13:01:43 +0200
X-Gm-Features: AVVi8CeRSS7JXqOJC8_jFJY-F8O-_1zMcUusRfzqJnniatTSJdpzkrHWbWs8ruQ
Message-ID: <CAOQ4uxh4-LYt8VUW5o+0mMrHpnZm3t8k4WD6x2kRqEj=_ZpLOA@mail.gmail.com>
Subject: Re: [PATCH stable/linux-5.10.y 0/7] Backport Fix incorrect overlayfs
 mmap() and mprotect() LSM access controls
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	miklos@szeredi.hu, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, 
	stephen.smalley.work@gmail.com, omosnace@redhat.com, 
	gregkh@linuxfoundation.org, sashal@kernel.org, bboscaccy@linux.microsoft.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, 
	lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 5:06=E2=80=AFAM Cai Xinchen <caixinchen1@huawei.com=
> wrote:
>
> Thank you for your reply. Regarding the two points of feedback:
>
> First, 6.1 is still in the process of being adapted.

So do not propose for 5.10 please.

>
> Second, this patch set is primarily intended to fix CVE-2026-46054, but
> it seems that for lower versions to implement SELinux checks for overlay
> mmap/mprotect checks, some dependencies are unavoidable. In such cases,
> should we add more tests to reduce the risk and integrate the changes,
> or should we simply not fix this issue? If more tests are needed, are
> there any recommended test suites?

I have concerns.
The burdn of proof is on you.

Thanks,
Amir.
