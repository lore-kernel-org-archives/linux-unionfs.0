Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186882E22BD
	for <linux-unionfs@vger.kernel.org>; Mon, 11 May 2026 20:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778532881; cv=pass; b=luPaUOxJHIbaTYiVfL8l1HJ5j1LdcLg5kf3b3my4v09nJIQgsT1uXkmSL+jdkC6H0kqTiEr9bH7PjuMwQbnT1gsr5lcixs6QeWPTE2ZcsCvA0dORZhN/x6jvBsgD7idj1o0M0MFYeVg24qrLoawGDMv3jBAI2yfhyn/t6gIktDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778532881; c=relaxed/simple;
	bh=QuY2STuJL3aNnFDJ9qVJfllim/W8KT7FW60LYM8hqIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zvb2O4dYZnnwzcJTY0qyCjWGo7fMFmbSGaTGhXIghhR1PYr3fB7VxxzaT9xxVGisurlUs/1WUKxI3XQxZwrWHXA2jKGXEl7+xBXWZVU9J/r+/GlS6VTs8qF8RygzmvT1w6asxno9qHdeR7+qOfYnOALgKe90ml7/SvzKpOOXXBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jt2d566W; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jt2d566W"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67b6da5a618so6677420a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 11 May 2026 13:54:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778532878; cv=none;
        d=google.com; s=arc-20240605;
        b=PHcpeUAqvzvCFSbqwVWB4YaRMC1GOrzfHMTCC2Q7L2bhsFV95FNYKjjt615SxRDq1v
         lvChOWwGQfH/X2g+0wXajYFJBzzt0P/7/SXo6t+YXRSJcrjSczlqrAk/QWMmcpCjCYkM
         KcXI2O2niWZ2F0hi65QIlEXY4QIb2Ebqa+Q9eYllx6OqnLRtCAlJ8E+AvpA/iOSB5HAV
         JvdGmD7ZXa0x0e2lV5P5f3qBrTCfCC18ts7fy3xHCn9KISflWFgiRjapcHHNahOHM9I+
         7jZlWYJMdqrEZbfumJOTv25jpouW61Ug1AMEuynkpQCTtt5WVSdsg7lHMj4JtmWD28qj
         bjDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vbGxWhCGo6MT9gx6YLsYVcFjvVG3ClWUZ4M2dJPCwuA=;
        fh=9ZVkmOWYxB6Sw5Se1KSfRd6OfJZ9lZUMvxAi+fUcS6k=;
        b=H8MBht9vs42kIXumW7bZb0rZPihBSZIqs1FWWWkOEpdThcPLSOtl0iFds4mlNRq0dY
         fmCqkng8WWdW+Q1Ed9vqJQ4d1oyTgXOuHmKz2gBQOf+EbFxgl/CvfRTuGTL4ML9aXfeB
         divcydL2Zx1l6HcijOU1q9K/gUeKHZYv/JyFdk8dIxopUE9bR9l4fuOC/CS3ggasoAUk
         2w9Ht/YIfriXOOw0nHY5sMtNbMw14F7X/9T0fZKsscjcqYdRTdwi4oFV4J+d85GWq7wQ
         N9my5hM48xX/xGUTIGCJ3LayZfB09AzfkMj8shgZA18+fmDUjmfCD2B3asm6HeGsdO/v
         50IQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778532878; x=1779137678; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vbGxWhCGo6MT9gx6YLsYVcFjvVG3ClWUZ4M2dJPCwuA=;
        b=Jt2d566WvXZJBaSdD2QmX77B8lmjc7/sXXxv1HN7eLWhzieChT27vmp3QkpqO6mtCT
         oFIoNU715sKtCTkNMAFsss/XAgHC01IMTqRrtriKWlMuQJc7bIh/FxlnoOwewdLCL/qQ
         iGruEzby5uOOyfCuXhJmLrr+Jqf/l2MHppnAEjkA03LvoziUA72XrR41PIC9LdZvTTdD
         7GDSCQNu/K1DVccoalvRgexpOB+R++q1+9O1lX7xXGBx5OYkiso7P4kKVd5vIPjs8OE+
         bheB0Xnl2iAIZXCeL+nupcvvy9Z/GXpgToqWp2CPy7ZWKFSOd1RZgkDH29Qf6LT6kPDs
         zGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778532878; x=1779137678;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbGxWhCGo6MT9gx6YLsYVcFjvVG3ClWUZ4M2dJPCwuA=;
        b=sWA96kYOxtU0sjzO1nDwGzB89oPuPRBKqEEt6Uy9jl/2QZLqTngCf61xxh/xTXOnH6
         5fwgv1R8Sl90ZJZ5nwfJEwVTYsdD57LAiVtsw72QAo53VG+sRxUAlZwKo+50yn9tgDW+
         QqKZKiPvOFcsRdow9EwPs42XjfRrDp2jPNmQ0OtXEP4TL1yd7dXDLT9DbdJhyKisEsQe
         abO5B2N0XKUrjD9K6oZP/VBPmXe3+nNyNigEhIxUhYpP7KAIvZWSIK8euBcsyEx/7Ln8
         P2JlFsn7yS9lnwjbqxX69mDrfQ39QdOfPztR65A9AZvcrxnYX+UisAW/H1GkIJ4STi+o
         HDQA==
X-Forwarded-Encrypted: i=1; AFNElJ94qfH2R/gMtPmp8CDVSuwFFk7ChQdOXir8K8AxvUzOSCfE2J/9fH1gPQYKeJZexQv+7xRnf496y42PncCU@vger.kernel.org
X-Gm-Message-State: AOJu0Yww7rCHWBbraG+U0OW7p6HnOi1JskXmr5MB/x5xpvjJaIQQn4/h
	PLwSh9AHBf4OIPszDBl4CwVsTbL40/Byr5qdcTyhSUIN3Iamsjo5+E94nC3nEaqr1rQTq7DUjdB
	DwAtYx87yuENY7LJjwHqQG3KoRZaMJfk=
X-Gm-Gg: Acq92OGARiLgvk3AXdpUgPwpi/Znga8TpYo/PDfC9xPvu25smvCXvBJ7lYL9+pql/2r
	QmdCevblV4AAInqtQdj7uE+z6Y8KkRZfnylW2iAAXhamGzJ1ejvbwcuNNJB5q/OHhBgoLmZOTzq
	aqXQmFX1FBwbjKbfzerAKEz6ZYWatvvY4GSwKRpDfmCccbeoipVh5MzhVddTCQLxGXjOz5ziD3E
	KGS29H6w8a895BF7kq3qabUA9V3Ifpr4yO6iTV38qvJw0FgMmdJOBh4IYNChGnn08YGtr0DchI1
	SVZrlKYyFOQ/kd9EqKhyMuSVnkqjTooSw1/7EEvk
X-Received: by 2002:a05:6402:5288:b0:67e:43a7:1764 with SMTP id
 4fb4d7f45d1cf-67f716e0b40mr5688118a12.26.1778532878285; Mon, 11 May 2026
 13:54:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260511062057.2365769-1-nirmoyd@nvidia.com>
In-Reply-To: <20260511062057.2365769-1-nirmoyd@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 11 May 2026 22:54:26 +0200
X-Gm-Features: AVHnY4KPVjR_K_-AdPTCXrgCLyHhB-t0Bn6vkKXWQXlfqlSBmI9va-U-4UMo2D0
Message-ID: <CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep merged and impure readdir caches separate
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
Content-Type: multipart/mixed; boundary="0000000000006ee545065190f4b6"

--0000000000006ee545065190f4b6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nirmoy,

Thanks for the patch.

On Mon, May 11, 2026 at 8:21=E2=80=AFAM Nirmoy Das <nirmoyd@nvidia.com> wro=
te:
>
> Overlayfs uses one inode cache slot for two readdir cache users with
> different lifetime rules. Merged directory iteration pins the cache from
> open directory files with cache->refcount. Impure real-directory iteratio=
n
> uses the inode cache as an unrefcounted lookup table.
>
> Those caches cannot be reused interchangeably. If merged iteration finds
> an impure cache in the inode slot, it can pin and seek through a cache
> that was not built for merged iteration. If impure iteration finds a merg=
ed
> cache, it can walk an object whose lifetime is controlled by open directo=
ry
> files. Either direction can leave ovl_iterate() using stale cache entries=
.
>
> Add ovl_dir_cache_drop() to detach the inode cache before freeing it. Kee=
p
> refcounted merged caches alive until ovl_cache_put(), stop publishing new
> merged caches through the inode slot,

This is unacceptable - invalidating merged dir cache to paper over
another root bug, which was not really fixed.

> and let impure iteration reuse only
> unrefcounted caches.

All those guards are nice, but how does a directory inode change from
being merged to impure or vice versa?
This should never happen.

It took a lot of arguing with Sonnet about wrong leads to find the real bug=
.

Real bug was introduced by:
b79e05aaa1667 ("ovl: no direct iteration for dir with origin xattr")

It changed the test from:

od->is_real =3D !OVL_TYPE_MERGE(type);
od->is_upper =3D OVL_TYPE_UPPER(type);

to:

od->is_real =3D !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
od->is_upper =3D OVL_TYPE_UPPER(type);

But there is a race window in copy up of a directory where
upper is set and published before the OVL_WHITEOUTS flag
is set.

an opendir() observing this state inside the race window will
wrongly start to iterate_real and another opendir later will
observe the flag and start iterate_merged - boom!

Attached is what I think is a correct fix.
WDYT?

Thanks,
Amir.

--0000000000006ee545065190f4b6
Content-Type: application/x-patch; 
	name="0001-ovl-fix-race-between-copy-up-and-open-of-a-directory.patch"
Content-Disposition: attachment; 
	filename="0001-ovl-fix-race-between-copy-up-and-open-of-a-directory.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mp1nqg2r0>
X-Attachment-Id: f_mp1nqg2r0

RnJvbSA5NGQ3NTk0OGNlYjcwZDVkYzQ5ZTkxODdhNzQyYjlhMmU0MmMzM2MwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBNb24sIDExIE1heSAyMDI2IDIyOjI1OjE4ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBmaXggcmFjZSBiZXR3ZWVuIGNvcHktdXAgYW5kIG9wZW4gb2YgYSBkaXJlY3RvcnkKCkNvbW1p
dCBiNzllMDVhYWExNjYgKCJvdmw6IG5vIGRpcmVjdCBpdGVyYXRpb24gZm9yIGRpciB3aXRoIG9y
aWdpbiB4YXR0ciIpCnJlcGxhY2VkIHRoZSBzdHJ1Y3R1cmFsIE9WTF9UWVBFX01FUkdFIGNoZWNr
IGluIG9kLT5pc19yZWFsIHdpdGggdGhlCk9WTF9XSElURU9VVFMgZmxhZywgYnV0IHNldCB0aGF0
IGZsYWcgYWZ0ZXIgb3ZsX2lub2RlX3VwZGF0ZSgpIHB1Ymxpc2hlZAp0aGUgdXBwZXIgZGVudHJ5
IHZpYSBzbXBfd21iKCkuICBBIGNvbmN1cnJlbnQgb3BlbigpIHRoYXQgb2JzZXJ2ZXMKX191cHBl
cmRlbnRyeSB2aWEgdGhlIHNtcF9ybWIgcGFpciBtYXkgbm90IHlldCBzZWUgT1ZMX1dISVRFT1VU
UyBhbmQKZ2V0cyBvZC0+aXNfcmVhbD10cnVlIG9uIHdoYXQgaXMgbm93IGEgbWVyZ2VkIGRpcmVj
dG9yeS4KClRoYXQgc3RhbGUgb2QtPmlzX3JlYWwgY2F1c2VzIGEgc3Vic2VxdWVudCBnZXRkZW50
cygpIHRvIGNhbGwKb3ZsX2NhY2hlX2dldF9pbXB1cmUoKSwgd2hpY2ggZnJlZXMgdGhlIG1lcmdl
ZCByZWZjb3VudGVkIGNhY2hlIHN0b3JlZApieSBhbm90aGVyIGZkLCByZXN1bHRpbmcgaW4gYSB1
c2UtYWZ0ZXItZnJlZS4KCk1vdmUgdGhlIGZsYWcgc2V0IGludG8gb3ZsX2lub2RlX3VwZGF0ZSgp
IGJlZm9yZSB0aGUgc21wX3dtYigpIHRvIGNsb3NlCnRoZSByYWNlIHdpbmRvdy4KCkZpeGVzOiBi
NzllMDVhYWExNjYgKCJvdmw6IG5vIGRpcmVjdCBpdGVyYXRpb24gZm9yIGRpciB3aXRoIG9yaWdp
biB4YXR0ciIpClJlcG9ydGVkLWJ5OiBzeXpib3QrYTE2ZmIwY2NlMzI5YTMyMDY2MWNAc3l6a2Fs
bGVyLmFwcHNwb3RtYWlsLmNvbQpDbG9zZXM6IGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29t
L2J1Zz9leHRpZD1hMTZmYjBjY2UzMjlhMzIwNjYxYwpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRz
dGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgotLS0KIGZzL292ZXJsYXlmcy9jb3B5X3VwLmMgfCAy
IC0tCiBmcy9vdmVybGF5ZnMvdXRpbC5jICAgIHwgOSArKysrKysrKysKIDIgZmlsZXMgY2hhbmdl
ZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL292ZXJs
YXlmcy9jb3B5X3VwLmMgYi9mcy9vdmVybGF5ZnMvY29weV91cC5jCmluZGV4IDEzY2I2MGI1MmJk
NmUuLmY2MTJjZWFiMzBhZjkgMTAwNjQ0Ci0tLSBhL2ZzL292ZXJsYXlmcy9jb3B5X3VwLmMKKysr
IGIvZnMvb3ZlcmxheWZzL2NvcHlfdXAuYwpAQCAtODM1LDggKzgzNSw2IEBAIHN0YXRpYyBpbnQg
b3ZsX2NvcHlfdXBfd29ya2RpcihzdHJ1Y3Qgb3ZsX2NvcHlfdXBfY3R4ICpjKQogCWlmICghYy0+
bWV0YWNvcHkpCiAJCW92bF9zZXRfdXBwZXJkYXRhKGlub2RlKTsKIAlvdmxfaW5vZGVfdXBkYXRl
KGlub2RlLCB0ZW1wKTsKLQlpZiAoU19JU0RJUihpbm9kZS0+aV9tb2RlKSkKLQkJb3ZsX3NldF9m
bGFnKE9WTF9XSElURU9VVFMsIGlub2RlKTsKIG91dDoKIAlvdmxfZW5kX3dyaXRlKGMtPmRlbnRy
eSk7CiAKZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy91dGlsLmMgYi9mcy9vdmVybGF5ZnMvdXRp
bC5jCmluZGV4IDdiODZhNmJhYzY0NDkuLjdjZDMyMDFhZTc0OTcgMTAwNjQ0Ci0tLSBhL2ZzL292
ZXJsYXlmcy91dGlsLmMKKysrIGIvZnMvb3ZlcmxheWZzL3V0aWwuYwpAQCAtNTk1LDYgKzU5NSwx
NSBAQCB2b2lkIG92bF9pbm9kZV91cGRhdGUoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGRl
bnRyeSAqdXBwZXJkZW50cnkpCiAKIAlXQVJOX09OKE9WTF9JKGlub2RlKS0+X191cHBlcmRlbnRy
eSk7CiAKKwkvKgorCSAqIEZvciBhIGRpcmVjdG9yeSBiZWluZyBjb3BpZWQgdXAsIHNldCBPVkxf
V0hJVEVPVVRTIGJlZm9yZSBwdWJsaXNoaW5nCisJICogdGhlIHVwcGVyIGRlbnRyeSwgc28gYSBj
b25jdXJyZW50IG9wZW4oKSB0aGF0IG9ic2VydmVzIF9fdXBwZXJkZW50cnkKKwkgKiB2aWEgdGhl
IHNtcF93bWIvcm1iIHBhaXIgaXMgZ3VhcmFudGVlZCB0byBhbHNvIG9ic2VydmUgT1ZMX1dISVRF
T1VUUworCSAqIGFuZCBvdmxfZGlyX2lzX3JlYWwoKSByZXR1cm5zIGZhbHNlLgorCSAqLworCWlm
IChTX0lTRElSKGlub2RlLT5pX21vZGUpKQorCQlvdmxfc2V0X2ZsYWcoT1ZMX1dISVRFT1VUUywg
aW5vZGUpOworCiAJLyoKIAkgKiBNYWtlIHN1cmUgdXBwZXJkZW50cnkgaXMgY29uc2lzdGVudCBi
ZWZvcmUgbWFraW5nIGl0IHZpc2libGUKIAkgKi8KLS0gCjIuNTQuMAoK
--0000000000006ee545065190f4b6--
