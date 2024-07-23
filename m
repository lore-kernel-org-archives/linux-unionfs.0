Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D23F13D503
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jul 2024 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721770319; cv=none; b=n85zaMgrESfZpyhe5etut6xLVSe0XQ24XAzNWQny225QtiZ00fnxaXPYpQrNxz7R5EMtFNynYB1Rj8v3cd79ci9pSeT52FeEn7i8KQzbjQ85RBzIoV4qOr2dWrmu4G2XEQ7Iq03hC9r2c8PzLRy88ZLIj7s1QzTm2fFd+1frVCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721770319; c=relaxed/simple;
	bh=VQFjjfwG+uIiFKjfQBvJYaFHQSXZwBtP+cPj1I7ZUHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jbwD3YTxRNAzlzesRLSm8MoGUHCKKhkWHig/rrsnpubJ4vb0dlr6i7vukTpOWXZgah5BKC7vgMsGMAmZhW2mupn+8Q5bGsI6Va5npPub7iiw4B7TDlRgI4tp30XaIxyofpjIPgtly4QiWosj7K1iF+as//DtjjGMiodz/GLhFik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FXFXBFSR; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FXFXBFSR"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6b7af49e815so32253776d6.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jul 2024 14:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721770316; x=1722375116; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCWUgD+h9q/NbmdzCpTyV84JQOaTfDk1QRKK3Kackek=;
        b=FXFXBFSR+/5SVj02w7L1O1DIQSkQ/22sbF9dEV/SriQuGihJCNSiCVZdg9oitgK/Eh
         jqE7vaVTqE46oGASTsr6AMqMgAU2yjj3ShgshVKMu8iwJ6W35zpy6lC2WL83r8AFYAQA
         Cjg1exbVpxUwr2swBdDRULdqapNGdIg3nDjYdhi8NOY+JPzw+PfP6+Y8w/NwgE7Z2TYQ
         ar0hi3GR42Y6cP+bH9LgIr0HaRbPZOnx5+ylwJ49XDwczDW7e7FF8u3J8vnveTA1qXdj
         5PQYoQCW4+vAdvqzCgqKISEN8DZV4Sp+meLfbZsqaG/m17gHrmicy9bm3V8PkAtle6is
         uStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721770316; x=1722375116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mCWUgD+h9q/NbmdzCpTyV84JQOaTfDk1QRKK3Kackek=;
        b=p25o8lv12ee2GZxtNyPYvedd9fkdam9s7dWAlgt23ZwASJKI1tQZfPDMz+81/P4B0y
         pKEgKirzJTkX7xqKja0QF+nM1bTWNmrXU6w8k/bsHeH5dvE22RXghC5vH7cS4A6JBl/P
         FSf3Z5H0vSZQe6CYQTqhWNRATTWxnBvkDdz4F01MTB05AoLXAcSK7b/+Xp8KepDyL1da
         0FpiiOk26+ldZz9MB7pHWVSk3Z5Hl+SKN2MyfDl/BJI39+roPBBUjZzSjNeF8bpSFFap
         z0PpJHXE67FLM9+D1eGoMwuh1OsFwxk+XyB7haNVxcwq6EwqLDD00L/IzzKnfg4jDwji
         a1QQ==
X-Gm-Message-State: AOJu0Yz+JbCUPGrHj7uvKTWtTna6e69qNyD5cP9X+cqwzyKa53F4HbMV
	Dx7As1ukwacT45OeLSwF9Ka65m0SWgG2TbNbNJlRuB43F0+agVCs5rpXmki6kCQl5m1b252tiuZ
	4ggUdwgscIIudckBJ6IJyLozfSNkfnC5EWrw=
X-Google-Smtp-Source: AGHT+IGSxjvPhPRxXaCwZ8CL19TsqpWR+au9oCDp0EdoUGVtZXAwiVZq3kpLxuM55FgGWXtylGqdcWRKFypL+Cy5FYY=
X-Received: by 2002:a05:6214:f03:b0:6b0:6400:3b6f with SMTP id
 6a1803df08f44-6b94f00df9bmr212453126d6.8.1721770316158; Tue, 23 Jul 2024
 14:31:56 -0700 (PDT)
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
 <CAOQ4uxgJwoudXw9pMw9nz5d5SCuryxv-O9fpnRcPcwqg4nk1hw@mail.gmail.com> <CAPt2mGNf7q_g6FJsgA=pcx-OWS7GrWs1CEO+JaqViDYPvaW21A@mail.gmail.com>
In-Reply-To: <CAPt2mGNf7q_g6FJsgA=pcx-OWS7GrWs1CEO+JaqViDYPvaW21A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Jul 2024 00:31:44 +0300
Message-ID: <CAOQ4uxjV7VbmGHdb68-d9r5L5xP6u9f1a-2S_kbjQu42GRcrSA@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Mike Baynton <mike@mbaynton.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2024 at 6:28=E2=80=AFPM Daire Byrne <daire@dneg.com> wrote:
>
> On Fri, 19 Jul 2024 at 10:19, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > > >> Basically, I need to be able to continue serving the same files =
and
> > > > >> paths even while the copy-up metadata process for any part of th=
e tree
> > > > >> is in progress. And it sounds like your idea of considering a co=
py-up
> > > > >> of a merged dir as "complete" (and essentially opaque) would be =
the
> > > > >> way to do that without files or dirs ever moving or losing acces=
s even
> > > > >> momentarily.
> > > > >
> > > > >
> > > > > Yes, that's the idea.
> > > > >
> > > > > I'll see when I get around to that demo.
> > > >
> > > > I found some time to write the POC patch, but not enough time
> > > > to make it work :) - it is failing some fstests.
> > > >
> > > > Since I don't know when I will have time to debug the issues,
> > > > here is the WIP if you want to debug it and point out the bugs:
> > > >
> > > > https://github.com/amir73il/linux/commits/ovl-finalize-dir/
> > >
> > > This is very cool - many thanks!
> > >
> >
> > Pushed two fixes to this branch - now it passes fstest - please re-test=
.
>
> I can confirm the root dentry issue is fixed and I now see a lot less
> ENOENTs hitting the lower (NFS) directory. For my test case, we go
> from ~80,000 -> 27,000 ENOENTs, a great improvement.
>
> However I was still seeing some lookups hitting the lower layer in
> directories that had opaque=3Dz. After a bit of testing and much head
> scratching, it seems like you need to do something like "ls
> /olv/blah/thing/version/lib" to force a readdir of the lower NFS
> filesystem (after remount) to reliably stop the lookups hitting the
> lower filesystem.
>
> For example, after doing the steps to copy up metadata and set
> opaque=3Dz, we then remount and test the effect:
>
> chown -R -h bob /olv/blah/thing/version/lib
> ls -lR  /ovl/blah/thing/version/lib
> umount /ovl
> mount /ovl
> for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM};done
>
> This will always send the lookup to the lower level. But if we do:
>
> ls -l /olv/blah/thing/version/lib
> for x in {1..10}; do stat /olv/blah/thing/version/lib/${RANDOM}.so;done
>
> this triggers a readdir of the lower NFS dir and then the random file
> lookups only hit the upper layer as expected.
>
> So then I'm not entirely clear why in my real world test *most* of the
> negative lookups are served by the upper level but some are not. I can
> only think that loading software *mostly* triggers READDIRs on things
> like lib dirs, but not always?
>
> It may also be complicated by the fact that we often have symlinks at
> various points in the path too (both dir & file).
>

No again, it's just a bug.
My fix to initialize __lastmerged for root dentry broke initialization
of __lastmerged
for lookup of non-root dentry and readdir would fixup  __lastmerged later.

Pushed a fix. Again, only sanity tested, so the finalize feature may
still have bugs.

> > ovl will lookup the lower data of a metacopy file at lookup time.
> > Perhaps we could do lazy lookup of data files, like we do with
> > data-only layers, but this would be more complicated and in any
> > case, stat(2) needs the lower data file to present the correct
> > value of st_blocks.
>
> Right... for some reason I thought it only needed st_size which it
> could get from the sparse file.
>
> > IOW, this patch mainly helps to prevent *negative* lookups
> > in the lower layers.
> >
> > > expect no lookups to the lower for negative lookups? Unless we can't
> > > serve negative lookups from the readdir of the upper dir?
> >
> > Correct expectation.
> > The bug was fixed. It should hopefully work now,
> > although I did not test.
> >
> > >
> > > I have probably misunderstood that the "finalized" directories will
> > > only serve the contents of the readdir result and not send metadata
> > > lookups to the lower level (ala dir=3Dopaque). Or my v6.9.3 kernel ha=
s
> > > some other issue unrelated to this patch....
> >
> > You understood almost correctly, but you need to understand that
> > the finalized directory is not completely opaque, it is partly opaque.
> > You can visualize this as painting the space "between entries" opaque,
> > so that negative lookup results will stop as well as readdir, but ovl
> > will still look *underneath* entries.
> >
> > BTW, ovl will also lookup in lower dirs if entries inside an upper
> > opaque dir have an absolute path redirect xattr.
> > This type of upper opaque dir is also called "impure" and has an
> > "impure" xattr.
> >
> > So you may say that the difference between an opaque=3Dy
> > dir and opaque=3Dz dir is that in the latter, all entries are treated
> > as if they have an absolute path redirect (to their own path),
> > but that is a very hand wavy way of putting it.
>
> Yea, that makes sense to me.
>
> > Anyway, if you are happy with the patch and want to see it upstreamed,
> > I have few requests:
> >
> > 1. Please provide your Tested-by.
> > 2. Please provide a detailed cover letter that explains the problem (*)
> >     and how the patch fixes it, which includes performance gain numbers=
.
> >     You may post the cover letter with my patch or ask me to do it
>
> I'll draft up something for review and I'll try to keep it concise.
>
> > 3. Please write an fstest to test the finalized dir feature (**)
> >     You may want to look at test overlay/031 for inspiration
> >     if also makes changes to layers offline and examines the outcome
>
> Bear with me... I'll have a look and see if I can figure it out.
>

I am not in a hurry. quite the contrary.
I have just a bit of time to help :)

> > (*) Please do NOT include the story of changing lower entries
> >     under a mounted overlayfs - they are not relevant to this patch
> >     and they are very controversial.
>
> Understood. However, I do suspect that some are using this "undefined
> behaviour" because it worked for their use case. This patch might ruin
> their day?
>

That's a good question - I don't know.
We can either try to see if someone shouts or add it as an opt-in feature.
I kind of dislike the idea of adding an opt-in option for this behavior,
which is explicitly documented as undefined and could lead to several
other weird issues, so I hope we can get away without opt-in.

Even if we agreed to extend the defined behavior to changes to lower
layers to objects which overlayfs did not yet observe, this definition will
not have included the case where the merged directory was already iterated.

Thanks,
Amir.

> > (**) Basically do chown -R and ls, unmount overlay, add lower entry
> >     re-mount overlay and verify that it is not observed.
> >     Can also sanity check that opaque=3Dz was set.
> >     Note that adding lower entries offline is a behavior that was once =
allowed
> >     and some users actually expect it to work, so I made the feature
> >     depend on !ovl_allow_offline_changes(ofs).
> >     Therefore, the test should explicitly require and enable metacopy f=
or
> >     overlayfs mount to enable the finalized dir feature.
>
> Many thanks,
>
> Daire
