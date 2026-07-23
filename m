Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB07470423
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814892; cv=pass; b=Yan42D0NK5YA5GnvZjNLHY5Qvckiifxyq9hSJcGHu8wmdOVwcyttdFW49bXmWBXs/aUAmIjetRosHhE/v7X6GS+FjLx76WYIqHwKPbGSm3l/DtRjZiHQ0EHinAWeFvLmyUuBjo1ZSE7jW9WDq2BE3GmT6Dq0WT7xDK1UEZRcC34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814892; c=relaxed/simple;
	bh=CmafpcKng2OO7DY/6c28d2C/fmsJL+veaB1z/UaK3fw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FA1liF14ouMfVaeojBpM7pGFS2fUethSvgMsNQiDlfjFs6zq09eXJiKdcBk0Xw0UwXVNV6iGcljmZwAkZJ1UfngVNPV1XAtvWUrNW9NpOerjboyScfY7CWi1gY9XsFVq39UvJONSc2PVkCMvc3NN+3VOq1QyiSROdxHJNb0JAIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWRdMM4+; arc=pass smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWRdMM4+"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6aad8c40ca7so288507eaf.3
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 06:54:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784814888; cv=none;
        d=google.com; s=arc-20260327;
        b=jth0nbyi3nW+IWbuChKfFiZo/eWs/J32kXq0yRozq4ivomKLDA6NUfN5JACLdYREfC
         xNPnysOJm9jV6IrI9i41+lzYWbq6dIAonM6j8mkrIjhVuCIpsrYtK8H2mydrbGUqFryA
         8gipw2DWadPTBxsUl5uAGT1I1drS+5YcjDOHfdNy8Z83JPn1GNNZKoZRupG+oG0mQYG9
         MzElkjrI2ODnpiVleGm7rwoLOJ4acy8cxH0+w2mF/+YHm0SbJSvEj+LjjPTbzTFOeeUC
         uFGaPU/gfkwyd+5pMH/diup5CCxqLVeBSS45DIe/bmv0oI9Vgz+NXafWrkiPb+SJzsRj
         mrGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CmafpcKng2OO7DY/6c28d2C/fmsJL+veaB1z/UaK3fw=;
        fh=5ZJH+mV7TiDEiDR/cfGLwLEf8Q7vcNxv/zBTZlYFvd4=;
        b=CVZBwoDoLP9/EbXisJNjTFoOOPf69T3gBYos+gvDLIApGiymIUsMnHbuyRoBWLyU/q
         12J/qJJUp06r9YmZV3/jKe71WE5/ecs2J5H7yEgpfVsY74q7LW3JJgrD6bdaXGEUs2w1
         srhfPZV1nyUObNqL+LA5QgUiRHB0ozFj3TbTSVbpeO3L+owbd5HenZQXPsk4OFoyRguA
         doFocbbKWIRk3SJJWdKMqTDTubzsyPDa3oQrLtWwT6BxZ7jA1/K71Vy834r2jG7Ki24V
         pt/hGDXxrvnMLjXGjL0p0r8daw8XaPQcgxenDu+8Vg1iioEB/QfoovnnWV5CHXQqDBGj
         gr0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784814888; x=1785419688; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CmafpcKng2OO7DY/6c28d2C/fmsJL+veaB1z/UaK3fw=;
        b=mWRdMM4+mfGr8tMDFkk03kCPJHiG4QsiI4+3bnLn5NzusyvhuGf3AuUip0yz4RsjJ1
         JI5ZsJ0hPqOzuQjeE0tBNHF7lsFS/vMpGoajdX4dxqUYHudhTgoH+MS5MD+/s7aTdP2N
         VdDX65MqovTuiVuLNmOsqPcdq+F3zNyjGhPYwNH242qyuZtsk9RlkmQuwiBQuXKrIhZX
         0XLv8Fy1sWUHuaQ/JfzQ917kHazV13KxaoZNg9ukfMRZR/YUnLdJEkUd5O1k6akSEl1J
         c1DAt0Lwl2Z8pzEWFnGIu2GicnDxGiBjqGzUmO07NDM0aZ6ntlkQDUnRD5aShMXO1Wtl
         iP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784814888; x=1785419688;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CmafpcKng2OO7DY/6c28d2C/fmsJL+veaB1z/UaK3fw=;
        b=M4GWQzNuB3HUuhggPQJMrAO43eNNsoRv2uZemzIFkMhd8vjktvmyfCaMd25XTEh8oM
         IFRm/UxDVj8NjluALr/W5an5xF6XtnGuoqKIZ1eo8r4RPX7JvO9ZNDkFgvfox9LRo4sE
         lTMd2igYiv0wnSginuf3Nz1thvFWqOgqfKCFcsVYfUKNtNuGSbwk2NPdfZnpSA2VZouj
         hIZAko+R/HmkfdKfoffB8T4pBDKnbCr6LyPisPjLgi60m+OiCeP07kZog8A8buqIW0nf
         Z37znkute93KaZGsBz8mvgO4IeZK+Bx6XJKdpWOGFkJ3hqJHL7RQfnt5sQ5110TBA6Kn
         Iocg==
X-Forwarded-Encrypted: i=1; AHgh+RpGPi7zxUJHkcF8ygIYH427QEE4V7I7ikidmvlQDng1zWWAKFkKScuf5AdbaKUQzG/a8G6HmbC6kTY6w6sm@vger.kernel.org
X-Gm-Message-State: AOJu0YzNI3uSQXbCtqWEJA2sb0tYN0wPwghIoTN1rOGGy8qs6AcA3B91
	PABAgNgxydhiNiTwk468FsYTn4lxzba9iopxP5Rbq1cynq1hlhc+gpS9+J+0bY94xdczb1JfJsI
	xfrRijG9776lrBE/EQNy3GSEoUz4X6o0=
X-Gm-Gg: AR+sD12oK/XLNHaW299XemW6JhSJX60AEwfaZJcp1n7WwqA0YSse8nLhzOUrnWMSKkd
	WEzHmWmvQeylyQjCkP1Z0av3+LPSkT/j9R5QvtnYKFQqe9eInRjinVRkxkHtPl+1fLVz6QRdJzu
	Bdp7ofXpkZRFE3PCZcXcC03TQXl5Mfvvi9X+qYEpKgenLnXfmiUduuNbPQgYHde05wF+t67+Gh5
	VQaBnDtiva5o23mX/ErTVqnFU7JPzgdeSJWHji8jIUzdyy94YsfYZRB7+yYqvBWjTPMcImOuVpR
	MoVJuPRf5GQCJpM6+USGbQQDZye8uVl4mTeM7kJNeX9YUhpBAtLz0oOS5TwyMuqKdouD6X5sWdp
	7gQ==
X-Received: by 2002:a05:6820:c2d2:10b0:6aa:d5e5:52f2 with SMTP id
 006d021491bc7-6aad5e55627mr842071eaf.70.1784814888288; Thu, 23 Jul 2026
 06:54:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723114848.1212429-1-amir73il@gmail.com> <CAO8sHcn=b94SL6KTfPtnqau++-g9CXD0LOpPjp4L+b9cu8mMSQ@mail.gmail.com>
 <CAOQ4uxjk_Se3dq3exxd5WS98g287HUMjVAucipxBX=T0W-8d6A@mail.gmail.com>
In-Reply-To: <CAOQ4uxjk_Se3dq3exxd5WS98g287HUMjVAucipxBX=T0W-8d6A@mail.gmail.com>
From: Daan De Meyer <daan.j.demeyer@gmail.com>
Date: Thu, 23 Jul 2026 15:54:37 +0200
X-Gm-Features: AUfX_my_Kci5UbImKiXwv3CQsg2Nzgm60fpkVMYbljRrTwwreQ6BhrmzgsjkQTQ
Message-ID: <CAO8sHckGrgfPnyOC-V6AP+DakG8LBXTFRHZSchXxi02LPyfMFg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Proposal for Cross-fs copy_file_range()
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> As far as I can see, OverlayFS-to-OverlayFS, which is classified
> as FS_COPY_SAME_FS should not have changed behavior at all.
> That was my intention at least, maybe I have a bug (?).

I am sorry, I forgot to mention that all of these issues are issues
with upstream overlayfs,
not with your patchset. I was trying to make the argument that to
solve the issues that are
already in upstream overlayfs and to introduce cross sb
copy_file_range() we need to move
away from recursively calling vfs_copy_file_range() within overlayfs
(and anywhere else really)
as its internals are really not intended for being called recursively.

`ovl_copyfile()` locks the overlay destination, removes privileges,
and then calls `vfs_copy_file_range()`
on the backing files under the destination OverlayFS mount credentials.

This has three observable consequences:

1. The recursive VFS call accounts one userspace copy twice.
2. When the files are on different OverlayFS mounts, the backing
source permission check uses the
destination mount credentials rather than the source mount credentials.
3. Backing permission hooks run while the overlay destination inode is
locked and after privileges
have been removed. A permission listener that accesses the destination
can deadlock, and a denied
backing check leaves the destination setid bits cleared.

Clone and dedupe use the same `ovl_copyfile()` helper and share the
credential and locking issue;
clone also shares the killpriv issue. Splice does not have the same
mixed-credential problem because
its source and destination operations are separate.

If anyone else thinks we should fix these pre-existing issues, then I
don't think recursively calling into
vfs_copy_file_range() is the way to go. If they're deemed not
important, then recursively calling into
vfs_copy_file_range() is probably fine.

Cheers,

Daan

On Thu, 23 Jul 2026 at 15:36, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jul 23, 2026 at 3:05=E2=80=AFPM Daan De Meyer <daan.j.demeyer@gma=
il.com> wrote:
> >
> > Hi Amir,
> >
> > I tested the series on top of f6cde11eb46e and cherry-picked these
> > selftests:
> >
> > https://github.com/daandemeyer/vfs/commit/0b0e47d408311fe2b4a3e1711656f=
836b56e10f4
> >
> > All four tests failed.
> >
> > The accounting test reports two reads and writes, and 128 KiB
> > accounted in each direction, for one 64 KiB copy. The outer and
> > recursive backing-file VFS calls both account the operation.
> >
> > The credential test fails with EPERM. The explicit source check uses
> > the source mount credentials, but the recursive VFS call checks the
> > real source again while the destination mount credentials are active.
> >
> > The permission-order test times out because the real source
> > FAN_ACCESS_PERM event happens after the destination inode has been
> > locked. The process handling the event cannot update the destination
> > while the copy is waiting for its response.
> >
> > Finally, denying that permission event still clears the destination's
> > setuid and setgid bits. ovl_copyfile() removes them before checking
> > permission on the real source.
> >
> > It looks like the root cause is that OverlayFS-to-OverlayFS is
> > classified as FS_COPY_SAME_FS before the FOP_CROSS_FS_COPY checks.
> > That leaves it on the existing recursive VFS path, so these issues
> > remain even with the series applied.
>
> I am baffled by this statement.
>
> As far as I can see, OverlayFS-to-OverlayFS, which is classified
> as FS_COPY_SAME_FS should not have changed behavior at all.
> That was my intention at least, maybe I have a bug (?).
>
> If I am right and behavior did not change then what are you saying?
> That OverlayFS-to-OverlayFS copy_file_range() in upstream has issues?
> Are those issues unique to copy_file_range() or also exist for clone
> and splice and regular read/write?
>
> Note the overlayfs model - do every operation on both overlayfs mount
> (with user creds) and on backing mount (with ovl mounter creds).
> Taking this model into consideration, what in your opinion is broken w.r.=
t
> upstream [1] behavior of OverlayFS-to-OverlayFS copy?
>
> Thanks,
> Amir.
>
> [1] upstream + this fix
> https://lore.kernel.org/linux-unionfs/20260712122421.203113-1-amir73il@gm=
ail.com/
