Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7168E3AFCF4
	for <linux-unionfs@vger.kernel.org>; Tue, 15 Sep 2026 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482042; cv=pass; b=Rbd3nM4jgDHBvTLgm1RKRSsDeP1FXRbWNvSxMF1jrURf1VdwOvKvag5P56BTVaTjWzv53fmLwWBL7UpnaaCj3K7auRUt4nDio9hB9OvTG2l2ZYLw0nkVHZ4tCOyiN2fJuE4RfWujQmrhKse8eYUqxjpzpOA8ngyB4TrP1rx34fc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482042; c=relaxed/simple;
	bh=32lpFruyhNUsWyexYikX8vyF9ON0Ldgf3SSLR0FL4Q8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rKa0sNXyRygLANRiFvn2n3tndDMZB8UTyv0u6TWHrSy9p05nhhUzJMUOc4cy55UHt3RKNAjeN0J+il9DOIY1jtm1AcDNrvJx4EAbn//IMaYq8V0zF2hrB4kCCSRu17ypfGIvdUbCy83H2lawGgyJq2w2cZm++iW1qo7W4af+ZmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBAYAcNP; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBAYAcNP"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2953a01240so550775566b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Sep 2026 07:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789482037; cv=none;
        d=google.com; s=arc-20260327;
        b=E4n5lmlD9MTaosjb/grMgLDXNXQxnHkRLDzJmZKQhD8xaPhYM3pl3e343JjS4evxJ5
         tUGYCr0FH5MbWd7GO/dffJJPU0Lt+o9pVTt/k2PJ7Jept8LoH+fn4coZzNY7wpyQLfbw
         3/NC7HFCDgZ0Is/Qy15EGMrdeXXOikzI9+aXqISHBKrtEYZvmkRQebhIWGaZY/EL1pNr
         6ngVsOewHZjAwW2oYqYkqvwMPMtOeuSUni1R7SdvnM1zU2DLvX+F/FjIzmJQgShYLMYn
         7Wjknj3xFlzFLBFzy3H3bwMHfuKNqH5VbBW7vIwUkFV+RK/RkPuGjW4ZPucPxMMbofH8
         QMbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rZ7LhLBdmBE5VBD6WpRRLsL3OA8Ij36kcHE37wE5ptE=;
        fh=ZfcFC9+kVgWpwSXr40Y9uFYp7q8ys/3i+H9rdXNftW4=;
        b=GoYdf3ElzndN0o9zt+KcfhpWHdpluja7JOXSbJqISpf8tfsI76x5sYE9XPL8wCGcNw
         DhtXcCGgqW/DUFrq4gey+LX9G3X58jrOFEtHkU17qyGefnWms19fveEa3m6FG+pz+cwT
         PMGLpQIE5rYrHhdoesXvwVfucCwUaAL7Ym50VwgNYS6lTnq9SV8NmodhbxYJu8xYB2WJ
         NVwBv0Cs+KNpWi2a9uI6IpoZxRY/mEqfNo5pcB+HL+CwrpH3pSGPgtz2HkD5KYIMONbA
         9aOF0bRXSXSIVKWgdL7063FHjb3vjwHD90JLD3GXpRKjGCcRWyvLjJYYFBpr8a8c5KLr
         knWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789482037; x=1790086837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rZ7LhLBdmBE5VBD6WpRRLsL3OA8Ij36kcHE37wE5ptE=;
        b=jBAYAcNPjoC3vLk4wWGqT/oDCt/C+LRrGQ8l9kdLLJje9QAN1l5lDyAWAaeKHHDjk/
         Mpwc8v241PWDMKlOFg2ut+pFI68M0+bq4FGj3PdW5b1lNqP46NvAD5SfRm1amEdE3r+c
         3cfWKvOyxFmXyFQBigUjmhdEfrRDgEUqROccGr1zFbcc7INh5ni6nuHX75Qf8KGCfEJW
         6+benLjh5WRFrLDYUHzV40ME1QbdOEY4EGZuCX41PX/wZqwdOFDdEQUWQQaLUc7+HR1R
         wZwZMUnO6BuEN17YhCGpKkHFDSDuEkIOT5w/313ij8cl/TeYCKW5HfqPFXes+YY72eOb
         YKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789482037; x=1790086837;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rZ7LhLBdmBE5VBD6WpRRLsL3OA8Ij36kcHE37wE5ptE=;
        b=rHZyBwk0rsNTmwRTFpTMjvI7KvPDC6TJnJBZncwtXDOH96CkI2SXG5ZY6hWdUk/WWQ
         NKUgYW0gwp6iDVrSIU3n4bLGGJrHzv9b7tDNQIhzDJq7SGE2CnQ2Re9zt6HSetPHJzYj
         cbeDm5HHsBrY4iMXMjRCZGeJU+fXUNDD9SwdSm2JWt5y9qBADKzNdYe0bkxfbFBbfTAF
         w2k1h65Kok2iSf/BD3kXNO1ICSs4HBkca7h40pQluVHBMFwE0u7aqpDHFgN9EeUK7/0E
         A031N98DiUVj1ADWTxaoY4rFsrjYzLS/miM/DgzvITYHvf7PT7kzDo3ZYn98P9KCF+tW
         RMBw==
X-Forwarded-Encrypted: i=1; AKwUvBxFvLIxjerz6JFfiqEsSP0YM8j47Eecaq5Gy4nSy7tu//L15PN2S3Nn1NIT9Kf+SCwacTOpYmnzBgstnOTZ@vger.kernel.org
X-Gm-Message-State: AFuF++kQQpHu3SMv4mEFxhLG6pUT8BUNCpOjj2dk6UXukl9RdTe1+K5z
	fcUIc0jzGbbl0BxPsDPJCIH2iQJK7PdZfx++HPTz0jOrLNxzHDkqHt1towjmBRmQ9ECXGcm3hgz
	3Sof7m2wvXU0Dbu3lGCi1RT75KQIX5ho=
X-Gm-Gg: AYBFou2OeGJPNz/1Fb9Df9THnNyf/9vJtLlw8Vjt8hhWa5aGFXLiLneYkk9w3EjDGVe
	gql/3gBe2hykjG19jUmQODFwCWPHBFbIwXmvILSIOeHM7908qRFoU2807lMdNkH3rdxLOs4Gs1U
	LHsOfxDqqkpOezcudApq0LUagGkVIi0h7macMEgY9D9pfMSj5K9Et0aGeCewpfw1XadZ9JDzUuN
	d+AtpShBGV5HoPgWiJALwKQTorrYRNvAW2cgIi0k/sq++IOoIEAvS6/UfrCMPrey+c7VRvbtU7l
	zF8ceW3HfJa9USyl40Hv+YKW2mVb8nFS8Wrb48RmVOWmCf6qs6rx8mPOoXe+mapguqA=
X-Received: by 2002:a17:906:7951:b0:c26:19de:9ac8 with SMTP id
 a640c23a62f3a-c29b86f9999mr543733066b.32.1789482036526; Tue, 15 Sep 2026
 07:20:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <CAOQ4uxhbbfn7pnq3YNMKpYDAjyZXdZcJoBpnkzjJwOdeDw9jow@mail.gmail.com>
 <CAJnrk1aBBVOY_bi0s8-FZm9EST2NNePW7jkX3J7ygQ3vaer7Tw@mail.gmail.com>
 <CAOQ4uxi_bdgJV4P0sgWbvhoTEHjSOhSHS=NcSymHp5-bdC_tzQ@mail.gmail.com> <CAJnrk1apXOpHuB3GrUy7BPn+Z-d0UoB2wrpDjHJZzM-v+Amy1Q@mail.gmail.com>
In-Reply-To: <CAJnrk1apXOpHuB3GrUy7BPn+Z-d0UoB2wrpDjHJZzM-v+Amy1Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 15 Sep 2026 16:20:24 +0200
X-Gm-Features: AcwNN1X-g6XyngnrNkv9YJgS61RqMjw37eKfZbKJTokQYitLU-pQcK4gcsK3CYo
Message-ID: <CAOQ4uxhqs-w-V8Uy8RU5vd6cYwVF9SRpMNY4zEP2W7_BJ7g_hA@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] fuse: extend passthrough to inode operations
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 9:20=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Sat, Sep 12, 2026 at 10:14=E2=80=AFAM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > On Sat, Sep 12, 2026 at 12:37=E2=80=AFAM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > >
> > > On Fri, Sep 11, 2026 at 5:56=E2=80=AFAM Amir Goldstein <amir73il@gmai=
l.com> wrote:
> > > >
> > > > On Sat, May 16, 2026 at 2:51=E2=80=AFAM Joanne Koong <joannelkoong@=
gmail.com> wrote:
> > > > >
> > > > > This series extends fuse passthrough to support inode operations =
(getattr +
> > > > > setattr) and directory readdir.
> > > > >
> > > > > The existing FUSE_PASSTHROUGH mode attaches a backing file to a f=
use inode
> > > > > only when a passthrough file is open. This series introduces
> > > > > FUSE_PASSTHROUGH_INO, a stricter mode requiring one-to-one inode =
number
> > > > > mapping, which allows attaching a backing file for the lifetime o=
f the fuse
> > > > > inode.
> > > > >
> > > >
> > > > Hi Joanne!
> > > >
> > > > I wanted to see how we can unblock this patch set
> > > > (did someone say conference driver development?)
> > > >
> > > > The main contention point for me on v2 was the fuse_entry2_out API.
> > > > And the suggestion to do a composite LOOKUP+STATX defers this patch
> > > > set to the unknown future of fusex.
> > > >
> > > > My favorite solution to a problem is to avert it.
> > > >
> > > > The question is how to include the backing_id with lookup/readdirpl=
us
> > > > reply. The answer is that there is no need to include it.
> > > >
> > > > I have already discussed with Miklos changing the UAPI to
> > > > widen the backing_id to 64bit and to let the server choose the id [=
1].
> > > >
> > > > Considering the fact that FUSE_PASSTHROUGH_INO literally means
> > > > one-to-one inode number mapping, it seems a bit idiotic that the ba=
cking
> > > > id (should it be widened to 64bit) be anything other than nodeid.
> > > >
> > > > The new 64bit UAPI is something like:
> > > >
> > > >  struct fuse_backing_map_v1 {
> > > >         int32_t         fd;
> > > >         uint32_t        flags;
> > > >         uint64_t        padding;
> > > >  };
> > > >
> > > >  #define FUSE_BACKING_FLAG_INO_ATTACH
> > > >
> > > >  struct fuse_backing_map {
> > > >         int32_t         fd;
> > > >         uint32_t        flags;
> > > >         uint64_t        nodeid;
> > > >         uint64_t        ops_mask;
> > > >  };
> > > >
> > > >  #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1,=
 \
> > > >                                              struct fuse_backing_ma=
p_v1)
> > > >  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2,=
 uint32_t)
> > > >  #define FUSE_DEV_IOC_BACKING_ADD         _IOW(FUSE_DEV_IOC_MAGIC, =
3, \
> > > >                                              struct fuse_backing_ma=
p)
> > > >  #define FUSE_DEV_IOC_BACKING_DEL         _IOW(FUSE_DEV_IOC_MAGIC, =
4, uint64_t)
> > > >
> > > > ---
> > > >
> > > > - Server calls BACKING_ADD before open or before lookup
> > > > - fuse_backing is stored in backing_map hash table instead of idr
> > > > - With flag FUSE_BACKING_FLAG_INO_ATTACH:
> > > > -- If fuse_inode of same the nodeid exists, fuse_inode_backing is a=
ttached
> > > > -- On instantiate of new fure inode, if fuse_backing exists with th=
is nodeid,
> > > >    it is auto attached the the fuse inode
> > > > -- This attachment lives until inode is evicted (same as in this pa=
tch set)
> > > > -- requires FUSE_PASSTHROUGH_INO
> > > > - Without flag FUSE_BACKING_FLAG_INO_ATTACH, backing is attached
> > > >   to inode on open as today and detached on last close
> > > > - The server attached backing survives inode evict and it is up to =
the server
> > > >   to do BACKING_DEL on forget if it wants to
> > > > - BACKING_DEL only removed from the backing_file hash table -
> > > >   it does not detach fuse_backing from the inode (as today)
> > > > - BACKING_ADD to already mapped backing or already attached inode f=
ails
> > > >
> > > > FUSE_OPEN reply does not need to include an explicit backing_id.
> > > > It's enough to set FOPEN_PASSTHROUGH because the backing file
> > > > is already attached to the inode.
> > > >
> > > > Similarly FUSE_LOOKUP and readdirplus do not need to change at all =
-
> > > > server just does ioctl BACKING_ADD before the reply.
> > > >
> > > > For backward compat, FUSE_PASSTHROUGH can use the old
> > > > BACKING_OPEN/CLOSE with a naive 32bit id allocator.
> > > >
> > > > [1] https://lore.kernel.org/fuse-devel/CAJfpegve9GMTRwvoA5y7AzUSD4e=
_EDJFzsqhCVN8xQ+RjQ=3D+Sw@mail.gmail.com/
> > > >
> > > > What do you think of this plan?
> > >
> > > Hi Amir!
> > >
> > > Thanks for your detailed email.
> > >
> > > I think this plan/idea is smart and it makes sense to me, but I'm
> > > confused what the plan is for fusex.
> > >
> > > If fusex is going to materialize, then in my opinion it would be
> > > cleanest for passthrough in fusex to work via either:
> > >
> > > a) fusex is fuse-over-io-uring first. All or almost all (excluding
> > > interrupts, notifications, etc) requests go through the io-uring
> > > protocol. For passthrough, since the reply is going through io-uring
> > > (which bypasses the setuid security problems Jann identified in [1]),
> > > the backing fd and ops mask can be passed directly as a reply to
> > > lookup (eg as a reply compounded to ENTRY + STATX replies), which
> > > allows dropping the idr/hashtable, a bunch of kernel-side logic(eg
> > > fuse_backing_id_{alloc(), free(), lookup()}, fuse_backing_{open(),
> > > close()}), and a bunch of uapi stuff (eg struct fuse_backign_map,
> > > FUSE_DEV_IOC_BACKING_{OPEN,CLOSE}). I think this also would nicely
> > > simplify things server-side (eg server doesn't have to maintain its
> > > own map to kernel backing ids and release them on FORGETs).
> > >
> >
> > That sounds good for FUSEX, but we still need to support
> > FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} in FUSE so...
>
> I was hoping after a certain deprecation time period, all of that
> could be dropped entirely. But maybe this is unrealistic of a plan
> given how widely used fuse is... I guess the deprecation time period
> would be like 10+ years.
>
> >
> > > or
> > >
> > > b) if fusex is not fuse-over-io-uring first, then imo passthrough
> > > passing back the backing id in the lookup reply (in the new + expande=
d
> > > reply struct) seems cleanest to me. Then there wouldn't need to be tw=
o
> > > separate registration mechanisms and the extra kernel-side logic for
> > > supporting auto-attach, or solve weird edge cases that might arise (e=
g
> > > races between concurrent opens in iocache mode and
> > > FUSE_DEV_IOC_BACKING_ADDs).
> >

Actually, I started to consider a different solution altogether.

Following the same line of thinking
"Do not need to include the backing_id with lookup/readdirplus reply"
but instead of pre-registring the backing fd to a nodeid, I started thinkin=
g -
Why pass a backing fd at all?

Both BACKING_OPEN and BACKING_ADD do not pass an fd for IO
they pass an O_PATH fd which is a proof that the server had access
to lookup the inode.

BACKING_OPEN requires system wide CAP_SYS_ADMIN and I don't see
us relaxing this considerably for passthrough of inode ops.
We could actually relax to ns_cacpable(CAP_SYS_ADMIN) if we create
a mode where inode passthrough is restricted to a specific backing filesyst=
em.
The premise that inode passthrough is one-to-one nodeid/backing ino mapping
kind of suggests that we would need to do this anyway.

What this means is that passing a backing file handle in the lookup
reply is actually a safer and more efficient way of passing a backing
inode descriptor to the kernel.

LOOKUP_FUSEX or LOOKUP_HANDLE will include the stable fuse handle
of the fuse inode.
For FUSE_PASSTHROUGH_INO it makes sense that the fuse stable
file handle is actually the backing file file handle, same as the one-to-on=
e
inode number mapping, so the lookup reply only really need one flag to say
we want passthrough (akin to FOPEN_PASSTHROUGH) and possibly the
passthrough ops mask.

There would need to be at least one main BACKING_FSOPEN ioctl
to define the sb/mnt/creds and those same details could be reused
for all the lookup/readdirplus replies.

ops_mask could either per lookup reply or common to all passthrough
inodes.

Food for thought.

I'll see if this materializes to a POC or  FUSE_DEV_IOC_BACKING_ADD
or both.

Thanks,
Amir.
