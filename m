Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793813578;
	b=zFUZqbY8muVwlFqI7fnXSJIx/F7ldOJcFvrfLcrTYYmBDSo7Yt5KtAnfeQHQy14Hbg/b
	 ovWBPdggcDVqdctv8aGRj4lTdDTDmJNwyS0KbiKkpSiVaxXMFEOJeQ/GH94ZvyU9f5WdL
	 4GN1pqbtefT5eHPUZn4IgvT3PYj3hIfXzwJI+NEL7xGWBZytXkue0iFVcqXHraTMaA7BI
	 QqphbXjSHvHzs9tnBm2jJdLvrtz77bRnF5HEXCn5HzFaEUqVPj+TWJ+5Onem3FIho3P+E
	 Cf3KRvSo9c1uFz5w8zCvsHzVxSO0CZQ7mTx5Ki1EeEeD4QIQW43T52A1dyIl1TsddUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Mu/e4yaFN9LQNUfDEaiq9ZKyo7jmvn2P77FadrJquUg=;
	b=yUJb5JnLdXbfkOPYxg9ZHL8vScu9wgGXlA6kaZIZdJdlAAE8gtMamEN7aN5VLfqb5l/d
	 GlnKXXOT5g7nNIOplMibgTWSvjgSFyAdyhcnb/c5uGAyz+NGonz15oVa6Mc0ZqNTvoY7U
	 VYEZBswvqob4yNN8bvIGzGmRldMO9ISMpBswHwByOP1YHzJ2mFmxKoNsqZo4tvUkZyf6A
	 o7Vdgpw1V+5bvvfW6QizgJdNIsHOJGkPqq6TQzsjDeK5cpmPlJ4VEA6Rg6NYf3GGhKVJf
	 uhcXwZLXHz53HCQaqwUMIv3xPxC0yDMw8xWnwSrZTfYk5y1vRLXgSjIW1oNUzOfbhxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RJnLh6xj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC969606A907
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 17:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC969606A907
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RJnLh6xj
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6acb9c018ffso1383059a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 09:32:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793813576; cv=none;
        d=google.com; s=arc-20260327;
        b=jUy7c+acKZZM3y/yW6HPSCMi+KZTmlD12YWEZIleZRKaQj98sTY9f5X4zIRVctAMt2
         4yrXeXkgx7s1T2YcEOuh4qxBMVrscJqJHx06ac+qXt/qUvu+coMlDvbzjepNvJPLOL/Y
         ScXNiWfl6KkoqgpmqDEMb96Wnd+XKRySOJfIx0O1Gg124xGBPG7BwmBlJ21sEo7NzzAZ
         c81D2VaxmDLJbXA7TQDMHC7eaBf9I2Becuxl5lEtS9mAC6Pb81VkjQ0C2GNJo6d1+oJi
         R+DWF4BCcbF+mKjSDApWEDfqUiQr6Owy3ds0leX8pW5m1aUI3mgbiMMBuGPBncbDmbF+
         KKJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mu/e4yaFN9LQNUfDEaiq9ZKyo7jmvn2P77FadrJquUg=;
        fh=HHGsTf3Nq6waNlJ8XMma/ctQKWwykt7nfp+Jp+9FDCM=;
        b=DX56Fk2o3Wr4HpHfhaYY/cytgJZDYXTP0ig4GeC0AOioLlaYdbRL3Y9OSj5OYkeRoU
         83umCKIEhI8Ol3ies/HCW9pMMoWN375fmw+84dj7aTxzEsUo37FKyPTwAjdHwH6Wqg5A
         uylTZN2Kc/JSYEM6WuTyd0DkFlA7sSmHVmxQ5+3pYOZkIofYmt0HAGdr/XnycyunNIcy
         o7/ZIcEXgeBqey+4OZZyL2lI294pVkerfl8sB2dWpGwF/Fq9n3Q/szCkMA9lTHJcKf/I
         xy8EXpKybdEZbGn9PWHgBwSTPRsXKKP6aTa82wzgZaH92Q/sUrb0AEsm48Qmtfmg845n
         Xv2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793813576; x=1794418376; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mu/e4yaFN9LQNUfDEaiq9ZKyo7jmvn2P77FadrJquUg=;
        b=RJnLh6xjfbqaIIUDfw3cp3McuWfIdf2Ng2nJ5Ww1CApa4eS9uV78kIXmxus5ZTu2tP
         XkFuwuHq3tUtk4RL4mVf0fg1DlOOrKI8y8iMjoP7SABOdttcvg6tVw70LLyZwXp+NMni
         /HVHw4kqnvbrlmj0TPZH9t/vrXFZKg5ERUKPagYIguYD198G0LQetCq60OCmm4NnTCnm
         l4r8fVPFB3CcitRtJIFBMYBLczSn3LDbvWb4iIS/A84aKXMaITJfXZwra2iGK3f9NRyL
         V511JRnoi7mHQG58uBq3gpLAVtj+UX8yo/wrCmjgIYhVK3XCMUDEwQCOpbL2BTdbXmgN
         FpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793813576; x=1794418376;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mu/e4yaFN9LQNUfDEaiq9ZKyo7jmvn2P77FadrJquUg=;
        b=x9vVmstlVy1fVUxnNTKCAKxSssE+ReO0iT1xR9JpnwOLBKLMDDgisiNxOZ1m/jdVqr
         IfYv7pbLOWbWZRRv80kFJZcbtMe4C1uKKS1WJnXtY6LfzXS5HeMsbVNeKYV3Pqm3Rk/V
         x3SePKBnMpYybm7mi+N2HSHP9coUl7XEVqXGoYu731YT8iSbm0jZuhuQvCZmWGzONBEt
         eEmgOr2IxjzBtNX25hY1sihLHtZwXne1z5jKKZlJ3a0+UMMxU9KbjgPJpB4RtvraS8R2
         m2nVpTC0Kd2IswXAR6d7dT7h8J71VtcqbSgm7hh4z0QlSazTeAp9VEtXy2hUFOFo5gSB
         HqYA==
X-Forwarded-Encrypted: i=1; AKwUvBwsiq/WJ6nxtjTWfyVjgqk7XXA69WlCJbC7M2gwLUaxpt5errTOenlRzyJSzHMl3n25NJMGeRUGoIFKR/Ue@vger.kernel.org
X-Gm-Message-State: APuU4Z+6W/8yoUZU7DWXU/S+iGmhcv9JFKl/m/C67MrjnfBeXfBmZleL
	Xm5QrzPUltLTcdk5nxXS4RQOYB0r3j+l/aKwkuV64xhxdGs0eGsimP5staWd0A5FKb/94eqKw9M
	4Qs3ngvkisQ6I6ZLNoMEw/7Tz42ydunE=
X-Gm-Gg: AYBFou1F7XOFtxGJtwSr6vaguiORHdDFZG1c3oz/ttD8TTkG4frIhXJhTXddCFTOXt1
	ug/zwnGr0KPpXYe9BtYt37kzGNp+2dwmfPTVhFWIYT+BXzdhv31yAkDOJVls6cLgDedmpu9drp4
	NeSe3e5Yw3YpO+n0vgka/TIiIKDc4QBxLJjaDa8Z1pERCd9BcQthVTQ/a0FGXaitDF1pN/3aLnl
	h75vivucgoLhVhSbWCcs8HL9yZHPN6Qf6wgRkThSjKATbqaUe9M5D/Ajmc01/Oj9zX1ERIIZE3l
	yUBgraQ+dAEleKRtvEfqBa4tTIgXfz947A7M76lCgbP6HE42R8Sho2S7lzaZI3l+xyB84hp+QDP
	kmmW5M9Afw+/aH9vxkiHvAqBtRaw/Z7OeYcADmDEDhKzvFt3Ea9bUUJ2jzskqaW9Xe8dm2Q==
X-Received: by 2002:a05:6402:5187:b0:6b5:6c8f:22c with SMTP id
 4fb4d7f45d1cf-6b577183624mr170574a12.5.1793813575918; Wed, 04 Nov 2026
 09:32:55 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
 <CAOQ4uxhWy2aQV6g7VJcV+NDLPTSoGyR4Rag8uvAwN=LWnApaJA@mail.gmail.com> <b9d94891c6bbb0a18176424eadf6ff88.josef@toxicpanda.com>
In-Reply-To: <b9d94891c6bbb0a18176424eadf6ff88.josef@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Nov 2026 18:32:43 +0100
X-Gm-Features: AclHuK_59wvajkPMd500vbmbA1AMyOdJVXBnQNeByyLMSA4U6W7ked8knU-c4rc
Message-ID: <CAOQ4uxid3ig6M_k4W+wXh8K+P5jiCpuYRNoq+CHnzHfYjwihug@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] ovl: only sync what was written through the overlay
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chengguang Xu <charliecgxu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 6:22=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> w=
rote:
>
> On Mon, Nov 2, 2026 at 11:14 AM Amir Goldstein <amir73il@gmail.com> wrote=
:
> > I think this is over engineering.
> >
> > What is our goal here?
> >
> > Make overlayfs behave better for the (many) containers use case.
> >
> > Who in their right mind uses a host filesystem which is not one of the
> > big three?
>
> I mean I'm good to say if you use something other than the big three
> you're on your own. I built it out this way because I assumed my
> attitude of "I only care about 3 file systems" wasn't acceptable, I'm so
> happy to find I was wrong.

Well no mean to disrespect any filesystem but I was referring to the use
case or running a multitude of containers.

Who does that not on a proper distro or on their own in house distro with
a proven server host filesystem?

I am asking genuinely. I don't think that the use case exists.

It doesn't even have to be the big three, it could be out of tree ZFS
or bcachefs, but as long as you trust your host filesystem to hold
massive server workloads it cannot be a toy and it has to have
a balance between performance and durability which implies that
fsync=3Drelaxed should be good.

Hand waving reasoning indeed, but if someone doesn't like it
they are free to choose any from the available fsync modes
for their system.

Thanks,
Amir.
