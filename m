Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7532A38F25E
	for <linux-unionfs@vger.kernel.org>; Tue, 17 Mar 2026 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773771374; cv=pass; b=a3mVlePIcjDNLmLVd+HmrtcARrCjM/dqHbn/w7WLmVqKWQ6tRRAHzp75987OSUG7e4hlq52cnrglOPt/s8BVFKUs1Z4cVt9osDnAFjox+Pc6Uxsf51T90bpIRtSUY9Kv+Usd99oavZ70TlzXjBLpxkyVzBaHwy8tBIa+yi8gSvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773771374; c=relaxed/simple;
	bh=QUDC5jrmRrJojzfitd2CzM1OmZr1G8/BgX/pdKw+87I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yq7GKIgZgWC+Jl9/wdzANEQ9HTTo6cPH6ow7TprXs9Uq16x1kk3pfLtbMYVbTYFvKBp02sue4B34xfHltP5LqT6lBhoUZ1uaanc4LTJerffeVosOrobAZdtQ0lZ581tS4Q2hmDtF1LdgUcrbCUu6sCax3Bf3jwIhfO9K2woWciI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=RoKUMaNJ; arc=pass smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="RoKUMaNJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b06c43e6a7so2475845ad.2
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Mar 2026 11:16:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773771373; cv=none;
        d=google.com; s=arc-20240605;
        b=ImyP4aSkGshwXCX6yl30Y4SOu2KyBiGQE/gaPY6yWoZ0xpQiAptuA5fDyCLql9NHRC
         QdwR8h58bp3lwlismUpGtQcOsgYs+kNe89ziN/E4BCjj6DKUouo/L402nc9f4aOOT71L
         d4mGRBoc8DKuDR7h4lJXzkRxloUqY97+fC6bIQpDqAZPpYixo7RO6dRTwIGsPBJ+9F7x
         WKohPGmdqbxhNBQ7P5CrxlG3kurhyjTPBn8+5CU5oi8u3ZKpRer763wvJssOtXZruXnb
         WjDBcgC+Uxb/ZPSX6oz4N9LxLRJrCANgjlzCifZwXBGBiOBGZB4QPV35qHX2CdxopNbV
         IyZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WngwhPK+4r0TmrjPdHGSTFw/2nCwtZ82oV0G4lyV188=;
        fh=BTU5GyhPmF0QkgT0WrchXanwaGt+6En60hha1AeBBPU=;
        b=CvgUb18ylsIQn+MbbpNO2uD1874K/oy99mFGCR3+4Sxatdb/2APtYOKuyOX3Ete1XL
         pk9VUBtPXo4Ay/bd8einybrX8FT4mN6sb/OLe0gBXhfFg7bD6k8hAwY58hM4M2YmTQF/
         cxKAtXsu9Xtx5Jvyf65GAuwD5gReNalllZef6riRyAtDufva1gTNO41kNFoMCnfwBuxn
         zH3Goe8VyChMPz9nYE2mGvlz4WZNaQJqZRHi5OVAH2KAWkdyocfO4A5QRkVmQqeuYNhu
         x4OIFPr9hEW0OugTYbLk9trZqgREVz7aJIpUqL/kSmfGNDcEfpzKmxmQFv6pC1WhyBbM
         0sjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773771373; x=1774376173; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WngwhPK+4r0TmrjPdHGSTFw/2nCwtZ82oV0G4lyV188=;
        b=RoKUMaNJelxkySue1Uj+KohQ2KRnoVt9Y6p+Jo16nniijXKT9ujEGEvX7xe2mSXF62
         26nsMSxAbPUzYhJ+xUjvwEBI7dNOPm+cP2T3o0R6j+y2ltRPmSxYMLckKi7dqzF8TzJ0
         gwXxY5yGtPnvALaJcGDMt6IHjoERwpza4t6SWZcm6JkzC/c2ts7HVbgeXh38FyTBoGb/
         ktIQrKCPa05YyPFAzu7UVMTjrWMMGe7TvRMmzl7jLZV52bh1s2rVzzF1jfnwCslZAivi
         tsdIpI9gHJgo+aElfozr2o8AMaMXdpoIFTpdoUyScfJZCHu7sbvTpfBdioeCEh8e5CiR
         6XWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773771373; x=1774376173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WngwhPK+4r0TmrjPdHGSTFw/2nCwtZ82oV0G4lyV188=;
        b=i17HpCWUMJoWJ/jZ4PuaLeIr/zgjnntVqFLxOs/0yYJtSKiLtRnXhYRT4LALJf53Lg
         9epYCDvCJlRBhJec8ZOwNgLAnGFaN0ycT76NkpNK6iNzZwPYn3jAwj/zQ1iOF4NHdWBR
         S+CNk0wcsM27RalEWkJh4AD0lliBqC0pq92N151XoVqQnN/wAgcPcMc/W0/nrk1wtYw/
         6J24CBoCYyDEfLKUICOXD0fVtPZPfftB9vMdutwrpkpgZTLaVc7ZCt7Qa95RAVNx50IR
         fZWLk0VjpTZjSXKj7PwTir3ZQHFrY21gf0LE/9pVRxgS+6r6zaINkRP3eFbdGnYliwop
         /GBw==
X-Forwarded-Encrypted: i=1; AJvYcCXSXb9y7x71I27/LKraAZREbJy4xDvliQdNR0tYzeis78mZsMUwUaGWi65jLgtOX9Bz25Kzg4/URPPgSBlJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1tPoGI4/Tw08byeaz69DE9nX07/uIRGnQi+ou/eQRMH5jZ5b0
	mw2nrtAqWbV2IFD/xdeRtgcIpXSCxG6TkWzJOXOJ/ANVTro7xRtl2wgWmdzCf16M5ZwkahikhsP
	y70hHy3AC06HhcH+1T1gLbGySbJT3EuvShQ31Y4Fc
X-Gm-Gg: ATEYQzy9VNoS9RuZs6H12SfJ9NXA+ZSIXYgbpjYb1OfmR7F3Kp5gqjZIm8GfIfz4Srq
	CgA4CCHjSEFqIV3UMjYhVxJyFJtTucwuzRjjH19VpGpl6S7tXwfHcbKChnkB7IPhwmlwTtTlglr
	5qZsJ0fmk4P65T4RnBTdmQ56tc3vhcc5D++Uk/H0NtD/v91hLBnJ9kWr/3NvOspBE5GvwwkcynY
	/F6m43ImG5mzd91uL7IIPIuYyjzKTTX0rqrUlY5dAPs1EtgPN7hdCqRZ9ZXBz/lSGDY0xCNlmto
	gd5pg3Q=
X-Received: by 2002:a17:903:1447:b0:2ae:c5fc:b2ea with SMTP id
 d9443c01a7336-2b06e3d2eb0mr4770225ad.30.1773771372739; Tue, 17 Mar 2026
 11:16:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260316213606.374109-5-paul@paul-moore.com> <CAHC9VhTEX-sRjyVi2p9j_jFjyWbzy54b=iteiTKGq-mnBaHkrg@mail.gmail.com>
 <CAOQ4uxi7+6Qt5K9s6Fq8deN-ep2gnxqJ6-wJy9pXJzszpfn-6A@mail.gmail.com>
In-Reply-To: <CAOQ4uxi7+6Qt5K9s6Fq8deN-ep2gnxqJ6-wJy9pXJzszpfn-6A@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 17 Mar 2026 14:16:01 -0400
X-Gm-Features: AaiRm52ZqNJHAbRzZUAvcxik2J2qc91q1AUn-hHxOheIit1e-BlWZgjcVmBec3Q
Message-ID: <CAHC9VhQX4aDvrd9uX1ESGteWpLLGbXmH1+SVFfE06juAsSCkGQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix incorrect overlayfs mmap() and mprotect() LSM
 access controls
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 3:26=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
> On Mon, Mar 16, 2026 at 10:59=E2=80=AFPM Paul Moore <paul@paul-moore.com>=
 wrote:
> > On Mon, Mar 16, 2026 at 5:36=E2=80=AFPM Paul Moore <paul@paul-moore.com=
> wrote:

...

> > Due to the nature of the issue, I'm going to merge this into
> > lsm/stable-7.0 in a few moments so the changes can get some testing in
> > linux-next with the idea of sending this up to Linus' later in the
> > week.  If anyone has any concerns over this patchset, please let me
> > know as soon as possible.
>
> Since previous 4 revisions were not posted to public list,
> let me repeat my concern from v4:
>
> On Fri, Mar 6, 2026 at 5:24=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
> > On Fri, Mar 6, 2026 at 3:24=E2=80=AFAM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> ...
> > > My expectation is that the merge of this patch will be collaborated
> > > with Christian ...
> >
> > Of course, that is one reason he is on the To/CC line.  More on this
> > in my reply to your 0/4 comments.
> >
>
> I am sorry Paul. This must be a misunderstanding.
>
> My expectation for collaborating the merge of my patch with
> Christian was that an agreement would be reached regarding
> which way it would be routed to Linus.
>
> CC to Christian and sending the patch to Linus without getting any
> ACK from Christian was not the way I expected this to go.

To be honest I expected Christian to provide an ACK by now, as he
reviewed and commented on your earlier patches with the O_PATH file
approach.  He has had weeks, if not months, to comment further and/or
supply an ACK so at this point I'm proceeding ahead as I mentioned to
you (and Christian last week).  You were very anxious to bring these
patches on-list, which I did, however, now that everything is on-list
there is a responsibility to act on this quickly (this was the
motivation for discussing the solution privately at first).

Hopefully Christian will comment, and preferably ACK your patch, but
even if he does not we still need to go ahead and fix this soon in
Linus' tree.

> > > and that it will NOT be auto selected or rushed into stable.
> >
> > I haven't marked it with a 'Fixes:' tag or a stable Cc which in my
> > experience are the two quickest ways to get pulled into a stable tree.
> > I'm not sure what stable policy Al or Christian have for the VFS tree,
> > but LSM and SELinux commits are not pulled into the stable trees
> > unless explicitly marked with a stable Cc or requested by a dev after
> > the fact.
> >
> > > I don't mind if you want to route the security_mmap_backing_file() ho=
oks to
> > > stable to use it for some simpler bandaid for stable, but rushing thi=
s
> > > one to stable is not a good idea IMO.
> >
> > Once again, see my (upcoming) reply to your 0/4 comments.
>
> TBH, I don't understand the logic of placing patches in lsm/stable-7.0
> without the intent of backporting them to stable.

I'm not going to copy-n-paste my previous off-list reply, as I have a
rather strict policy about forwarding private or off-list emails to a
public list without consent.  However, the quick answer is that
inclusion in a lsm/stable-X.Y branch does not mean a patch(set) is
automatically tagged for stable, in fact you'll notice none of the
patches have a stable marking, mostly due to your previous request.
As the LSM and SELinux trees are not pulled into the stables trees
unless explicitly marked, or requested, I do not expect those patches
to be automatically backported.  I do not know the stable backport
policy for VFS patches.

> I perceive my patch as a risky patch for overlayfs and the vfs
> this is why I wanted Christian do be part of the decision if and when
> my patch is sent to Linus.

Christian has been a part of the discussion for months now, and has
already provided feedback on the VFS portions of this patchset (which
you have incorporated).  I agree, I would appreciate it if Christian
could supply his ACK, or an alternate solution, but as you strongly
encouraged us to bring this issue on-list, we now need to get a fix in
Linus' tree soon.

--=20
paul-moore.com
