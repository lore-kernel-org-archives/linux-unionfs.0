Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29A9389118
	for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 07:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777275799; cv=pass; b=JhsauyaEGrI9zO6RxyZ+YrKEx+t6xvCCiYfjxKRScwKSgjTm9TqmYopBjXYz1dmTLeSLBtfY5P9yh1mrLVMmdS1XGIxXf2qE3VkbcxVQI6ErPyQ5eZRvJBb/r4fD4NWCAax8G7jH+O1bWK2mKtXr8nANNI8CaeK80Gf79DnSRjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777275799; c=relaxed/simple;
	bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUz2IkMogKy9kX7qw4T0pjawlgVSYFp742pM7nF4vT7AS0sBrRTexlBv/WBKgWDLxesf7KTfP64SHzh/8ikVHRstZ584IF4g+IWEVcPyuIlZXnexVVmemcnqwaaHRz6uTMYEc7VhC2xnwS3v7Ytytwn13R/TMeGs7rohn5NfHqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/FA44Bb; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/FA44Bb"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9c3a9fe80fso1461483666b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 00:43:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777275796; cv=none;
        d=google.com; s=arc-20240605;
        b=ELqGCKQ2a31ZimBWiPim3WE1+mM7L10sErMJh1WVwLhGEH9GercZH+INRw1piSNvcr
         70T6sSy2Y4hZyKEF8x+1KplkilTK2RhSBTJTpuF5Tzde+9Dc2MpkhKZJkFE9ZEq6IkZJ
         j/PuTcprUQ5iajmSJhHnYxY7eLiDgQM4ua3KO+7HF853RJ7rUYTslFlbEpse00XR7tqw
         SF1zGBm26y4cA+BKA4/SGZycz+dhgBgidDu9zORNjw0HtWcwC8rH/TtgNJE0cJ8ooG4s
         /h2/bgLWOOR9mk8pFgl2ZPIJBHCaSpngM6svVjhej4pwHCCTtiR8TrspjslQqENouqYg
         rfYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
        fh=/GmLRv1SpAgoow4jiEcZDJKD8XgHQr9Ht0Y45McqP/E=;
        b=ST5RFhtWTptH1ZVptWfwFsEOIpMvDucfx0rmixHmV+svYPXeLmFG3IOml+iQQUeFhi
         +9r0HWAVrMsrTlF9Snxkk3kU8oIdezGyurRBw4vhQRc8qkPcuppyzAjASh0YpP1WnCHz
         l0wbaXsTnY8vTab8MYBbhlOfvtkIbNwMuhSFcqDxls6pud1jB5bMzsJZVYpF4E+ID80Z
         ytwy/XhzcF6OBxCM/cbSRSq9pLyaFeFWxUUtUWEltcWkkbURlhrJ3pfyqsYqozB/MtU5
         MDjCII2uoHIs5Jf/0erd6D4Sjrd3lwar+ZjTdE0vEtIb+6tJkckbdCunmu/vfqhKSkRk
         po2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777275796; x=1777880596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
        b=a/FA44BbzZXxxbedD8kE5+H1vrImlqqwN3YbeQOMdARXbVawR2vWZ5mOHYsA0YlO6v
         +mNHBShRUXyetKieaB97logJ3fHpKQfperZrl3A1YBRmfKG7kWwRx+OyWr2e4qHevHdI
         FkSbpfYlqPq1NF1ZGronloT46QL3AE0W1eJi35NbAOuLa93pZfVe2V8dNf/QqjdRZws0
         ccmYmpcAf4FGllvW8jDeuJuKAoC7AeJJj4aKFMgI4ZGbnMNhE3AXwvuBO7STe9DrOEVz
         0kGo3j33hKJgLfhPoGH91kHzGdQkBkILo/RhOF74RxQojeHWwmocHhlB52HiIugGKkx1
         ZoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777275796; x=1777880596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
        b=M8tDVzMg6Fjh2ZfVJ372RO2+cVyWw+8Wdqhr5x9vYIQxM8qbANlZLHsfbHpveUCJTN
         n7AKjFf9hEUDIp+/vKocx527llJLfh137IN1nxpN2zasKxHDhOyriYdeKnRyT11Q9Bo7
         X99eGhX/J2zywkZKxRjVPlkwJ/+HDTP4RsC8vE+poPShb5jKB0kYUZu9zZsPU+s6T3Kq
         b1qXl3rYYa/dlsj/ESb7AdPO8w5aviGS8iDJjaoAKzyPQ1Qciarda07ji5aLgNhjmkRx
         WKXA7v1YlIUNmt63C0rQbqww9yNVe6oH3w4rQeAqfB7s+p/ThgLDSRXzYHeAADULPKVk
         QwbQ==
X-Forwarded-Encrypted: i=1; AFNElJ//OWd9d62pcDDmS14Dv9vwix5c7Zg27WWT9bUulXdoSFFfz1o6jj5aIoKMvR0XNOnzn0nL3jhs6BlYvNuu@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2I4WmRVYkbjFnJD/ceD8qsMMdsWeBH+lHjL3TR/W0Nf27zaXP
	1yHnZpcvLLKrcwhNgK8O33/Bd7ZGbQEQxQINfaBDD3Hyk3Gy2E9wmu8VpvgdbcLW548g/Ri6Ffg
	Oud1HkzwI2yw82/syUUPgjkNH1hlXbBI=
X-Gm-Gg: AeBDiesaD+RDX9xAHKmyV3LGRUvYIfbMeIfemKK5S5eZkpEpWIHK3AbxsZBOzFfzvIt
	XnO3P/x34VY2Xl935pf6v/SrTPiWKgMU5f1DtfdJc58tsiwnCmZv8/Uv4iXE0QHHNoHgZkK9+A3
	7U+/rW7Amx8s7pyAa38H28hytSSGMAyMx93Zew82IpVkQ89MuxpCdkhoATOqbFkOg8XOlMsXW8X
	nUzNxtM8HMZLzGuWuapIb8XwmhDH7XD45zOP1YhTHYX+5z2Is8QZz6yNplcTTOEGCgR0TqXunOd
	LByfKXWIFhP4sV9FM+7p3rlUR+sEc0upJzS4evLyu4psPBFkItfH
X-Received: by 2002:a17:907:c30f:b0:b9c:bc70:e928 with SMTP id
 a640c23a62f3a-ba41a91d717mr2121879166b.25.1777275795629; Mon, 27 Apr 2026
 00:43:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-8-neilb@ownmail.net>
In-Reply-To: <20260427040517.828226-8-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 09:43:04 +0200
X-Gm-Features: AVHnY4Li24Tmq3-41JYR95SCf6Z2AFdg2a4cjT7d8-aaRtTKWrSVG2trUoxa1eg
Message-ID: <CAOQ4uxi8rqkbhK4=8N1ncfU1m6bjdHLbinSf=j3k0oVEaSa-wA@mail.gmail.com>
Subject: Re: [PATCH v3 07/19] VFS: Add LOOKUP_SHARED flag.
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 6:06=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> Some ->lookup handlers will need to drop and retake the parent lock, so
> they can safely use d_alloc_parallel().
>
> ->lookup can be called with the parent lock either exclusive or shared.
>
> A new flag, LOOKUP_SHARED, tells ->lookup how the parent is locked.
>
> This is rather ugly, but will be gone soon after we move
> d_alloc_parallel() out of the directory lock as ->lookup() will *always*
> called with a shared lock on the parent.

Neil,

Forgive me for being skeptical about the *always* part.

How long ago did we add ->iterate_shared()?

It's true that Linus eventually got rid of ->iterate(), but we did not
get rid of the assumption that iterate_shared() might be upgraded
to exclusive lock.

The obvious reason is that *someone* needs to do this work for
old filesystems, which are also hard to test and nobody wants to
touch them.

I have nothing against this patch, but I think it is more realistic
to state that LOOKUP_SHARED is here to stay, so if you think it
is too ugly, maybe there is something to be done about it.
Personally, I do not see the ugliness though.

Am I misjudging the situation of shared lookup wrt old filesystems?

Thanks,
Amir.
