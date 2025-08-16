Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A716E2853EB
	for <linux-unionfs@vger.kernel.org>; Sat, 16 Aug 2025 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755346453; cv=none; b=ovh66yDROZi+mDUfPJR6dU9Uax+sfKVG/qNZ0Hj+Z0E09Srmi1ETn073NJ5pmwjdVE9aSB5rOtBetH2qmub8tDZJxMKqDgixWU5B3YnfdMNJyLv7ETL7HDb6OjMCsu/rfMfCKG3yLiuhlOO+qrxnF9iUy++c+CozoPSE/U57+0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755346453; c=relaxed/simple;
	bh=BD10JVkC3R7DkPjy0YQFa8uERMYfZwc8NczxD31yOCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C9vRQbozI36tC4y0bZOYdi+mjx0xkO10PTy415N1NLCWXHvLZlUxnHQtKCho4a/CDP9/VFAB1uc3PWAvIy/8Ua67Y+AlZHk/1b35+TSv2E57VSrxG2UeK3d9AZn099jquNn5sUKWdNpUjfAv64QbjlrO4gm3zqwRWyB5KSZjkrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I+VjRDHZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+VjRDHZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755346450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLWcRDhFZNlURBXrvT9Nk3wXpWaxYOYQFIQkZVfgJPw=;
	b=I+VjRDHZB6HXoNVMOAPK0B5r1UIqk00qiBwattew+ZXHfr936kMBqIBxmyW8l0Ff/wMEri
	cuWLH4JbQVoCAEdv4tmwEUDwjTwBuJ5O6zIOrTY0ObquG06Ca9HwKU2TIsULaGrwDoKrfH
	1Lw2tMPzg17S7pjR3mWaknrI48wfPQc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-M6cr69k5NKyoSQhT-lnjDw-1; Sat, 16 Aug 2025 08:14:08 -0400
X-MC-Unique: M6cr69k5NKyoSQhT-lnjDw-1
X-Mimecast-MFC-AGG-ID: M6cr69k5NKyoSQhT-lnjDw_1755346447
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-618b3c74f6fso1136568a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 16 Aug 2025 05:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755346447; x=1755951247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qLWcRDhFZNlURBXrvT9Nk3wXpWaxYOYQFIQkZVfgJPw=;
        b=LvhwiD7/CBx1ZBcxcwOztGq37RzpXDC75reITQCqdYGElWPu8EkAG0Cz5gMrtP8pRj
         OlnXm1fvdVjnj2B8ZrUMLWA6xiNurB44b9MrNnnlwPvcI1+8lSGq14SYAMzvlXs9S8Ev
         fTQKuvOzQkoX7MBYZSY3FXG1AC1ZBCfUqzmSTUVjpzJj9P+TKQOUP9spOT8SYorP2PxA
         I3cjLe51AmFUU+FxMNIepXUkj5Duyac0H8AXJQ5tUX+bkiT7yi5MroccrlPzCNboVByN
         sEwFsYbGkY7lORKDULwHrdYZxJBOclaMaLHZjp5BL8Qu0eyXiozLIn07NkHyQCf08HyB
         DOzQ==
X-Gm-Message-State: AOJu0YyN11FLXs+xEjsuXCINcGG2THo3u5gTeUk79w6wS5jYBBDznjgX
	50l5nC+2yPrP9kWSvazaMQf3FEVqpPezxlHegdcrORq9BTzjQQO0mgmhiq0vmeaaFwVM8+joh0n
	psm/+ZLXlSnBmF5le/BkUidzMNYys6ktes0VeI1cKl0VXUGVjAOPiUPASXtCebtxvzVir+a6HE5
	aqzOC1GCbHn8WLr5eaFT6un1tYnPReQs11qnedfuN+gJ/jhylwtw==
X-Gm-Gg: ASbGnctP46lBD/mE4F4/BkjqM++6REu+0A7LxQ9M9fsMeaMEtEjVbTCyqc4fqwCJOy+
	/lp4KwlOymkBdFVxbqTkjybMYQOJJLVrVqIVoAiDp1h38KyjMIxehZQFqxi2FZvm+jHZskaMHcj
	NvSWsDWUHEG23/xrR4gFBsPg==
X-Received: by 2002:a17:907:c10:b0:af9:e1f0:cd15 with SMTP id a640c23a62f3a-afcdc248af0mr532387866b.18.1755346447035;
        Sat, 16 Aug 2025 05:14:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQjCPkWO4xFP0qiVY7R9QAi0veIzidLpinD+pqaN5Uyb1WZU9VKvwtELaQDT2JopefoCUyt5sDBU30jM+wlgg=
X-Received: by 2002:a17:907:c10:b0:af9:e1f0:cd15 with SMTP id
 a640c23a62f3a-afcdc248af0mr532385966b.18.1755346446516; Sat, 16 Aug 2025
 05:14:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815144555.110780-1-zlang@kernel.org> <CAOQ4uxjVpVPVfiJPokpmu6pLDmjtYbeDr+j5jNHi8k9bK_2feg@mail.gmail.com>
 <20250815153520.xzgxwuwc7slt34li@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhNhs4MPC1ZOTC5_Kzxe9DeFxD75XK6wkSFPjNducVBWg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhNhs4MPC1ZOTC5_Kzxe9DeFxD75XK6wkSFPjNducVBWg@mail.gmail.com>
From: Murphy Zhou <xzhou@redhat.com>
Date: Sat, 16 Aug 2025 20:13:49 +0800
X-Gm-Features: Ac12FXxOHZLATSVAHEA8quqmmu4KM6Oo8-ubvsyEeiu5_M_cGb5HNoU5IYLkzHY
Message-ID: <CALWRkkjd6jY6iqy=iOcFB1ABZGEhx+E26=ioVfsW0Ax9ySR6xw@mail.gmail.com>
Subject: Re: [PATCH] overlay/005: only run for xfs underlying fs
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 16, 2025 at 12:09=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Fri, Aug 15, 2025 at 5:35=E2=80=AFPM Zorro Lang <zlang@redhat.com> wro=
te:
> >
> > On Fri, Aug 15, 2025 at 05:16:51PM +0200, Amir Goldstein wrote:
> > > On Fri, Aug 15, 2025 at 4:47=E2=80=AFPM Zorro Lang <zlang@kernel.org>=
 wrote:
> > > >
> > > > When we runs overlay/005 on a system without xfs module, it always
> > > > fails as "unknown filesystem type xfs", due to this case require xf=
s
> > > > to be the underlying fs explicitly:
> > > >
> > > >   $MKFS_XFS_PROG -f -n ftype=3D1 $upper_loop_dev >>$seqres.full 2>&=
1
> > > >
> > > > So notrun this case if the underlying fs isn't 'xfs'.
> > >
> > > It would have been better if instead of mkfs.xfs, we would have
> > > used a helper to format $upper_loop_dev as $OVL_BASE_FSTYP
> > >
> > > But this is easier, so unless anybody wants to take on the better fix
> > >
> > > Acked-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Thanks Amir, No matter what kinds of underlying fs are all good?
> >
>
> All I know is what I read in the comments and git history.
> The documented kernel commit has nothing to do with xfs.
>
> > I saw this case use:
> >
> >   $MKFS_XFS_PROG -f -n ftype=3D1 $upper_loop_dev
> >
> > So I thought it need the xfs ftype feature :-D
> >
>
> Ha no. Overlayfs needs underlying support for readdir d_type
> but ftype is the default for xfs for a long long time.
>
> I think that when Xiong Zhou wrote tests 003,004,0005:
>
> https://lore.kernel.org/fstests/1461241438-24238-1-git-send-email-xzhou@r=
edhat.com/
>
> One of the tests was supposed to test the non-default ftype=3D0
> config and then 005 used explicit ftype=3D1, but I am pretty sure
> that ftype=3D1 was the default long before those tests were written.
>
> IOW, any the loop devices could be formatted with any base fs.
> The only thing that matters for the test is the small size of the
> formatted loop devices.

Agree to remove the restrictions.

>
>
> Thanks,
> Amir.
>

