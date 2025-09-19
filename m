Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AC62EBBA2
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Sep 2025 13:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287374; cv=none; b=Y62F0Whxk0WCr+TdDdl5IVCSSBaVewr0Q3HpR5a5d9FOzou57qpKVNRSj/2rpPkF/90i8hi4IPVy+51fer9eEzEpDGP+mn1herScZMeKNCxr44/0G0mISQ4j80sHeO2fiYNPakOmJ2G2X8jWFIR0Rmw4URc66vqe6OyugLHvnv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287374; c=relaxed/simple;
	bh=H2nghK4bl/H+DNUfQhtZLwYHG07QNLlFwkEd9mrXbhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLwqoPYr59pXKAqqvPSDOqsmDeXLncdx6D4kMH/AGSq5rdo27mAc5SfRJRoWYdvNMMACRY9a5v8iJvMp7G61Ar4rBpmnbvzVHiAJ5XuJISqriYGd1VfllopDUt3vLF3zKFZH8j1HcCCyYu911LNAIt5VLjepj9kRm0l1+YqLhtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BQIPISGy; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BQIPISGy"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so3290741a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Sep 2025 06:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758287369; x=1758892169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2nghK4bl/H+DNUfQhtZLwYHG07QNLlFwkEd9mrXbhQ=;
        b=BQIPISGyaL9K2DiFORwYXbLp0t2u4Qq7Wi9F4RNLMuSVpyK66tSAoNsyEIYswqWV26
         iNyNMFsvPDMLcyCx5Brope1KQRqcyBHMz4yssiys1snjyeR3l1GIcRFDsIjglAi9HvWj
         IlBVLk4wEYQGTNNyUT7TeWjslzh1k5HuAp+0Qpsn5AsZ2NW8Y5UyHSzN70Zer329AMnZ
         n996bHOKl75/nauI8STW5nkufGGR6s1xIt3boi1DFvvYhV32fAvcCtgJqEW1NhPtORuX
         wm9IS6roqrijLmO1HE8RXHPiymNGhW+W2wOGR4/VZPeKOGA6ByVNxAJRMbvc1aw+r+Xm
         q8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287369; x=1758892169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2nghK4bl/H+DNUfQhtZLwYHG07QNLlFwkEd9mrXbhQ=;
        b=HV+Ix9v50Nc+JGnkohz2CIafJRcHp8EpgVaiOFQFZktQ8d37UherrpAeKldIule+mE
         fNAnfX7dNqqYNe7fvD/K/OJ7+9pizU+SHA7tsWblU9jRVHPTuKXgPB1XDol3i1d6D0n5
         9536nk0AYnaE+2vG/yhnpQsJ8eKtXruogHKQmxon9F9kVgqKgn6Aq4R9Y1ADA11O7V3D
         44IMLGNz6Z/oTrbzIe1zxN0w1bXkfwpsC8PMX21my6fuUF/XC1OivmFOoZ6FaIjNAIEE
         8BACLw4Ip8h02zjGNgL39d9JRiEcSEX7viBukAOzX9FmLDQRCXCwnrLWiHvr8mj07GN0
         DpBg==
X-Forwarded-Encrypted: i=1; AJvYcCWBk8uCEkVVJ9yDYAiQknhFswUcXERMBNtlns26jeZdSsnGP3aYPkcLM7MZ0faRmWjjonQnlPTEVgBTQPGQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyI4xRgv+OpEnEWXJoTt70uExXp2zJJZTcFKxoq4fwNEQUtPkn9
	KUeS4mdGILu+lgkJVVfwVWtMOVWwuQw6mc3SaO2wgfiCjA9Yl15iTvuZibILu+UpkByc8h8Vu5x
	73Uwrywct8dydjevmHIfVR45VKmlqjQ4=
X-Gm-Gg: ASbGnctfSgXeYAYRSRQk9rZ9KvBpYhv6yLWENZ8j0BfE81AfTsmYMPcw2x6+sqcAY/N
	7fxgv8kGSVezZEiHjlLR217hEHPVe7SOolnVG8lZ2SmMIExZDmGaRXhBawcW13AAOPlP5kbCg7u
	Jvk8ustS9ZQphzgjnRwP/srv7m9E8Oaj09f07o85t4gR1RXrVPiangnTXSDkmFtMh1vAENW+smm
	WbXBVjWzmoJfJcAYnOkEUoBsMNxFprlYbQ+4j8=
X-Google-Smtp-Source: AGHT+IFApfhAHEjMUI5U299k57YwKnPsMN/Ik0b5HX6lVlpdtHbeIxsd1Q0r+GQz5I22vbwNy4Ut9U4zuDgZ7sOE0qo=
X-Received: by 2002:a05:6402:5343:10b0:62b:2899:5b31 with SMTP id
 4fb4d7f45d1cf-62fc08d40ecmr2418056a12.5.1758287368510; Fri, 19 Sep 2025
 06:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916135900.2170346-1-mjguzik@gmail.com> <20250919-unmotiviert-dankt-40775a34d7a7@brauner>
In-Reply-To: <20250919-unmotiviert-dankt-40775a34d7a7@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 19 Sep 2025 15:09:16 +0200
X-Gm-Features: AS18NWD5Om8yGekTULVtEvApOLHSTiZijG74rmoXqBK7CgJeOnhoxL1KEl8c09g
Message-ID: <CAGudoHFgf3pCAOfp7cXc4Y6pmrVRjG9R79Ak16kcMUq+uQyUfw@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] hide ->i_state behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 2:19=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, Sep 16, 2025 at 03:58:48PM +0200, Mateusz Guzik wrote:
> > This is generated against:
> > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=
=3Dvfs-6.18.inode.refcount.preliminaries
>
> Given how late in the cycle it is I'm going to push this into the v6.19
> merge window. You don't need to resend. We might get by with applying
> and rebasing given that it's fairly mechanincal overall. Objections
> Mateusz?

First a nit: if the prelim branch is going in, you may want to adjust
the dump_inode commit to use icount_read instead of
atomic_read(&inode->i_count));

Getting this in *now* is indeed not worth it, so I support the idea.
