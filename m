Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD90786345
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Dec 2024 17:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733852229; cv=none; b=H863b7OyPKmFa8AXjnshP0OrwI/iDLCNo3IwBQjIQq7dHisK/qz/UWzqMstQKXTcj0116hZbVfH0fRZ/Hl2QOomRurLJhjs+qdGs+mibWc4zf77+I+ISxiiIZot1rDUbIfOtfjzmJ48XzOW1xWHHEPLkRDlaK9OQXjVnJqJpTds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733852229; c=relaxed/simple;
	bh=4PaP1GU4hdWTOosAKA9Jb/ncwbq9kkaoBYo2Z7yYX3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qIQVT6h4Ii8LxpEtX0JCfD81Qps54zPhCt3sy4xCjsfAoy9p+YNjTMPkG/6b5zQcPXb+zyUUwy1CMd94lShgPufxSgca3uklM3+lvhG6FG44Uwffwgdb4ygtYhl+AN3CU9gP6KYYliKdDe9PdWMIF6O8F01trxkhFJu2MQVJdyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0WMlny7n; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0WMlny7n"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3e638e1b4so9803a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Dec 2024 09:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733852226; x=1734457026; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wzu7X1ZjViJF0SXMKQho06IRqPzYv6DxoYltDYvQnk=;
        b=0WMlny7n+NdxbUTkuC7pNb4Hjr5XkPYA6tHqhvvg5Fiv8lstPHQdVbpYiiouDOmGDt
         P/716+xm/V4FR4qXqXqayM8pGNjinn/+KIuYVjcP3cUEef2rcLNONGJUCaWKq0xckZtv
         QFVbNkGcwUigwaDH98gF/tA63REmVC4BrbV04gfyrPxUnDavfq+/Wf+n/Df4o0aH8ac6
         jWwINpPL+A3GDbVPoiSC31ToDpIp4Pt2J9sWZSmhSh96cKV87uVtEFPbZL7WwFMg6dcB
         MhRjdJcg9AFhH/xxrOejgRDb9AcRPJytOHNIevWjPkBBxDerpftZWkC1iawvv5RzW2gv
         UHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733852226; x=1734457026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wzu7X1ZjViJF0SXMKQho06IRqPzYv6DxoYltDYvQnk=;
        b=RSgPVWrkyqIp2wNE4WGF3ELgU6q1kip7NyAV4UHyvVj5qPLJtXs/fyoJ0LckXBOWsj
         yXzciyMPBIwCLKo4JFptFqMDG/lAd5ztL8oLP5YKYFsRryymi2RAS7hnzn+9ukxfyxAQ
         PKVP02P8Ppr2SU1/V2wV5nHYG7wuELoQtTFTVZ26aqaIGHnE6CzppdXavTfUdD9ZvsU8
         i2ogQRcYiebAPGhzQo+J4kH2D0zjsaPci/J5Y/uTwgJfqRrjTAEoIrZ8YS/GzDPNpR9J
         rG7WzDkreCe1Wm1YT9EAu+9Vb6HFlYrUH0aSRh5FYZwyNrSREynZ8MuQqjfNjhNaYDud
         5TxA==
X-Forwarded-Encrypted: i=1; AJvYcCU0DATiOUkohnAb7xBLrj/zz2c/4wY7IQNs0ueRW1J/tkQBTbx232Uxr+M2tk8UUgj3jGlZF9wMoVDf2Gq0@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb9wJPwvwoIWTfjqaXGPALAOp6rgzpXt0W201Po+YHwVe0+sR8
	MCRRN4uiLH8tPQ+CIPf7KUXBNPVjo5GoBB3qsEfDbMbtxDiiNdNnEfiXHVoee+sZOeP22epxthg
	M8FPSrTIFafgU6pz5+r37jYw22ND7ttOHQkhv
X-Gm-Gg: ASbGncsMicNQeKDANd/QFSe0guAyzCNscncVkIfcpeCemLcSlUc5kWGTz4S+rKbPQJ9
	4GN34Jiexk69FvjjV+MPXjoZ6priD0NbfjSXerRJ88Hn0eMxzp9hoMYfV4RgQCv0=
X-Google-Smtp-Source: AGHT+IEdARILfjyINLngpuK+SsFhjFPi/HteqqvHDbkb0RqEV4fKS0qkKFVjCwpZ4InVBwgtudaS9P2xqeLiIDBGol8=
X-Received: by 2002:a05:6402:1104:b0:5d1:22e1:7458 with SMTP id
 4fb4d7f45d1cf-5d41f6efed8mr136449a12.4.1733852225608; Tue, 10 Dec 2024
 09:37:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local> <CAOQ4uxjLZJXDm+7aiFsEtiUhvux5U=dftw7eNBpk55J6wW9XBw@mail.gmail.com>
 <f773da0d-38df-43ad-86a9-6cba785d53a8@lucifer.local>
In-Reply-To: <f773da0d-38df-43ad-86a9-6cba785d53a8@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Tue, 10 Dec 2024 18:36:29 +0100
Message-ID: <CAG48ez0u3H7FtC665+KLZgJAfffSMoOXqtMx4rwxdOvTkP0d=Q@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's get_unmapped_area()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu, 
	akpm@linux-foundation.org, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-unionfs@vger.kernel.org, wangkefeng.wang@huawei.com, 
	sunnanyong@huawei.com, yi.zhang@huawei.com, 
	Matthew Wilcox <willy@infradead.org>, Liam Howlett <liam.howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 4:24=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> (fixing typo in cc list: tujinjiang@huawe.com -> tujinjiang@huawei.com)
>
> + Liam
>
> (JinJiang - you forgot to cc the correct maintainers, please ensure you r=
un
> scripts/get_maintainers.pl on files you change)
>
> On Thu, Dec 05, 2024 at 04:12:12PM +0100, Amir Goldstein wrote:
> > On Thu, Dec 5, 2024 at 4:04=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > + Matthew for large folio aspect
> > >
> > > On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> > > > During our tests in containers, there is a read-only file (i.e., sh=
ared
> > > > libraies) in the overlayfs filesystem, and the underlying filesyste=
m is
> > > > ext4, which supports large folio. We mmap the file with PROT_READ p=
rot,
> > > > and then call madvise(MADV_COLLAPSE) for it. However, the madvise c=
all
> > > > fails and returns EINVAL.
> > > >
> > > > The reason is that the mapping address isn't aligned to PMD size. S=
ince
> > > > overlayfs doesn't support large folio, __get_unmapped_area() doesn'=
t call
> > > > thp_get_unmapped_area() to get a THP aligned address.
> > > >
> > > > To fix it, call get_unmapped_area() with the realfile.
> > >
> > > Isn't the correct solution to get overlayfs to support large folios?
> > >
> > > >
> > > > Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=3Dm, w=
e should
> > > > export get_unmapped_area().
> > >
> > > Yeah, not in favour of this at all. This is an internal implementatio=
n
> > > detail. It seems like you're trying to hack your way into avoiding
> > > providing support for large folios and to hand it off to the underlyi=
ng
> > > file system.
> > >
> > > Again, why don't you just support large folios in overlayfs?
> > >
> >
> > This whole discussion seems moot.
> > overlayfs does not have address_space operations
> > It does not have its own page cache.
>
> And here we see my total lack of knowledge of overlayfs coming into play
> here :) Thanks for pointing this out.
>
> In that case, I object even further to the original of course...
>
> >
> > The file in  vma->vm_file is not an overlayfs file at all - it is the
> > real (e.g. ext4) file
> > when returning from ovl_mmap() =3D> backing_file_mmap()
> > so I have very little clue why the proposed solution even works,
> > but it certainly does not look correct.
>
> I think then Jinjiang in this cause you ought to go back to the drawing
> board and reconsider what might be the underlying issue here.

To summarize: overlayfs switches out the VMA's backing file in the
->mmap handler. ->get_unmapped_area has to be called on the original
file, before the VMA is set up (obviously), but the VMA's ->vm_file
can only be overridden once the overlayfs ->mmap handler is called. So
the ->get_unmapped_area you see early in the mmap path is provided by
overlayfs, while the VMA you have in the end is actually basically
just a VMA of the backing file that doesn't have much to do with the
original file.

So I guess some possible solutions would be that overlayfs forwards
the .get_unmapped_area to the backing file manually, or that the
->vm_file swapping mechanism is changed to use some new separate
file_operations handler for "I want to use another backing file" that
is called before the get_unmapped_area stuff? (But to be clear, I'm
not saying whether these are good ideas or not. Maybe Lorenzo has more
of an opinion on that than I do.)

By the way, I think FUSE is kinda similar, FUSE also has a
"passthrough" mode that uses backing_file_mmap(); FUSE also doesn't
have any special code in their .get_unmapped_area handler for this.
But FUSE's .get_unmapped_area is set to thp_get_unmapped_area, which I
guess the passthrough mode it is sorta wrong the other way around and
unnecessarily over-aligns even if the backing file can't do THP?
