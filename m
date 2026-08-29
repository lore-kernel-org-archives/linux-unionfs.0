Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F388C3C553B
	for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788021764; cv=pass; b=bPDshRizWHVYYCRTYguhlhTsUElbUcJEsfyTqfYbMjWs2dkDSNbT00rlr/fyoLpCTcUsTy55ryqiNGhJuUBSNO9TbxQYfB1I+iAW1hr7Wh9fA12PO27bMPj5/fdbozl7VlSe0V+AvU9HCc3dLJKAzDCfmwtyXD6idyb0+udBfIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788021764; c=relaxed/simple;
	bh=gVZFIq7E6DUEA7UcHTTV0g77Ncrm6ajPHymyOnK3Cyw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u94WwTtvb+o3n8NpNyan1yiJUyIlOuYsHLbVSkvrQqy+KUr7pjuf88X816iu6hiASdFA41NZ4ZDQjtlH052deLjJZ2qDg/qWODDhqpYrnrBIZBDwproCby9i1Aw2QHmqiwdgR9nxS88YYga9aJ8Od6UdDg04NbyjSWmZZIH3cKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTetC3FY; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTetC3FY"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso260732666b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 09:42:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788021761; cv=none;
        d=google.com; s=arc-20260327;
        b=MS5gzpp62dZgLxQXhNj84fjYgSuV15KCRmuL0FWXkT3225iXVinFc9/Gju0LwJMaE0
         PZ5nkZdo0LdL31yFvrrnUu//L+q0ZJey6eMOaRpW6sx7RC1if6wUo6RXw/CWvY86BTjw
         RSVP8BV7XC8Q5HNHgu+ejqwzoXzaWn5XAVR5Rk2vWYRzGcvb/C7VLUm5OfoF1TRZOi5J
         sFKHmIkBm13N6DFaaGUBrwHhxm3pXnb+CJ5C3lrQP52n6KhZwJNq6iEVQYLa3bkfgdA1
         kVgzJFQz7DOLQXnOgra8fS0Sng6FacNagZ5nVmyI/aw/yJvBnIjT2ptC7rG2STeW9SzS
         0HYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cDbJApH470Nb27U1ofVrGiRQ548vKaC8I4YjQ8kLrVI=;
        fh=O30FjaJQUuETWmjwIqQd+0BwBhIB8ywR/NbPwtL/a4A=;
        b=GmwKKulNwrd/JK1jQclyIIFuWPFcJI6Pw2pANeeCxu2mXWmbctek4m/tEXaICZVxjj
         8VB5qOrBxJQSNlM2ezB/ZDgFcwF1yYILJrdHr60HE15wazAQNI5kiSi/P5rvlZMBYhNS
         T+gxxNzxx6YdZQVA9RAeKuCTBsOGbmBwft8pLFeJ4ElCTWnkALQiSBMAkEN5IN3oEO6y
         cQhvazjmOkW4WQ2Ho+Pges0MU0I+o1zZFW/d90mOVm/9ibNA3vcoqhhSvq/+kykoW+Ps
         vA1sn5FMHBUTTX4xniF6xzsfnMHc1GM7rnqXewFZO2BPm9vCHRjZAHfQk7L+4ZOFAT2Z
         2sfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788021761; x=1788626561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cDbJApH470Nb27U1ofVrGiRQ548vKaC8I4YjQ8kLrVI=;
        b=OTetC3FY9YR2dT91pmq0tWTCBVQw98A+ro76zO0jrdRuA8IZtsnSh7UkqJxyoJsput
         QYkwqUcp//atCTeq9nNabFfVtR3cltA4BnJlSN/uar5m/kgT+3MEs42eO0e02wospduc
         rd7a0zJaN5uoUP6GJRavB4PZ8F3hyZZHH4PEbtX9YmOgSbCfGFN/PElptV+PHQz0J9vf
         Bkx0xSdvVwNswH+ipIw1CNfsIk4PAx0dQAqh41NWWhrjuJmVCLhS+IToYESJMrG28Xbz
         dtUzdafCWjb87kTs+7MK86BNNaSyY3rkhvgNFqCPfd9b+Pbk5DgfsG4pW4torbn/l2sa
         A84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788021761; x=1788626561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cDbJApH470Nb27U1ofVrGiRQ548vKaC8I4YjQ8kLrVI=;
        b=iySO2ssJ0QMvzu/g0Z8rEgRKXHabL/hQyzXxAc+IeHhVfIE0yMjfldfdQPUVTk5Fzf
         FKItghIXRd1eq7OLORPoCAWKTEFGlxM7A+thB7HNAq3Qu9joFnVg+ied6ovyJ8qFOHwc
         DDmCRG0zOtsjIa9A+MTDvtgWk8NIJ+VHRkkEZx+EfpfTLDVomYrhCXM2TM4no4eL5GTt
         ScqRX84SUlcFWZMEl2VJnEgOHKE0wJU1pLNi3XWTK1Fx9VaczLBM7irnpPQ+n4mj2Zfm
         mukZneWs1+/WHFP64h4D9isRz1A7dHyBo/6wuNf0cb7aE7eOnVafydOTZyMWYGGme+sw
         zlXg==
X-Forwarded-Encrypted: i=1; AHgh+RrG18ynisCX995uYCWI14MmL4IS4lA3F5Mb5rJsykMnvGlSZgFY/2pkG6zuMsNwS5xpwFPJq7AkWOPiPNCl@vger.kernel.org
X-Gm-Message-State: AFuF++kOkESYe3mnXkx7BK054hLcnxNV5JP3k7ZASPi/ZrCYhI4VWZ4E
	iYIWQz47+YbWYLdO2fDjBderw/CDZD4sCpcGW8USua6TMhEG7f+HcVqqq5+iF2ktMSisQDGhl3f
	r6SQLZPLOebcxsYxXBElv+kY6aVjn2y8=
X-Gm-Gg: AR+sD13i4TCUPucShQscz/0X2Ab98XZCs15s9xIpjwg2+11qLSMb+01G7a1F0oFuCQ1
	Q5srfBRNcf0zBMcfPk9vjqpGBwZ+R531Z1eDsVOhMSCaUTtVQwisbo0czh3YdI2eu5LhN5LAT2s
	M/hX7h6MbTwIrQC4zvj0qi0gjeUMxbet2Sr69I80jRCyLwOqXgxksWyXc7ZJcXvvTME3N4wr6Mz
	emzjvo6KRZ1MCCMAIwv7Grb2lk+e4HLoj9AYmik87bgZ7hr2IdeQqvx/u3mrJ0a83cB7TVzFz58
	2Mk25H6sE9J/32wouy3mNoXakmCzCMF//j4HoF81V5hTWQ==
X-Received: by 2002:a17:907:3ccc:b0:c15:f26a:3438 with SMTP id
 a640c23a62f3a-c255741f461mr1048868466b.24.1788021760941; Sat, 29 Aug 2026
 09:42:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820175832.44512-1-kmehltretter@gmail.com>
 <5fa5ef078f41cd57d0e52ab2ab023094@paul-moore.com> <CAOQ4uxjn3sWjkrV8KbA-V+eno3E4OskTnCznNBex6FOstEbJ-A@mail.gmail.com>
 <CAHC9VhQ5oQWL7bj745U5UzSWm2OfyKMjHVeaEYXZvzO0Em0iZA@mail.gmail.com>
In-Reply-To: <CAHC9VhQ5oQWL7bj745U5UzSWm2OfyKMjHVeaEYXZvzO0Em0iZA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 29 Aug 2026 18:42:28 +0200
X-Gm-Features: AcwNN1VZx95EdI2tjlNCAWiVqqkY5zejH9GYUNhl8FvdsMNeGPTwmtuy5Ph3m7k
Message-ID: <CAOQ4uxioiwVPntt1=QeXXftehoPPb5LFZHuctfJzkNJzrNq9Ng@mail.gmail.com>
Subject: Re: [PATCH v2] selinux: preserve user SID across nested backing files
To: Paul Moore <paul@paul-moore.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, selinux@vger.kernel.org, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 12:05=E2=80=AFAM Paul Moore <paul@paul-moore.com> w=
rote:
>
> On Fri, Aug 28, 2026 at 5:05=E2=80=AFAM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> > On Thu, Aug 27, 2026 at 9:39=E2=80=AFPM Paul Moore <paul@paul-moore.com=
> wrote:
> > > On Aug 20, 2026 Karl Mehltretter <kmehltretter@gmail.com> wrote:
>
> ...
>
> > > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > > index 1ead2eee1944..171b90412ff1 100644
> > > > --- a/security/selinux/hooks.c
> > > > +++ b/security/selinux/hooks.c
> > > > @@ -3843,13 +3843,20 @@ static int selinux_file_alloc_security(stru=
ct file *file)
> > > >       return 0;
> > > >  }
> > > >
> > > > +static inline u32 selinux_file_user_sid(const struct file *file)
> > > > +{
> > > > +     if (unlikely(file->f_mode & FMODE_BACKING))
> > > > +             return selinux_backing_file(file)->uf_sid;
> > > > +     return selinux_file(file)->sid;
> > > > +}
> > >
> > > I'm a little concerned that this only works for one additional level =
of
> > > filesystem stacking.  Yes, I know that OVL_MAX_NESTING and
> > > FILESYSTEM_MAX_STACK_DEPTH are currently set at "2", but it's not an
> > > unreasonable concern that at some point in the future that number wil=
l
> > > increase without proper notification or testing and we will once agai=
n
> > > have a problem.
> > >
> > > At the absolute minimum we should have a BUILD_BUG_ON() for the stack=
ing
> > > depth.  It would be good if we could watch both the overlayfs and vfs
> > > constants, but the overlayfs constant isn't available outside
> > > fs/overlayfs/inode.c (thankfully it is currently set to the vfs limit=
).
> > >
> > >   BUIILD_BUG_ON(FILESYSTEM_MAX_STACK_DEPTH > 2);
> > >
> > > Ideally, the code would be written to keep diving down the stack unti=
l
> > > it hit the true backing file.  No one likes to see recursion, but at =
the
> > > point where this function is called there should already be a reasona=
ble
> > > bound on the stacking depth and the work involved.
> >
> > Unless I am missing something, stack depth should not matter.
> > file_user_path() should hold the user visible path, for all the backing=
 files
> > in all the depths of the backing files stack.
> >
> > This is the issue that was fixed with commit
> > f2381b546e7e6 fs: fix user path of nested backing files
> >
> > This patch makes uf_sid behave the same way and also documents this:
> >
> > struct backing_file_security_struct {
> > -       u32 uf_sid; /* associated user file fsec->sid */
> > +       u32 uf_sid; /* top-level user file fsec->sid */
> >  };
>
> Perhaps I'm not understanding your comment correctly (it's the end of
> a long week), but selinux_backing_file_alloc() and the newly created
> selinux_file_user_sid() functions don't operate on the
> file_user_path() path struct.  In fact the path which is resolved in
> backing_file_open() isn't even passed into the
> security_backing_file_alloc() LSM hook.

Right.
But the file that is passed into the hook has the top-level uf_sid
in selinux_file_user_sid().

>
> Are you trying to explain that the way the backing files are allocated
> in a stacked filesystem, regardless of the number of layers, is that
> they will be allocated from the top down in such a way that the uf_sid
> will trickle down to the bottommost backing file?

Yes, both selinux_file_user_sid() and file_user_path() should follow
the same pattern independently - they always stash the top-most user visibl=
e
path/creds.

Thanks,
Amir.
