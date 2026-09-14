Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62CC3A1E67
	for <linux-unionfs@vger.kernel.org>; Mon, 14 Sep 2026 19:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789413626; cv=pass; b=RGE/vJm9lWXmuS1r2m5MnEDxMyN+KwB9CEdch+b8U1ydmEfxkdPnjb+SCh2jf8oEICXZjJoWSsxxWZUJDecnAntyM6mECNyLBsPnj3OEd0/i9ObnKTksBhpYQ0nC7Y/C7nRmPTQiaHertGxR5ju2YXf1dDxtRF7mWtGRki16v0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789413626; c=relaxed/simple;
	bh=xakzeq5id78Z/Uqt2W5jU58Uyg9YaQypJq9wqXGUycM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVUNj7+pUrN+TI7WA/wStYGBKv4j5ZTFPplvtMil19ADRR4SN1wyg7yOM0F4jInOvDcgEN8tnt+01abPE0kPryiBW9CoMAtoPE8PBNLyPjtxxTf/luzoJf2PMsZ2sbCAY65P1HR55XHsr5eiVBwPYvcVumwca06EinIr1Wt+JaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sMntrinA; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sMntrinA"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6351832so1343360f8f.3
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Sep 2026 12:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789413621; cv=none;
        d=google.com; s=arc-20260327;
        b=gIfwhJ0GfbA15+6SlwbSGqnxL2Q/6t7HbITL2SRo6mjFNCP8OGDnWXshdePobJmdMf
         QfPz69WFgr2MV39f6eRjGyDpvhRtHl1aVizxA7kA2jYaaGemJE6f0nyhDAKX16MGfV1V
         pI8cV8S/7FhZcYQobPAG6jDH2sO4P90ffcrsAhu+1fN9iQNdI4bLeiG/l6zhgRUWGKQD
         qZfNFEMiGzMCoxDeP+sJRZXhxGqoJXL6yBtY/awlHC873n8myzqoIlrPO3TXZBBNKo4d
         +7RFKPjzI7nXp9fRqT97tQ5HB2LCHezln0wBnP++E15B4qE04dJ96IqCy/Hil25UYqz4
         w4Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RToJfpqTIYj+TSAl56wnkXn/Ktuv55iQLTBkVkQVxAQ=;
        fh=QqoYFmxyBv91+Z60847Ls8MQCwxF/pU/xb8r+ErJ3XE=;
        b=Uk7XKTm4eLt9GY1KFh9NtoOG6cJ8s/0lNVLfxbFoyL5KgMNi5XC0fVzeF+QBno43G7
         KyT4BZIDk/GXi2I+5lJzvUKyvhv76UnXBhl+AYKe+zUbCm+NUk69MBIVRwFfFpMXMwPd
         Hehz1iLBdUnJv6ByX2hhVfTCfXVwWQrULLfqG6XfvGaXkojAI4izVvrjfccheJ+6vObf
         EnyXH8Hzc4KKDA9Lloov/YCTyJKvDsFaI6R91mls0bbAefN331f5bxbZRxmCsh0mnKxh
         kUIsgGqYgJ4SGZrwUuXPly+jgj1gaDVj4+GRigAi0bZ24Tdge0m1/4xauvPNG5pp9FkU
         GAjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789413621; x=1790018421; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RToJfpqTIYj+TSAl56wnkXn/Ktuv55iQLTBkVkQVxAQ=;
        b=sMntrinAfGi4wEN5X8dZCH4429hX1WKIZprolwv4TRbft0rA/OChgDYhFRKol3gsuP
         VtMOhGjFefOHjD6ylSL/AJlwYjd+XibecB1CD6dGxQyheKdMd/i2SGHzcHRY/xThO0a1
         FI76PixFNJAcZnJoQQ+ceebJGgfbtVzij0jEuxwbml5jnt77NS6Yo2OGT6AegONU5jFi
         WnspJ4Im39sXAqaaUkjOcHDV/VL4T5oAHsJiDg7CgKTtKMTWzsOub56FToBw8Yo/WIKS
         Q3DS38jr8+PAAK859ARYCoC3u+JKI9kmj9cdTEggixBeU2ezcAv0wa9B+5hSQfr01HfZ
         GzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789413621; x=1790018421;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RToJfpqTIYj+TSAl56wnkXn/Ktuv55iQLTBkVkQVxAQ=;
        b=FZp+AgPFEkDvPZkOTJnXkbTCr1Vz1DatBNXl0jrgWG2YBfeKXH8Rtl/itsflFw+APV
         cdFmA7lvVN+EdE3C/59CsC+9DBGduLqvBF2z3Oeem6VZxC8oJlj1BHt0493g9PJBjXoj
         TOlbbGD503MyeKPwvJvWEsvGEuP8ajlGVr0ivo3SIxDiBqhkdLkclo2gYGx3KskRdy8n
         gpScPxSU7DZw4DmFTYHS1iLAXUjTqlzoPWsv4YxFXwejcdJmtnziTEGt6BZzBmK/QeY5
         wxfYfqwYZ5nz4GJe6f12S3v7378ZZsc6ZCUpJ0piK/mUAGnNItm3teim000V/kauc9N0
         yKdg==
X-Forwarded-Encrypted: i=1; AKwUvBzv1D8mvkwl+T0nOHTCwVGW2cTkj+bIMmfkrsxyVmpph1V2rvdcIgw50Nz70cQAhiv0GxIXCjpRAJnVpCLM@vger.kernel.org
X-Gm-Message-State: AFuF++mGBsvNaBMmjnXU5J7U1TPsX5fYmFYL4XgfXhiBY+17BQ3IQNfu
	tZ3rP9aYkxACS9wZFTAN7AQHVDjFcxmUew/HV4T1OewGFdrBY9amSi0NCtbhg+J5FtT0pR6W/zZ
	PfK5VE/9vM/Zq5tzFyMG0hd8gzlYIyyI=
X-Gm-Gg: AYBFou0pcwiZ7yMwhFTIvFEKJ0gjtRL/2BY0e5kDsEBS02h0tDlkihx2exjopLsp7b+
	TPzfUraaQ3gmwqXP/Zk1CIuFPPJwwtRRDaE8GShciGY5tk1PKDdY4xgrEGcXH+zDzymqr2tcYEr
	2B65w7DMHnIBtsw5ztXtyZfNEdjwtEOqoa2opxLWpmF5mUd3dUZDdqEJTut9oahZPI4W4Y7GtVT
	W54IIQH9sJQhCUv9NjyJjwSxSO156WXpuEWyt4ro76HT5vzIqnBqKxNzUDIV/D6GAV0KjElvs9p
	XB0od29/OSZQuu3ts5vdQ9OkWVg4UOsad74/kPZfzwhWtC9DUxNlw+oIa/9O/1sIZpXFMQyw/nz
	Q0njNYo0vh6lAAqEK3y5vh/bP68QXNr5RJqNS4A8=
X-Received: by 2002:a05:6000:616:b0:487:4a8:e853 with SMTP id
 ffacd0b85a97d-48704a8e88amr2218941f8f.12.1789413621130; Mon, 14 Sep 2026
 12:20:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <CAOQ4uxhbbfn7pnq3YNMKpYDAjyZXdZcJoBpnkzjJwOdeDw9jow@mail.gmail.com>
 <CAJnrk1aBBVOY_bi0s8-FZm9EST2NNePW7jkX3J7ygQ3vaer7Tw@mail.gmail.com> <CAOQ4uxi_bdgJV4P0sgWbvhoTEHjSOhSHS=NcSymHp5-bdC_tzQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxi_bdgJV4P0sgWbvhoTEHjSOhSHS=NcSymHp5-bdC_tzQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 14 Sep 2026 12:20:09 -0700
X-Gm-Features: AcwNN1VT4YJXomw_m6K_xFXbNQACsxT_M1yNqzMKI4PHHq0XbCPy_cX8UwU-MQQ
Message-ID: <CAJnrk1apXOpHuB3GrUy7BPn+Z-d0UoB2wrpDjHJZzM-v+Amy1Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] fuse: extend passthrough to inode operations
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 10:14=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Sat, Sep 12, 2026 at 12:37=E2=80=AFAM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> >
> > On Fri, Sep 11, 2026 at 5:56=E2=80=AFAM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Sat, May 16, 2026 at 2:51=E2=80=AFAM Joanne Koong <joannelkoong@gm=
ail.com> wrote:
> > > >
> > > > This series extends fuse passthrough to support inode operations (g=
etattr +
> > > > setattr) and directory readdir.
> > > >
> > > > The existing FUSE_PASSTHROUGH mode attaches a backing file to a fus=
e inode
> > > > only when a passthrough file is open. This series introduces
> > > > FUSE_PASSTHROUGH_INO, a stricter mode requiring one-to-one inode nu=
mber
> > > > mapping, which allows attaching a backing file for the lifetime of =
the fuse
> > > > inode.
> > > >
> > >
> > > Hi Joanne!
> > >
> > > I wanted to see how we can unblock this patch set
> > > (did someone say conference driver development?)
> > >
> > > The main contention point for me on v2 was the fuse_entry2_out API.
> > > And the suggestion to do a composite LOOKUP+STATX defers this patch
> > > set to the unknown future of fusex.
> > >
> > > My favorite solution to a problem is to avert it.
> > >
> > > The question is how to include the backing_id with lookup/readdirplus
> > > reply. The answer is that there is no need to include it.
> > >
> > > I have already discussed with Miklos changing the UAPI to
> > > widen the backing_id to 64bit and to let the server choose the id [1]=
.
> > >
> > > Considering the fact that FUSE_PASSTHROUGH_INO literally means
> > > one-to-one inode number mapping, it seems a bit idiotic that the back=
ing
> > > id (should it be widened to 64bit) be anything other than nodeid.
> > >
> > > The new 64bit UAPI is something like:
> > >
> > >  struct fuse_backing_map_v1 {
> > >         int32_t         fd;
> > >         uint32_t        flags;
> > >         uint64_t        padding;
> > >  };
> > >
> > >  #define FUSE_BACKING_FLAG_INO_ATTACH
> > >
> > >  struct fuse_backing_map {
> > >         int32_t         fd;
> > >         uint32_t        flags;
> > >         uint64_t        nodeid;
> > >         uint64_t        ops_mask;
> > >  };
> > >
> > >  #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1, \
> > >                                              struct fuse_backing_map_=
v1)
> > >  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, u=
int32_t)
> > >  #define FUSE_DEV_IOC_BACKING_ADD         _IOW(FUSE_DEV_IOC_MAGIC, 3,=
 \
> > >                                              struct fuse_backing_map)
> > >  #define FUSE_DEV_IOC_BACKING_DEL         _IOW(FUSE_DEV_IOC_MAGIC, 4,=
 uint64_t)
> > >
> > > ---
> > >
> > > - Server calls BACKING_ADD before open or before lookup
> > > - fuse_backing is stored in backing_map hash table instead of idr
> > > - With flag FUSE_BACKING_FLAG_INO_ATTACH:
> > > -- If fuse_inode of same the nodeid exists, fuse_inode_backing is att=
ached
> > > -- On instantiate of new fure inode, if fuse_backing exists with this=
 nodeid,
> > >    it is auto attached the the fuse inode
> > > -- This attachment lives until inode is evicted (same as in this patc=
h set)
> > > -- requires FUSE_PASSTHROUGH_INO
> > > - Without flag FUSE_BACKING_FLAG_INO_ATTACH, backing is attached
> > >   to inode on open as today and detached on last close
> > > - The server attached backing survives inode evict and it is up to th=
e server
> > >   to do BACKING_DEL on forget if it wants to
> > > - BACKING_DEL only removed from the backing_file hash table -
> > >   it does not detach fuse_backing from the inode (as today)
> > > - BACKING_ADD to already mapped backing or already attached inode fai=
ls
> > >
> > > FUSE_OPEN reply does not need to include an explicit backing_id.
> > > It's enough to set FOPEN_PASSTHROUGH because the backing file
> > > is already attached to the inode.
> > >
> > > Similarly FUSE_LOOKUP and readdirplus do not need to change at all -
> > > server just does ioctl BACKING_ADD before the reply.
> > >
> > > For backward compat, FUSE_PASSTHROUGH can use the old
> > > BACKING_OPEN/CLOSE with a naive 32bit id allocator.
> > >
> > > [1] https://lore.kernel.org/fuse-devel/CAJfpegve9GMTRwvoA5y7AzUSD4e_E=
DJFzsqhCVN8xQ+RjQ=3D+Sw@mail.gmail.com/
> > >
> > > What do you think of this plan?
> >
> > Hi Amir!
> >
> > Thanks for your detailed email.
> >
> > I think this plan/idea is smart and it makes sense to me, but I'm
> > confused what the plan is for fusex.
> >
> > If fusex is going to materialize, then in my opinion it would be
> > cleanest for passthrough in fusex to work via either:
> >
> > a) fusex is fuse-over-io-uring first. All or almost all (excluding
> > interrupts, notifications, etc) requests go through the io-uring
> > protocol. For passthrough, since the reply is going through io-uring
> > (which bypasses the setuid security problems Jann identified in [1]),
> > the backing fd and ops mask can be passed directly as a reply to
> > lookup (eg as a reply compounded to ENTRY + STATX replies), which
> > allows dropping the idr/hashtable, a bunch of kernel-side logic(eg
> > fuse_backing_id_{alloc(), free(), lookup()}, fuse_backing_{open(),
> > close()}), and a bunch of uapi stuff (eg struct fuse_backign_map,
> > FUSE_DEV_IOC_BACKING_{OPEN,CLOSE}). I think this also would nicely
> > simplify things server-side (eg server doesn't have to maintain its
> > own map to kernel backing ids and release them on FORGETs).
> >
>
> That sounds good for FUSEX, but we still need to support
> FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} in FUSE so...

I was hoping after a certain deprecation time period, all of that
could be dropped entirely. But maybe this is unrealistic of a plan
given how widely used fuse is... I guess the deprecation time period
would be like 10+ years.

>
> > or
> >
> > b) if fusex is not fuse-over-io-uring first, then imo passthrough
> > passing back the backing id in the lookup reply (in the new + expanded
> > reply struct) seems cleanest to me. Then there wouldn't need to be two
> > separate registration mechanisms and the extra kernel-side logic for
> > supporting auto-attach, or solve weird edge cases that might arise (eg
> > races between concurrent opens in iocache mode and
> > FUSE_DEV_IOC_BACKING_ADDs).
>
> Same problem.
> We need to support FUSE_DEV_IOC_BACKING_{OPEN,CLOSE}),
> so we cannot get rid of the backing_files and separate mechanism.
> However, we can replace its implementation with a hash table.
>
> w.r.t concerns about auto-attach and weird edge cases,
> I understand your concern, but my feeling is that after seeing the
> patches, it will be easier to determine how much of a risk this really is=
.
> So it is on me to show a POC.
>
> >
> >
> > If fusex will be abandoned, it still seems like the entry reply will
> > have to be expanded anyway (either with a v2 struct or by piggybacking
> > off compound requests) for Luis's lookup handle work to land. If
> > that's happening regardless, imo having inode passthrough reuse /
> > piggyback off that infrastructure seems cleaner to me (but also
> > unfortunately a lot longer of a timeline given the dependencies :()
> > than adding the FUSE_DEV_IOC_BACKING_ADD registration mechanism /
> > logic.
>
> As you say, lookup handle and compound requests are a tall order.
> As I wrote in my own review on v2, I'd rather wait for those over
> v2 struct.
>
> However, I still stand behind my claim that
> FUSE_DEV_IOC_BACKING_ADD/DEL do not add much
> complexity over the existing registration mechanism that we need to
> support anyway. Moreover, Miklos suggested that we bite the bullet
> and make this UAPI change.
>
> >
> > What are your thoughts on this? What is your preference?
> >
>
> Let me post a quick POC of FUSE_DEV_IOC_BACKING_ADD
> and let's reassess our opinions based on these POC patches.

Sounds great, looking forward to seeing the POC!

Thanks,
Joanne
