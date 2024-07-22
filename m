Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAD916E863
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jul 2024 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721662080; cv=none; b=ND/4FAj5v7oozK9O3otMBnTYtxn6qXjNA5TiV8oiUwqjxWNN7Xug2Srdewq+kdtOONHZA6b2QtwkoVNLBEyJkJ1tnXThZxflGlUpwR29j8bpIEebZNUEioRWou4K0g1aKh8JJLgYtSyYW2SdEBEt4ickrU7oO7oLtTXWhREejTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721662080; c=relaxed/simple;
	bh=Kys96NMeBZW+4l2I5Z+S0tJCFNNuogbeanfdL8pEl9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JpLosoWFVh2d/KTwKWO4/j64FDr+S3t0HrG2BPwT/0xzoFR1WEoUVyHu1WCZBBcLsJFE3t9VfdQdkezaNyw9KNAcuIfV1ifeJ9+JCFjdJqmO1UBJ3rNtjyh8qVDWZWeWZ/3xn3FNzjclsuU2lPMDs0/gkzaHu1tE/fBLt/9Gj+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=w9RiFIRr; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="w9RiFIRr"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-4f511fddfcfso630909e0c.1
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jul 2024 08:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1721662076; x=1722266876; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jxObtDwmQ1v+MTJ5Z/YrAmxAETTopMyIa2Ezh+Sfv7Y=;
        b=w9RiFIRrjSEl0XEd3RUUSpNvqKohdv5svi4JhCBQi7ylJ/No10t96I5JiDItksDlxZ
         ugpa3IuszLsbBR7H6UbvTMXAs7EQzljSGAXaZ0/j0KizLeHyhgK8ulBVGvDtktvqXsmT
         4Gh0RcLSj4qLJbX2e5SqSXF5KeyP81BhvjYkFaVN5Kp44TXRnTzW47QhDPhOdJIm3/e9
         wOya+9iY0tadK+K4p+qEvCBv1NymgtmIOAqu4P5+I6YPG6177GIrPHraIiZwMJDi6J4W
         aC78IJ0RaGB1DzAFX4a67nX+aveeS8AtbkuaNdzoy0BR/eX56RPL7OX8yOb/odRo0fql
         1tSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721662076; x=1722266876;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jxObtDwmQ1v+MTJ5Z/YrAmxAETTopMyIa2Ezh+Sfv7Y=;
        b=WDcVx8Wz684+7cgTTaoY+JwqxRGrwVufSXjyX4MW/QzcKR+i7wGPeigh32ZVJM1SP5
         8QVPHXrY8Lw3N9rydaMoM1PcK1zBCf+BQX3op9X0dCwftNr3kqWGtFjCwumZch9vV2Nw
         BJwMdLAj/aYOms2p620ltpd6DEogMoW8U0NUYDapk1lgbLagKwM+/cXcKCZ1FIArOmLU
         oGk0ltQ1wavP9s0eusTU9MjTjoSO8vvqhmm7fsNGBYUz5EUhN44wDrhalJPyxKTtUGst
         O7rNx1rvc3pQnDtjWmnX/zoWZ5Uf94dxZsoqrGyAFSbh7MDHYwZ7eF5iXhVicwzjp0u0
         eRGA==
X-Gm-Message-State: AOJu0YxcoaEcQGXHpwAEdQAMw02HRYra+KI0LMdJyGK3fNZzALGTi6X8
	aN1R/3N+a9mRv4Vdp1pF5UFXO224l96Wf0HI7whymyGIeYAc5mijTm+fJkqi3zgGTXWBG20IxGg
	/b0VsUYJknQXCAbUS6zDwecv3+lEup+UFKMllrVRlDOaFBctYk58=
X-Google-Smtp-Source: AGHT+IHVISRI6n0QwHTnfScvLPtUIKLGSQITUH4w2ctYOia6T6RSk2NpDaB0nhKrylac9RGyj1AE1+GKksoDZI2uo4k=
X-Received: by 2002:a05:6122:181f:b0:4f5:12d3:799a with SMTP id
 71dfb90a1353d-4f68e43aaacmr311116e0c.2.1721662076350; Mon, 22 Jul 2024
 08:27:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <CAPt2mGPWzGGZdGGRg2CEQw0QnHNSm7o7xpHow65R+iJ0BO5CMQ@mail.gmail.com>
 <CAOQ4uxg16b7SJrsN=5kvE0QSD94-VoHiWTCvGVbGEcaadfVmeA@mail.gmail.com>
 <CAPt2mGOkxUE7t22SrcW6hHW+OaccNuB8Xem-hVAv-aiyteiXqw@mail.gmail.com>
 <CAOQ4uxgyjXU7_-SnpbfvDTFzjKekB+sxRp3Ea+LSrrQrkMcf1w@mail.gmail.com>
 <CAPt2mGP_fS2MOVzat9kFE-W+JkUXCpS87WfJEb_YiosR5Tn-NA@mail.gmail.com>
 <CAOQ4uxhO21UqcppSqoXO7QLOUAHVjRGkN1Ao=WrNGCc7GHaD6w@mail.gmail.com>
 <CAOQ4uxjAG_mcZBZ=Yi7i2zVjizEEGiw7mAfM9wu23KqBAGSnug@mail.gmail.com>
 <CAPt2mGNdNtSFQchwCFD9r1cDa4URJ7BVF7HwuzQUCp2qK30shw@mail.gmail.com> <CAOQ4uxgJwoudXw9pMw9nz5d5SCuryxv-O9fpnRcPcwqg4nk1hw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgJwoudXw9pMw9nz5d5SCuryxv-O9fpnRcPcwqg4nk1hw@mail.gmail.com>
From: Daire Byrne <daire@dneg.com>
Date: Mon, 22 Jul 2024 16:27:12 +0100
Message-ID: <CAPt2mGNf7q_g6FJsgA=pcx-OWS7GrWs1CEO+JaqViDYPvaW21A@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Mike Baynton <mike@mbaynton.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jul 2024 at 10:19, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > >> Basically, I need to be able to continue serving the same files and
> > > >> paths even while the copy-up metadata process for any part of the tree
> > > >> is in progress. And it sounds like your idea of considering a copy-up
> > > >> of a merged dir as "complete" (and essentially opaque) would be the
> > > >> way to do that without files or dirs ever moving or losing access even
> > > >> momentarily.
> > > >
> > > >
> > > > Yes, that's the idea.
> > > >
> > > > I'll see when I get around to that demo.
> > >
> > > I found some time to write the POC patch, but not enough time
> > > to make it work :) - it is failing some fstests.
> > >
> > > Since I don't know when I will have time to debug the issues,
> > > here is the WIP if you want to debug it and point out the bugs:
> > >
> > > https://github.com/amir73il/linux/commits/ovl-finalize-dir/
> >
> > This is very cool - many thanks!
> >
>
> Pushed two fixes to this branch - now it passes fstest - please re-test.

I can confirm the root dentry issue is fixed and I now see a lot less
ENOENTs hitting the lower (NFS) directory. For my test case, we go
from ~80,000 -> 27,000 ENOENTs, a great improvement.

However I was still seeing some lookups hitting the lower layer in
directories that had opaque=z. After a bit of testing and much head
scratching, it seems like you need to do something like "ls
/olv/blah/thing/version/lib" to force a readdir of the lower NFS
filesystem (after remount) to reliably stop the lookups hitting the
lower filesystem.

For example, after doing the steps to copy up metadata and set
opaque=z, we then remount and test the effect:

chown -R -h bob /olv/blah/thing/version/lib
ls -lR  /ovl/blah/thing/version/lib
umount /ovl
mount /ovl
for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM};done

This will always send the lookup to the lower level. But if we do:

ls -l /olv/blah/thing/version/lib
for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM}.so;done

this triggers a readdir of the lower NFS dir and then the random file
lookups only hit the upper layer as expected.

So then I'm not entirely clear why in my real world test *most* of the
negative lookups are served by the upper level but some are not. I can
only think that loading software *mostly* triggers READDIRs on things
like lib dirs, but not always?

It may also be complicated by the fact that we often have symlinks at
various points in the path too (both dir & file).

> ovl will lookup the lower data of a metacopy file at lookup time.
> Perhaps we could do lazy lookup of data files, like we do with
> data-only layers, but this would be more complicated and in any
> case, stat(2) needs the lower data file to present the correct
> value of st_blocks.

Right... for some reason I thought it only needed st_size which it
could get from the sparse file.

> IOW, this patch mainly helps to prevent *negative* lookups
> in the lower layers.
>
> > expect no lookups to the lower for negative lookups? Unless we can't
> > serve negative lookups from the readdir of the upper dir?
>
> Correct expectation.
> The bug was fixed. It should hopefully work now,
> although I did not test.
>
> >
> > I have probably misunderstood that the "finalized" directories will
> > only serve the contents of the readdir result and not send metadata
> > lookups to the lower level (ala dir=opaque). Or my v6.9.3 kernel has
> > some other issue unrelated to this patch....
>
> You understood almost correctly, but you need to understand that
> the finalized directory is not completely opaque, it is partly opaque.
> You can visualize this as painting the space "between entries" opaque,
> so that negative lookup results will stop as well as readdir, but ovl
> will still look *underneath* entries.
>
> BTW, ovl will also lookup in lower dirs if entries inside an upper
> opaque dir have an absolute path redirect xattr.
> This type of upper opaque dir is also called "impure" and has an
> "impure" xattr.
>
> So you may say that the difference between an opaque=y
> dir and opaque=z dir is that in the latter, all entries are treated
> as if they have an absolute path redirect (to their own path),
> but that is a very hand wavy way of putting it.

Yea, that makes sense to me.

> Anyway, if you are happy with the patch and want to see it upstreamed,
> I have few requests:
>
> 1. Please provide your Tested-by.
> 2. Please provide a detailed cover letter that explains the problem (*)
>     and how the patch fixes it, which includes performance gain numbers.
>     You may post the cover letter with my patch or ask me to do it

I'll draft up something for review and I'll try to keep it concise.

> 3. Please write an fstest to test the finalized dir feature (**)
>     You may want to look at test overlay/031 for inspiration
>     if also makes changes to layers offline and examines the outcome

Bear with me... I'll have a look and see if I can figure it out.

> (*) Please do NOT include the story of changing lower entries
>     under a mounted overlayfs - they are not relevant to this patch
>     and they are very controversial.

Understood. However, I do suspect that some are using this "undefined
behaviour" because it worked for their use case. This patch might ruin
their day?

> (**) Basically do chown -R and ls, unmount overlay, add lower entry
>     re-mount overlay and verify that it is not observed.
>     Can also sanity check that opaque=z was set.
>     Note that adding lower entries offline is a behavior that was once allowed
>     and some users actually expect it to work, so I made the feature
>     depend on !ovl_allow_offline_changes(ofs).
>     Therefore, the test should explicitly require and enable metacopy for
>     overlayfs mount to enable the finalized dir feature.

Many thanks,

Daire
