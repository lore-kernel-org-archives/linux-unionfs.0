Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFAA366801
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Feb 2026 13:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770383555; cv=pass; b=ct+IN7cpxfPfXit/IaXFYgBgDnzNs+mWfQUOqd8UTrZtb/vlFwTyPAXtxZFYCuMIA/6FRAz6UXgXh03ke0ua/js7bwi+miR1nKa4SDBOslm0mNDsVso14rXWGKgKkhDu654Vx6pXv6jyDwvQgEKvlC8PRsEWKhQEsrWyloiU5SQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770383555; c=relaxed/simple;
	bh=CrEE7/bOrfWGlAsAei56Ak0WdJbpvJHOmaGDNmweqM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pZVNcVUjGRD5vxbN25RqgPtT/34O/waXnxLr4db7uzY3PVWLWfUlpkSgon1Q8G6v0dl0+dHE002i3QHruOODfwmXpz1aLPWa8SbqVrW2wn8GbhjNf8LRx3ShVuLJHxLlF6I/9CpfLz/87j7LdcGtq2O2Yh+00YGGCL721C7SBIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7Qw7UqY; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7Qw7UqY"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso3033669a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Feb 2026 05:12:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770383553; cv=none;
        d=google.com; s=arc-20240605;
        b=EwpFoaviNS/LRDjuCmkc9chibU0nn4/fsXmEGE0OzIDNUqKd4W41409mE+er9A9WZi
         vKfzNRLjQxCydBBBZIP28Dz0v6usZrRW1PkMDlVTpPLrrEIWKLo3YfA1Md94JInlLvdz
         fIE98snS08O0lpIu8SaBO8nH+xMQynId/Lbh/itGbpdiRMbrFQY9MYjcMfTPjRXbTtpD
         QxXJpwG4pMsq4o8099u5G9xNBhB/EnenQBs8890qQMmPuJwsNxCK3Zf9FxouCINWWnV4
         55LD4h/XCG23U2zd0C3dMMji26uKvXYJZjJ2WHE1MCAQOJVRhUEsvPdR2JBbBD1i+cyM
         NynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o0D7XNcksMFotrGauTILfOksOfq1AbJOoC2AY5poRMw=;
        fh=yw7uGR1Y/qoEhOlPm2IcJtRplIOQjPIT9BXNj9I3jWM=;
        b=XTVzCtTyphC/U7bRNna+YCkysMOiLthv5TEacdSBh9yVXkeFcO5USs6Am981BPdbiP
         sblQ51y6lkZywIq2cZAVz2hISw32PbAhZPLpo9cMl9A03MyPl0Pr3j9pLWwkUxMuJ93h
         tns3Ij67T7ZsK4jlEFeVrvWV8vhSGeTkI+kUHHIsTUTKixupOzKd+ROmnCr+u9vdDqlW
         nNPQwka1XGIFT76FhxDlj47f0on3iRUDEfD8l+PGOh7qI4krV7qR3QlcjBiHtouy4YXT
         0tW88sBEhtsEpyqOQRRyA8tcSu8DiydWoDQZU6p+GQeNjn85pYSg9EBVtjNBHm1xkzIZ
         tz9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770383553; x=1770988353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0D7XNcksMFotrGauTILfOksOfq1AbJOoC2AY5poRMw=;
        b=U7Qw7UqYhtdUmayZ9ck6hsSNV7MLkZG+gYjmUsXNe4FQnGAxxxahSOhHxHyLd4BpZZ
         U5aQ83498vNW2zOyEDezmjZbP1tr3nPULKC2dsYXWNtJsIuxVb4KoFkgTHDsBpF30hzE
         X+HXU0vOXkV6yWLbpKB0ZMKsl/78g7iV4hzkUFJ3ClrhFYRSqfEWn28Nnyhm3P6ZSDwP
         J11J6TZ1UeX7WyyTJKXqfk+n4lZ/QHKeKnINUEL6XnOUFiy0WYkboz0TXlgC+K2Bb08/
         rkXDUu1sDK3aEvV1K1XMdVv7ShWvKUzl1Q5v8ZW4eGd96J6CX15v11GfuAG+8ZrJG9PF
         922g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770383553; x=1770988353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o0D7XNcksMFotrGauTILfOksOfq1AbJOoC2AY5poRMw=;
        b=WujNo7o8Cm3ETR9yt2TCJeQ6Gl7bLqON21IKW5MrPmhv2EcE8//JprhH3y0SXWyjNG
         pHQYLqmcvFqIS2D29VniczH9MoqHEWcHbSnwDPWyVb0IWprcHk+obD8ZVe0M4BXVuRKl
         nW03DrZ1QGS7LMCYaTlcl9Joi3S3PZKI+XDgC29uv+O78Nphi71jF1pGx7hgO0A9a/T5
         4AnlgDghSY2vGYCPEvXgJn761hH9/8nrqn0JeBXB9qdiBGiuzLAn6+ghou8ylLva1oTN
         KnCcgwyysqb56GTG4aFEm2Un8jdPeQROV0ylejL9yWyw+e+zO1wje7fvzhrMgAZGfcFU
         5fBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdSQl1Fly5/+OSjaKZijep1+rcQQ1kNbB9RN9Eu6zzyTPEBny5Zfd4OvpARgvjU0vY+50PhLC3MBtCFROm@vger.kernel.org
X-Gm-Message-State: AOJu0Yygew5qwht0cGmC1lpZ/p94ofv3w4pRk0Astlw1TRv+E0zDcj8g
	Lah/qjSJLv4cbvVor/hAmeUdPm9i/tAYD50QVwxP/KmApsb0GFelTFgcEQKHxfsNIExmi6R4Vtk
	jsjRNJkRGQsBKGtcOvxSZptommjxDpTs=
X-Gm-Gg: AZuq6aL7ep+qseCcIJ3mkSLxByXg75AuW7JpXUph/w4F4KAOeUnE0H2U8K/EPIpq7cc
	OWFMQWgSSsMsqS29nrjh3rO7wlxHeArbcL5jKRt3eLFJQVywdmlBP5bRjtiEfr44fPf4O00vb9L
	INw1CLDVg8i/f5NxX0DUJXg2oXVBdoqx9bYYVg0xNrAOeGc1999XodKevD1ZQC4zeejPUlh0U9J
	DN1OKjdwQx9tq/dKK8rB+TsY+MWLhHIX6SmlByP7hSGJ6MPtaMG69+bSD2+BppuwrEFH0mbeT4a
	8O+tEfMg+TANvYiH/i8O2KaJcSP/onxXrFW0Gpcx
X-Received: by 2002:a05:6402:3512:b0:659:4853:5398 with SMTP id
 4fb4d7f45d1cf-65984139061mr1247097a12.14.1770383552988; Fri, 06 Feb 2026
 05:12:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114-tonyk-get_disk_uuid-v1-0-e6a319e25d57@igalia.com>
 <20260115062944.GA9590@lst.de> <633bb5f3-4582-416c-b8b9-fd1f3b3452ab@suse.com>
 <20260115072311.GA10352@lst.de> <22b16e24-d10e-43f6-bc2b-eeaa94310e3a@igalia.com>
 <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com>
 <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com> <CAOQ4uxi988PutUi=Owm5zf6NaCm90PUCJLu7dw8firH8305w-A@mail.gmail.com>
 <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com> <CAOQ4uxgCM=q29Vs+35y-2K9k7GP2A2NfPkuqCrUiMUHW+KhbWw@mail.gmail.com>
 <75a9247a-12f4-4066-9712-c70ab41c274f@igalia.com> <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
 <CAOQ4uxg6dKr4XB3yAkfGd_ehZkBMcoNHiF5CeB9=3aca44yHRg@mail.gmail.com>
 <ee38734b-c4c3-4b96-8ff2-b4ce5730b57c@igalia.com> <8ab387b1-c4aa-40a5-946f-f4510d8afd02@igalia.com>
 <CAOQ4uxiRpwuyfj_Wy3Zj+HAi+jgQOq8nPQK8wmn6Hgsz-9i1fw@mail.gmail.com>
 <CAOQ4uxhHFvYNAgES9wpM_C-7GvfwXC2xet1ensfeQOyPJRAuNQ@mail.gmail.com> <05c37282-715e-4334-82e6-aea3241f15eb@igalia.com>
In-Reply-To: <05c37282-715e-4334-82e6-aea3241f15eb@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Feb 2026 14:12:21 +0100
X-Gm-Features: AZwV_QhqFlrzBxPxOmk9tvy31EKQfxouilAipC7udcRwop8DYl9mi6Fi_3EXec0
Message-ID: <CAOQ4uxgzK7qYDFWYT62jH_zq8JkLGussD5ro4cKDqSNQqBiVUA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use real disk UUID for origin file handles
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Carlos Maiolino <cem@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kernel-dev@igalia.com, vivek@collabora.com, 
	Ludovico de Nittis <ludovico.denittis@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 9:34=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@igal=
ia.com> wrote:
>
> Em 28/01/2026 08:49, Amir Goldstein escreveu:
> > On Sat, Jan 24, 2026 at 11:45=E2=80=AFAM Amir Goldstein <amir73il@gmail=
.com> wrote:
> >>
> >> On Fri, Jan 23, 2026 at 9:08=E2=80=AFPM Andr=C3=A9 Almeida <andrealmei=
d@igalia.com> wrote:
> >>>
> >>> Em 23/01/2026 10:24, Andr=C3=A9 Almeida escreveu:
> >>>>
> >>>> Em 22/01/2026 17:07, Amir Goldstein escreveu:
> >>>>> On Tue, Jan 20, 2026 at 4:12=E2=80=AFPM Amir Goldstein <amir73il@gm=
ail.com>
> >>>>> wrote:
> >>>>>>
> >>>>>> On Mon, Jan 19, 2026 at 5:56=E2=80=AFPM Andr=C3=A9 Almeida
> >>>>>> <andrealmeid@igalia.com> wrote:
> >>>>>>>
> >>>>> ...
> >>>>>>> Actually they are not in the same fs, upper and lower are coming =
from
> >>>>>>> different fs', so when trying to mount I get the fallback to
> >>>>>>> `uuid=3Dnull`. A quick hack circumventing this check makes the mo=
unt
> >>>>>>> work.
> >>>>>>>
> >>>>>>> If you think this is the best way to solve this issue (rather tha=
n
> >>>>>>> following the VFS helper path for instance),
> >>>>>>
> >>>>>> That's up to you if you want to solve the "all lower layers on sam=
e fs"
> >>>>>> or want to also allow lower layers on different fs.
> >>>>>> The former could be solved by relaxing the ovl rules.
> >>>>>>
> >>>>>>> please let me know how can
> >>>>>>> I safely lift this restriction, like maybe adding a new flag for =
this?
> >>>>>>
> >>>>>> I think the attached patch should work for you and should not
> >>>>>> break anything.
> >>>>>>
> >>>>>> It's only sanity tested and will need to write tests to verify it.
> >>>>>>
> >>>>>
> >>>>> Andre,
> >>>>>
> >>>>> I tested the patch and it looks good on my side.
> >>>>> If you want me to queue this patch for 7.0,
> >>>>> please let me know if it addresses your use case.
> >>>>>
> >>>>
> >>>> Hi Amir,
> >>>>
> >>>> I'm still testing it to make sure it works my case, I will return to=
 you
> >>>> ASAP. Thanks for the help!
> >>>>
> >>>
> >>> So, your patch wasn't initially working in my setup here, and after s=
ome
> >>> debugging it turns out that on ovl_verify_fh() *fh would have a NULL
> >>> UUID, but *ofh would have a valid UUID, so the compare would then fai=
l.
> >>>
> >>> Adding this line at ovl_get_fh() fixed the issue for me and made the
> >>> patch work as I was expecting:
> >>>
> >>> +       if (!ovl_origin_uuid(ofs))
> >>> +               fh->fb.uuid =3D uuid_null;
> >>> +
> >>>           return fh;
> >>>
> >>> Please let me know if that makes sense to you.
> >>
> >> It does not make sense to me.
> >> I think you may be using the uuid=3Doff feature in the wrong way.
> >> What you did was to change the stored UUID, but this NOT the
> >> purpose of uuid=3Doff.
> >>
> >> The purpose of uuid=3Doff is NOT to allow mounting an overlayfs
> >> that was previously using a different lower UUID.
> >> The purpose is to mount overlayfs the from the FIRST time with
> >> uuid=3Doff so that ovl_verify_origin_fh() gets null uuid from the
> >> first call that sets the ORIGIN xattr.
> >>
> >> IOW, if user want to be able to change underlying later UUID
> >> user needs to declare from the first overlayfs mount that this
> >> is expected to happen, otherwise, overlayfs will assume that
> >> an unintentional wrong configuration was used.
> >>
> >> I updated the documentation to try to explain this better:
> >>
> >> Is my understanding of the problems you had correct?
> >> Is my solution understood and applicable to your use case?
> >>
> >
> > Hi Andre,
> >
> > Sorry to nag you, but if you'd like me to queue the suggested change to=
 7.0,
> > I would need your feedback soon.
> >
>
> Hey Amir, sorry for my delay. I just had a week out of the office and
> just got back to this.
>
> Our initial test case worked great! We managed to mount both images and
> use overlayfs without a problem after your clarification of where to use
> uuid=3Doff, which should be on the first mount.

Not only on the *first* mount - on *all* the mounts.
Unless you use "uuid=3Doff" consistently, overlayfs will deny the mount.

>
> However, when rebooting to the other partition, the mount failed with
> "failed to verify upper root origin" again, but I believe that I forgot
> to add `uuid=3Doff` somewhere in the mount scripts. I'm still debugging t=
his.

Not sure what you mean by "other partition"
Overlayfs verifies the origin by file handle + UUID.
We allow relaxing UUID check with uuid=3Doff
but isn't it the case for btrfs that the same file in different
clones will have a different file handle, because of different
root_objectid?

        fid->objectid =3D btrfs_ino(BTRFS_I(inode));
        fid->root_objectid =3D btrfs_root_id(BTRFS_I(inode)->root);
        fid->gen =3D inode->i_generation;

That means that you can use "uuid=3Doff" to overcome the
ephemeral nature of the btrfs clone UUID, but you cannot
use it to mount an overlayfs that was created in one btrfs
clone from another clone.

Sorry, no "fileid=3Doff" option, this is out of the question.

You are free to use "index=3Doff" to avoid those requirements,
but the essence of "index=3Don" is that the lower file can be uniquely
identified and therefore, changing the lower file's unique id is game over.

>
> Anyhow, I see that we are now too close to the merge window, and from my
> side we can delay this for 7.1 and merge it when it gets 100% clear that
> this is the solution that we are looking for.
>

I pushed this patch to overlayfs-next branch.
It is an internal logic change in overlayfs that does not conflict with
other code, so there should not be a problem to send a PR on the
second half of the 7.0 merge window if this is useful.

I think that the change itself makes sense because there was never
a justification for the strict rule of both upper/lower on the same fs
for uuid=3Doff, but I am still not going to send it without knowing that
someone finds this useful for their workload.

Thanks,
Amir.
