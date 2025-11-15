Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B62116F6
	for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 08:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763194308; cv=none; b=DmV19n6qmpIUoPCz+acngHVTLuSXtcCaTvnp0hJb0PfErbuiPQQ3ubIYsmr5sTvlq3vQ5WfvjyUtM+x9oRJ4HJA8hlb1/xN6k1KrcScRa87jW+W3fipaRtd22xHNve/MPLdz4ocAfbE7Gx1lPZr2KxO67g+24l5YgjCvNV19Olg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763194308; c=relaxed/simple;
	bh=QIBFpHynOInHiAJlxbAK/wTVou/4Ob0QHGDLNQ4jfRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MDpFYhx7OjB3w/Vc3f5Njh20HMrYYPRcuAbri9xtWO461W3xXldRZm1shV4RMC6vp4lWU05yNt2lBeNKtSBa/1cUdFVJc8XW6wbtbS8yWe+Gu4/W0rkaZ8i9uDH/rBBM21KbaDgLxlojECUKEahsL7XqeytpnbYWsr64tBE87E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6SygEBe; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6SygEBe"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64369269721so845477a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 00:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763194305; x=1763799105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTgJvucTK4WSvLw37JpaJABlSGehYqmIEwQ+BAHe7h4=;
        b=m6SygEBeyQZzYJKIOX5kXQv4NCse1a+jw8P0/3ktPt1FGAETPbaTaDKFRmfhzp5cFX
         KLC4iqZGJ2tXSZ47ULHOyJbtvs7HHbU6GqD1Aji1dxako6wKZ83SOPIL8s0Tzg9L0x88
         hxho3cmihust1s7JOmHvWBwn8j9IoSIO8lAA7kKHkSrMEEPkwVh9//DgWiN+OEqBio5V
         HP4zw5JnAohGdJ8jnZugYGZeiuiocqFuUbTI3P5ZGgT96xbCiSMWgh19r9Iij3XNdehr
         7aXDUDaXzfKv90RewQxK7b1wEg7lvD65tyPqIgpM7zDS4ruQ0lBFGcVQdZUnR98jhhk5
         PcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763194305; x=1763799105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nTgJvucTK4WSvLw37JpaJABlSGehYqmIEwQ+BAHe7h4=;
        b=ZgqTgapy440iAkwHUffEBmttpO0RWyB5TGpdM8567Rq58FFP87OPs1AJtox7dSC2LZ
         4357gDWj8wR75j6OAHNRBmyZF+eqMAflShjQxM9FwNUq0bltnKCR9mFUETWoBbI5uw59
         i2lKy9h+G0TJanpzyYmji+xVQ5LyT92GyRRK7EzUddPFMa8WFYjT5VBeyohPvuhwlnQ2
         DzRpflhsDn7dKstc1V4O8vabBi57KspWM8nZhheiFE4ybiOiP02Lf00/U0sKtq+3YE5Q
         1mztd8k3U9iOyetmWj/hTm0uOXmJCMUupda1RObFMfN3Aahnq5eTy9uDEdE17C5RFDFT
         hDtw==
X-Forwarded-Encrypted: i=1; AJvYcCUIUxw6q21kaVfAtmZXb00d6dRJ07fJiNvADVxHfsV/ntnf3yGMIPYCh3yGDNtU7llbRNwQurT7kjvZEJyJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyG7t08gjZS57cmd2qfQCaeAhRvZc3OVF4oLWSM7+bVAqu0KDiO
	+C+lPtR6m4Pg8S79KwFFmZJPIV8YmVYZLgyDrN9CjIzfBVex1LhlyCOBIRQK0nsn3PY6suLUEFU
	QRO7QIyADptPDsZAzqLzSHGmcRCYNF/nKaT/pODohmA==
X-Gm-Gg: ASbGncvVOaLvxg8CtOkvbHru7jFjpMrMPuYgOY4xF2TzeJUTsvbYGaIPQ4+IO/C6J53
	9Bu27WxN+OP9Qy5MTgtO3m62LG7NviHMKVakKlwrqBrVUdzlEUmMPDTQ+CjUqeeBCAFcNUjmksF
	BBpkudBrwShK1Nugu/1/rPEh8a75LkTGa1aGwJ1mI7iwo5akjWh2NfcaINqOYI+BZV4osxcWNyU
	g94TYB5Sq3Y8vO23aVhtEGwJKv3/nGjvQykmPcmFTL8+gKFYNPLXGhB3FAbQbHkt3ynG4/Jo1Sv
	nCMhVeJWrtuw2c1hRK4UJqTneky7Ig==
X-Google-Smtp-Source: AGHT+IH1xDPFtHhZ9mUxe/8mNbdWMETlMxaoF1sBpFr568z4QBWRznGo2vR0HbO6CO3Ap7/fxj6AW13RGYp/iskf7MY=
X-Received: by 2002:a17:907:7f18:b0:b4e:a47f:715d with SMTP id
 a640c23a62f3a-b736780c24bmr577407766b.17.1763194304569; Sat, 15 Nov 2025
 00:11:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114194852.1344740-1-amir73il@gmail.com> <20251115071102.pelohvzihg4aafse@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20251115071102.pelohvzihg4aafse@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 15 Nov 2025 09:11:33 +0100
X-Gm-Features: AWmQ_bmBKpgg4Fmq2iK_15HmvUz2CjgPkQ8V2O5kx6bJTm16kqG_bYVBuI7i-dM
Message-ID: <CAOQ4uxjWWTm7wYK9737V89ToYgF6gSZ4TD1=tr58nNehk5rcoA@mail.gmail.com>
Subject: Re: [PATCH v2] overlay: add tests for casefolded layers
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 15, 2025 at 8:11=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Fri, Nov 14, 2025 at 08:48:52PM +0100, Amir Goldstein wrote:
> > Overalyfs did not allow mounting layers with casefold capable fs
> > until kernel v6.17 and did not allow casefold enabled layers
> > until kernel v6.18.
> >
> > Since kernel v6.18, overalyfs allows this kind of setups,
> > as long as the layers have consistent encoding and all the directories
> > in the subtree have consistent casefolding.
> >
> > Create test cases for the following scenarios:
> > - Mounting overlayfs with casefold disabled
> > - Mounting overlayfs with casefold enabled
> > - Lookup subdir in overlayfs with mismatch casefold to parent dir
> > - Change casefold of underlying subdir while overalyfs is mounted
> > - Mounting overlayfs with strict enconding, but casefold disabled
> > - Mounting overlayfs with strict enconding casefold enabled
> > - Mounting overlayfs with layers with inconsistent UTF8 version
> >
> > Co-developed-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Hi Zorro,
> >
> > I fixed the bug you found with tmpfs.
> >
> > Please note that I did not assign a sequential test number because
> > I wanted to let you assign a non conflicting number when you merge it.
>
> Thanks Amir :) This version looks good to me, just one question below...
>
> >
> > Thanks,
> > Amir.
> >
> > Chages since v1:
> > - Fix test run with tmpfs (needed _scratch_mount_casefold_strict)
> > - unmount MNT1/MNT2 in cleanup
> > - Use _mount _unmount helpers
> >
> >  tests/generic/999     | 242 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/999.out |  13 +++
> >  2 files changed, 255 insertions(+)
> >  create mode 100755 tests/generic/999
> >  create mode 100644 tests/generic/999.out
> >
> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 00000000..c315b8ba
> > --- /dev/null
> > +++ b/tests/generic/999
> > @@ -0,0 +1,242 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2025 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test 999
> > +#
> > +# Test overlayfs error cases with casefold enabled layers
> > +#
> > +# Overalyfs did not allow mounting layers with casefold capable fs
> > +# until kernel v6.17 and with casefold enabled until kernel v6.18.
> > +# Since kernel v6.17, overalyfs allows the mount, as long as casefoldi=
ng
> > +# is disabled on all directories.
> > +# Since kernel v6.18, overalyfs allows the mount, as long as casefoldi=
ng
> > +# is consistent on all directories and encoding is consistent on all l=
ayers.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick mount casefold
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +     cd /
> > +     _unmount $merge 2>/dev/null
> > +     _unmount $MNT1 2>/dev/null
> > +     _unmount $MNT2 2>/dev/null
>
> ... I saw you mount $MNT1 and $MNT2 at first, then mount $merge:
>
>   mount_casefold_version "utf8-12.1.0" $MNT1
>   mount_casefold_version "utf8-11.0.0" $MNT2
>   ...
>   mount_overlay $lowerdir (which mount on $merge)
>
> So I think unmount $merge after umount $MNT1 and $MNT2 might (looks)
> make more sense, although I saw you've tried to do unmount_overlay
> before _cleanup :)
>

Conceptually, overlayfs mount is a stack, so the correct order is
to unmount the top of the stack ($merge) first and then to unmounted
the base fs of the stack ($MNT1,$MNT2).

In practice, the order does not matter because overlayfs mount does
not prevent unmount of the mounts that were used as upper/lower,
but there is certainly no reason to require unmounting them first.

Thanks,
Amir.
