Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D5924503B
	for <linux-unionfs@vger.kernel.org>; Tue,  7 Apr 2026 19:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775589620; cv=pass; b=jZ7SLp7RyYVlhgdnC560V9WSIEoYZu1XrXsFmwoSHT2KIA1J+LBtJ/OG7ePEMu+7mF1R7Nz9cCiMfl/lsRsQ8O6QmAO5J2oYDcxOcWEwgW9zq/pkq/3it/bNawvyGhIkOiUT68a7fSy9SIBVVQw9BKpsauN9h/Fy9FzZOZhQGh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775589620; c=relaxed/simple;
	bh=i6c6Uhklk6n23W8x1AxzLaFh13KM9OwbxJ2yYTpwf54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frpL8aoP3Sp0uM7x0the83Nfx2Z3ULomVtbE6GI/m1TfZ14+XX4Y1hLRjeZa1qTN9HSQDeamtYPI2iRDJtW7x/kC3Jd1dvwSCwGgV9D2SZaKVi4TJcbQyRafFvrv7MXxfpzU0+8UBNuhQSYyYzdT9Agi5U25DobfRgVWFOSDvAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyZUiWWI; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyZUiWWI"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so5141876a91.2
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Apr 2026 12:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775589618; cv=none;
        d=google.com; s=arc-20240605;
        b=aKw8gjZQttN5q0cVWAk1p8ruea1/r2n3tLcMANdb1axa6bjbBNXOCHliwkskumJppy
         djukHOJBa1RlZ9PYWjQEON84L2c1NxnQnuMJGkB+sRUYtcGy2crvbUdOZIgprCe63q0R
         p7yw4pQB6EcXZyqUJdf95cGi9qn0T/7Uqs7J8Oaemcl31Ach4U4HF/vDwyWS7l25SaRk
         5nK9NU4Nxm4s/mfAKNzpbkIqlvD8ZG0ywelQPY3fX7qIr+INr/hWLVUd6I/pxjYzMZMH
         r6YmeR6nQNMXBSI5WVgCjXT8yXEf7a/VnY+HcyDD8L72729fyFB3ikojQtpJZixkuqA9
         Ha7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LvCMx9MBtYrViWX1Qz0ZJHbJw9R+8QQ6ywXBNqXTjw0=;
        fh=ym1aLHt2NKPxCpk45i7jUs+k4GEsEqS9ua3Doe7nNMI=;
        b=dCY/H2TVGcS6WwpObmJ7jN8QrBkWFqnx2QN4CXrWFRIgsu6c55amHUrUhnaGLl+UA6
         kIzmtouZ0VHP7Pon7B0FgglKcLnh23hZaZRfqFkwy7nM0FNfdhf6m1AruNob1UNs6DT+
         xJLgzfgxT59FEhaXJ7SDfiGYCFqjMqvNQMEWV1HImMG+IxhimLWjiyFTV6KcnsNifcZu
         u0REcVkgV1nFdyCvkgC9eAeTkzQDEJfS/2iMSCCPQlCLFHoaKv99P21dQOo50pQlHCSE
         X+eGJUfqZwYaWJ9OyVfLfyMD3fMhL/L2jDSfInlFKGfXgTnbooID+Tcbe2FE3PXituLW
         Pp2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775589618; x=1776194418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvCMx9MBtYrViWX1Qz0ZJHbJw9R+8QQ6ywXBNqXTjw0=;
        b=eyZUiWWILQVMtoM7LN+je344gEOI2bb+oTPGGw49fR/pLvre5XwIY3Y0OQq9XQlglO
         v7pGURmjkXPNSZujNTn/TSK1p3EfZ/5/ErzUyGBS8vgxDCfTWo2s7mBUKa7HRTzS4mZD
         mSGaa+mqRr4mLpoltEgg53+qacArS0qWR0T6VJl1GsbYJRLQal2fit2uyn2S6BBWurER
         dl7wceAy/RmA6U3CKIUbd+We8HdJbAsRml8wBQpatHpRcpBJwpwMU2h4gY9rF5Tpo8My
         FeXEc/FKtXPEp+Sp+foOWr+lrurKCZtmaOIbqepRdcZN2SZ9n0VdOOPEOdLrT9IB7QBy
         WkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775589618; x=1776194418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LvCMx9MBtYrViWX1Qz0ZJHbJw9R+8QQ6ywXBNqXTjw0=;
        b=IC9FkBpG0IFJNJK3Icyih3wSScg3PF3N7c8aEYKJO4GCoOQa2PphiHelvgCksg4Mb0
         9aWTeuzT9zhDrYTHDZBqFZPJDTYEhkdRmkJKqPcxxPDhX5LrgHXg6pHewxOUZe7/+fhd
         D0En/acjyG3ZPQfkD3bVW6ITyUsE7eYbOWiL+xWfAB7re1GpogJ6A/QBhGDstHCowi16
         qXtLDonqZM79bAQWxXOeROB2TU9fQOsDYzki4P9c44afERetijUMgXfR6DYtWtUDpbU5
         xt/6Qq8hRR/PfmTD2ZcktBOm6kBhQhvlfZF+F170VweeAUJPwUPHOdu6rYp6LWIJeN0S
         1oyw==
X-Forwarded-Encrypted: i=1; AJvYcCV/INNIYg9KmIQ+1nfjozzrhSxi7ynMAb171wGfYWv7keaQsAOmm2ZeIiLjrxcD5hhtpjCn+0Ilv2pguPIS@vger.kernel.org
X-Gm-Message-State: AOJu0YxH/6AGC0lHfXd/vuZ/et2KeXaqQ7N9rbeN0DDrR8L4ifqX88Cn
	ibwRgSSlbyyniVXKiOChYm55MnXeFrJFqDLmxUVmg1fcexs35zbVRXXIWTyCpIW5KDnSMFnQMkn
	XeRGyX9/5J2dDMc8uK2xP1Efsi917tak=
X-Gm-Gg: AeBDiesnLBvx0Cj+LadwzUPe1XwoAFVNVcsQq1L2CNyAV4KNr/2+rIj8WXKmkTmabC9
	bJ0LqoDC3zX6iY3lXOXSr1s+PcTM/qdcI4GaZfFRfQMqHVGwa7+xd6d+1w8T5tv6GuZxATHOjLi
	QVQY7gsfgKVmy/OQL/I9vXg1vW8RDT+NjVrSZgCpbbCr5P+lcQPJB1c9r7X31lq2fqueARfvKnq
	o5voW/FRHT8rLlUPCBpwhj9Vodd0ZV+fZV+4fZPzxkEKMoPpUhMEXGctLtQ3aF0rlVbVzw2yDWD
	/7n6ip0=
X-Received: by 2002:a17:90b:3d4d:b0:35b:aca5:db39 with SMTP id
 98e67ed59e1d1-35de67ee6bemr17005316a91.9.1775589618190; Tue, 07 Apr 2026
 12:20:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403030848.731867-5-paul@paul-moore.com> <20260403030848.731867-8-paul@paul-moore.com>
 <CAEjxPJ4nqeuPhve3Fe-tFuNW9R5grnWwfYJv7q2cRu+UPQ5c4A@mail.gmail.com> <CAHC9VhQnA38-9wDeVmOMxAFPHnd9y6x5LXtD3cSquGiL_MDDpA@mail.gmail.com>
In-Reply-To: <CAHC9VhQnA38-9wDeVmOMxAFPHnd9y6x5LXtD3cSquGiL_MDDpA@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Tue, 7 Apr 2026 15:20:06 -0400
X-Gm-Features: AQROBzC7o3Va4ubfSL9DMqzx-1hfP9_BswdLqwBtMsXc3haoHViWO4Xh57-I6OU
Message-ID: <CAEjxPJ62=0v9QYJ6s0DrwRp4WZna8f9wnuM_DUUNrcz2dd_kog@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] selinux: fix overlayfs mmap() and mprotect()
 access checks
To: Paul Moore <paul@paul-moore.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 10:35=E2=80=AFAM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Tue, Apr 7, 2026 at 8:14=E2=80=AFAM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> > On Thu, Apr 2, 2026 at 11:09=E2=80=AFPM Paul Moore <paul@paul-moore.com=
> wrote:
> > >
> > > The existing SELinux security model for overlayfs is to allow access =
if
> > > the current task is able to access the top level file (the "user" fil=
e)
> > > and the mounter's credentials are sufficient to access the lower
> > > level file (the "backing" file).  Unfortunately, the current code doe=
s
> > > not properly enforce these access controls for both mmap() and mprote=
ct()
> > > operations on overlayfs filesystems.
> > >
> > > This patch makes use of the newly created security_mmap_backing_file(=
)
> > > LSM hook to provide the missing backing file enforcement for mmap()
> > > operations, and leverages the backing file API and new LSM blob to
> > > provide the necessary information to properly enforce the mprotect()
> > > access controls.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> >
> > Do you have tests for these changes showing the before and after (i.e.
> > failing without your patches, passing with them)? I tried running an
> > earlier set from Ondrej but they failed.
>
> A few months ago I sent you and Ondrej some feedback on those early
> tests from Ondrej, but yes, I also had problems with Ondrej's tests.
> I've been using a hacked up combination of the existing tests, some of
> Ondrej's additions, and an additional debug/test patch to ensure the
> labeling is correct.  It's far from ideal, but I didn't invest time in
> test development as I assumed Ondrej would continue his efforts there
> (unfortunately it doesn't appear that he has?), and I wanted to focus
> on getting a solution as soon as possible for obvious reasons.

Ok, I'm happy to look at even unpolished tests - just want something I
can use to exercise the before and after states.
