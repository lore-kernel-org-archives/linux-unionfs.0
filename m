Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A471E8F6D
	for <linux-unionfs@vger.kernel.org>; Sat, 27 Jul 2024 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722101488; cv=none; b=MIJOVfFat2ltF3Z2Ws94jaA1wbW21doCIgmWuDeEhCOAGxqwPlc753Iw42PMDOsCN49QjkhexihA5YQVP6mcUbZc5N3DIUcoJaxZp7uyLtazCiTM6ZELJZ4MneoPWQz7NeTD2bkBgM404zFH916IJ2PBzzfhRbBrZQnJYsAoXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722101488; c=relaxed/simple;
	bh=YB4E8oIJGHifUne36c3zaSyUUrUAidRJ/pLPxBMSng8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W6lLQrYpBixHqcLgv0kqNg4pMPQafd2Bld/5Ty5D7zRTehcwd4wq33Qqgcqlm6JuuZF8A+CV+NttAUgdC0ygEjdjwxDl3p9BnTwqRFjdXkVdGb3/P5TRKmp5TwwpETopWlZIOgNFGfCfaOZObjnDpOnA7twXQSGV7EpvDwHn6v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KpK2HsBi; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KpK2HsBi"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-66493332ebfso6762067b3.3
        for <linux-unionfs@vger.kernel.org>; Sat, 27 Jul 2024 10:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722101485; x=1722706285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=diGCP5EH2uPVFKUuR26WA5amKoQKQxcGSt3vsh+qd58=;
        b=KpK2HsBiKwCJZBWHNa60ChdA7mteGtAGZmSLt/fIcLBEINp3KjoPuzesX/yC4qVRj8
         7iuxkZoPl1BY7V4Mq+KnRlY6f3m2OhonA8xxa/9rSDEtFpiNcfjEBNey7j0nnLPhhzPN
         vA022Ar6+crFSkV7+wV9Rq4AePsR067SEyJe6A++mkUnqvtJwzyQmpIzZ01CQxU3ZTKT
         KQo4i3063NvsAzKDLjM58oSKFVQl7pXbsb3A4euQQEMJlekseVFYq4avYdHwmC65J2k+
         GmJin5Qm5anZZIXAB47q1IQ/XhhLHTPOzXq4FU9sR8wDcojGPq9yLNMab6751LoZkIud
         eWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722101485; x=1722706285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=diGCP5EH2uPVFKUuR26WA5amKoQKQxcGSt3vsh+qd58=;
        b=C5EcI+c2J81/RNlp1Xfel27YCUyX7eW+rmB5bKDNV6Pdyhtgo7P9TIDVHQfMCfH0Bo
         wS2QU9077utLzENNuuOW8ogSPSlwMjKDeDEB/lJoJMB3W5h1Jq3LUG9h4SIOPl3lmR3u
         2GbBK2K+REHkzpDexN2ybn9wgENrh5bafNAJsjjeAur62R3Caf8hPU0hbiCb/9LYaczD
         p5Bo/sSFHxqTRtSUeWxP+mZH0AOrjvSCavMZlIgJkSSG9Vr6QYGHr6j+0TMdlMz07Z0W
         M/irDeHnHxuzIszr2PjY90m4mJRHhszfeJgYx4gq5vFnsiyLL63M9tMXdUbEduGjunM5
         l1OA==
X-Gm-Message-State: AOJu0YxSaoQ4mqQmOz97InIZR20JMt1bPIFtMVn0YA2Zc9vfbF2MLX0B
	jodAu4tOT6trha4TRYoMofafnvDvApsoJdVImuQD+PyJDCVZVAT5JxNN6Wa8HsZid0auwQryODB
	V9mqUCzDNU3oE860MMKoj5iysgnT5x4rb
X-Google-Smtp-Source: AGHT+IFxNiZ7k2Q/TcS8oTkDfP7DunfcJ4n7b10W21K7t0c76yEPZU43V8Lre7fIzNAySwPfZ2Gxiy/jwWBH9aUlLg0=
X-Received: by 2002:a81:a212:0:b0:64b:7500:2e9 with SMTP id
 00721157ae682-67a05c8a291mr40780567b3.9.1722101485202; Sat, 27 Jul 2024
 10:31:25 -0700 (PDT)
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
 <CAPt2mGNdNtSFQchwCFD9r1cDa4URJ7BVF7HwuzQUCp2qK30shw@mail.gmail.com>
 <CAOQ4uxgJwoudXw9pMw9nz5d5SCuryxv-O9fpnRcPcwqg4nk1hw@mail.gmail.com>
 <CAPt2mGNf7q_g6FJsgA=pcx-OWS7GrWs1CEO+JaqViDYPvaW21A@mail.gmail.com>
 <CAOQ4uxjV7VbmGHdb68-d9r5L5xP6u9f1a-2S_kbjQu42GRcrSA@mail.gmail.com> <CAPt2mGMq+Z0nixWhE67is2UUw5v_Z7ZRaQrChOCMNCAT30ZDpQ@mail.gmail.com>
In-Reply-To: <CAPt2mGMq+Z0nixWhE67is2UUw5v_Z7ZRaQrChOCMNCAT30ZDpQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 27 Jul 2024 20:31:13 +0300
Message-ID: <CAOQ4uxiiVRsADsv4SsyNDzZjLoWAsx82no+o+OjpTPBz_Mn49Q@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Mike Baynton <mike@mbaynton.com>, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 6:22=E2=80=AFPM Daire Byrne <daire@dneg.com> wrote:
>
> On Tue, 23 Jul 2024 at 22:31, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Jul 22, 2024 at 6:28=E2=80=AFPM Daire Byrne <daire@dneg.com> wr=
ote:
> > >
> > > On Fri, 19 Jul 2024 at 10:19, Amir Goldstein <amir73il@gmail.com> wro=
te:
> > > >
> > > > > > >> Basically, I need to be able to continue serving the same fi=
les and
> > > > > > >> paths even while the copy-up metadata process for any part o=
f the tree
> > > > > > >> is in progress. And it sounds like your idea of considering =
a copy-up
> > > > > > >> of a merged dir as "complete" (and essentially opaque) would=
 be the
> > > > > > >> way to do that without files or dirs ever moving or losing a=
ccess even
> > > > > > >> momentarily.
> > > > > > >
> > > > > > >
> > > > > > > Yes, that's the idea.
> > > > > > >
> > > > > > > I'll see when I get around to that demo.
> > > > > >
> > > > > > I found some time to write the POC patch, but not enough time
> > > > > > to make it work :) - it is failing some fstests.
> > > > > >
> > > > > > Since I don't know when I will have time to debug the issues,
> > > > > > here is the WIP if you want to debug it and point out the bugs:
> > > > > >
> > > > > > https://github.com/amir73il/linux/commits/ovl-finalize-dir/
> > > > >
> > > > > This is very cool - many thanks!
> > > > >
> > > >
> > > > Pushed two fixes to this branch - now it passes fstest - please re-=
test.
> > >
> > > I can confirm the root dentry issue is fixed and I now see a lot less
> > > ENOENTs hitting the lower (NFS) directory. For my test case, we go
> > > from ~80,000 -> 27,000 ENOENTs, a great improvement.
> > >
> > > However I was still seeing some lookups hitting the lower layer in
> > > directories that had opaque=3Dz. After a bit of testing and much head
> > > scratching, it seems like you need to do something like "ls
> > > /olv/blah/thing/version/lib" to force a readdir of the lower NFS
> > > filesystem (after remount) to reliably stop the lookups hitting the
> > > lower filesystem.
> > >
> > > For example, after doing the steps to copy up metadata and set
> > > opaque=3Dz, we then remount and test the effect:
> > >
> > > chown -R -h bob /olv/blah/thing/version/lib
> > > ls -lR  /ovl/blah/thing/version/lib
> > > umount /ovl
> > > mount /ovl
> > > for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM};done
> > >
> > > This will always send the lookup to the lower level. But if we do:
> > >
> > > ls -l /olv/blah/thing/version/lib
> > > for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM}.so;do=
ne
> > >
> > > this triggers a readdir of the lower NFS dir and then the random file
> > > lookups only hit the upper layer as expected.
> > >
> > > So then I'm not entirely clear why in my real world test *most* of th=
e
> > > negative lookups are served by the upper level but some are not. I ca=
n
> > > only think that loading software *mostly* triggers READDIRs on things
> > > like lib dirs, but not always?
> > >
> > > It may also be complicated by the fact that we often have symlinks at
> > > various points in the path too (both dir & file).
> > >
> >
> > No again, it's just a bug.
> > My fix to initialize __lastmerged for root dentry broke initialization
> > of __lastmerged
> > for lookup of non-root dentry and readdir would fixup  __lastmerged lat=
er.
> >
> > Pushed a fix. Again, only sanity tested, so the finalize feature may
> > still have bugs.
>
> Yep, that totally fixed the issue - after a remount, the directories
> are still "finalized" and negative lookups are not hitting the lower
> NFS filesystem.
>
> So I have been doing some basic benchmarks to figure out how best to
> make the case for this patch being included upstream. I have also been
> looking at fscache too as it's a good companion to the idea of
> "caching" or "localising" both metadata and data for a remote NFS
> filesystem full of software releases.
>
> I took one of our more complicated applications with ~200 various
> paths (LD_LIBRARY, PYTHONPATH, PLUGINS, etc) and recorded the
> (tcpdump) packet capture and launch times:
>
> vanilla NFS - total packets=3D475531, NOENTs=3D69456, OPENs=3D61146
> fscache NFS - total packets=3D200120, NOENTs=3D69460, OPENs=3D61045
> fscache+overlay - total packets=3D67157, NOENTs=3D45, OPENs=3D6412
>
> The time to start the software went from 58s (vanilla NFS) to 32s
> (fscache+overlay). In both the fscache and overlay case, this
> measurement was taken after a remount where the fscache reads had been
> populated (so 0 READ calls over the network) and the lib directories
> had been copied up and finalised.
>
> I have also had pretty good success using a systemtap script to
> monitor for the NOENT lookups to lib dirs and pass those to a
> userspace daemon which then initiates the "chown -R -h bob
> /ovl/blah/thing/lib/" commands. I might try with bpftrace too to
> contrast and compare.
>
> I was a little surprised to see that the copy-up was also helping with
> reducing OPEN and LOOKUP calls hitting the remote filesystem, but I'll
> take that bonus improvement too. If we just take the fscache ->
> fscache+overlay case, there is an almost 4x reduction in packet counts
> (roundtrips) with the metacopy overlay. If we look at the improvement
> from the vanilla NFS mount we currently use, it's a 7x reduction in
> packets between client and NFS server.
>

Nice improvement :)

> > > > ovl will lookup the lower data of a metacopy file at lookup time.
> > > > Perhaps we could do lazy lookup of data files, like we do with
> > > > data-only layers, but this would be more complicated and in any
> > > > case, stat(2) needs the lower data file to present the correct
> > > > value of st_blocks.
> > >
> > > Right... for some reason I thought it only needed st_size which it
> > > could get from the sparse file.
> > >
> > > > IOW, this patch mainly helps to prevent *negative* lookups
> > > > in the lower layers.
> > > >
> > > > > expect no lookups to the lower for negative lookups? Unless we ca=
n't
> > > > > serve negative lookups from the readdir of the upper dir?
> > > >
> > > > Correct expectation.
> > > > The bug was fixed. It should hopefully work now,
> > > > although I did not test.
> > > >
> > > > >
> > > > > I have probably misunderstood that the "finalized" directories wi=
ll
> > > > > only serve the contents of the readdir result and not send metada=
ta
> > > > > lookups to the lower level (ala dir=3Dopaque). Or my v6.9.3 kerne=
l has
> > > > > some other issue unrelated to this patch....
> > > >
> > > > You understood almost correctly, but you need to understand that
> > > > the finalized directory is not completely opaque, it is partly opaq=
ue.
> > > > You can visualize this as painting the space "between entries" opaq=
ue,
> > > > so that negative lookup results will stop as well as readdir, but o=
vl
> > > > will still look *underneath* entries.
> > > >
> > > > BTW, ovl will also lookup in lower dirs if entries inside an upper
> > > > opaque dir have an absolute path redirect xattr.
> > > > This type of upper opaque dir is also called "impure" and has an
> > > > "impure" xattr.
> > > >
> > > > So you may say that the difference between an opaque=3Dy
> > > > dir and opaque=3Dz dir is that in the latter, all entries are treat=
ed
> > > > as if they have an absolute path redirect (to their own path),
> > > > but that is a very hand wavy way of putting it.
> > >
> > > Yea, that makes sense to me.
> > >
> > > > Anyway, if you are happy with the patch and want to see it upstream=
ed,
> > > > I have few requests:
> > > >
> > > > 1. Please provide your Tested-by.
> > > > 2. Please provide a detailed cover letter that explains the problem=
 (*)
> > > >     and how the patch fixes it, which includes performance gain num=
bers.
> > > >     You may post the cover letter with my patch or ask me to do it
> > >
> > > I'll draft up something for review and I'll try to keep it concise.
>
> I'll try to get to this next week.
>
> > >
> > > > 3. Please write an fstest to test the finalized dir feature (**)
> > > >     You may want to look at test overlay/031 for inspiration
> > > >     if also makes changes to layers offline and examines the outcom=
e
> > >
> > > Bear with me... I'll have a look and see if I can figure it out.
> > >
> >
> > I am not in a hurry. quite the contrary.
> > I have just a bit of time to help :)
> >
> > > > (*) Please do NOT include the story of changing lower entries
> > > >     under a mounted overlayfs - they are not relevant to this patch
> > > >     and they are very controversial.
> > >
> > > Understood. However, I do suspect that some are using this "undefined
> > > behaviour" because it worked for their use case. This patch might rui=
n
> > > their day?
> > >
> >
> > That's a good question - I don't know.
> > We can either try to see if someone shouts or add it as an opt-in featu=
re.
> > I kind of dislike the idea of adding an opt-in option for this behavior=
,
> > which is explicitly documented as undefined and could lead to several
> > other weird issues, so I hope we can get away without opt-in.
> >
> > Even if we agreed to extend the defined behavior to changes to lower
> > layers to objects which overlayfs did not yet observe, this definition =
will
> > not have included the case where the merged directory was already itera=
ted.
>
> Maybe if it's enabled by default but at least has an option to disabled i=
t?
>

Maybe.

But I think that if people are using an unofficial feature that is
explicitly documented
as unsupported, then it is in the best interest of everyone that the
maintainers will be
notified about this situation (by the shouts of breakage or better now
beforehand).

We can try to commit to not breaking real life applications...
if we knew about their existence..

> But you really know best when it comes to changes like this.
>

There is a fine balance when it comes to keeping legacy behavior vs.
making improvements.

I will need Miklos to chime in on this question.

Thanks,
Amir.
