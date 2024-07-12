Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C10526AED
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720785923; cv=none; b=JelFQbDI+W7rYJK/7dY8U7PJ+E2t+oFujStzDZEMqbXrfR+SRHNPe0We2N4ub8qydUlkHqZGZ5g8QzSdSVpmPtM90hvOOp/Erdphwqv/4g++kP+kvT2wr2/K9sJbAHkGxdHyV5LS/0I29HY8ST+yh07Yug9Otlm/XpjGJTuFuwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720785923; c=relaxed/simple;
	bh=eGQ3YXPMkWNr/FRSxxhdZKqHnfNEVlw95e9+jpDfU84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MgL2u6q6tkC5FqHPOwZ+z+mKjzAnlfCBHD+c2vVfdrjwhOOcDMOzWiuUtCfVLgKdQ6UrCH6JtEHHm3NJzrxiAzxH5mXIrt68ODHcVfwk3dUVbAEonthLh65/26q3suUR4iC9MPOLeoBJJVLHJYjRBLrqkcjD9heqXqVL5w++ems=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=TB8X+3+o; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="TB8X+3+o"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6b5e0d881a1so22821996d6.1
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 05:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1720785920; x=1721390720; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7F00E+chsxSZicCHyonr4EAGP5+uZZIaXSXm/1AL3M=;
        b=TB8X+3+o5Eo066bDZ1Gl+UAiIUP2yBLqjBDv1FLhrzg7HkaztTxJQ9vBesK3rBbXZ4
         H0y2hGAx9iR+3htg07cLoxRLOhIwHCd9BQww25M8XerOJaRuqboW2kORaGM7D3mWzgoE
         6fzZ2Ws3PHyrR+UvLJr3l497YtAmVI3ujzHBPAFJyfXY29L489scLPf9IDKCobW+iSvZ
         EvNM0uMfuVTwPpKsjU2DCN7zvKYXusH7VBk9YGOaVdRV4o40693CEnb0k0Tz7sPWTt2c
         sc2wziYom9zJqEIVWOl8Clkxjzf5wkyugiUZYHRo80e05RLhC7FpVxZ3r/fqgFhXQl2/
         UA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720785920; x=1721390720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s7F00E+chsxSZicCHyonr4EAGP5+uZZIaXSXm/1AL3M=;
        b=i7AcOU2PsuUNr6OWLlhyiVMmWwAfgdKSPEEXhTi2N3PRCM/p9hknJhkWFtGX1tSD+S
         VIT188y+qK248ecwS/faNFgtvKVhrkhpKyhRXi4JDfuWy5foQfEbthdiX7McfDmTV2BE
         zwZW62zXcO2T2v1sEn8Xyn7TkOEdib+92AgKpaby3F0BmrD0xTa0g61/Ol26HeW/xco9
         wyqCBCYR3BDDkRzUDUrbl0sFbEPN5/Tbz1WbZZS6NbBz3IZaU1KWGwqxMITdDNJSMa4P
         evaVO4IJ0q5d49y0e7gD2nWEsf43kvSF9vpLJt6yys4rBBsXPDtCdfB/0sDHYjuKllsh
         +7eA==
X-Forwarded-Encrypted: i=1; AJvYcCVtFWBVcCO02no9/OOBKyXrmZI09nifauJovZHBUyI+ucq2drD3r3gxx1FP/ufQHSUN4ixmBUqHXGMD1kINrnUXuRKhSBe55+NUUQOMLA==
X-Gm-Message-State: AOJu0Yy5gIBlyYYDodKiG9ADYvuCZa6Xl+ptJQwe7jyPRiXwiHPNGCsx
	pknYte3JjgorZYoUZ9223QHiWgWMUI4vRyPUGlbqtL0at+Z88p1uCLfckkkYlCqazIx52R1jmyt
	lb/XFbinH6v4598i6mWsP2UeT5q5Pq6gsFL5rpw==
X-Google-Smtp-Source: AGHT+IH13DmmnvIsaLm3vLq+iguLYYnhrR10rbexUUViVEW0WYd0iKI6PMRVMpVB2FbvC2nc14FelSAWyqhyAE1pRuk=
X-Received: by 2002:ad4:5c48:0:b0:6b0:74cb:96d9 with SMTP id
 6a1803df08f44-6b754c20c4emr36128546d6.30.1720785920122; Fri, 12 Jul 2024
 05:05:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com> <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
In-Reply-To: <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
From: Daire Byrne <daire@dneg.com>
Date: Fri, 12 Jul 2024 13:04:43 +0100
Message-ID: <CAPt2mGNO_koGozPx68GwowuxDd+CkZWT3Xa7DE-4XCwd9K_RJw@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Mike Baynton <mike@mbaynton.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jul 2024 at 04:24, Mike Baynton <mike@mbaynton.com> wrote:
>
> On 7/11/24 18:30, Amir Goldstein wrote:
> > On Thu, Jul 11, 2024 at 6:59=E2=80=AFPM Daire Byrne <daire@dneg.com> wr=
ote:
> >> Basically I have a read-only NFS filesystem with software releases
> >> that are versioned such that no files are ever overwritten or changed.
> >> New uniquely named directory trees and files are added from time to
> >> time and older ones are cleaned up.
> >>
> >
> > Sounds like a common use case that many people are interested in.
>
> I can vouch that that's accurate, I'm doing nearly the same thing. The
> properties of the NFS filesystem in terms of what is and is not expected
> to change is identical for me, though my approach to incorporating
> overlayfs has been a little different.
>
> My confidence in the reliability of what I'm doing is still far from
> absolute, so I will be interested in efforts to validate/officially
> sanction/support/document related techniques.
>
> The way I am doing it is with NFS as a data-only layer. Basically my use
> case calls for presenting different views of NFS-backed data (it's
> software libraries) to different applications. No application wants or
> needs to have the entire NFS tree exposed to it, but each application
> wants to use some data available on NFS and wants it to be presented in
> some particular local place. So I actually wanted a method where I
> author a metadata-only layer external to overlayfs, built to spec.
>
> Essentially it's making overlayfs redirects be my symlinks so that code
> which doesn't follow symlinks or is otherwise influenced by them is none
> the wiser.

Yea, so I have also toyed with the "composefs" idea of having
completely seperate metadata and data, but our sofware bucket is so
big and complicated, it would be a real effort to maintain coherence
between the two.

Our pipeline is also hard coded to use the specific /blah/software
mount tree and chopping that up into fragments and replicating the
structure would be a lot of effort too.

Basically I liked the idea of having our current NFS mount to always
fall back on and provide that compatibility, but being able to tweak
or change parts of that large tree in an overlay to optimise
performance or even change behaviour.

I should also say that we do also use "symlink" collections for some
of our software such that we compress 100 unique PYTHONPATHs down to a
single PYTHONPATH directory full of file symlinks to all the 100
PYTHONPATH install directories. Again this helps with the "negative
lookup" storm that can happen when looking for files as this single
big directory can serve all those lookups and answer once for each
file rather than amplify the negative lookup across 100 directories.

But even then, our software stack and dependencies are so big and
complex, that we are unable to do this for every component of the
software. So when I say we take 100 directories off the path and
compress it down to 1, there are still another 50 we could not include
in that (for various reasons). So we actually reduce from 150
directories to 50 + 1 which is better, but still a lot of filesystem
walking.

So if we still have to do all these negative lookups and walk paths,
can we do it locally rather than have 1000s of clients all do it over
NFS?

> >> My first question is how bad can the "undefined behaviour" be in this
> >> kind of setup?
> >
> > The behavior is "undefined" because nobody tried to define it,
> > document it and test it.
> > I don't think it would be that "bad", but it will be unpredictable
> > and is not very nice for a software product.
> >
> > One of the current problems is that overlayfs uses readdir cache
> > the readdir cache is not auto invalidated when lower dir changes
> > so whether or not new subdirs are observed in overlay depends
> > on whether the merged overlay directory is kept in cache or not.
> >
>
> My approach doesn't support adding new files from the data-only NFS
> layer after the overlayfs is created, of course, since the metadata-only
> layer is itself the first lower layer and so would presumably get into
> undefined-land if added to. But this arrangement does probably
> mitigate this problem. Creating metadata inodes of a fixed set of
> libraries for a specific application is cheap enough (and considerably
> faster than copying it all locally) that the immutablity limitation
> works for me.
>
> >> Any files that get copied up to the upper layer are
> >> guaranteed to never change in the lower NFS filesystem (by it's
> >> design), but new directories and files that have not yet been copied
> >> up, can randomly appear over time. Deletions are not so important
> >> because if it has been deleted in the lower level, then the upper
> >> level copy failing has similar results (but we should cleanup the
> >> upper layer too).
> >>
> >> If it's possible to get over this first difficult hurdle, then I have
> >> another extra bit of complexity to throw on top - now manually make an
> >> entire directory tree (of metdata) that we have recursively copied up
> >> "opaque" in the upper layer (currently needs to be done outside of
> >> overlayfs). Over time or dropping of caches, I have found that this
> >> (seamlessly?) takes effect for new lookups.
> >>
> >> I also noticed that in the current implementation, this "opaque"
> >> transition actual breaks access to the file because the metadata
> >> copy-up sets "trusted.overlay.metacopy" but does not currently add an
> >> explicit "trusted.overlay.redirect" to the correspnding lower layer
> >> file. But if it did (or we do it manually with setfattr), then it is
> >> possible to have an upper level directory that is opaque, contains
> >> file metadata only and redirects to the data to the real files on the
> >> lower NFS filesystem.
>
> So once you use opaque dirs and redirects on an upper layer, it's
> sounding very similar to redirects into a data-only layer. In either
> case you're responsible for producing metadata inodes for each NFS file
> you want presented to the application/user.
>
> This way seems interesting and more promising for adding NFS-backed
> files "online" though.

I guess the difference is that I'm not trying to replicate the
entirety of the metadata, I just want to tweak bits of it and still
avail of the overlay merged directories to fall through to the
directory tree and data underneath for everything else.

> > how can we document it to make the behavior "defined"?
> >
> > My thinking is:
> >
> > "Changes to the underlying filesystems while part of a mounted overlay
> > filesystem are not allowed.  If the underlying filesystem is changed,
> > the behavior of the overlay is undefined, though it will not result in
> > a crash or deadlock.
> >
> > One exception to this rule is changes to underlying filesystem objects
> > that were not accessed by a overlayfs prior to the change.
> > In other words, once accessed from a mounted overlay filesystem,
> > changes to the underlying filesystem objects are not allowed."
> >
> > But this claim needs to be proved and tested (write tests),
> > before the documentation defines this behavior.
> > I am not even sure if the claim is correct.
>
> I've been blissfully and naively assuming that it is based on intuition
> :).
>
> I think Daire and I are basically only adding new files to the NFS
> filesystem, and both the all-opaque approach and the data-only approach
> could prevent accidental access to things on the NFS filesystem through
> the overlayfs (or at least portion of it meant for end-user consumption)
> while they are still being birthed and might be experiencing changes.
> At some point in the NFS tree, directories must be modified, but since
> both approaches have overlayfs sourcing all directory entries from local
> metadata-only layers, it seems plausible that the directories that
> change aren't really "accessed by a overlayfs prior to the change."

Yes, I think your case has a good chance of being safe and becoming
well defined behaviour.

But my idea was still very much relying on using the majority of the
lower layer as is. And for all the reasons given, I suspect my use
case is still a no-no.

> How much proving/testing would you want to see before documenting this
> and supporting someone in future who finds a way to prove the claim
> wrong?
>
> >
> > One more thing that could help said service is if overlayfs
> > supported a hybrid mode of redirect_dir=3Dfollow,metacopy=3Don,
> > where redirect is enabled for regular files for metacopy, but NOT
> > enabled for directories (which was redirect_dir original use case).
> >
> > This way, the service could run the command line:
> > $ mv /ovl/blah/thing /ovl/local
> > then "mv" will get EXDEV for moving directories and will create
> > opaque directories in their place and it will recursively move all
> > the files to the opaque directories.
>
> Clever.
>
> Thanks,
> Mike

Thanks for the support! Certainly creating metadata only layers with
data layers is something I have considered. But for many of the same
reasons that we cannot compress all our PATHs to a single directory
full of symlinks, I'm not sure I will be able to construct a concise
metadata only layer without a much deeper understanding of how our
devs are building and deploying software. And I'm not sure I have the
mental fortitude for that journey :)

Daire
