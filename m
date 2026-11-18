Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794998270;
	b=lNgRAynf6ROoLqwBnNGlvaQ7nYxeOI++GefnYxuMF6MK5PXOrxQpZIGoS3pO2lJO/P22
	 JbMBhHPIHV6Tv+224NMVBBqoIXtQvGJW8J5qJTuOTcNWcLcqa/dVjEzegUmoW4LqBpRHb
	 xdmj43LVz3SzKFTWY5FGnLFES+4btI61EMw10X7BPTgMSmlkuiiTk76AuO42cp+2Qsq3/
	 UyobrP8kAIRVV6UhQF1YcS7AvrUeRljIwf6155tV5JUazAMpngHQg1rVlGv9+o8oioWAF
	 S7tYzWLLBS7pb5p5C6kZZtjGPC92ogj/FhQH+o+yaOFiWZtqoZTSGzxLog+sdSTyIqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998270;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=jfBqG2kKo0nT2ILNCvBc41zfj1MBfIB9+pQTxNPopsE=;
	b=A5kwQ89qAbJz6oPdLruro7HXxb8yqVqVKw0YkuJWNVYMvaRUxFMbNW7E5adUDV31aczp
	 B/K+FCFzBtwvOFd1f2CHXSSg4WsUQ/YseYDRw4Uk6pxN5++agUj6npDoCb5Ew1ksfmgnB
	 Y3lNehd0bvW+OwS2HqvJf8Tc+0hr7wDM5Ospc2ewmytrJQccr0JK6OWVXwCcVnWKvwVgQ
	 N3pmPHjB6Vqx78RAvv4s8sxao73de8DWIMPREVxjJ49Btta+Aoxn1slGlA/o508rCTrRi
	 GaamkyoFQQY6L/nTz8Q3USfo6vDXuiQ2lZzZL8iaEGzl1pPLR7yb5mKrfqfEzKJk/Tw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u7puCFIa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8A606A32C
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 10:37:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52A8A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u7puCFIa
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso1088387a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 02:37:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794998269; cv=none;
        d=google.com; s=arc-20260327;
        b=GPbRbJFKhaIpA45cHBOb6c0Z1ttGKcnsHZV11D4VhnvEriceucPQzYjB084/Yb4ekG
         z1Nk6UQE2kPiSHbs3ZjMXsNCIwKN+6ULaw0Xpr0QiJ5wXqCUxwjdvKRyAlk77E6Q+fg4
         FcO3gZNfM03MGpkghS2ywqBnBL0XqaJoKp6zozQblLm64SYYAG9rlRlXqSv/gd75uvo+
         FELackVxqxsqAHRlz0hCCzPtZ40ygWEf3ykthB8m5xZTMkRnW4a1tdn4nYgGBCj8g5pG
         KUsbrv41bZlhLqduEAQ2rRlHHcgn3hIn2SRSOpJL52H/hATVx8+A9tkpZc1Tq3jsG74u
         X7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jfBqG2kKo0nT2ILNCvBc41zfj1MBfIB9+pQTxNPopsE=;
        fh=ni8vWdhX17FseOOaHHdUmFwH/Hc808JlcNtcVWivxrc=;
        b=Fn3QxX8mKyN3rMQHS+hNiiO/8FKlH56g2YbWwvHZuk2N9CJeL0lQWv9fDLoA3uJ+bV
         MQSr0B18ehR55wvhEbBh92WqWogcpOBjjs3n8I55OQLNNW+BDNIeoC9ntHMq4QZz51d+
         rod2YLPkxuwswz2uInZl4KdG5T0fGKBhmhymDUzkXlUDX4mbHADJch9qE8byF1r1w+P1
         HdtHfow+znREKlgIkHPW3KhF9nM80HhKeGLfjzJhGl8GA0Lb5TlMQUgr7k17Hkgy0oqd
         tL/AAf4nKG3oj1q9O6vASiAkaQ4alCqIEiwDwz0DXGF3fz2B8IhJoqhs65AOfsjQyBpc
         UVkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794998269; x=1795603069; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jfBqG2kKo0nT2ILNCvBc41zfj1MBfIB9+pQTxNPopsE=;
        b=u7puCFIaCwt39fMcFoGSR56hFgt0mR5dSpFsw7vDWBt5ryYUVzlIsCsIPrw1sk0aH+
         AdSJYCNahE2toJxgmR3EgbBrxiWp3VVvtNZdgmij730ZWvs3j0HAA6mJ8mbOI7HITaPZ
         mUr/ED8sLaY63h0Xh2AOXP/nS0gDIm3Q+FjJ/6C4KzmcHvOCaDcv8EOP5sEkRT2U+P41
         ekC16zzmrN/y5rYC99Tap9E9L0KgnYx4/+myLkkK4rmoiQpeTtZcZHA1rd9pFeSiKz+H
         30Cfdn25t6WB6yTL0CUY5Jz4EJV3yfRWt1rXAXrH/YobTjTvBTm6nmw6Iuxvv6GjoCZP
         +XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794998269; x=1795603069;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jfBqG2kKo0nT2ILNCvBc41zfj1MBfIB9+pQTxNPopsE=;
        b=v0DyZrnXRQacvw8aKAB83G4TopwYtSK+brgrLDgpDL52CMmThbcrzfnVnBK4Sn9Orz
         4frwJCq4qLpeFrseDzdAYVILxx1AeKfugB0J96xhJp2afk4kx9o5eOpmQUWa4115cZ2f
         wW5/olTfxbme67esSQnOp7voFpTIwIwJIfIca9J25FoOFX6cB6SdToMNl8n2OOVVriA3
         SChhulyNZ7WDBi8MHU557JHDg1zvFYWIkM5gDf5vsSgDLYVcAcJ1nqEyQUfCtxaoTz8N
         wHiPmlZNqZxX0751kzArq7xeYtn5A6uKAuiRHi2Fvboj5JQTfbHMmp9zQI5p8zPo0fMd
         Zt7w==
X-Forwarded-Encrypted: i=1; AL+hErGWcR50tfGE8E/puQzIZKg+Ubj3lS+edUuCTTBOOETmZjr3r1LLaliC18HH1U/Sgy4rZidMvuEvicqGYV1E@vger.kernel.org
X-Gm-Message-State: APuU4Z/G90liIvU0Mrc+tgHM0UofAj7vQTAiyIil4r5usvAIXScqxt8E
	wORmglDxqDtbEEnXKMqCasz2+is/PPAA6AV85iK6DrlzhF2L9TYgm2uUagte53HzcQXcGyr/L5c
	TcH8wN7gs4NRBOuPBkaK+rQ2KX8fvpVg=
X-Gm-Gg: AYBFou0UMQBPUIq9SA4AiS+KoBrRYorkaf+P3ttpgBKlnNNOT1a/kpRnTvQCcnq8wrt
	u/RfsGNxWdzmmWfgRNBjh2mxDDoWyfB4Le17zeFi5uOoGb1wt6YHiT4zT7J2DSEdhmPCYRhjV3s
	4dkiHrNeqbBtdDYcrziGkv9VHqsmq0EZIWOCeT95oRkvw4Z8UZ7XVNtrBvppy6f1CkN5Qpito73
	Z31EkVGWIhkFgOZXs+hQhm0Lq7XcBVi3mYHo3561aHj5Jv7Dtwj5cOupkELhIpVUjxVyDiS1GZE
	7ilEJNaREQ6lYvSiLnmZ3Rum7/RQQskml96eJy2DxD/jO2mXUfsHA+YEJ3nWDrjsoZamQOnKrBi
	6jGhBbGk2TC3yl/mFQ5HS6815FlpFmSSS+4FwnrZoMHR2rFiyezjlrczZX1FmyeVHPKR+BQ==
X-Received: by 2002:a17:907:3fa3:b0:c4d:31cd:9dec with SMTP id
 a640c23a62f3a-c510e3a4ea4mr177646866b.30.1794998268333; Wed, 18 Nov 2026
 02:37:48 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118040056.6543-1-dingf3ng@gmail.com> <20261118-entdecken-landnahme-fratze-8581bee07c39@brauner>
In-Reply-To: <20261118-entdecken-landnahme-fratze-8581bee07c39@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 11:37:36 +0100
X-Gm-Features: AclHuK98XCfk-oMd6A8M54AGkphcYjj6oHS1i-On-0XmS10GCtySb3LAOlgzHQs
Message-ID: <CAOQ4uxg5baphOjo+_A=3nZBmFEmMV7KOiv_W=rjEVYV41eTEaA@mail.gmail.com>
Subject: Re: ovl: sync_file_range() does nothing on overlayfs files
To: Christian Brauner <brauner@kernel.org>
Cc: Ding Feng <dingf3ng@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Josef Bacik <josef@toxicpanda.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000002849dc06608a9aa5"

--0000000000002849dc06608a9aa5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 11:16=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Wed, Nov 18, 2026 at 12:00:56PM +0800, Ding Feng wrote:
> > cachestat() has the same cause, and Pavel's series in June [3] fixes it
> > by forwarding to the real file, as ovl_fadvise() does. Christian
> > suggested a helper in fs/backing-file.c for that instead of a new file
> > operation. Could sync_file_range() use the same helper? I can send a
> > patch along those lines if that direction is acceptable.
>
> This is really an overlayfs call, I think. A helper in fs/backing-file.c
> that gets the file whose mapping actually has the pages might be fine.
> For overlayfs copy-up changes the file so the helper has to go ask
> overlayfs, I think. But really, Amir is better equipped to decide
> whether this makes sense.

Like this?

Completely untested.

Thanks,
Amir.

--0000000000002849dc06608a9aa5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-fs-add-f_real-file-operation.patch"
Content-Disposition: attachment; 
	filename="0001-fs-add-f_real-file-operation.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mwlzlsyf0>
X-Attachment-Id: f_mwlzlsyf0

RnJvbTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KU3ViamVjdDogW1BBVENI
IFJGQyBQT0NdIGZzOiBhZGQgLT5mX3JlYWwoKSBmaWxlIG9wZXJhdGlvbgoKc3luY19maWxlX3Jh
bmdlKDIpIGFuZCBjYWNoZXN0YXQoMikgb3BlcmF0ZSBvbiBmaWxlLT5mX21hcHBpbmcuICBGb3Ig
YQpmaWxlIG9uIGEgc3RhY2tpbmcgZmlsZXN5c3RlbSwgc3VjaCBhcyBvdmVybGF5ZnMsIHRoZSBk
YXRhIGFuZCBpdHMgcGFnZQpjYWNoZSBhcmUgaW4gdGhlIHJlYWwgKGJhY2tpbmcpIGZpbGUsIHNv
IG9uIGEgc3RhY2tlZCBmaWxlCnN5bmNfZmlsZV9yYW5nZSgpIHdyaXRlcyBiYWNrIG5vdGhpbmcg
YW5kIGNhY2hlc3RhdCgpIHJlcG9ydHMgbm90aGluZy4KCkFkZCBhIC0+Zl9yZWFsKCkgZmlsZSBv
cGVyYXRpb24sIG1vZGVsbGVkIGFmdGVyIC0+ZF9yZWFsKCksIGFuZCBhCmZpbGVfcmVhbCgpIGhl
bHBlciBpbiBiYWNraW5nLWZpbGUuaCB0aGF0IHJldHVybnMgdGhlIGJhY2tpbmcgZmlsZQpob2xk
aW5nIHRoZSBkYXRhIG9mIGEgc3RhY2tlZCBmaWxlLCBvciB0aGUgZmlsZSBpdHNlbGYuICBmaWxl
X3JlYWwoKSBpcwphIG5vLW9wIHdpdGhvdXQgQ09ORklHX0ZTX1NUQUNLOyBvdGhlcndpc2UgaXRz
IHNsb3cgcGF0aCBpbgpmcy9iYWNraW5nLWZpbGUuYyBjYWxscyAtPmZfcmVhbCgpIGFuZCB2ZXJp
ZmllcyB0aGF0IGl0IHJldHVybmVkIGEKYmFja2luZyBmaWxlLiAgVGhlIHJlYWwgZmlsZSBpcyBv
d25lZCBieSB0aGUgc3RhY2tlZCBmaWxlLCBzbyBpdCBpcwp2YWxpZCBmb3IgYXMgbG9uZyBhcyB0
aGUgY2FsbGVyIGhvbGRzIHRoZSBzdGFja2VkIGZpbGUuCgpmaWxlX3JlYWwoKSBpcyBvbmx5IG1l
YW50IGZvciBpbnNwZWN0aW5nIGFuZCB3cml0aW5nIGJhY2sgdGhlIHBhZ2UgY2FjaGUKb2YgdGhl
IGRhdGEuICBPcGVyYXRpb25zIHRoYXQgbmVlZCB0aGUgY3JlZGVudGlhbHMgb3IgcGVybWlzc2lv
biBjaGVja3MKb2YgdGhlIHN0YWNraW5nIGZpbGVzeXN0ZW0gbmVlZCBhIGRlZGljYXRlZCBmaWxl
IG9wZXJhdGlvbiwgbGlrZQotPmZhZHZpc2UoKS4KClVzZSBmaWxlX3JlYWwoKSBpbiBzeW5jX2Zp
bGVfcmFuZ2UoKSAoYWxzbyB1c2VkIGJ5IGlvX3VyaW5nKSBhbmQgaW4KY2FjaGVzdGF0KCksIGFu
ZCBpbXBsZW1lbnQgLT5mX3JlYWwoKSBmb3Igb3ZlcmxheWZzLgoKU2lnbmVkLW9mZi1ieTogQW1p
ciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KLS0tCiBmcy9iYWNraW5nLWZpbGUuYyAg
ICAgICAgICAgIHwgICAxMiArKysrKysrKysrKysKIGZzL292ZXJsYXlmcy9maWxlLmMgICAgICAg
ICAgfCAgIDExICsrKysrKysrKysrCiBmcy9zeW5jLmMgICAgICAgICAgICAgICAgICAgIHwgICAg
OCArKysrKysrKwogaW5jbHVkZS9saW51eC9iYWNraW5nLWZpbGUuaCB8ICAgMjYgKysrKysrKysr
KysrKysrKysrKysrKysrKysKIGluY2x1ZGUvbGludXgvZnMuaCAgICAgICAgICAgfCAgICAxICsK
IG1tL2ZpbGVtYXAuYyAgICAgICAgICAgICAgICAgfCAgICA5ICsrKysrKysrLQogNiBmaWxlcyBj
aGFuZ2VkLCA2NiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgotLS0gYS9pbmNsdWRlL2xp
bnV4L2ZzLmgKKysrIGIvaW5jbHVkZS9saW51eC9mcy5oCkBAIC0xOTYwLDYgKzE5NjAsNyBAQCBz
dHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHsKIAkJCQkgICBzdHJ1Y3QgZmlsZSAqZmlsZV9vdXQsIGxv
ZmZfdCBwb3Nfb3V0LAogCQkJCSAgIGxvZmZfdCBsZW4sIHVuc2lnbmVkIGludCByZW1hcF9mbGFn
cyk7CiAJaW50ICgqZmFkdmlzZSkoc3RydWN0IGZpbGUgKiwgbG9mZl90LCBsb2ZmX3QsIGludCk7
CisJc3RydWN0IGZpbGUgKigqZl9yZWFsKShjb25zdCBzdHJ1Y3QgZmlsZSAqKTsKIAlpbnQgKCp1
cmluZ19jbWQpKHN0cnVjdCBpb191cmluZ19jbWQgKmlvdWNtZCwgdW5zaWduZWQgaW50IGlzc3Vl
X2ZsYWdzKTsKIAlpbnQgKCp1cmluZ19jbWRfaW9wb2xsKShzdHJ1Y3QgaW9fdXJpbmdfY21kICos
IHN0cnVjdCBpb19jb21wX2JhdGNoICosCiAJCQkJdW5zaWduZWQgaW50IHBvbGxfZmxhZ3MpOwot
LS0gYS9pbmNsdWRlL2xpbnV4L2JhY2tpbmctZmlsZS5oCisrKyBiL2luY2x1ZGUvbGludXgvYmFj
a2luZy1maWxlLmgKQEAgLTQwLDUgKzQwLDMxIEBAIHNzaXplX3QgYmFja2luZ19maWxlX3NwbGlj
ZV93cml0ZShzdHJ1Y3QKIAkJCQkgIHN0cnVjdCBiYWNraW5nX2ZpbGVfY3R4ICpjdHgpOwogaW50
IGJhY2tpbmdfZmlsZV9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1
Y3QgKnZtYSwKIAkJICAgICAgc3RydWN0IGJhY2tpbmdfZmlsZV9jdHggKmN0eCk7CitzdHJ1Y3Qg
ZmlsZSAqX19maWxlX3JlYWwoc3RydWN0IGZpbGUgKmZpbGUpOworCisvKioKKyAqIGZpbGVfcmVh
bCAtIFJldHVybiB0aGUgcmVhbCBmaWxlIGhvc3RpbmcgdGhlIGRhdGEKKyAqIEBmaWxlOiB0aGUg
ZmlsZSB0byBxdWVyeQorICoKKyAqIElmIEBmaWxlIGlzIG9uIGEgc3RhY2tpbmcgZmlsZXN5c3Rl
bSAoZS5nLiBvdmVybGF5ZnMpIHdob3NlIGRhdGEgaXMKKyAqIGFjY2Vzc2VkIHRocm91Z2ggYSBi
YWNraW5nIGZpbGUsIHJldHVybiB0aGF0IGJhY2tpbmcgZmlsZS4KKyAqIE90aGVyd2lzZSByZXR1
cm4gQGZpbGUgaXRzZWxmLgorICoKKyAqIFRoZSByZXR1cm5lZCBmaWxlIGlzIG93bmVkIGJ5IEBm
aWxlIGFuZCBpcyB2YWxpZCBmb3IgYXMgbG9uZyBhcyB0aGUKKyAqIGNhbGxlciBob2xkcyBhIHJl
ZmVyZW5jZSB0byBAZmlsZS4KKyAqCisgKiBUaGUgcmVhbCBmaWxlIGlzIG9ubHkgbWVhbnQgdG8g
YmUgdXNlZCBmb3IgaW5zcGVjdGluZyBhbmQgd3JpdGluZworICogYmFjayB0aGUgcGFnZSBjYWNo
ZSBvZiB0aGUgZGF0YSAoZS5nLiBzeW5jX2ZpbGVfcmFuZ2UoMiksIGNhY2hlc3RhdCgyKSkuCisg
KiBJdCBtdXN0IG5vdCBiZSB1c2VkIGZvciBvcGVyYXRpb25zIHRoYXQgcmVxdWlyZSB0aGUgY3Jl
ZGVudGlhbHMgb3IgdGhlCisgKiBwZXJtaXNzaW9uIGNoZWNrcyBvZiB0aGUgc3RhY2tpbmcgZmls
ZXN5c3RlbTsgdGhvc2UgbmVlZCBhIGRlZGljYXRlZAorICogZmlsZSBvcGVyYXRpb24gKGUuZy4g
LT5mYWR2aXNlKCkpLgorICovCitzdGF0aWMgaW5saW5lIHN0cnVjdCBmaWxlICpmaWxlX3JlYWwo
c3RydWN0IGZpbGUgKmZpbGUpCit7CisJaWYgKCFJU19FTkFCTEVEKENPTkZJR19GU19TVEFDSykg
fHwgbGlrZWx5KCFmaWxlLT5mX29wLT5mX3JlYWwpKQorCQlyZXR1cm4gZmlsZTsKKworCXJldHVy
biBfX2ZpbGVfcmVhbChmaWxlKTsKK30KIAogI2VuZGlmIC8qIF9MSU5VWF9CQUNLSU5HX0ZJTEVf
SCAqLwotLS0gYS9mcy9iYWNraW5nLWZpbGUuYworKysgYi9mcy9iYWNraW5nLWZpbGUuYwpAQCAt
MTAyLDYgKzEwMiwxOCBAQCBzdHJ1Y3QgZmlsZSAqYmFja2luZ190bXBmaWxlX29wZW4oY29uc3QK
IH0KIEVYUE9SVF9TWU1CT0woYmFja2luZ190bXBmaWxlX29wZW4pOwogCisvKiBTbG93IHBhdGgg
b2YgZmlsZV9yZWFsKCkgZm9yIGEgZmlsZSB3aXRoIC0+Zl9yZWFsKCkgKi8KK3N0cnVjdCBmaWxl
ICpfX2ZpbGVfcmVhbChzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwlzdHJ1Y3QgZmlsZSAqcmVhbF9m
aWxlID0gZmlsZS0+Zl9vcC0+Zl9yZWFsKGZpbGUpOworCisJaWYgKCFJU19FUlIocmVhbF9maWxl
KSAmJiByZWFsX2ZpbGUgIT0gZmlsZSAmJgorCSAgICBXQVJOX09OX09OQ0UoIShyZWFsX2ZpbGUt
PmZfbW9kZSAmIEZNT0RFX0JBQ0tJTkcpKSkKKwkJcmV0dXJuIEVSUl9QVFIoLUVJTyk7CisKKwly
ZXR1cm4gcmVhbF9maWxlOworfQorCiBzdHJ1Y3QgYmFja2luZ19haW8gewogCXN0cnVjdCBraW9j
YiBpb2NiOwogCXJlZmNvdW50X3QgcmVmOwotLS0gYS9mcy9zeW5jLmMKKysrIGIvZnMvc3luYy5j
CkBAIC03LDYgKzcsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgogI2luY2x1ZGUgPGxp
bnV4L2ZpbGUuaD4KICNpbmNsdWRlIDxsaW51eC9mcy5oPgorI2luY2x1ZGUgPGxpbnV4L2JhY2tp
bmctZmlsZS5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KICNpbmNsdWRlIDxsaW51eC9leHBv
cnQuaD4KICNpbmNsdWRlIDxsaW51eC9uYW1laS5oPgpAQCAtMjY5LDYgKzI3MCwxMyBAQCBpbnQg
c3luY19maWxlX3JhbmdlKHN0cnVjdCBmaWxlICpmaWxlLCBsCiAJaWYgKCFTX0lTUkVHKGlfbW9k
ZSkgJiYgIVNfSVNCTEsoaV9tb2RlKSAmJiAhU19JU0RJUihpX21vZGUpKQogCQlnb3RvIG91dDsK
IAorCS8qIFRoZSBwYWdlIGNhY2hlIG9mIGEgc3RhY2tlZCBmaWxlIGlzIGluIGl0cyByZWFsIGZp
bGUgKi8KKwlmaWxlID0gZmlsZV9yZWFsKGZpbGUpOworCWlmIChJU19FUlIoZmlsZSkpIHsKKwkJ
cmV0ID0gUFRSX0VSUihmaWxlKTsKKwkJZ290byBvdXQ7CisJfQorCiAJbWFwcGluZyA9IGZpbGUt
PmZfbWFwcGluZzsKIAlyZXQgPSAwOwogCWlmIChmbGFncyAmIFNZTkNfRklMRV9SQU5HRV9XQUlU
X0JFRk9SRSkgewotLS0gYS9tbS9maWxlbWFwLmMKKysrIGIvbW0vZmlsZW1hcC5jCkBAIC0zMSw2
ICszMSw3IEBACiAjaW5jbHVkZSA8bGludXgvaGFzaC5oPgogI2luY2x1ZGUgPGxpbnV4L3dyaXRl
YmFjay5oPgogI2luY2x1ZGUgPGxpbnV4L2JhY2tpbmctZGV2Lmg+CisjaW5jbHVkZSA8bGludXgv
YmFja2luZy1maWxlLmg+CiAjaW5jbHVkZSA8bGludXgvZm9saW9fYmF0Y2guaD4KICNpbmNsdWRl
IDxsaW51eC9zZWN1cml0eS5oPgogI2luY2x1ZGUgPGxpbnV4L2NwdXNldC5oPgpAQCAtNDc4Miw2
ICs0NzgzLDcgQEAgU1lTQ0FMTF9ERUZJTkU0KGNhY2hlc3RhdCwgdW5zaWduZWQgaW50LAogCQlz
dHJ1Y3QgY2FjaGVzdGF0IF9fdXNlciAqLCBjc3RhdCwgdW5zaWduZWQgaW50LCBmbGFncykKIHsK
IAlDTEFTUyhmZCwgZikoZmQpOworCXN0cnVjdCBmaWxlICpyZWFsX2ZpbGU7CiAJc3RydWN0IGFk
ZHJlc3Nfc3BhY2UgKm1hcHBpbmc7CiAJc3RydWN0IGNhY2hlc3RhdF9yYW5nZSBjc3I7CiAJc3Ry
dWN0IGNhY2hlc3RhdCBjczsKQEAgLTQ4MDQsMTEgKzQ4MDYsMTYgQEAgU1lTQ0FMTF9ERUZJTkU0
KGNhY2hlc3RhdCwgdW5zaWduZWQgaW50LAogCWlmIChmbGFncyAhPSAwKQogCQlyZXR1cm4gLUVJ
TlZBTDsKIAorCS8qIFRoZSBwYWdlIGNhY2hlIG9mIGEgc3RhY2tlZCBmaWxlIGlzIGluIGl0cyBy
ZWFsIGZpbGUgKi8KKwlyZWFsX2ZpbGUgPSBmaWxlX3JlYWwoZmRfZmlsZShmKSk7CisJaWYgKElT
X0VSUihyZWFsX2ZpbGUpKQorCQlyZXR1cm4gUFRSX0VSUihyZWFsX2ZpbGUpOworCiAJZmlyc3Rf
aW5kZXggPSBjc3Iub2ZmID4+IFBBR0VfU0hJRlQ7CiAJbGFzdF9pbmRleCA9CiAJCWNzci5sZW4g
PT0gMCA/IFVMT05HX01BWCA6IChjc3Iub2ZmICsgY3NyLmxlbiAtIDEpID4+IFBBR0VfU0hJRlQ7
CiAJbWVtc2V0KCZjcywgMCwgc2l6ZW9mKHN0cnVjdCBjYWNoZXN0YXQpKTsKLQltYXBwaW5nID0g
ZmRfZmlsZShmKS0+Zl9tYXBwaW5nOworCW1hcHBpbmcgPSByZWFsX2ZpbGUtPmZfbWFwcGluZzsK
IAlmaWxlbWFwX2NhY2hlc3RhdChtYXBwaW5nLCBmaXJzdF9pbmRleCwgbGFzdF9pbmRleCwgJmNz
KTsKIAogCWlmIChjb3B5X3RvX3VzZXIoY3N0YXQsICZjcywgc2l6ZW9mKHN0cnVjdCBjYWNoZXN0
YXQpKSkKLS0tIGEvZnMvb3ZlcmxheWZzL2ZpbGUuYworKysgYi9mcy9vdmVybGF5ZnMvZmlsZS5j
CkBAIC0xOTUsNiArMTk1LDE2IEBAIHN0YXRpYyBzdHJ1Y3QgZmlsZSAqb3ZsX3JlYWxfZmlsZShj
b25zdAogCXJldHVybiBvdmxfcmVhbF9maWxlX3BhdGgoZmlsZSwgJnJlYWxwYXRoKTsKIH0KIAor
LyoKKyAqIFRoZSByZWFsIGZpbGUgdGhhdCBob2xkcyB0aGUgcGFnZSBjYWNoZSBvZiB0aGUgZGF0
YTogdGhlIHVwcGVyIGZpbGUgYWZ0ZXIKKyAqIGNvcHkgdXAsIG90aGVyd2lzZSB0aGUgbG93ZXIg
ZGF0YSBmaWxlLiAgQWZ0ZXIgY29weSB1cCBvZiBhIGZpbGUgdGhhdCB3YXMKKyAqIG9wZW5lZCBm
cm9tIGxvd2VyLCB0aGlzIG9wZW5zIHRoZSB1cHBlciBmaWxlLCBqdXN0IGxpa2UgYSB3cml0ZSB3
b3VsZC4KKyAqLworc3RhdGljIHN0cnVjdCBmaWxlICpvdmxfZl9yZWFsKGNvbnN0IHN0cnVjdCBm
aWxlICpmaWxlKQoreworCXJldHVybiBvdmxfcmVhbF9maWxlKGZpbGUpOworfQorCiBzdGF0aWMg
aW50IG92bF9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogewog
CXN0cnVjdCBkZW50cnkgKmRlbnRyeSA9IGZpbGVfZGVudHJ5KGZpbGUpOwpAQCAtNjU2LDYgKzY2
Niw3IEBAIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgb3ZsX2ZpbGVfb3AKIAkubW1hcAkJ
PSBvdmxfbW1hcCwKIAkuZmFsbG9jYXRlCT0gb3ZsX2ZhbGxvY2F0ZSwKIAkuZmFkdmlzZQk9IG92
bF9mYWR2aXNlLAorCS5mX3JlYWwJCT0gb3ZsX2ZfcmVhbCwKIAkuZmx1c2gJCT0gb3ZsX2ZsdXNo
LAogCS5zcGxpY2VfcmVhZCAgICA9IG92bF9zcGxpY2VfcmVhZCwKIAkuc3BsaWNlX3dyaXRlICAg
PSBvdmxfc3BsaWNlX3dyaXRlLAo=
--0000000000002849dc06608a9aa5--
