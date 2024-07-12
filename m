Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8862D528
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720775362; cv=none; b=azegrC311WuiRuuxfszO3pSa5rtVu4AjohMPoFVFta1yQDYZABsAIkt0y8ZjEyJKrDFAkm7pAOZeI16bFxfABG35jRe6Wr357lknU5HzZJRAuGCb+cjcAnCFDGQRkq+Bu2uYPec+6Rw0Uv4JmcLsRknoamRbAfngbLhNWIyxJYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720775362; c=relaxed/simple;
	bh=pTXp6F+h0edrIIdY0miio2a+6rNkqjhKOIuKSdYM14A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WHHB1q85+L2oj2pvv0dXtkyxbpTp8cXk/ik7O/sPoz59WvrjuZWLaGUl/AFQKPH62Q8EQNedW/ICGF6bxPLzVmy3DsZ7PuEVOqmpwTjqT0INnRTfyAd2PDY/MRDI2JYf2w6diTvsEch2OZD7W7eyofbzb9Q1qre2b/X2KhpjJpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A41jynXT; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A41jynXT"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-79f02fe11aeso136016585a.2
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 02:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720775360; x=1721380160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Rg9i3elTCRfDcWeJk8PwL/3PJicV9/G5lYJ3uqwSLw=;
        b=A41jynXTTG9bXDLvdqUv+0yKIZyM0rUemB9SXvTh9NE/2qd/Fbj3XrqHyR6aIyjgVE
         snFLzqkIIsVXViaikCgfEAOzurr3m9wE8i+eEaIovlBVBynkH8iPD3gE/yH3Un3wTsFb
         9y568hsmXZQrLAy64VrNkVx73Id17Ow9HhnkBonYnQHfCHaTlCDvZZG20g3AfIaiujXR
         EQvrahxWf0v5nArp9o9qcN+GNv3aFSMcYQNXiPNLCvyKuHQFL310Ij7379XT7Vqwclbw
         /peYcaNsTTtN/42zIL0o+ddgDmcXKjezsGMSn/63wTdSlyYJblqJ+KxMWAzFpUj2otmK
         fFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720775360; x=1721380160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Rg9i3elTCRfDcWeJk8PwL/3PJicV9/G5lYJ3uqwSLw=;
        b=rCGWmTR33Cb4hDURwRxsQuI2TUXqWKvFDnSOPCxfQCPYQHhirRBjhSkG/Go7ktS2tb
         UmObA42dHgijsU2c+Rqt7kMEyO0P0f+2scF2I3aGdDZQF9vN8eGnxQIElMK4+OfRyMqW
         WbhzDg68dROFQkT+pFwHBG/vLyD2IimciTQVCYiEe7dAJAW5/74nFbB7NIqkTdTHTW0J
         vc9pNZZH8qLTo/AZ0uA1qpI+cOqZp6NQojJd+E9fvQdc/b2z6kQMuDlJ+CYqjKhIOeg+
         f9cFEV9NZVPrqP93s69LvA7t9blHIwdU0oUQ7rn+aIMdWcq+LYwwf0RurMibkiYek0aq
         OVOA==
X-Forwarded-Encrypted: i=1; AJvYcCWZQ9KKA+/HAANDeRV0yWd0VGxF5uA12HfTXzO13OOZ8ww4KjGFzd6T8dqBt7fvHUyXQLgWsOlSSSO+uYcDXexoisraLEsJdcX5yJbQ3A==
X-Gm-Message-State: AOJu0YzEd7ZNM4CTs5nV0wymWUyQypV0oxOY1G1NawmlNjR6aEQ0PVBG
	yKfAKFMLpM5vALIGUn+8t23Nxt4FdsPALPPwEY7bOvWBxk07Melh8zjIsH1cTGLchbCDLAeKyWk
	gQy0lPsN+yb4BuCJYRhPPerPWYfpW2EOF
X-Google-Smtp-Source: AGHT+IF8/fKQkE5SYjOMFCNFLXb/n3MRmXTAXwRnwLGbuUSky8dOOPrNPwDzt8BoJieX5gYoz5F+WvFQ88TdOvHwAOE=
X-Received: by 2002:a05:6214:2a88:b0:6b5:470:c876 with SMTP id
 6a1803df08f44-6b61bcdb5ccmr135997286d6.24.1720775359509; Fri, 12 Jul 2024
 02:09:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com> <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
In-Reply-To: <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 12 Jul 2024 12:09:08 +0300
Message-ID: <CAOQ4uxiSm0Le4dYx_R2WPmF9Ut8z6eZinN-qvDrG+Y2GnX11fg@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Mike Baynton <mike@mbaynton.com>
Cc: Daire Byrne <daire@dneg.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 6:24=E2=80=AFAM Mike Baynton <mike@mbaynton.com> wr=
ote:
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
>

Nice.
I've always wished that data-only would not be an "offline-only" feature,
but getting the official API for that scheme right might be a challenge.

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

Assuming that this "effectively-data-only" NFS layer is never iterated via
overlayfs then adding new unreferenced objects to this layer should not
be a problem either.

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

Yes, it is almost the same as data-only layer.
The only difference is that real data-only layer can never be accessed
directly from overlay, while the effectively-data-only layer must have
some path (e.g /blobs) accessible directly from overlay in order to do
online rename of blobs into the upper opaque layer.

> This way seems interesting and more promising for adding NFS-backed
> files "online" though.
>
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

Yes, what overlay did not observe, overlay cannot know about.
But the devil is in the details, such as what is an "accessed
filesystem object".

In our case study, we refer to the newly added directory entries
and new inodes "never accessed by overlayfs", so it sounds
safe to add them while overlayfs is mounted, but their parent directory,
even if never iterated via overlayfs was indeed accessed by overlayfs
(when looking up for existing siblings), so overlayfs did access
the lower parent directory and it does reference the lower parent
directory dentry/inode, so it is still not "intuitively" safe to change it.

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
>
> How much proving/testing would you want to see before documenting this
> and supporting someone in future who finds a way to prove the claim
> wrong?
>

*very* good question :)

For testing, an xfstest will do - you can fork one of the existing
data-only tests as a template.

For documentation, I think it is too hard to commit to the general
statement above.

Try to narrow the exception to the rule to the very specific use case
of "append-only" instead of "immutable" lower directory and then
state that the behavior is "defined" - the new entries are either visible
by overlayfs or they are not visible, and the "undefined" element
is *when* they become visible and via which API (*).

(*) New entries may be visible to lookup and invisible to readdir
     due to overlayfs readdir cache, and entries could be visible to
     readdir and invisible to lookup, due to vfs negative lookup cache.

Note that the behavior of POSIX readdir() for entries added while
an open dir fd is being iterated is similar - the new entries will either
be visible in the iteration of that fd or they won't be, but there is
a clear "barrier" when the new entries will become visible
(on seek to start or open of new fd).

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

Feel free to post this patch if you find it useful.
The commit message should say that the mount option
check does not reflect the actual dependency in the code,
and it should also explain very well why this mount option combination
is desired and lore Link: to this conversation.

Thanks,
Amir.
