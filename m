Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4CE16B72E
	for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713477; cv=none; b=H2nzwj2vp4MENtFzTGw984NomTIYYJdGfwfQv0fqiftFyZR0A9/eCOMWu/LZrgWYTv8ra09Nuk1RGhI3uVRDn9XF5d9glYc6Nuw3aNhUhpR54iGH4wJW9e47jej2gcIZIktsBM+NSmIfgmax18RlId5mUONcN9NMNuJA9DrMXRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713477; c=relaxed/simple;
	bh=pC0RFYUCaFf8QlY2eA33EpnciEZHtDY5+HvwcE6VYdk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=kvwlobL/+RZZqoTCpHDRgjieOJZzykAyc4PwWtZsbHnkhFxd2Wb5g965BtLWfMhEIgr+LhHPQbufb4ozo+lx05BJNqVvXoVZpLCqMGS8oPVkgrw1k4IBV1lBAISSiGWzURKERKe+wcn9M9OvkHtHwf3RSRmjgfsMrPE7Mcx2JQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=fAlyXxGb; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="fAlyXxGb"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-48fec155a0bso386449137.1
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 08:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1720713469; x=1721318269; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pC0RFYUCaFf8QlY2eA33EpnciEZHtDY5+HvwcE6VYdk=;
        b=fAlyXxGbNxPUJnY7Yb+MRAUV/LboNwwZnRoKZ/yKTx4q4w5SUK7NUZAFTZiFkriDUz
         a7QfnMvdX+kmuaYmALQvYkC2R8YwcZvg+xW1s0bv4OQDBsL2WqDdWJkgs8fz2bvWzowt
         PphPbmvhIE2moEJp2YAf6DifsoJSWXq+hvaO8p4b4h7YMvoQUaP71XU5AR4MSG0MrYKP
         6vKwwBGD9uSkaYADBkOlkUUuSKC/617OQCsd4BUfJkrriGE1UdPo3igHTOVcS85nNEPY
         eBqHGaIycQnj9rV7ZPDCJh1LvLMAOM6bIwFGKmUCKGgK08wSsh1vfJGIjwRwyFkSdK7d
         5exA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720713469; x=1721318269;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pC0RFYUCaFf8QlY2eA33EpnciEZHtDY5+HvwcE6VYdk=;
        b=GVLrFLm9iads58RMsYjkbuzHWulRPI1cyP4feFYV5n71reA8Sjm2radtyXcAS16PQQ
         8/0bvVUzdSQOuPeUXW0VpFWA/krd3paHMUYiDDmag/Ht0SPtuYMtYPBshgvX7ABMq1Kx
         qnfsfq/84MDTDHMsIIZuXu0b1nidkWI4kxu/sCq3pvDYgMW8NU/LP6QAfKnpN2JtPgOg
         WIGT8ysogsgME/7iu284DzmEoWJRouRYUYfiY9gkvn+cdieYkZTpRhNjMVX2xt+zI0w4
         44tYBupds97YTVPZeGPhRAhDwcU2K5B3R0g+Tp/1owVmIRd1o+d4Gdz8/HiVoQ6gp4l3
         IxWw==
X-Gm-Message-State: AOJu0YxgoG2lhHvYV2LuB3ZlZQvc8XH1PpGg2lKs3ai4gNhjmTsK8R1c
	cmThZBRYxhorIxrDOZpNY2daYIXwt1HCSRwzlbpJVhHUoSILCubiEawcAshXJ/2Tu4wkt3OvP1H
	iEyv8mU8ouklWBQvYipq+0pbEjFnF4gV0lkJ2v7Zs2m3/xikaeYM=
X-Google-Smtp-Source: AGHT+IFgCJFRAEdCatbEEyt1dkivbhXKulJVm4PCNGMsDAlOALRuUzPfiE/IYq4C3gLnyRpoWNj6mRyMSw6OSavX/rU=
X-Received: by 2002:a05:6102:41a1:b0:48f:716c:1e9b with SMTP id
 ada2fe7eead31-490321372cemr12683212137.10.1720713468932; Thu, 11 Jul 2024
 08:57:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Daire Byrne <daire@dneg.com>
Date: Thu, 11 Jul 2024 16:57:12 +0100
Message-ID: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
Subject: overlayfs: NFS lowerdir changes & opaque negative lookups
To: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Apologies for what I assume is another frequent (and long) "changes
outside of overlayfs" query, but I *think* I have a slightly unique
use case and so just wanted to ask some experts about the implications
of the "undefined behaviour" that the documentation (rightly) warns
against.

Basically I have a read-only NFS filesystem with software releases
that are versioned such that no files are ever overwritten or changed.
New uniquely named directory trees and files are added from time to
time and older ones are cleaned up.

I was toying with the idea of putting a metadata only overlay on top
of this NFS filesystem (which can change underneath but only with new
and uniquely named directories and files), and then using a userspace
metadata copy-up to "localise" directories such that all lookups hit
the overlay, but file data is still served from the lower NFS server.
The file data in the upper layer and lower layer never actually
diverge and so the upper layer is more of a one time permanent
(metadata) "cache" of the lower NFS layer.

So something like "chown bob -R -h /blah/thing/UIIDA/versionXX/lib" to
copy-up metadata only. No subsequent changes will ever be made to
/blah/thing/UIIDA/versionXX/lib on the lower filesystem (other than it
being deleted). Now, at some point, a new directory
/blah/thing/UIIDB/versionYY/lib might appear on the lower NFS
filesystem that has not yet got any upper directory files other than
perhaps sharing part of the directory path - /blah/thing.

Now this *seems* to work in very basic testing and I have also read
the previous related discussion and patch here:

https://lore.kernel.org/all/CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com

My first question is how bad can the "undefined behaviour" be in this
kind of setup? Any files that get copied up to the upper layer are
guaranteed to never change in the lower NFS filesystem (by it's
design), but new directories and files that have not yet been copied
up, can randomly appear over time. Deletions are not so important
because if it has been deleted in the lower level, then the upper
level copy failing has similar results (but we should cleanup the
upper layer too).

If it's possible to get over this first difficult hurdle, then I have
another extra bit of complexity to throw on top - now manually make an
entire directory tree (of metdata) that we have recursively copied up
"opaque" in the upper layer (currently needs to be done outside of
overlayfs). Over time or dropping of caches, I have found that this
(seamlessly?) takes effect for new lookups.

I also noticed that in the current implementation, this "opaque"
transition actual breaks access to the file because the metadata
copy-up sets "trusted.overlay.metacopy" but does not currently add an
explicit "trusted.overlay.redirect" to the correspnding lower layer
file. But if it did (or we do it manually with setfattr), then it is
possible to have an upper level directory that is opaque, contains
file metadata only and redirects to the data to the real files on the
lower NFS filesystem.

Why the hell would you want to do this? Well, for the case where you
are distributing software to many machines, having it on a shared NFS
filesystem is convenient and reasonably atomic. But when you have
sofware with many many PATHs (LD_LIBRARY, PYTHON, etc), you can create
some pretty impressive negative lookups across all those NFS hosted
directories that can overhelm a single NFS storage server at scale. By
"caching" or localising the entire PATH directory metadata locally on
each host, we can serve those negative lookups from local opaque
directories without traversing the network.

I think this is a common enough software distribution problem in large
systems and there are already many different solutions to work around
it. Most involve localising the software on demand from a central
repository.

Well, I just wondered if it could ever be done using an overlay in the
way I describe? But at the moment, it has to deal with a sporaidcally
changing lower filesystem and a manually hand crafted upper
filesystem. While I think this might all work fine if the filesystems
can be mounted and unmounted between software runs, it would be even
better if it could safely be done "online".

Things like fscache can also add NFS file content caching on top, but
it does not help with the metadata PATH walking problem endemic in
large clusters with software distributed on shared filesystems. I'm
suggesting a local metadata cache on top for read-only (but updated)
NFS software volumes.

Anyway, that's my silly idea for "lookup caching" (or acceleration) -
too crazy right? ;)

Daire
