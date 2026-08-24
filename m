Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76633A1E81
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787560191; cv=pass; b=ULUtj7SFRaAlE37rVGKBrVNQDdV90Uw3IjVeCPkPns53K31tvs52AwpUUub+m+wwXeQmDf8ArPn6Q79SwRagGbTehk95EWU5T7A42B/XG2WGdU5BL6iUqeM/aOzUFaxLzZwtVjtESJTKsNNb5Fgm7XmRab6QRY2LR3+/zMJh43g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787560191; c=relaxed/simple;
	bh=Tz455rwy8fwlJU5e/OyYKeyXhTs/2lpPvxcUrf88NeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MRt4df+gSjCtRrCe6KCBtOVRU7oa04jtbyD/CES7Yff+WXX6VaVwJQesZf8OfsNQKakRX9h7LukheXowD9rAg2XBe94f9NcW2kMWqmYLPmLTzBVmxWylxfWVlEPW5nE4rIDzuFqfp18+OCO+M+r6cAgg/IEDuMG22middk18K6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FqbAbV1N; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FqbAbV1N"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a18840e2abso5507723a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 01:29:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787560182; cv=none;
        d=google.com; s=arc-20260327;
        b=Mc7yBxZcvoPB3KNRSu8bj/3JSn5+j5BQ13Gyp/SN7wVZJscUdpD4w2q9CfE3Vr82WX
         +vDr8IieD5SR0WwQo8nmVRJotzNojlu5QwYXzRSAK0GZrAgHH5ICU3UmS2sO4aE0yPeF
         iMnRLo2J7rx9rO5kLCq15ySZ83lIolzjEC07+8LVmkaNe7zL35fhUIPAgQSy5usjWmz6
         VKUcYlIeySkRsVHfXQzLwmqU9E6CMcHX9TuEbkn1WRCYmqPcAUnnJLS+S8/aGhN06M97
         /IoiStA9eBEVx58/6qdz4PnvHzkrmMTO0OvHV4zC/NEzxKyWu22/X4RWls3npqpaIj7k
         hkSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aALTdzmz9gKwaB19EuKx9/YeS53HDdRQXdxNvRw3dlY=;
        fh=I6jEMjLQ0QQSa3e35RWxIatTRiI4pRQDvdrCkV/t9J0=;
        b=lap3wuZp4pukO3i2hqx+lQi1tL8Ze8j2FspwjRIATYUTO+5UgRTG1aJFBA1LhVwEik
         GuYTeGBMTxIlXsGHGBinH40L4GGFdWmBQGUF1AMMlQXQheB+jNmxprbINpyRKfxYaYPv
         JTtFNqb7gXVihxcpkbU6SNZAaQHSC3Zpr9h901nC31F9eenjuNDzc9ffZKThDQaORm2P
         iLF/0aRj/AMOzxU843pwMU+KDR2LH9U0ynhmPYtRdktfkFlt3zL3fduNazlMyY6JPEg7
         LaLycO9RWvvwz/8VkSF3hLNdmotgRWklTazQrY5fdaVRqLgUluDW+bKaFg9FlLGVWy0T
         Pogg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787560182; x=1788164982; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aALTdzmz9gKwaB19EuKx9/YeS53HDdRQXdxNvRw3dlY=;
        b=FqbAbV1NoN5cgw07v4n8PXvKm9OPzrvbu6UNUS4d6b0BuJCWlsTOpWC2t0pohEekuR
         Gi5goO31/rTS9aNsxvRueEdlgJSsPg+4DvhX1f4JUcvw0KwNJfsra26W5F00W+ajnsHW
         KUKNmaDmwVKHpOYSpQZvj1ZLXXWgH4W7VsXtgqDWbJCxHdmxDwEIIAqsc9UFuLEY2BXg
         lBNU5HgLCvaa9Ml/ORkXg2xzr7W2hKTFl51t1PdSU6yRyesyU6xc1fgnuINKA9O7pZUy
         JYiId1UMDONjG9ouC1gNmJj629PHBXMFTAEP5NGWn+35jrE+gVAXWHVl9U5/ev2nt7nN
         vY5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787560182; x=1788164982;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aALTdzmz9gKwaB19EuKx9/YeS53HDdRQXdxNvRw3dlY=;
        b=cUPsu1n+ZWxWoVUwvkG6dYYJeek7DTKtY0QhagkUzh+8y+5UWAa5XoN15sk4GT8xLM
         PTNTFTtUX768piG6DT5ZFRktOa8wOodcw9H8u33W476ziURuGeC+3WKe3z4k0EtMOC39
         6QN1uickNDEyKeDXdDZlwF2QRxhQkN06kMntSE/RUqz0kcymG0FfRWZKDmozal3oelMJ
         PZfGfojyoX+ePt3LsjikJYuTIoZYn8zYaKZLl5Ew6EPd+KLtKrXaNIVZsflHZGB+yq3z
         +tr0pOSNzC4N/RuahyS8CuBvS6LohhjKz8DiknXwZar8RVuYbJgRU0sgAQcDw9dgVNP4
         us/A==
X-Forwarded-Encrypted: i=1; AHgh+RqAXCxMzkLsjUeNLeRh1z7KbcfS60rgDMwI9lO5dUS69NlQzo6el6giDNvClp5K3GRaEBhvxdijxBKfY/6M@vger.kernel.org
X-Gm-Message-State: AFuF++nofZwYDi/83y7YO/rBlI0D6GnFHI2TOPY/3iroQBdBrdbT0j21
	ofBIzux42D6lkcb4+1lysIXM8MYBbKx5bNVOZAbWOkUiEADpn2dDJD8ahHGRhWdb3TeKKRlxiph
	DOJlrAwKLGfCVw32rgCl42YVHWQMIIaA=
X-Gm-Gg: AR+sD13kqYSzPQDQC8osXhfFXJ88cVm9xv05zIFtFbNctwu+N5QD9DyxJyyAINSpSj/
	FBHmJoFq6oiR37X8huUydy+FXyB+xUiB6nKFXGxXVxAAtDLK99GDPmyL8Piff+PP1P06NyJDN+b
	WX3KWwXwVBqZ3aUQXOz8P61G7J3+IE8REZhwn6OsgRbqmfswke33XiIgH4Li3wHjh/7kurmrn+E
	pqwBMyrxYRq81hRecCLiAaBYgpHLAgwssUpUE8Nn9Sw1KQvYAlOjCanaNJsV7tuumxHkH999rU5
	EXjTeQOVstMX5cYq4LKGSS12zIgEWX+PO8EqKHO6zg7RbE1E4P67yXBF
X-Received: by 2002:a05:6402:3705:b0:698:8847:e2f8 with SMTP id
 4fb4d7f45d1cf-6a582ba7883mr21209458a12.15.1787560181240; Mon, 24 Aug 2026
 01:29:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026082150-autograph-perky-e3cb@gregkh> <20260823224256.2724025-1-fahad@codepure.com>
In-Reply-To: <20260823224256.2724025-1-fahad@codepure.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 24 Aug 2026 10:29:29 +0200
X-Gm-Features: AcwNN1VD_X4ximi1X3FI38PlUOe0IPBjOfOJ1uzEdCVUoK9JrYNcnDYMBpPZyx0
Message-ID: <CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com>
Subject: Re: ovl_copy_xattr() can write uninitialised heap into the upper
 file's xattr
To: Fahad Alharbi <fahad@codepure.com>
Cc: security@kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	overlayfs <linux-unionfs@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 12:44=E2=80=AFAM Fahad Alharbi <fahad@codepure.com>=
 wrote:
>
> Everything below is now measured on mainline.  My earlier mails in this t=
hread
> carried v6.12.101 numbers and I had not run a mainline kernel; that is fi=
xed,
> and the 6.12 figures are withdrawn in favour of the ones here.
>
> Summary: on v7.2-rc6 an unprivileged user leaks kernel pointers out of
> ovl_copy_xattr(), 5 of 5 boots, and the patch below stops it, 0 of 5.
>
> The bug
> -------
>
> fs/overlayfs/copy_up.c, ovl_copy_xattr(), per xattr name:
>
>         retry:
>                 size =3D ovl_do_getxattr(oldpath, name, value, value_size=
);
>                 if (size =3D=3D -ERANGE)
>                         size =3D ovl_do_getxattr(oldpath, name, NULL, 0);
>
>                 if (size < 0) { error =3D size; break; }
>
>                 if (size > value_size) {
>                         ... kvmalloc(size) ...; value_size =3D size; goto=
 retry;
>                 }
>
>                 error =3D ovl_do_setxattr(OVL_FS(sb), new, name, value, s=
ize, 0);
>
> The second call passes NULL/0, so it reports the size without writing any=
thing
> into `value`.  If the value shrank between the two calls so that the new =
size
> fits the existing buffer, "size > value_size" is false, the reallocation =
is
> skipped, and ovl_do_setxattr() is handed `size` bytes of a buffer that wa=
s
> never filled for this name.  The allocation is kvmalloc(), not kvzalloc()=
.
>
> Those bytes are persisted as an xattr on the upper file and read back by =
the
> caller.
>
> Measured on v7.2-rc6 (075b74841bd0)
> -----------------------------------
>
> Unprivileged: uid 1000, CapInh/CapPrm/CapEff all zero (CapBnd is the full=
 set
> inherited from init, which grants nothing without Prm/Eff), exactly one
> unshare(CLONE_NEWUSER|CLONE_NEWNS) since ovl_fs_type has FS_USERNS_MOUNT.=
  The
> lower filesystem is tmpfs.  No FUSE: /dev/fuse is 0600 on this image, so =
it
> could not be used even accidentally.  One fresh disposable VM per boot.
>
>                                   boots leaked   pooled            with a=
 kptr
>         unpatched                 5 of 5         122 of 5,000,000  121
>         patched                   0 of 5         0 of 5,000,000    0
>         unpatched, racer disabled 0 of 4         0 of 4,000,000    0
>
> The third row is the control: the leak needs the race, and the detector h=
as no
> false positives.  Cost to an attacker is about 51 s of racing per leaked =
value
> at ~9,100 copy-ups/s.
>
> A representative line, verbatim:
>
>         [poc] uid=3D1000 euid=3D1000 N=3D32 delta=3D8 trials=3D1000000 mo=
de=3Dr
>         [poc] RESULT mode=3Dr N=3D32 delta=3D8 : 23 of 1000000 copy-ups l=
eaked
>               (kptr-bearing 23)  [109.5s, 9129/s]
>         [poc] VERDICT: LEAK OBSERVED
>
> What comes out
> --------------
>
> With a slab groom, 32 of 32 trials disclosed at least one kernel pointer,=
 and
> 31 of 32 disclosed the caller's own struct cred address; 129 pointers acr=
oss
> 3,072 disclosed bytes.  One trial landed on a different object and return=
ed a
> .text pointer, ffffffff8142713e, which defeats KASLR.  SLAB_FREELIST_RAND=
OM
> and SLAB_FREELIST_HARDENED were both on.  Example:
>
>         [t00] len=3D96 nz=3D40 kptrs=3D4 create@68 cred@40=3Dffff888102a8=
d240
>               kptrs: +24=3Dffff88810535e140 +32=3Dffff8881019cfdc0
>                      +40=3Dffff888102a8d240 +48=3Dffff88810247be70
>
> Without a groom the same leak returns recycled heap rather than pointers =
-- in
> one 4096-byte sample the overlay's own mount-option string, a path, users=
pace
> stack addresses and a canary-shaped qword, but no kernel pointer.  I ment=
ion
> that so the pointer figures are not read as unconditional: the groom is w=
hat
> makes it a pointer leak.
>
> One caveat on those two paragraphs: they were produced by the determinist=
ic
> FUSE probe, which needs /dev/fuse and therefore ran as root.  They establ=
ish
> what the kernel discloses.  The unprivileged reachability is the tmpfs ta=
ble
> above, where 121 of 122 leaks were also kptr-bearing.
>
> Still present in mainline
> -------------------------
>
> ovl_copy_xattr() is byte-identical at origin/master (66fb95a52111,
> 2026-08-22), v7.2-rc6, v6.12.101 and v6.12.104 -- same sha256 of the
> extracted function.
> git log -L :ovl_copy_xattr:fs/overlayfs/copy_up.c returns 16 commits ever=
, the
> newest a 2024 LSM return-value refactor; no commit has ever added zeroing=
, a
> bound, or a re-read.  Introduced by e4ad29fa0d22 ("ovl: use a minimal buf=
fer
> in ovl_copy_xattr", v4.5), confirmed by content since v4.4 has no value_s=
ize.
> Nothing overlayfs-related is in the stable queues.
>
> The patch
> ---------
>
> Built and booted on v7.2-rc6.  Both kernels use byte-identical configs, s=
o the
> only variable is this hunk; I confirmed the change is in the binary
> (objdump shows cmp $0x4 and mov $0xfffffff5 in the patched copy_up.o, abs=
ent
> from the unpatched one) rather than trusting the build.
>
>   - Leak: 0 of 5,000,000 copy-ups, 0 of 5 boots, against 122 of 5,000,000
>     unpatched.
>   - Functional: 51 of 51 xattr byte-compares identical to the unpatched
>     kernel, 17 sizes from 0 to 65536 in three orderings, with the
>     legitimate -ERANGE growth path exercised and no -EAGAIN.
>   - Termination: the probe that failed to terminate on three earlier atte=
mpts
>     of mine now returns in 0.100 s after 5 sized GETXATTRs, exactly
>     1 + OVL_COPY_XATTR_MAX_RETRY.
>   - -EAGAIN was never reached in normal operation: EAGAIN=3D0 on all 10
>     unprivileged boots.
>   - No BUG, WARNING, oops, lockup or stall in any boot.
>
> Four things about the patch you should have rather than find
> ------------------------------------------------------------
>
> 1. It does not fix the growth path.  The "size > value_size" branch still=
 does
>    goto retry with no counter.  It is bounded -- value_size increases
>    strictly, and fuse_getxattr() clamps a size query with
>    min_t(size_t, outarg.size, XATTR_SIZE_MAX) (fs/fuse/xattr.c) -- so it
>    cannot loop forever, but a hostile lower fs can still force up to ~65,=
535
>    kvmalloc/kvfree plus getxattr round-trips for a single name.  Measured=
 with
>    an ever-increasing size: unpatched 65,536 calls / 7.815 s, patched 65,=
540 /
>    7.810 s.  Pre-existing and unchanged by this patch; my patch costs fou=
r
>    extra iterations there.  I raise it because it is reachable today.
>
> 2. I suggested kvzalloc() in my first mail and did not take that route.
>    kvzalloc() would stop the disclosure in one word, and if you want the
>    minimal fix that is the one to take.  I went further because the shrin=
k
>    case is also a correctness bug independent of the leak: the upper file
>    still ends up with bytes that are not the lower file's xattr value --
>    zeros instead of heap.  Re-reading writes the right value.  If you wou=
ld
>    rather have the one-word change, or want both (kvzalloc as a belt-and-
>    braces plus the re-read), say which and I will send it.
>
> 3. -EAGAIN is a new errno for overlayfs; git grep EAGAIN fs/overlayfs was
>    empty before this.  No kernel caller of copy-up retries on it, but
>    userspace conventionally does, and overlayfs already uses -EIO a few l=
ines above for
>    "the underlying fs is broken".  If you would prefer -EIO, say so and I=
 will
>    resend.
>
> 4. This is my fourth attempt.  Three earlier versions failed to terminate=
; one
>    had no progress measure and two grew value_size on every -ERANGE on th=
e
>    assumption that XATTR_SIZE_MAX bounded it, which is wrong for this pat=
h
>    because ovl_do_getxattr() -> vfs_getxattr() passes the caller's buffer=
 size
>    to __vfs_getxattr() unbounded.  I did not send any of those, and this
>    version counts rather than relying on an implicit bound.
>
> Reproducers and logs
> --------------------
>
> I have three reproducers -- the unprivileged tmpfs racer, a deterministic=
 FUSE
> probe with eight attack modes, and a functional-regression harness -- plu=
s the
> unedited console logs for every run quoted above.  Per security-bugs.rst =
I am
> not pasting the reproducer here, since this thread will be posted publicl=
y;
> say the word and I will send any or all of it, in whatever form you prefe=
r.
>
> I have not Cced linux-unionfs or LKML, since this is still on
> security@kernel.org.  If you would rather handle it in the open, say so a=
nd I
> will repost there.

Fahad,

I usually don't CC public lists for private emails, but since you offered i=
t,
I will reply on the list.

First some ethics w.r.t LLM driver patches:
(1) The Linux kernel generally does not consider LLM detected security issu=
es
for security embargoes.
I won't fault you if your conscience tells you that you need to post privat=
ely
first for a very severe security bug, but other maintainers may be less tol=
erant
so keep that in mind.
(2) You are writing to HUMANS not to machines. This report is way too long
and a human would spend way too long before realizing this is worth their
effort or not. Please use some of your token to produce a clear human reada=
ble
TDLR the next time you post LLM driven patches and honestly, I am sure that
the report itself could have been much shorter if you read it and tried to
make it fit a human reader who is a volunteer with limited time.
(3) Please make sure that LLM reads overlayfs.rst before proposing patches

Regarding the patch itself, if you follow rule #3 above you will find
this paragraph:

Changes to underlying filesystems
---------------------------------

Changes to the underlying filesystems while part of a mounted overlay
filesystem are not allowed.  If the underlying filesystem is changed,
the behavior of the overlay is undefined, though it will not result in
a crash or deadlock.

What this tells you is that your EAGAIN retry loop is the wrong approach -
We do not try to cope with changes to underlying layers - we detect them
and abort with EIO, something like that should be enough:

    size =3D ovl_do_getxattr(oldpath, name, value, value_size);
    if (size =3D=3D -ERANGE) {
        size =3D ovl_do_getxattr(oldpath, name, NULL, 0);
        if (size >=3D 0 && size <=3D value_size) {
            error =3D -EIO;
            break;
        }
    }

The next time you post please do it on the list and please make it concise.

Thanks,
Amir.

>
> -- 8< --------------------------------------------------------------- 8< =
--
>
> From: Fahad Alharbi <fahad@codepure.com>
> Subject: [PATCH] ovl: don't copy an xattr the buffer was never filled wit=
h
>
> ovl_copy_xattr() sizes and fills one reusable buffer per xattr name:
>
>         size =3D ovl_do_getxattr(oldpath, name, value, value_size);
>         if (size =3D=3D -ERANGE)
>                 size =3D ovl_do_getxattr(oldpath, name, NULL, 0);
>
> The second call passes NULL/0, so it reports the current size without
> writing anything into `value`.  When the value grew (giving -ERANGE) and
> then shrank again before the sizing call, the reported size can be less
> than or equal to value_size.  The "size > value_size" reallocation path
> is then skipped and the code falls through to
>
>         error =3D ovl_do_setxattr(OVL_FS(sb), new, name, value, size, 0);
>
> writing `size` bytes out of a buffer that was never filled for this name.
>
> For the first name that is uninitialised kvmalloc() memory (the buffer is
> kvmalloc(), not kvzalloc()); for later names it is the value of a
> previously copied xattr of the same file, which the caller may not have
> permission to read.  Either way the bytes are persisted as an xattr on
> the upper file and can be read back by an unprivileged user.  Measured on
> an unmodified 6.12.101 as uid 1000 with no capabilities and one user
> namespace, with a tmpfs lower and a second thread changing the value
> size: 624 of 2,000,000 copy-ups leaked over 20 cold boots, and 397 of
> those carried a kernel pointer.  A hostile FUSE lower makes it
> deterministic and much larger: one chmod() over 4096 xattr names returned
> 819,200 bytes of kernel memory on that same kernel.
>
> Re-read the value when the buffer was not filled for this name.  A lower
> filesystem that keeps changing the size could make that repeat, so bound
> the number of re-reads: only a racing or hostile lower fs reaches the
> retry at all, and a well-behaved one needs none.  The counter is per
> name, so a well-behaved name never spends another name's budget, and the
> abort happens before ovl_do_setxattr(), so the failure mode is a failed
> copy-up and never a partial or leaking one.
>
> Note this does not fix the pre-existing "size > value_size" growth path,
> which still does an uncounted goto retry; against a lower that reports an
> ever-increasing size that path runs to XATTR_SIZE_MAX iterations today,
> bounded only by the lower filesystem (fuse_getxattr() clamps a size query
> to XATTR_SIZE_MAX), not by ovl_copy_xattr().  This patch adds four
> iterations to that worst case and does not otherwise change it.
>
> Testing was done on v6.12.101, both a KASAN + SLUB_DEBUG_ON build and an
> uninstrumented one, in disposable VMs; I have not run a mainline kernel.
> ovl_copy_xattr() is byte-identical between v6.12.101 and v7.2-rc6, and
> the patched function is byte-identical to the one that was built and
> tested.
>
> Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Fahad Alharbi <fahad@codepure.com>
> ---
>  fs/overlayfs/copy_up.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index e963701b4c87..6a78dfbf6eb7 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -72,12 +72,20 @@ static int ovl_copy_acl(struct ovl_fs *ofs, const str=
uct path *path,
>         return err;
>  }
>
> +/*
> + * Bound on re-reads of a single xattr whose size changed under us.  Onl=
y a
> + * racing or hostile lower filesystem can reach it; a well-behaved one n=
eeds
> + * none.
> + */
> +#define OVL_COPY_XATTR_MAX_RETRY 4
> +
>  int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, s=
truct dentry *new)
>  {
>         struct dentry *old =3D oldpath->dentry;
>         ssize_t list_size, size, value_size =3D 0;
>         char *buf, *name, *value =3D NULL;
>         int error =3D 0;
> +       int retries;
>         size_t slen;
>
>         if (!old->d_inode->i_op->listxattr || !new->d_inode->i_op->listxa=
ttr)
> @@ -129,10 +137,32 @@ int ovl_copy_xattr(struct super_block *sb, const st=
ruct path *oldpath, struct de
>                         break;
>                 }
>
> +               retries =3D 0;
>  retry:
>                 size =3D ovl_do_getxattr(oldpath, name, value, value_size=
);
> -               if (size =3D=3D -ERANGE)
> +               if (size =3D=3D -ERANGE) {
>                         size =3D ovl_do_getxattr(oldpath, name, NULL, 0);
> +                       if (size >=3D 0 && size <=3D value_size) {
> +                               /*
> +                                * The sizing call above reports the leng=
th but
> +                                * does not fill the buffer.  Reaching he=
re means
> +                                * the value shrank after the -ERANGE, so=
 it now
> +                                * fits and the reallocation below is ski=
pped --
> +                                * which would hand ovl_do_setxattr() byt=
es that
> +                                * were never written for this name.  Re-=
read it.
> +                                *
> +                                * A lower filesystem that keeps changing=
 the
> +                                * size could make that repeat forever, s=
o bound
> +                                * it: this only triggers on a racing or =
hostile
> +                                * lower fs, never in the steady state.
> +                                */
> +                               if (++retries > OVL_COPY_XATTR_MAX_RETRY)=
 {
> +                                       error =3D -EAGAIN;
> +                                       break;
> +                               }
> +                               goto retry;
> +                       }
> +               }
>
>                 if (size < 0) {
>                         error =3D size;
> --
> 2.43.0
>
