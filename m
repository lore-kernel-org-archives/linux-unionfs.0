Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cg4M+oo5"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E848112
	for <linux-unionfs@vger.kernel.org>; Tue, 12 Dec 2023 13:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702415889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G0WO36JLXIv5AaAr7yVxA4KjLJZuBfSjRiR5T6MWPYU=;
	b=Cg4M+oo5St/YzM0hIx8Mx6CIpuDTebAXspCV1MaMeB0e/zfXvPGMb2OsKNKx1EuVpwzGiE
	LKhVwSdueKf6qbccrvjtm/iPy5ZqgCGJDp2UJPLdEc8GDic3VgogdSnHUyQ0RYuCzZeEAR
	1S6k2qMdabU5xF+dYKAkPfmNZZx7V7s=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-9Qq4IR0JONWENgoo8FyP1Q-1; Tue, 12 Dec 2023 16:18:07 -0500
X-MC-Unique: 9Qq4IR0JONWENgoo8FyP1Q-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5ca2b4038f7so848867a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Dec 2023 13:18:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702415886; x=1703020686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G0WO36JLXIv5AaAr7yVxA4KjLJZuBfSjRiR5T6MWPYU=;
        b=EVh7Vw7N4qnKpSU+PJMoJ946TxEmnUqRDC4HI9r57O0B92v5raymbC6+cMk1R2+K1S
         sSirPlTx1plKPbzn5OexSUrMZmzVHbfajNTFGRGO8fU2dgY7uv9CeOrL1qNsgABGKn4s
         +ayfddbEyPWGdXC3smB1EuKFIgX4c9bw/Q1iSXo8alfIiU2oOV5ckdklAVKA0pekPpJD
         HRCF3KCWmamyqfLALt199LrmXXdxAs1dVrELXYW9Uu6aTFeDqx8717vfuyH9fagDqTGM
         JfpEP5agIuV631h+d8R8vUbG9kqta0XwGk3MpWfEv3NAXaEoWSO452QW1sws+KU+zj05
         Sqqw==
X-Gm-Message-State: AOJu0YwKDG2f6wS8BcQItspPpZCw3+beu7iWEDvLDGxRIBTm15i+4uiD
	+BYwdcNTTYJdKUZEGcJeVfBHzGNQUgScAE5f0tQTYJT15viaZO+1GWOxG2qj9BW/bvR/Ui1Fdli
	dxsqpOlM+jM4Th1Pq6LG8U5OcL/ATVD4E2I00OhnQoQ==
X-Received: by 2002:a05:6a21:a5a4:b0:18f:fcc5:4c4f with SMTP id gd36-20020a056a21a5a400b0018ffcc54c4fmr3324484pzc.40.1702415886583;
        Tue, 12 Dec 2023 13:18:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGaBUhsIKPiauenUWhA450tnBxmPri38tJ3FEk9h3f5UdGgkVU3xuISSVrM65CvHBeTYR1IOqNO0hPKmoRXyW0=
X-Received: by 2002:a05:6a21:a5a4:b0:18f:fcc5:4c4f with SMTP id
 gd36-20020a056a21a5a400b0018ffcc54c4fmr3324464pzc.40.1702415886268; Tue, 12
 Dec 2023 13:18:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOgh=Fwb+JCTQ-iqzjq8st9qbvauxc4gqqafjWG2Xc08MeBabQ@mail.gmail.com>
 <941aff31-6aa4-4c37-bb94-547c46250304@linux.alibaba.com> <ZXgNQ85PdUKrQU1j@infradead.org>
 <58d175f8-a06e-4b00-95fe-1bd5a79106df@linux.alibaba.com> <ZXha1IxzRfhsRNOu@infradead.org>
In-Reply-To: <ZXha1IxzRfhsRNOu@infradead.org>
From: Eric Curtin <ecurtin@redhat.com>
Date: Tue, 12 Dec 2023 21:17:29 +0000
Message-ID: <CAOgh=Fw2TcOFgCz1HbU1E=_HGRnf1PTTG2Qp_nD1D9f083RwUA@mail.gmail.com>
Subject: Re: [RFC KERNEL] initoverlayfs - a scalable initial filesystem
To: Christoph Hellwig <hch@infradead.org>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Daan De Meyer <daan.j.demeyer@gmail.com>, 
	Stephen Smoogen <ssmoogen@redhat.com>, Yariv Rachmani <yrachman@redhat.com>, 
	Daniel Walsh <dwalsh@redhat.com>, Douglas Landgraf <dlandgra@redhat.com>, 
	Alexander Larsson <alexl@redhat.com>, Colin Walters <walters@redhat.com>, Brian Masney <bmasney@redhat.com>, 
	Eric Chanudet <echanude@redhat.com>, Pavol Brilla <pbrilla@redhat.com>, 
	Lokesh Mandvekar <lmandvek@redhat.com>, =?UTF-8?B?UGV0ciDFoGFiYXRh?= <psabata@redhat.com>, 
	Lennart Poettering <lennart@poettering.net>, Luca Boccassi <bluca@debian.org>, Neal Gompa <neal@gompa.dev>, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Dec 2023 at 13:06, Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Dec 12, 2023 at 03:50:25PM +0800, Gao Xiang wrote:
> > I have no idea how it's faster than the current initramfs or initrd.
> > So if it's really useful, maybe some numbers can be posted first
> > with the current `memmap` hack and see it's worth going further with
> > some new infrastructure like initdax.
>
> Agreed.
>

I was politely poked this morning to highlight the graphs on the
initoverlayfs page, so as promised highlighting. That's not to say
this is either kernelspace's or userspace's role to optimize, but it
does prove there are benefits if we put some effort into optimizing
early boot.

https://github.com/containers/initoverlayfs

With this approach systemd starts ~300ms faster on a Raspberry Pi 4
with sd card, and this systemd instance has access to all the files
that a traditional initramfs would. I did this test on a Raspberry Pi
4 with NVMe drive over USB and the results were closer to a 500ms
benefit in systemd start time.

Is mise le meas/Regards,

Eric Curtin

