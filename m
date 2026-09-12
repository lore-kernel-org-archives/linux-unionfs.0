Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD4834E75D
	for <linux-unionfs@vger.kernel.org>; Sat, 12 Sep 2026 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789233298; cv=pass; b=d+O951/60cYykhetHP84WGkWSaeKu5hIvBF8W/GN7LZ5TuDSklN8RW3i/rLQ27Op/Bzc062xNJhTP2LQF5MOLjvrQmZ4st8NrF/PVYgad/Z44jjmSrHpXcgEnodOoHJwhUoSc7JeGrFi9BPjDBr0hHCocQU9Sf2fCHboepw8jTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789233298; c=relaxed/simple;
	bh=+FW0pbG0OmhW4/8ZrhnzMMIRgqPmeD7bCWQclF0zYf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JAeJ8/7OF6Fc/VwCAimw0MW425FnF/IoHrNN2GkXY0EL2J+if8JkxpFOza6Z/sTYye6gzYHJ9K6LFeoGfaEreEDHV63FHh3h6cY2wF1HD0MSwkAT6E2WOOkFwEIXaQdmEhHrJtCMR+Wi/5edroIbCYLdOasOylRE+qlf4wckdEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VANmqakl; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VANmqakl"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c25b661d37dso295915466b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 12 Sep 2026 10:14:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789233294; cv=none;
        d=google.com; s=arc-20260327;
        b=bnKDDt6ZbQmPY3ts/N7USoPal8vsY4Spc5EIJ2IWHa0bo9l10Cwe5lM/YVZ603zDXc
         uHPMDt0OvMoGydhqtOuK9JYGI44B16dAVuKVi6UeX2wikxCK4LDzu4ZnepcEeqoIpuvW
         lbSTdeZBf0oQ3jFwv9q88vbl9I+oTtdQ7Tv/caxVYfZxL6soTFuLOvddyTs5HBZpOFHw
         WQ6t9uBZZjY64HfEn1GIOIfZ0uZAg7fDNWrSfcq8jp8JSj0iAIuoiFKTqa5KrfJfc/88
         z5ftT1IT+ynDWlFbcIXrMm0EZXMZleGIbrvxALCui52KbvWgZiBG4hd+7VWHXY6w75tM
         8USA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KRAPNhTa/+jL5NE3IQve8IfPyvKe3Wz0oKp1H5EXtN4=;
        fh=2BT2wpD7VA6pyJpuRqoZeEQg+JnK7Qh/2un+jWGFLtE=;
        b=ZgCcILwK0drlcR271DixFVAAPN1MEwapwaYIwHPc8TGmi/HBk9/muXNEQn6iwVwe7X
         RSxoeUpb/YjjEkaR2uqOWvtUDsjjKWhKQR8odFvf/wZyPb1nWvsxR2Uu1Ncek/2OaRUl
         Na182Q8C3IJziGGbA1CuXN7KSnod/KihAktFNPEsTdgJ0L+6B89hqQQ7O4XXzaYFkRj1
         DWzKyyadh124JVYoR2Itmk531rzu4+bMmStH3sUnVkRtB4outAbLxjBm9hqaVOMw6CYC
         LF9RHp3nMFQrT+YSgDXne9fF03zF9pX+Psm0Gwa+u+hp37KpfPZ425VVNK5ypb/7RpAa
         4SXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789233294; x=1789838094; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KRAPNhTa/+jL5NE3IQve8IfPyvKe3Wz0oKp1H5EXtN4=;
        b=VANmqaklzaFAWdgNqUxQO/6NECwVZr3la28KvfIPw8Z3oaVrAYCEodlNHL5ZgQ4+7W
         cuiBFaTe+yAUC0h8n5d9AUeRlpedW519X0jdOrEYs66E2yFq3dagYCcDvJC0Zs6rkAzf
         ZqM62YIdYa4qaFaZWrgTXegZRG44jRz0KLMX+pRf1wL9+JOUNwR4NCoyC4gzp2sEFc/w
         zZrcr0ho/bS0HJo3iMkoSoM/Ah6xg6a/DJakgPoG2E5ruLAKQJXU8vTMFRRZ39rUyDhi
         2qzEqxzj9iRmoGFm4jPiWtLK/8sA1W4oUvJgqNI4IJnUJkNAPffdYzmdnarcTy5BY7tr
         V7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789233294; x=1789838094;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KRAPNhTa/+jL5NE3IQve8IfPyvKe3Wz0oKp1H5EXtN4=;
        b=pjdIUqI/Bawq/LZpBaHR9P/pUdEge93VTCbdqeymTDqZphYNmp9qIMRF2ajSMrlTFE
         EyNAbYz1pqrVZwtKKwEjGyqxmcSH8k0us1yUVnyRu4aiQGF3ON7OvAkjXBsccKl797dL
         jWhgAqKSuODLo3UcB/F5Vd878lH2fv23zRqaMddPrAdyq68Bbdk7q6iznFIbpIpzwYVD
         H5z40H0COf/TMSqJXZkSqVDshdt8pg4D+lq8Gdy3yZ4NSN3mh/VFQaNtWpXf/cxoVdD4
         C+2NRqe6/wKf4fvJJBrFGsecHv7GB8aLKIqAExKMEI4cxbbEubLNl0zjkUwo/LnrdHd3
         fjbw==
X-Forwarded-Encrypted: i=1; AKwUvByXGIDJVymvEDx0/nDoXBbbFr1RnoaX6xRnpUlwycb3EmlB06lyDnA3bI6/uU0xuGH1IgtH2a2PqbFFWIrb@vger.kernel.org
X-Gm-Message-State: AFuF++l+1NrpziXWdpAU4nCd2NoVS/dMFX35i0oJXH1Nl872Gdh+8XY7
	m0E6PcF+r7v3CkfWhad0hM5h32mzd1FO/Vzd+nKP3Amcu3hVZJ5hkX/n43CqRZr2KbseFRBpGlY
	UBDWEbHJXtHBTxCcZJUaSClNSAqCm4vI=
X-Gm-Gg: AYBFou373KZI3OzI5z4oHh11eg5XGn2W0LD5cYViQLvdFGsJ0ikuziCfGEa8o7sqVY+
	H/gwT+pYVYjUVOTe83i0NcC9Iw/K7BQlOjaxXLzKDjWB7MPCcbRJRPWuy2ZaAchWdoiruAUsIaj
	VumXOU7sghWXL7h5+tpAfjHljnyCQcqATmA6xjuff7AakHW4jQi6C36qIf7KqT8SKunAYwuZiFr
	JuVm6P5hswilpipazujXHKdpiqoLN3msQk+qJuv9c/3+aHsiu/qaFUvBFcP6HOxDI9aMWIVpgPN
	oAcFL1MPXNy7331QoLxijDn2DJ/aqFn81y1NfZYgwZku2FqdYbYYNDOGFKBB4KPmwfE=
X-Received: by 2002:a17:907:8b91:b0:c26:19e3:e979 with SMTP id
 a640c23a62f3a-c29667467b6mr478184466b.25.1789233293638; Sat, 12 Sep 2026
 10:14:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <CAOQ4uxhbbfn7pnq3YNMKpYDAjyZXdZcJoBpnkzjJwOdeDw9jow@mail.gmail.com> <CAJnrk1aBBVOY_bi0s8-FZm9EST2NNePW7jkX3J7ygQ3vaer7Tw@mail.gmail.com>
In-Reply-To: <CAJnrk1aBBVOY_bi0s8-FZm9EST2NNePW7jkX3J7ygQ3vaer7Tw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 12 Sep 2026 19:14:42 +0200
X-Gm-Features: AcwNN1VyqcGoVQnwjkC7DVLNcJQhG2IGzH2-wJ2MfUq75vtopdqS3aPOVXQtpB4
Message-ID: <CAOQ4uxi_bdgJV4P0sgWbvhoTEHjSOhSHS=NcSymHp5-bdC_tzQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] fuse: extend passthrough to inode operations
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 12:37=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Fri, Sep 11, 2026 at 5:56=E2=80=AFAM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Sat, May 16, 2026 at 2:51=E2=80=AFAM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > This series extends fuse passthrough to support inode operations (get=
attr +
> > > setattr) and directory readdir.
> > >
> > > The existing FUSE_PASSTHROUGH mode attaches a backing file to a fuse =
inode
> > > only when a passthrough file is open. This series introduces
> > > FUSE_PASSTHROUGH_INO, a stricter mode requiring one-to-one inode numb=
er
> > > mapping, which allows attaching a backing file for the lifetime of th=
e fuse
> > > inode.
> > >
> >
> > Hi Joanne!
> >
> > I wanted to see how we can unblock this patch set
> > (did someone say conference driver development?)
> >
> > The main contention point for me on v2 was the fuse_entry2_out API.
> > And the suggestion to do a composite LOOKUP+STATX defers this patch
> > set to the unknown future of fusex.
> >
> > My favorite solution to a problem is to avert it.
> >
> > The question is how to include the backing_id with lookup/readdirplus
> > reply. The answer is that there is no need to include it.
> >
> > I have already discussed with Miklos changing the UAPI to
> > widen the backing_id to 64bit and to let the server choose the id [1].
> >
> > Considering the fact that FUSE_PASSTHROUGH_INO literally means
> > one-to-one inode number mapping, it seems a bit idiotic that the backin=
g
> > id (should it be widened to 64bit) be anything other than nodeid.
> >
> > The new 64bit UAPI is something like:
> >
> >  struct fuse_backing_map_v1 {
> >         int32_t         fd;
> >         uint32_t        flags;
> >         uint64_t        padding;
> >  };
> >
> >  #define FUSE_BACKING_FLAG_INO_ATTACH
> >
> >  struct fuse_backing_map {
> >         int32_t         fd;
> >         uint32_t        flags;
> >         uint64_t        nodeid;
> >         uint64_t        ops_mask;
> >  };
> >
> >  #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1, \
> >                                              struct fuse_backing_map_v1=
)
> >  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, uin=
t32_t)
> >  #define FUSE_DEV_IOC_BACKING_ADD         _IOW(FUSE_DEV_IOC_MAGIC, 3, \
> >                                              struct fuse_backing_map)
> >  #define FUSE_DEV_IOC_BACKING_DEL         _IOW(FUSE_DEV_IOC_MAGIC, 4, u=
int64_t)
> >
> > ---
> >
> > - Server calls BACKING_ADD before open or before lookup
> > - fuse_backing is stored in backing_map hash table instead of idr
> > - With flag FUSE_BACKING_FLAG_INO_ATTACH:
> > -- If fuse_inode of same the nodeid exists, fuse_inode_backing is attac=
hed
> > -- On instantiate of new fure inode, if fuse_backing exists with this n=
odeid,
> >    it is auto attached the the fuse inode
> > -- This attachment lives until inode is evicted (same as in this patch =
set)
> > -- requires FUSE_PASSTHROUGH_INO
> > - Without flag FUSE_BACKING_FLAG_INO_ATTACH, backing is attached
> >   to inode on open as today and detached on last close
> > - The server attached backing survives inode evict and it is up to the =
server
> >   to do BACKING_DEL on forget if it wants to
> > - BACKING_DEL only removed from the backing_file hash table -
> >   it does not detach fuse_backing from the inode (as today)
> > - BACKING_ADD to already mapped backing or already attached inode fails
> >
> > FUSE_OPEN reply does not need to include an explicit backing_id.
> > It's enough to set FOPEN_PASSTHROUGH because the backing file
> > is already attached to the inode.
> >
> > Similarly FUSE_LOOKUP and readdirplus do not need to change at all -
> > server just does ioctl BACKING_ADD before the reply.
> >
> > For backward compat, FUSE_PASSTHROUGH can use the old
> > BACKING_OPEN/CLOSE with a naive 32bit id allocator.
> >
> > [1] https://lore.kernel.org/fuse-devel/CAJfpegve9GMTRwvoA5y7AzUSD4e_EDJ=
FzsqhCVN8xQ+RjQ=3D+Sw@mail.gmail.com/
> >
> > What do you think of this plan?
>
> Hi Amir!
>
> Thanks for your detailed email.
>
> I think this plan/idea is smart and it makes sense to me, but I'm
> confused what the plan is for fusex.
>
> If fusex is going to materialize, then in my opinion it would be
> cleanest for passthrough in fusex to work via either:
>
> a) fusex is fuse-over-io-uring first. All or almost all (excluding
> interrupts, notifications, etc) requests go through the io-uring
> protocol. For passthrough, since the reply is going through io-uring
> (which bypasses the setuid security problems Jann identified in [1]),
> the backing fd and ops mask can be passed directly as a reply to
> lookup (eg as a reply compounded to ENTRY + STATX replies), which
> allows dropping the idr/hashtable, a bunch of kernel-side logic(eg
> fuse_backing_id_{alloc(), free(), lookup()}, fuse_backing_{open(),
> close()}), and a bunch of uapi stuff (eg struct fuse_backign_map,
> FUSE_DEV_IOC_BACKING_{OPEN,CLOSE}). I think this also would nicely
> simplify things server-side (eg server doesn't have to maintain its
> own map to kernel backing ids and release them on FORGETs).
>

That sounds good for FUSEX, but we still need to support
FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} in FUSE so...

> or
>
> b) if fusex is not fuse-over-io-uring first, then imo passthrough
> passing back the backing id in the lookup reply (in the new + expanded
> reply struct) seems cleanest to me. Then there wouldn't need to be two
> separate registration mechanisms and the extra kernel-side logic for
> supporting auto-attach, or solve weird edge cases that might arise (eg
> races between concurrent opens in iocache mode and
> FUSE_DEV_IOC_BACKING_ADDs).

Same problem.
We need to support FUSE_DEV_IOC_BACKING_{OPEN,CLOSE}),
so we cannot get rid of the backing_files and separate mechanism.
However, we can replace its implementation with a hash table.

w.r.t concerns about auto-attach and weird edge cases,
I understand your concern, but my feeling is that after seeing the
patches, it will be easier to determine how much of a risk this really is.
So it is on me to show a POC.

>
>
> If fusex will be abandoned, it still seems like the entry reply will
> have to be expanded anyway (either with a v2 struct or by piggybacking
> off compound requests) for Luis's lookup handle work to land. If
> that's happening regardless, imo having inode passthrough reuse /
> piggyback off that infrastructure seems cleaner to me (but also
> unfortunately a lot longer of a timeline given the dependencies :()
> than adding the FUSE_DEV_IOC_BACKING_ADD registration mechanism /
> logic.

As you say, lookup handle and compound requests are a tall order.
As I wrote in my own review on v2, I'd rather wait for those over
v2 struct.

However, I still stand behind my claim that
FUSE_DEV_IOC_BACKING_ADD/DEL do not add much
complexity over the existing registration mechanism that we need to
support anyway. Moreover, Miklos suggested that we bite the bullet
and make this UAPI change.

>
> What are your thoughts on this? What is your preference?
>

Let me post a quick POC of FUSE_DEV_IOC_BACKING_ADD
and let's reassess our opinions based on these POC patches.

Thanks,
Amir.
