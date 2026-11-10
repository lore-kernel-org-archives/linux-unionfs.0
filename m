Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794322517;
	b=335Q8JbcYZh2ITzW7t+IHxjnMjMLiT2yc/rfz/gcTO2kGPxOiFiHFXs+3/O5VvlLDclm
	 1/Cd01YH3WWwomCiejXlpoQ4g/rWV0ErE9xxQQv+3LBaGnYQ4RrKAoJVICK8wAlaAg0Ho
	 sPON4TsAORjFgWBcSDEeRoy3RNS3cnOrk3nD/R4e+C1wD8ULGZoAHH5leJ8iaUQZMrWqp
	 s3cQBulKteKomBRTGjCsGHaSfM9zL840uojZD6Lqe0B0RQCHAf7vuhbIOwbYcmYm3ZfMJ
	 jJxtfMGlCLUjlDW4ARB9eSXT8Xx9nwj9T/LF1gQsZGerD92YvF7eGkemvfNbq5rPbtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322517;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=HMSpATx3FoU6WjmgIUPsWFQe0qXX5jBJ5VQal2Jf2Kk=;
	b=hmmytgYaKvGJIwD7AVcsw0OudxoF9hSS3+TnJu+qT9KM/9/18JyzycaKSQwMkL4FO6J9
	 gh3i3h4B/1DKv2dcTf2qr1sKj5aGazCTf3F/7fiBr31+y9MhylswyQVoY0A65RhlJQkuJ
	 NUjCQznOr7C91HXy7/maBsR6CNDegF/0gpZZm91AQtDtGGBRNssTAwAZYbFUCZcBINkEv
	 p2jTkSN21ijacU+QStxY2yFOqu7vgvl1r+C8Zs2Ncol8w3uMo+hpn52XBvnOmp+N6azJ1
	 Dg2W1oGbxMO16zq3mhTfb1+Coo9EIgCTgtp3erlgaWd/iPowmm8gEGkbKq6eydlZ0YA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wjcqRrnM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38B4606A331
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:55:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A38B4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wjcqRrnM
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b5669a5100so2859766a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:55:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794322515; cv=none;
        d=google.com; s=arc-20260327;
        b=rX9TqE6czFrK+KFAHO6avARW54jhOt5c3sH57YF5LrG9GRXu6XUZboZ8n3puekY22K
         u2HeYTKQg+/LpPDl1TgClvvN6an4uJLT81HAckwfqsjzSG7+XmrjG5VX8iDRDlKYZuTJ
         xcTItjhb93C1v7VU/eCFgy7I6X/SCchW5rRUi5LWqY2Wan+yK6Z/ziOv7h9n5sjlDljh
         gppJVjaSenxeYwbG14b68sHFsTeaXfvowbGI7u7L3E/6Opogwuti74HwOTZ0GeTkc6pv
         zlXmLJZQCPdmmU1iQWE59mzayJCV1+06HiebDTzLABym3aRBArAoXRWVfHr32GUmHphk
         hFtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HMSpATx3FoU6WjmgIUPsWFQe0qXX5jBJ5VQal2Jf2Kk=;
        fh=/5MLFBgWZjypO5MGbpkCKPSGqtBRVuMW1Dwzkz3Vgxc=;
        b=s85tgbgNSpFRQCZlvuAfE4UvUNYByNVTyPznIQzcoBI/9gDfIaRjVvZvuk2AS7mGRQ
         bpB7Ap6WWEHSSQC1B4SrMcpvkE0S/khja2ZxOOGtBdUFfMUbvXouVvN2ZRJCNxWiwQ5L
         zL3X65ZPgnKCb75l/VoZvfGl5KbsKsCDyWPgZC/wV2FDtoyF9HqC8Z9Q6VYYSxl3PTQK
         6g4bQ07Z0F4GqdE3KCN6hlnLNGvxfAGLMhA56/DJeGZ+0p+RjGJfevU7MvjWKOFi1EHa
         zUhwclbDRKJUcnC0YDzV6aHqRDl4ctprRbPRtXL46wMp02g75hJJvHBV/udhjr8hFpd+
         92jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794322515; x=1794927315; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HMSpATx3FoU6WjmgIUPsWFQe0qXX5jBJ5VQal2Jf2Kk=;
        b=wjcqRrnMLRqeNmideQXFPBAluQcGoLxK26NfYgkvg7vcn74TUIUaJDII/QVYi7IXyD
         Jei/4trZxR7o6oLIVTt4kK4wHng7FDoEe3ZBcl1p9HUN/OV40nF/XoDCZbnk0RJJTgjL
         QxMC3xdjJm+v8lNamZDbrHwyfbvDNwU9BsKWNknWqke1AJ662YmQIlX4DLXyOG8UqYwq
         MxIwt8iAXdOP/FNEIRIEeBFrraP7drPWQzHPhvj6phUJvNOQnGbll93zdC/O0gL5J+uV
         7YetTZ3clTo2a7yWRHlteHNXziOrcwYWUbaZuNTpfisYxtxDzL8LgWAgZwJeEq85ZAE+
         mZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794322515; x=1794927315;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HMSpATx3FoU6WjmgIUPsWFQe0qXX5jBJ5VQal2Jf2Kk=;
        b=DzRtn5sHCalbca6c7ZXQFtSb4gnIPO/K1wmeIlGUc9SEa0PdmNCZUDelEj38UkQAxT
         0xlof5Hjx2PjOMbxpP+7f5KMfEzlQcZHddZvxdin7fTdoiyDSfa6jtLNHudQifxxIpdz
         MdlCUuJTqh7t8TZTLRfRLTTjO/hFky7ZI0d5IGT21ikAYcYQOIADJP6Tb+EbRlVCL9DV
         tTTt0rGvMS1EGRSXGKlJGANJB1oDVhaUUV/bZpotF67sx0alh1wcmmXODtsb14UiRpK1
         iCYw2DlLuU+zKQVTiNMxvuRt+UXBeWz7G2gVcfeUCop+GaIsDFXfDINtmTfFni+zlzbl
         DjTQ==
X-Gm-Message-State: APuU4Z+VvJMjSff6Q4BLnPrH9GmN8o9dTwyLSqgdxcYdlBBN+xd0r3Ft
	AE1QrH9cU1xwqIMkT3+YRGj3ZJ7c/UvGhA0gb6ldAxet9cU98+HVI1h0Fis1yBOLXQrujQLaZYn
	tJicQMRvB/MaqWd5T+sm9BRHHy8ZW29Y=
X-Gm-Gg: AYBFou2UgvJAI0KT8IgcRsWEieUGweGjxVKFSvHvxE2RcOjoWVDkysOTJfhNDlH9MD8
	kOwwEW43VHRu1YKZZLTKTExQk15UOfLmZEb53vqOO9F3nDUYyU1L545tJPfu2+TWUiRC5VrpUL3
	uPsImfjdVn3LME140hsrQvfiXLDv+u2/6aKHQInIvZ4DoVn0BMKURMtL/gYW6YK9a2Ne6Zk+X/e
	TqPyiEzvJNtQajagzf1Y2+mi+l0x67XrTIixdlPzy3OdMejhGz/1e1MLM8oUnj0Kdt6zCld2Dfs
	KoA1pU7j+TtklXyYJXB3VX6nAQ34sPwi+3njckmXllF0jAnzD1ov+Q1g7/f8UjlfNvbbgr/Fgvn
	dBqpSqlGsId7zjtttMxQrCG8x5phWfxTkVLO+akd8joJ8CnfSqeBTQd27E28MN5ui51RPFA==
X-Received: by 2002:a05:6402:2355:b0:6b4:7938:2cab with SMTP id
 4fb4d7f45d1cf-6b756afca1fmr2337402a12.32.1794322514249; Tue, 10 Nov 2026
 06:55:14 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <412ffb1b-f3fc-429b-8d78-8b1a9e8d86bb@infinite-source.de>
In-Reply-To: <412ffb1b-f3fc-429b-8d78-8b1a9e8d86bb@infinite-source.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Nov 2026 15:55:02 +0100
X-Gm-Features: AclHuK9F1DgbfrAhbTtf5Fh-Zui3KaNxhkpHcOajGHaVuv6VVOhhp5gaZoiVkh4
Message-ID: <CAOQ4uxjEQMgLq=LFzpb5K20hgoHWXjyTxRQWs-qTPFym9p-jww@mail.gmail.com>
Subject: Re: Bug: overlayfs does not honor pwritev2(..., RWF_NOAPPEND)
To: The 8472 <kernel@infinite-source.de>
Cc: linux-unionfs@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 3:16=E2=80=AFPM The 8472 <kernel@infinite-source.de=
> wrote:
>
> Hello,
>
> I have observed failures where a positioned writes using pwritev2+RWF_NOA=
PPEND
> on an O_APPEND file still appends the written bytes instead of writing at=
 the
> specified offset, contrary to the behavior promised by the manpage.
> Github support confirmed[0] seeing this behavior, specifically on overlay=
fs,
> other tested filesystems were fine.
>
> Context: I'm trying to use RWF_NOAPPEND to get portable behavior for the
> Rust standard library's File::write_at()[1] and linux is the one that's
> not consistent with other unix systems.
>
>
> [0] https://github.com/actions/runner-images/issues/15277#issuecomment-67=
68886675
> [1] https://doc.rust-lang.org/nightly/std/os/unix/fs/trait.FileExt.html#t=
ymethod.write_at
>


The fix is staged on Christian's vfs.fixes branch:

https://lore.kernel.org/linux-unionfs/20261105-clever-vorkam-selten-1766828=
67893@brauner/

Note that it depends on this fix which is already in mainline:

https://lore.kernel.org/linux-unionfs/20261029-work-fs-ai-fixes-v1-2-88f227=
92f6f7@kernel.org/

Feel free to test and report back.

Thanks,
Amir.
