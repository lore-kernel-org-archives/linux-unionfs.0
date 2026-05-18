Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B149381AEB
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779129587; cv=pass; b=WTxPxgPL6+Hqli8aathc0Omx97h54rvhox2WPPVpUs/L2jqHzYmwndbzabIOO0oMRXrybJtzptewQMnybYc+h5tubXr1lDB7TzC+v0yVWUNc9onZ3RzhnnQXhGFrbgjYpSvPI9g8r5RJIYkdW8Hw+azfqyN0tvzQRK2Agxt6Skg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779129587; c=relaxed/simple;
	bh=xCC7AHTEi3ftlT5SE/Ec0E0hK+N0nXWX1qAzoLVrJWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+bgxT1Gv5ozag3yv3IBOj+WZ9b5vbuqS6uG06AVlo0ECCjwGzOauOwfvKMYhgn6iJIdhDpw1eX2T6fk1BPl1X/B2ENDqYOAaMPi0Wml3TF/mS7qfdtQQRfagMTBIaG/ggAQbzd4XNPEVrar6uOjqxOGW+uVhT3n4yGGda2/Og8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAR4ipk0; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAR4ipk0"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9d9971d059so376999766b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 11:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779129584; cv=none;
        d=google.com; s=arc-20240605;
        b=Fn9Bpc0b7gzSh5bsGPD3aRJL/QNtKghclfQzRSX9Z4P6ZExJ2lKihp1hnAWnDEOw+K
         5jRLda4nZAW741w6tXZIcNqk6EkjPHBsm1wzQFeLKC6505EOpSNF4uyRPGOyFzzO8qTY
         jA7iNZWOPwOBPNAzo94kibVLR0wswBs7iRFDFnu6tnO1s7uwZFPyKqngbX5b96+fiZgJ
         44UA7RVl2jk9nqna/NddLOYbo+hU2NZoWasVgnkrAp9CQRpjZGEPyiQC087ylHms4D6s
         E/Gjyk11zhHBF70sK3vkXBAbEdR3lnrFL+1B7wSooMczl3CwYuxArvs2PAhr9zEcyBxf
         68Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j9+DsIOO/UhcsX5Jdn5KmB3aHxjo7tVc/mcyYuxt+ds=;
        fh=d3ZU5kdxOSvPGXeldPQbOrO1hUwdGPvEWueNbfxlh7s=;
        b=C2mbJw4RkVcvweXt0eiE6nzPDrQNZRSledzPH7Rm5umrZ8yu5yHPaiajnVQOk0XOLP
         TMo9snmelGCROfwlkM/cHqnopRqUUS5NR8Z413WUqswIcOt8a/BgbBMXQ8pHRIVwdt5F
         QFH0upiyXb7BRAl8+r26qvDWh0cLfqCws0l353VhUaVH5f6UZwOY0leSSiRQhxIWzMvh
         J/HOHw18wuNv8roiM+IdtRJ3dZaTAbJ+2d4Vf0KM31TZ/mUPvXVJjD7DvsGRiixz4ELJ
         svyrooa5rti8GSod09Lakz81bdm0zFYukWtHEA4YDJVIfFuB6GaTu/Qh3DQtTMsCZWN2
         XBAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779129584; x=1779734384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9+DsIOO/UhcsX5Jdn5KmB3aHxjo7tVc/mcyYuxt+ds=;
        b=UAR4ipk0ocMoD746qr7vsY0KZWM2FrxvI0HXyiCJSE09OyE2CQh+y1+ogr/1ZlTNnq
         zPH4SCG/xBS4PxxWfGDmNEFPRWJCiCuyA0m+9m2dcnKSG29KUjR14hc3dmydkrnb5fOC
         kiw3OdX/2ALsj8nHiKWPhas693v9KU+8KaCbHwaKMNvdT1n2NFa8HolFS3WTtCHKE5jv
         M44tQRcQWLqAio2m6vqnOx1xxiNfdv/fVt2gaaqxALrxrfhtFxcDlQBE9X90YhIV3utd
         TKGo/pCj3+nIUv0UubDbbRVWTkKra/fs89bc6SGtc4vYHT5oeYxgnOhwWqcMe7Qsr3bW
         Lr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779129584; x=1779734384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j9+DsIOO/UhcsX5Jdn5KmB3aHxjo7tVc/mcyYuxt+ds=;
        b=eQIvoAueUJlzLp4zUHPEsiruFY9x5xDGg3L5lce5uSSzY/alPeFV7CxN2cK+J3mDPH
         KKhkL5Mg2DM8FSl3a7RZNa8ZIOOiVHtMBotl1SbcBb0xS+f0ic5SjzbCeFnrXqN0hprx
         m+SJyJakxz3Tebw0KQT3A6LFfoGTSzw56k+g0w8zMR6+h18NSqh7WP9SUIrgd1Nr1UrN
         tgUm06AGij34kut3vZjUPzUHrrdyLwIu7hwtifnEOzCZl4Cj4GQouZaXZTW0ihH9/p3C
         UHV03UCJ7hPh2nfo1uStMln9/b/JbuIymhtVL4WNd95YhLB1526QT4MYwmNJ/XolAG38
         R4Og==
X-Forwarded-Encrypted: i=1; AFNElJ8zO22/w7VbtBlGn44EHOcYW3SuXRPNA4cNwrkgTWP1UAAMZ+JGT3N72Q040Rlo4cgiq8IK/0g4Nyt2piLy@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv8z/MXAWK2eDEo69fBg6iqigpAki8yLGP9t60+yFY3vDj0f+z
	9mnxpM6WAYYndXzEIDiKzCltW5wfXiyHJG4BRg6jsLARz6FzBHAAIF2zWeEEJB/rRHnon58GFMW
	Ht9WG5gTNZArnU+n2puCjD8zCTg1EI/g=
X-Gm-Gg: Acq92OE8Tu7Kug6FEiwA6cecAwFMAG0RMnTS4C11Kr66wZQ8HNQJJbX1DO1paJVsE9k
	VYHVUemrmjeZCj+PNthjvJdZtiFaT8fFypadvx1L+POYmGd5ONuQfWtohIvDHI4dumLa4r0s7ow
	4SOGTPxpOMbm6hh/MTvsTH+5kL35wOU8+RMLEzriYDjfBgRfbQtSa1y1UYBihwoNi2fQPN6D/mg
	CFSxNoDYfZ0F3PhyAMOVowVZkpMYMLp3qeKULnJPio1wP1sqCljJljZ/r64CDDkD6QqJH2eBWmY
	VVu3Kv3QI58m2fIph9JPADD6MA5omGR90cx8zgIs/g==
X-Received: by 2002:a17:907:a317:b0:baf:e47:1b6a with SMTP id
 a640c23a62f3a-bd5179305eamr901579466b.24.1779129583498; Mon, 18 May 2026
 11:39:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-3-joannelkoong@gmail.com> <CAJnrk1YUjqd+j1yLXuO0M07ueCUYNC0NqgwmQSm3OiY3hnhgZQ@mail.gmail.com>
 <CAOQ4uxhyZU_6jbv8kY8od_SgG9yQ6aX+KcB2c1um4DajJdSPqA@mail.gmail.com> <CAJnrk1aEc1nf7ax0UvdCi7rkzbWDFpgjJcE35HCQyWcPLdoOnw@mail.gmail.com>
In-Reply-To: <CAJnrk1aEc1nf7ax0UvdCi7rkzbWDFpgjJcE35HCQyWcPLdoOnw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 May 2026 20:39:31 +0200
X-Gm-Features: AVHnY4JsphHHnp2Pz3CHXNh0OLuBHsTbi3fRyxqNZbsPkkAYnNNogJkZfjWHYTw
Message-ID: <CAOQ4uxhUZByYu6hp0TSekZ49FZDp20xPTpG9CmFDjtiTfh8Sgg@mail.gmail.com>
Subject: Re: [PATCH v2 02/21] fuse: prepare for passthrough of inode operations
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 8:04=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Sat, May 16, 2026 at 9:11=E2=80=AFAM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Sat, May 16, 2026 at 3:34=E2=80=AFAM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > On Fri, May 15, 2026 at 5:52=E2=80=AFPM Joanne Koong <joannelkoong@gm=
ail.com> wrote:
> > > >
> > > > +/* op bits for fuse_backing_map ops_mask */
> > > > +#define FUSE_PASSTHROUGH_OP_READ       FUSE_PASSTHROUGH_OP(FUSE_RE=
AD)
> > > > +#define FUSE_PASSTHROUGH_OP_WRITE      FUSE_PASSTHROUGH_OP(FUSE_WR=
ITE)
> > >
> > > Do you think we should couple the passthrough op code to the fuse
> > > opcode so closely, instead of defining the passthrough ops separately=
,
> > > eg doing something like this?:
> > >
> > > #define FUSE_PASSTHROUGH_READ         (1 << 0)
> > > #define FUSE_PASSTHROUGH_WRITE       (1 << 1)
> >
> > Don't drop the _OP_ please
> > Need it to distinguish from FUSE_PASSTHROUGH{,_INO}
> > and we need to think if we want to format this as 32bit and extend late=
r
> > or start with a u64 ops_mask format from the start.
> >
> > >
> > > In the (far) future when some more advanced passthrough features get
> > > added (eg full subtree passthrough), it seems like we'd want to add a
> > > passthrough op for that,
> >
> > I don't know. fuse_backing_map has flags, why would we want to put that
> > in ops_mask.
>
> That's a good point, I like your idea of using flags for that.
>
> >
> > > but that wouldn't map to a fuse op. I think
> > > there are also some fuse ops we might skip defining as passthrough op=
s
> > > but are implicitly passed through (eg FUSE_STATX which is covered by
> > > FUSE_GETATTR),
> >
> > This could also become the case with FUSE_CREATE{,_HANDLE}
> > or {FUSE,FUSEX}_CREAT.
> >
> > TBH, the fact that some ops will never be in the mask and
> > that some ops have a canonical bit in itself does not justify creating
> > a different mapping. Do we also want to squeeze the mask into 32bit
> > and leave reserved space? my intuition is to leave it u64.
> >
> > > so it seems more intuitive to define the passthrough
> > > ops as describing capabilities rather than implying that it describes
> > > what specific opcodes get passed through?
> >
> > hmm. I guess you have a point that it is a bit limiting to commit
> > to this arithmetic in UAPI.
> >
> > My thinking behind this was ease of use with these helpers:
> >
> >        if (!fuse_passthrough_op(file_inode(in), FUSE_READ))
> >
> > but those could just as well be macros:
> >
> > static inline bool fuse_inode_passthrough_op(struct inode *inode,
> >                                             u64 opbit)...
> >
> > #define FUSE_PASSTHROUGH_OP(inode, opname)    \
> >              fuse_passthrough_op(inode, FUSE_PASSTHROUGH_OP_ ## opname)
> >
> > #define FUSE_BACKING_MAP_OP(map, opname) \
> >        ((map)->ops_mask & FUSE_PASSTHROUGH_OP ## opname))
> >
> > ...
> >        if (!FUSE_PASSTHROUGH_OP(file_inode(in), READ))
> >
> > wdyt?
>
> Nice, the macro idea is neat!
>
> I feel like it gives more flexibility to define it separately and I
> think with that, u32 would be more than enough bits as well. But I'm
> happy to go with what you think would be better here.

I am not sure. Let's keep it u64 for now.
Since the struct is in an ioctl, it does not really matter much.
If we ever consider moving backing_map responses inline
in lookup/readdirplus response (maybe over io uring) we could reconsider.

In case you missed the exciting conversations about this API
original fuse passthough patches from Android had the backing fd
in the open response but it was deemed unsafe writing fds to
/dev/fuse, so ioctl was chosen instead [1].

With io_uring I don't think the security concern holds, so I see no reason
why backing_map would not be possible in-place for readdirplus
responses if we wanted to do that, but we can also ignore all this for now.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/CAG48ez3ZX8R9kRAQhung2_e3wjowu5cP=
h7WL3U866mkga-kftQ@mail.gmail.com/
