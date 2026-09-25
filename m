Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9099C3DDDCA
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790356051; cv=pass; b=BH6dqtVnNs1kNFXWIL6JJYgzWy/EDBdqLUwBzSmsZkHKnxeB2xVhHy6pw8YSyfHWz1Ec8E2SzvZWbyM06/CiF8phzsIAc23HPkEdfqceQd3xWNQk1L3XxbG1v9it7fXB853pR7kwFWTP/tF3EHTmpsL8vB37SCbfs0fAC2FBAAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790356051; c=relaxed/simple;
	bh=Z/QlDjEqmTsvd8hmVsRhjPJAPZKduCsAshcn9SEcHsU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mKIjnp/Vz9clXI2KiFkBZ+lP8Ne49LJddJ/Sr7UcbWUvUJ9rvPQyv+N4FnH5oBxduVnKkkAQJewfJimtifOeLtbg7qgQu0HB+/KiOEWpBaic2O2kXZMdUjumDZvTl4/dCstJrjpSJ3OMN9GNJ+es5lKIoAPiLGGa+VeVF5rcFDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=JQ7vBslB; arc=pass smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="JQ7vBslB"
Received: by mail-pj2-f41.google.com with SMTP id d9443c01a7336-2df958a8272so4264785ad.3
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 10:07:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790356042; cv=none;
        d=google.com; s=arc-20260327;
        b=TzCUqYoKoyN8R8U1+drI8jbxyTc6MYfAX279uLSxS22Y1Z6qhh2YrFvRrYwtohjDJc
         Gg4kh6N8u/x3IZNIwovLq1xnCiXYaBBr8TREn216qES6Wmji3sl+gbfHMCD3KTSmn3vc
         Yv9Ingvt7hrvcrmyBO69sNMABDzIYnlWVmt/zFKtScUmD3dJW5VXDmxFMrAhxCyS7YFD
         F8IUsTniL4S+xbuxtOzAImZIUM05SXptg7dxmVd6Wyj6GzN+Sl6YmZEccGPPGognXmYk
         i3ZcYpa0bFc681/NSZwkgXLmszvvxQcSTXgXI39nv20HrhUd25wqWe9IE+StnwM8YRZc
         tH8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8YwzIASUiQRwU6GfvzkJObDJseuyBEMVP7g4XrNm/58=;
        fh=5UziV/nJgk5ajdIRjaPg8PxGOBZFUQAYg3At8PnxhOQ=;
        b=Lt2HqVTT9gD+rqSD/+LBf5oQPgMNJjzfjj7MnBffaEwnbvbx5rgnQ4HrFueG6Px0Ci
         IYokxrMS4jE5mNx+4JUmKklJyuv34ZTkU5chMsIm1Viaf7beZvHNcD3b2Fm0gr8nm7Cf
         jeUH2+dtvnQKjTnUQLneWp4dmNSSNBEblaBFHRrdvVJWpJqlacn2tv/k1MSRG3pUYkQ+
         WLWdZbC/+DmTOsxWxvigAa46TU/SGptMyR3yPX1sXSA31Br4fBb8JXaQJ/ze8MBW3IRj
         lWg9uvFT4FF6vW9k+4VwBx66XE9GOqnU78OrocAW5YF4JyVtKZRK3XA5SHnj4JatQogV
         +96g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1790356042; x=1790960842; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YwzIASUiQRwU6GfvzkJObDJseuyBEMVP7g4XrNm/58=;
        b=JQ7vBslBA75Oz3vhccuiegu2ZSCVFqSF0HyjC/3/vNzOkrP+yD6f4D4JjYMSYAoFrr
         wlg7Wmn6oEu7SXRotz0a67VZfHRO6XibZ9ZQ2iaB3D1nQj3Xnbu+DnvAmLPuwuabcTJk
         PXz37aU1zp89S9iK0/x3WEyWrQZ8hNLRiSYpSLIsFe52Q0ZtYHr08wUrk94pc3ENWlQd
         J+Tedgfpmw+/PX5h3yjumGEOqc+s3rcWYPx4Hn4luwZxasnr3NVcHxFxvCE/jfitgeBw
         +jOt/CmP2fD13Y486VYHbVYAPN3U4OMa+qtVuZhbWJD5jm5g1hu0o/Zq9FL93oXYU7V4
         vv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790356042; x=1790960842;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YwzIASUiQRwU6GfvzkJObDJseuyBEMVP7g4XrNm/58=;
        b=rP7w8EpMBUDpIecYeHWiyNtell14PoZjtXvAfmc5LMxVx4eJ4gFX/yuIDosgHnd2YX
         49F5DxtWB0Zz2fvjHAB0cNm5sGOWt1t71lJj8buPD73c2pO0KnEIYSE+cjBM5e72xAE4
         gHe33NRiDAJGvusspDorFVMy5M5nw84cDcloAyR6q0CZuk9pX5P0hhCyGEz7Y6Lcv1j5
         zunScAL20TMc88iWWQg2ALeXIqFaTZy+L+hw7nqaq1+Rku5o9FNO8qMfRhXDVEEK6d29
         7AgQolcVKKNOh/7XyOEvuVIa/m4GSFudJ1+pxOOyizz3MlF+qt6nJ8LOtCGzduNc1/7T
         eeEQ==
X-Forwarded-Encrypted: i=1; AKwUvByClhURBt84Q2O53ac5jA16NgaBFuUWiHLSJtXTE/Bcd8SkFsq9rMqmDLnRr9H0SuPfXgJtBn8Q1kvxfsqc@vger.kernel.org
X-Gm-Message-State: AFuF++kd4lwzB15MOPGGYboQefLWOXOXkzdrzALhXZofAqLGdquYrJYH
	l1hpZumjFa72/YoyeAY6mwlW5F1KsFeZu/gQLocGb1cA95A7X89IQt+XK6rFmTelBk14V5VB43O
	+ujH4I+QmG14apm/hqY1u/jB4tae5SnBPCLzvlO7/
X-Gm-Gg: AYBFou0PFoFd6H++lzisjmHZjwZEfuXL7FejAyn409wFVXvPgIN9ES1jiNN48URPxo0
	jxZAOS+qPOXvIB/IVq9W8f8Ti2kDnm7p5WDkctMlsKwAQ4Fwh6gy8oZlecAX/bIA7tL52I+IbPU
	fZHJDS8Z7a60MfVnSqQRnJUi8Vo2X+qclzEIadAdTAHsjXmQ12Kq/O0CMEm/oOHuRj5vGPMEnz2
	PHjPvpvFHQHSLXy0R4qqxvxPY38kyfv18Qrp4moxM14GVYOfsY6+9422+PSYl7gCydODuWdMfti
	PvzOaDS2GRRbyDBGi/9t5MjzhprH+EYWcxE/PwW4y9qwXM6Ha0fWslQn0NGkuYIrmaPkZr4RbMx
	nmrax92l8MZj3MKMQJE5x6A==
X-Received: by 2002:a17:902:d48d:b0:2df:99e6:9448 with SMTP id
 d9443c01a7336-2df99e695bbmr12902675ad.61.1790356042370; Fri, 25 Sep 2026
 10:07:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924104831.1081137-1-caixinchen1@huawei.com> <20260925-zahnersatz-hielt-lerche-141893658522@brauner>
In-Reply-To: <20260925-zahnersatz-hielt-lerche-141893658522@brauner>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 25 Sep 2026 13:07:08 -0400
X-Gm-Features: AclHuK-PYyMWIn_xv6i13K6lF_3RP26uUOO_mtAnUMGHNcMrV5ydBitx8qn_ri0
Message-ID: <CAHC9VhSeXmOHvioZ12aVmnOtpP52-G=K_jS3K0fTSiCrDHStPw@mail.gmail.com>
Subject: Re: [PATCH RFC -next 00/12] landlock: Add READ_METADATA and
 WRITE_METADATA access rights
To: Christian Brauner <brauner@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Cai Xinchen <caixinchen1@huawei.com>, gnoack@google.com, jmorris@namei.org, 
	serge@hallyn.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, 
	dakr@kernel.org, dlemoal@kernel.org, hch@lst.de, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, jack@suse.cz, dhowells@redhat.com, code@tyhicks.com, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	hirofumi@mail.parknet.co.jp, cel@kernel.org, jlayton@kernel.org, 
	neil@brown.name, okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, 
	miklos@szeredi.hu, amir73il@gmail.com, senozhatsky@chromium.org, 
	chenxiaosong@chenxiaosong.com, zohar@linux.ibm.com, roberto.sassu@huawei.com, 
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, 
	stephen.smalley.work@gmail.com, omosnacek@gmail.com, casey@schaufler-ca.com, 
	nanx95726@gmail.com, djwong@kernel.org, daniel@iogearbox.net, 
	linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netfs@lists.linux.dev, ecryptfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	xiujianfeng@huawei.com, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 11:33=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> On Thu, Sep 24, 2026 at 06:48:19PM +0800, Cai Xinchen wrote:
> > This series adds two new Landlock filesystem access rights,
> > LANDLOCK_ACCESS_FS_READ_METADATA and LANDLOCK_ACCESS_FS_WRITE_METADATA,
> > which control access to file and directory metadata such as inode
> > attributes (mode, ownership, timestamps), extended attributes and POSIX
> > ACLs.  It picks up the work from the "landlock: add chmod and chown
> > support" series [1] and follows the coarse-grained grouping discussed i=
n
> > that thread [2]: instead of separate chmod/chown rights, metadata
> > operations are grouped into one read and one write right.
>
> This is mostly fine for me. @Michael, for the fs side of things I would
> give you a stable branch vfs-7.*.shared.landlock.path that you can pull
> once this is ready.

This is in my queue, but I haven't reviewed the changes yet.

@Christian, I'm guessing you will merge patches 1/12, 3/13, and 4/12
since those are the VFS changes?  Once you have a branch for that, and
we have all the necessary ACKs, I'll merge the LSM changes in 2/12,
5/12, 6/12, and 7/12 and then Micka=C3=ABl can merge the Landlock patches.

Are we all okay with that?

--
paul-moore.com
