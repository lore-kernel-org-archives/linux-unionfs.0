Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B87818E1E
	for <linux-unionfs@vger.kernel.org>; Fri, 26 Jul 2024 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722007349; cv=none; b=sPpX4iasFKV0qaSEm5w66Ss/n5P+Y/Hswy8EKm3LnWBw5ak9bU4/KZuftfKjT+QhJPs6k2iklqzHeA3HuD43hM1Kc30aQuCRzdrpeW0FP8JrJNU7oCfsppL9CfdYfri7NFR9mDfpMbpARrLcZ+vhkfcK4oSJHU+XVJnSLSEucCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722007349; c=relaxed/simple;
	bh=wN99+WSZbCcfAcVVziI0umguVpVLxj92W0cuiM/ilX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kKnjqE9r4muo6/PbsbQ9opYRrccDD9fexBU1vgqbYAphsSDwaLBmej4HegAAPAkj3ideED1yE0mUw/Jl3zM9cdYrFbLZPIsgMDwLjEJaXTkJSm8+YkGo3YZtG3oIT6UT+6/byXDBikPQQIMpWH7+VspgqrV5+mlVbSmU9XJ/h88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=uX3rNJrr; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="uX3rNJrr"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4f527c0c959so306718e0c.1
        for <linux-unionfs@vger.kernel.org>; Fri, 26 Jul 2024 08:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1722007346; x=1722612146; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/FnGpi1d3DL28NsYdxECh6f7abmbChjazrK+pnAurjg=;
        b=uX3rNJrrJ0m5e2uHkGSj4LkNge1cKEIJNkaqZLyT9VuyKZ6G3pMKYlgPexpos5yNqB
         +fbqEXbOJ0MuAy74GDir2g6ojReBiCy6oPC0VqIzbiPHHm9dzTAXWREqOjQBvWVMHLzB
         89LlL268iB4Y0y2wZUFI9V+RYtdxDVU4Bm5lHc4GfYSHhCkvaSAyBJAhqg0JzRL5HsA3
         NieVC1JUQb+/xbI8eN/UZfTRECeM1EUTsgOz0kzr6dYOHwtwbKMygL189w7Vo8qFtnwA
         y33Y4ndn9HwC23+qSn4lzTEWEkcH7VG/t4uwGnjMIyIQ+h3YYo9npyMFVugevAHCqs7i
         Ir2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722007346; x=1722612146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FnGpi1d3DL28NsYdxECh6f7abmbChjazrK+pnAurjg=;
        b=WbnGExeJJcXOv7wlNLB1CdWwVaKgbRqoiWUA2zrJ+ikH/KAVJjGSmnKGKDNcWKj/3T
         oKuK0DV5jZ4JpTXt29N7GLpBh0tLJMXIZ8LmHiw3Uo4uTPjl9lmgIqLvjoI66MVMzENl
         S9ODyAgEXCS+wM7BNv2+gk9k3yJeBaBz0moK+quyenksBBwgSIo2B4kwkwecrp7TLMa5
         JpafKEMeWHEXFFapmPVLxG6+l7OTuEwa444XAqitgC3GK07aV9a0xMiT3cp/tEgCbVTD
         FjuECDRsVDCBS9ffFzX6gDHUYoaU1Im414SJVALKqCrpDwsN/okHR8K90knqrPvyGqBp
         VqCw==
X-Gm-Message-State: AOJu0YyiifcbVb8r0hkMcEIMpVMRiFqjfP3PcUIbeIJ2pExs5g87TOYi
	boTRee617dtVPy04ycllspv27ZsXaVO2AmGAtE1lMEKgBiwnCcyLkpt3YWO4/csZNVSKTV84FFc
	hIuRenGqTBdWugkdxnoxavnhsv7haJEeoKyc7KQ==
X-Google-Smtp-Source: AGHT+IFj4+duZRP/nt0mjSwCRx9Ui7YjSIrcIPIsuAlbwImyMoQfysAr19kpmxzrtiwkqYbxy2kzWRofQZEvbcOS0Nk=
X-Received: by 2002:a05:6122:310a:b0:4d3:3846:73bb with SMTP id
 71dfb90a1353d-4f6c5b8d5c4mr8550566e0c.7.1722007345877; Fri, 26 Jul 2024
 08:22:25 -0700 (PDT)
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
 <CAPt2mGNf7q_g6FJsgA=pcx-OWS7GrWs1CEO+JaqViDYPvaW21A@mail.gmail.com> <CAOQ4uxjV7VbmGHdb68-d9r5L5xP6u9f1a-2S_kbjQu42GRcrSA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjV7VbmGHdb68-d9r5L5xP6u9f1a-2S_kbjQu42GRcrSA@mail.gmail.com>
From: Daire Byrne <daire@dneg.com>
Date: Fri, 26 Jul 2024 16:21:48 +0100
Message-ID: <CAPt2mGMq+Z0nixWhE67is2UUw5v_Z7ZRaQrChOCMNCAT30ZDpQ@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Mike Baynton <mike@mbaynton.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jul 2024 at 22:31, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jul 22, 2024 at 6:28=E2=80=AFPM Daire Byrne <daire@dneg.com> wrot=
e:
> >
> > On Fri, 19 Jul 2024 at 10:19, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > > > >> Basically, I need to be able to continue serving the same file=
s and
> > > > > >> paths even while the copy-up metadata process for any part of =
the tree
> > > > > >> is in progress. And it sounds like your idea of considering a =
copy-up
> > > > > >> of a merged dir as "complete" (and essentially opaque) would b=
e the
> > > > > >> way to do that without files or dirs ever moving or losing acc=
ess even
> > > > > >> momentarily.
> > > > > >
> > > > > >
> > > > > > Yes, that's the idea.
> > > > > >
> > > > > > I'll see when I get around to that demo.
> > > > >
> > > > > I found some time to write the POC patch, but not enough time
> > > > > to make it work :) - it is failing some fstests.
> > > > >
> > > > > Since I don't know when I will have time to debug the issues,
> > > > > here is the WIP if you want to debug it and point out the bugs:
> > > > >
> > > > > https://github.com/amir73il/linux/commits/ovl-finalize-dir/
> > > >
> > > > This is very cool - many thanks!
> > > >
> > >
> > > Pushed two fixes to this branch - now it passes fstest - please re-te=
st.
> >
> > I can confirm the root dentry issue is fixed and I now see a lot less
> > ENOENTs hitting the lower (NFS) directory. For my test case, we go
> > from ~80,000 -> 27,000 ENOENTs, a great improvement.
> >
> > However I was still seeing some lookups hitting the lower layer in
> > directories that had opaque=3Dz. After a bit of testing and much head
> > scratching, it seems like you need to do something like "ls
> > /olv/blah/thing/version/lib" to force a readdir of the lower NFS
> > filesystem (after remount) to reliably stop the lookups hitting the
> > lower filesystem.
> >
> > For example, after doing the steps to copy up metadata and set
> > opaque=3Dz, we then remount and test the effect:
> >
> > chown -R -h bob /olv/blah/thing/version/lib
> > ls -lR  /ovl/blah/thing/version/lib
> > umount /ovl
> > mount /ovl
> > for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM};done
> >
> > This will always send the lookup to the lower level. But if we do:
> >
> > ls -l /olv/blah/thing/version/lib
> > for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM}.so;done
> >
> > this triggers a readdir of the lower NFS dir and then the random file
> > lookups only hit the upper layer as expected.
> >
> > So then I'm not entirely clear why in my real world test *most* of the
> > negative lookups are served by the upper level but some are not. I can
> > only think that loading software *mostly* triggers READDIRs on things
> > like lib dirs, but not always?
> >
> > It may also be complicated by the fact that we often have symlinks at
> > various points in the path too (both dir & file).
> >
>
> No again, it's just a bug.
> My fix to initialize __lastmerged for root dentry broke initialization
> of __lastmerged
> for lookup of non-root dentry and readdir would fixup  __lastmerged later=
.
>
> Pushed a fix. Again, only sanity tested, so the finalize feature may
> still have bugs.

Yep, that totally fixed the issue - after a remount, the directories
are still "finalized" and negative lookups are not hitting the lower
NFS filesystem.

So I have been doing some basic benchmarks to figure out how best to
make the case for this patch being included upstream. I have also been
looking at fscache too as it's a good companion to the idea of
"caching" or "localising" both metadata and data for a remote NFS
filesystem full of software releases.

I took one of our more complicated applications with ~200 various
paths (LD_LIBRARY, PYTHONPATH, PLUGINS, etc) and recorded the
(tcpdump) packet capture and launch times:

vanilla NFS - total packets=3D475531, NOENTs=3D69456, OPENs=3D61146
fscache NFS - total packets=3D200120, NOENTs=3D69460, OPENs=3D61045
fscache+overlay - total packets=3D67157, NOENTs=3D45, OPENs=3D6412

The time to start the software went from 58s (vanilla NFS) to 32s
(fscache+overlay). In both the fscache and overlay case, this
measurement was taken after a remount where the fscache reads had been
populated (so 0 READ calls over the network) and the lib directories
had been copied up and finalised.

I have also had pretty good success using a systemtap script to
monitor for the NOENT lookups to lib dirs and pass those to a
userspace daemon which then initiates the "chown -R -h bob
/ovl/blah/thing/lib/" commands. I might try with bpftrace too to
contrast and compare.

I was a little surprised to see that the copy-up was also helping with
reducing OPEN and LOOKUP calls hitting the remote filesystem, but I'll
take that bonus improvement too. If we just take the fscache ->
fscache+overlay case, there is an almost 4x reduction in packet counts
(roundtrips) with the metacopy overlay. If we look at the improvement
from the vanilla NFS mount we currently use, it's a 7x reduction in
packets between client and NFS server.

> > > ovl will lookup the lower data of a metacopy file at lookup time.
> > > Perhaps we could do lazy lookup of data files, like we do with
> > > data-only layers, but this would be more complicated and in any
> > > case, stat(2) needs the lower data file to present the correct
> > > value of st_blocks.
> >
> > Right... for some reason I thought it only needed st_size which it
> > could get from the sparse file.
> >
> > > IOW, this patch mainly helps to prevent *negative* lookups
> > > in the lower layers.
> > >
> > > > expect no lookups to the lower for negative lookups? Unless we can'=
t
> > > > serve negative lookups from the readdir of the upper dir?
> > >
> > > Correct expectation.
> > > The bug was fixed. It should hopefully work now,
> > > although I did not test.
> > >
> > > >
> > > > I have probably misunderstood that the "finalized" directories will
> > > > only serve the contents of the readdir result and not send metadata
> > > > lookups to the lower level (ala dir=3Dopaque). Or my v6.9.3 kernel =
has
> > > > some other issue unrelated to this patch....
> > >
> > > You understood almost correctly, but you need to understand that
> > > the finalized directory is not completely opaque, it is partly opaque=
.
> > > You can visualize this as painting the space "between entries" opaque=
,
> > > so that negative lookup results will stop as well as readdir, but ovl
> > > will still look *underneath* entries.
> > >
> > > BTW, ovl will also lookup in lower dirs if entries inside an upper
> > > opaque dir have an absolute path redirect xattr.
> > > This type of upper opaque dir is also called "impure" and has an
> > > "impure" xattr.
> > >
> > > So you may say that the difference between an opaque=3Dy
> > > dir and opaque=3Dz dir is that in the latter, all entries are treated
> > > as if they have an absolute path redirect (to their own path),
> > > but that is a very hand wavy way of putting it.
> >
> > Yea, that makes sense to me.
> >
> > > Anyway, if you are happy with the patch and want to see it upstreamed=
,
> > > I have few requests:
> > >
> > > 1. Please provide your Tested-by.
> > > 2. Please provide a detailed cover letter that explains the problem (=
*)
> > >     and how the patch fixes it, which includes performance gain numbe=
rs.
> > >     You may post the cover letter with my patch or ask me to do it
> >
> > I'll draft up something for review and I'll try to keep it concise.

I'll try to get to this next week.

> >
> > > 3. Please write an fstest to test the finalized dir feature (**)
> > >     You may want to look at test overlay/031 for inspiration
> > >     if also makes changes to layers offline and examines the outcome
> >
> > Bear with me... I'll have a look and see if I can figure it out.
> >
>
> I am not in a hurry. quite the contrary.
> I have just a bit of time to help :)
>
> > > (*) Please do NOT include the story of changing lower entries
> > >     under a mounted overlayfs - they are not relevant to this patch
> > >     and they are very controversial.
> >
> > Understood. However, I do suspect that some are using this "undefined
> > behaviour" because it worked for their use case. This patch might ruin
> > their day?
> >
>
> That's a good question - I don't know.
> We can either try to see if someone shouts or add it as an opt-in feature=
.
> I kind of dislike the idea of adding an opt-in option for this behavior,
> which is explicitly documented as undefined and could lead to several
> other weird issues, so I hope we can get away without opt-in.
>
> Even if we agreed to extend the defined behavior to changes to lower
> layers to objects which overlayfs did not yet observe, this definition wi=
ll
> not have included the case where the merged directory was already iterate=
d.

Maybe if it's enabled by default but at least has an option to disabled it?

But you really know best when it comes to changes like this.

Many thanks for your help and support with this. I'm truly grateful!

Now I need to finesse my userspace daemon for doing the copy-up and
try this out with production workloads (we have 5000+ batch hosts
running up to 6 applications at the same time).

Daire
