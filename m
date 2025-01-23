Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9706212F86
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 16:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737650684; cv=none; b=OKwj1XAca752QWXguismjmcxQ3HsHOH2UO80tKmbnpre3pP6H1sammQLbfNuRnEW7mU4pkCEeAm1kvtYtSKJwwLGScu/iqO0HZB6N71Vg+v7qgz3YwYSbhyAYkPaH/oUWMunaFaA/Njued7ViYWThiNk4pW+O/fhE9L6VermtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737650684; c=relaxed/simple;
	bh=ObLA/kRyNpxub4JtVmVOW4oMY0X5R09ng2DbfPm+cE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cMqUWA7QS0aNkfCEI+nTieqpgfwi2W0JukguOugD1vSw6Qus98JtlfckXA2UgISYQefGRWPiViOgp2cujuOuacjLImizI9G1gbVLN5Qenu7DblbEoX7r5KG3KrvQmT54BfslELEWAJFEtd/fNcY7UU4hJTtJyMaZ/s0CdiLtgvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=engflow.com; spf=pass smtp.mailfrom=engflow.com; dkim=pass (1024-bit key) header.d=engflow.com header.i=@engflow.com header.b=R87uOcXN; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=engflow.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=engflow.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=engflow.com header.i=@engflow.com header.b="R87uOcXN"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30613802a04so11443921fa.2
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 08:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engflow.com; s=google; t=1737650680; x=1738255480; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ou4pI4NzHMmTf/zMB0eJzxRFKrkTtzd88Z63Stl79E4=;
        b=R87uOcXN3tKz3pnyzlr7otr1/Sk+3LeMvg9RMMkF0jpneZX/Yu18n4STNkzxR6z1D7
         zKEcHL/9qHuZ55wY0mL+BYd5qztChZB1dvFaIjhE3haNuwhXnDfibUfpsGbjQjvBYCfK
         AcJffTMuDyXErajK+uRC11HC/ZpOQW49ItRA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737650680; x=1738255480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ou4pI4NzHMmTf/zMB0eJzxRFKrkTtzd88Z63Stl79E4=;
        b=mQSZR2WdzB4CXqc/ZVtwtzUJLDwS1+H5ZJGG4mNjUX9CJflg6uDgusPpX4eVfjPD4R
         XZLGuYaRRN8wSyBuOxzcgJb0pMtN8rrauFcxeWfi23sql+GPl46BKzXrLdhFXVy6b3ng
         TpBiu+ruWIA+aJmQBCTbUFSHvl4cJPrqPlv8gneb/QLfoyQEmSjL3cBLWd6VL+jSeq5u
         un8NxTqWSVawSP+JZKbHHft0gLcnZGS+1CpbpzeNNXbDvki6pAZ9iQWJPO9FPdgrpKbL
         AKfP/ac2jU+sZbEiCJGiY7wGw0EAHiP549sTcmpnBS+C1xGz0crm16ciaf7ViqGCoFlL
         rOEg==
X-Forwarded-Encrypted: i=1; AJvYcCUnuAxjhN7kHrAh/Sv2G1rosRf9+RpSMxDQgh8ruv5VH0JV65953UQ/Tl/xK75QWR3ODjRhpZl//327DEI2@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu3J6YLCw7UXVjCaBB+CR3xMdwFZcVsxG2gwZYpFHsBKxsYhfp
	3FOHDwVbr3JerycahgPk/Pr+GK08dkOCKIEM/GvnyYVCPdnc3fiIIcocmYFJCkC8YJUDFNxOBWG
	lklnVoMRnZB2DKlC7s+erPg2QNO4y22NO81LZh6STx3U6V+zBirlZTQ==
X-Gm-Gg: ASbGncu5PpwopuXy1u67yn/xIH/6Q05M5Tn6uPNiCYeB+I0YwJbl0DzH47cEp9urMqd
	ZlGZCTdzNaZgK/Q8dH6VYucaEsbxN9x5Sb+Gcj0Sf8U7AXxHWT3D8AjnWw/YGHDNM4MvVPpNpt3
	356e+UQVQvntDCDR+B56iS+ebijCFrlQ==
X-Google-Smtp-Source: AGHT+IERtY9ag4YmfMpnRsuctVwLQvPk5qsp5gWs2L8S87rQpVhC1dxslbIpQl21auF/0qR1KhWLVCU4PZItt4HKzYk=
X-Received: by 2002:a05:651c:b26:b0:302:40ec:a1bc with SMTP id
 38308e7fff4ca-3072cb133cbmr93810061fa.30.1737650679630; Thu, 23 Jan 2025
 08:44:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250123081804.550042-1-hanwen@engflow.com> <CAOQ4uxgwJuZWQ9WgpmNL=fdsycwduOqXio5kEciD6TOWoMX8kw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgwJuZWQ9WgpmNL=fdsycwduOqXio5kEciD6TOWoMX8kw@mail.gmail.com>
From: Han-Wen Nienhuys <hanwen@engflow.com>
Date: Thu, 23 Jan 2025 17:44:28 +0100
X-Gm-Features: AWEUYZnRybytUtR5qyw30yyyr8CJcf1CVeH8ds8oUePFLuVRDBADHuixfJegSsU
Message-ID: <CAOjC7oMAYPeS94eDrgzYV0=5PNG_8i11SF5+vsffDfOTFuA8rw@mail.gmail.com>
Subject: Re: [PATCH] fs: support cross-type copy_file_range in overlayfs.
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2025 at 12:10=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
> after the --- line, but with my suggestion below, you should probably spl=
it
> this to one vfs patch to change copy_file_range() interface and another
> patch to implement ovl_copy_file_range() support.

ack.

> > I thought this could speed a lot of operations in docker/podman.
>
> What sort of operations are we talking about?
> The only relevant use case as far as I can tell is copying
> from a shared lower fs directly into overlayfs, but why is this useful?
> to which scenario?
> Do you have an example of use cases for copy to another direction?

My use-case is the snapshot/restore command, which copies changed
files from the overlay mount, and stores them into a tar file on the
podman storage directory (which is on the same FS as the lowerdir and
upperdir), Restore does the process in the opposite direction. Since
the tar file lives on the same FS as the upperdir, the copy could use
reflinks. I prototyped this at

https://github.com/containers/podman/commit/dd54c885cbe6f4d08554c886389546f=
215af1817

(timings in the commit message), but it hardcodes a path substitution.
It would be much nicer if copy_file_range() just worked.

Also, copying files into and out of containers (podman container cp)
would also be sped up.

I have just become aware that podman/docker also supports btrfs-based
storage (iso. overlayfs). If I were to use that, I suppose I don't
need this at all.

> > I don't really know what I'm doing, but it seems to work. I tested this
> > manually using qemu; is there an official test suite where I could add
> > a test?
>
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> See: README.overlay

Awesome. I knew this existed, but didn't realize it went beyond testing XFS=
.

> For testing your change, you will need a tests/overlay specific copy_rang=
e test.
> Let's talk about that if that becomes relevant.

ack.

> > +       bool in_overlay =3D file_in->f_op->copy_file_range =3D=3D &ovl_=
copy_file_range;
> > +       bool out_overlay =3D file_out->f_op->copy_file_range =3D=3D &ov=
l_copy_file_range;
>
> I prefer if we did not add the support for copying out of overlayfs
> unless there is a *very* good reason to do so and then

The case of copying into overlayfs is the one I'm more interested in,
as we're trying to reduce app startup time by restoring a container
snapshot. This involves copying FS diffs into the container.

> Note that cross-sb copy_file_range() supported by cifs_copy_file_range()
> and nfs4_copy_file_range() is quite close to what you are trying to do he=
re
> I will propose below a way to unify those cases.

OK. I will look into this next week.

> I prefer not to do that unless there is a *very* good reason.
> copy from another sb source is less risky IMO.

You said this up above, but could you say a little bit more about why?
Are you concerned that code that will dereference the wrong type of
per-FS data might still survive long enough to write garbage data to
stable storage?

> Thanks,
> Amir.



--=20
Han-Wen Nienhuys | hanwen@engflow.com | EngFlow GmbH
Fischerweg 51, 82194 Gr=C3=B6benzell, Germany
Amtsgericht M=C3=BCnchen, HRB 255664
Gesch=C3=A4ftsf=C3=BChrer (Managing Director): Ulf Adams
https://www.engflow.com/
