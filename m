Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649332;
	b=vP3T+pgF/MsYURaR4xVcL1Z4dndtNexK5RC8RsQbtLsLt7p0kucFjywB1QnuRQEYwa9Q
	 sSyPaGw7KdhRZg0fuqsVFuOKKIk16m78m5Wa8BURjDgDN4xpGi1vqrzjM6jZVkDgyisWA
	 3gdO7abhfyh+dfgHrnP0xne9mv4QlSF8+tyokjhSvXd5a4PyzH10mPVp//2YfGRMF8V7K
	 xt9s9iGc+45U039P/tUIe0O0ZYRRn4KB/UCoc6MwfqSQIX9GRAJ6Hp1eZYMY6jhUquf2K
	 YX9+UNiKcWhO2ZR94IIG1Gvo9V3bCSTjKJj6jTEom0k3s6JA5JWp3cU9mYmULhJPRXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649332;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=XUdVdHB+zcD0ZfrhpcEWa7mU5CsovKnpilTuxu8BNsA=;
	b=Z0elxzmZAibBGocr1g9R44pO6QNWb30Vv9ntRx+XAqNyw8kl3zslQ7xeid5f5HSSY+1g
	 idAk3rNfGq1eSvGU64jcVt5qQfltzyMONe3vWz+21Dj8IRdoYWQRRWNQiPi0R9qhTGo3b
	 LhHLRmMTTZCBBFvdsGgNPhXMgZHKA9jPAabtMIy/qYtANV20xEKgMREwAG/I5+k/M8WqB
	 qpD/tII6pq3PZD26+agKeAOiFz54Ol1thrjo0PIoBcBBJdcSM4GtbwlnQQcumYQqLjkiN
	 z8vdt6FKGua49kYCO9moHxEXQ2S63OQHQpx3afWTZO/wbofzT4Xv84YwXdxwelaSfzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Uj9Bjy6q;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7484F6082BE1
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Nov 2026 19:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7484F6082BE1
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Uj9Bjy6q
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so5587839a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Nov 2026 11:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793649330; x=1794254130; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XUdVdHB+zcD0ZfrhpcEWa7mU5CsovKnpilTuxu8BNsA=;
        b=Uj9Bjy6qOW0mhqkbulaa+t1Is4J4D3Vo428K8ro2o3+DW8fUQm5d6kzviKdWC/vrGm
         1XxTMmXlL9wwox35fAmVnwflxPQCTdp06a9Sp9IxjQPNMKwKVEb69wSkoWwBa0V4Hboa
         iakJLwQ1o9Z/U6Ym/HbgAx22hHykx9vSEgXD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793649330; x=1794254130;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XUdVdHB+zcD0ZfrhpcEWa7mU5CsovKnpilTuxu8BNsA=;
        b=mZH/C5ITi2O6Poex7n4atLMOSbEEmZy8KuKzlWkbr+Z3R9ocrrnKy5hX0sARkOs5Vq
         fQ6XrS5mjDPWwyO7HMpfR22D/+3EoJTdaMYM5yW/bXE1ftLjZm+0ztzMXM+/9OLQE5Ui
         LBcES4W/DnZY440YHNVWZTYQSEmFzupjSH8TXMRMJHzEVkjdEaD5rNxIlFw5jH/rDeTY
         xaHMjdAKYfwWaXkuOnvTp7gFZgXR8j4esenljdKJb69RmDzNkx29VIsz4sHWm+wUEitF
         7jeC0MALiMcpciT47p3/gq0UE51RkGhBEdY1Ux13CvO5GOVFLQLoBoe8iMqn9ZFv8bAm
         jADA==
X-Forwarded-Encrypted: i=1; AKwUvBzld25NmjYZN9daena02EmMhqYWwIzTTM9YJ0WqQ7UndQNiTLFAkLnhGma7WRmQ2bC34vLP3V9BlRi6l0SL@vger.kernel.org
X-Gm-Message-State: APuU4Z8iId8BuRGylZ7C2K4538CuVLnY0QnN5b9+mOVEVdU4ESUdjimf
	/rBzG1BWDFmVEfunl/VIlRfT5fRqsMaxo/Q4NRiwtBat2YSNDbvp9i4pQ5sZRBeY7Jp3cJ7K54V
	Xr3fClFEZxA==
X-Gm-Gg: AYBFou14d/QUNvTv5XyU6xX386o9/R45n4f5jdOJg8nvvCqGlY2w5L869OURpH3bbXM
	QGy8pmN1v2nRaIX3AjsBTifGu4yPqBRCbn/4TDozq095aongF3uQX1KyesXKzQYiND/Jkr61dm7
	6PR6qmEcPz+02aNFmfJ0pa5ECClqPQ5Df7nlUQERHwYjg9tBsBGZoKkwVFrW4pH2NxMpKu2txfm
	BQkeRij8vM6XgAcYOl9i2oohjYJTNYSTvd0wpYIKGAYbuRPL4LrVD1JG52aF/CtTAN/sbGCIEjs
	YgwaEL0ZvkNHPAv9uTBlNXvK92PhTR+IgytWZETp8FYpZ+qjCELXRzkYjUNOrQ3S6Bg/HJ/te8H
	XViXfHTejkWEJa8ey7+UXjrkYuD/9hlkRYm1IglueJUXPSE9r8gCdbclmZZwCXTJLzQxsK9NkXB
	EOoCQy4oeUHOWNaY2DYY2f9to+Yl5eNrVD3mO2UaZJvy5Rd5BDh65cDWwyRVJtpqVSlROMMQpr1
	OLHmczV5rs+/ZjGVrvVk5LJKvf7k1jyxG4xdiJUUoPJ51X1K1UEXCOMT07wa5Zpv2I9qC3EFh6N
	c771FVeUdUfyRdAoApJONB06Tx4UFOLeEDlyqE7vPsmd0/ntMwPIIuY+vdtDPhKSLSjnbd3YT46
	3GkuzvQMw88z32BJI8roXEdg=
X-Received: by 2002:a05:6402:529b:b0:6b4:16fb:b9bf with SMTP id 4fb4d7f45d1cf-6b4d5ede184mr7467967a12.34.1793649329841;
        Mon, 02 Nov 2026 11:55:29 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4eca211ddsm3490850a12.34.2026.11.02.11.55.28
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 11:55:28 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b4f7d3cd98so2504045a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Nov 2026 11:55:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwhIxvXulGHnEt7g6nMxJow9U4pDlU8Od6zrIT2qnIDDwB3qY25LjUsJVR0nh3tPz9MkiDN2k5uc+KiZXPJ@vger.kernel.org
X-Received: by 2002:a17:906:c143:b0:c46:c3ad:e1ca with SMTP id
 a640c23a62f3a-c4ca7a0996cmr933511966b.9.1793649328428; Mon, 02 Nov 2026
 11:55:28 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031095716.3030288-1-amir73il@gmail.com> <CAHk-=wiPhTLn1p0ZHx-7SMdk4_zazqDK1k7MMEn9scRfqeDgtw@mail.gmail.com>
 <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 11:55:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wikNxjCHDOSqEDanyNqfbVRRKXetGcLzFn2zUsbhUUexw@mail.gmail.com>
X-Gm-Features: AclHuK9jdW8dJ1vAaU5rIVesbAlxbo1p3sB97I1bpi_SdINXhJdbMidG1oN3Exo
Message-ID: <CAHk-=wikNxjCHDOSqEDanyNqfbVRRKXetGcLzFn2zUsbhUUexw@mail.gmail.com>
Subject: Re: Return failure from take_dentry_name_snapshot() (Was: [GIT PULL]
 overlayfs fixes for 7.3)
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary="00000000000012e61c065f5087fd"

--00000000000012e61c065f5087fd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Nov 2026 at 03:50, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Oct 31, 2026 at 8:19=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> >                 // Ok, we have a name reference. Make sure it is still =
valid
> >                 if (read_seqcount_retry(&dentry->d_seq, seq)) {
> >                         release_dentry_name_snapshot(name);
> >                         goto retry;
> >                 }
> >
> >                 name->name.name =3D s;

This was wrong: it sets 'name->name.name' too late:
release_dentry_name_snapshot() already needs it set, because it then
compares that name pointer to the inline pointer to see if it was an
external name or not.

The fix is to just have a separate "release_external_name()" helper,
since that's what we actually want here.

> Attached proper patch.

Your proper patch ended up having my bug in it, so it will leak the
external name in the (admittedly very unlikely) case of
take_dentry_name_snapshot having gotten an external name reference but
then raced with a rename.

I think this attached patch is correct.

                     Linus

--00000000000012e61c065f5087fd
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mvzohkua0>
X-Attachment-Id: f_mvzohkua0

IGZzL2RjYWNoZS5jICAgICAgICAgICAgfCA3NyArKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZnMvb3ZlcmxheWZzL3N1cGVyLmMgICB8IDEwICsrLS0t
LS0KIGluY2x1ZGUvbGludXgvZGNhY2hlLmggfCAgMyArLQogMyBmaWxlcyBjaGFuZ2VkLCAzNyBp
bnNlcnRpb25zKCspLCA1MyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9kY2FjaGUuYyBi
L2ZzL2RjYWNoZS5jCmluZGV4IDQwOWY4NDFlMDU4ZS4uNzljZTFkMGU1MmMyIDEwMDY0NAotLS0g
YS9mcy9kY2FjaGUuYworKysgYi9mcy9kY2FjaGUuYwpAQCAtMzM1LDYgKzMzNSwxMiBAQCBzdHJ1
Y3QgZXh0ZXJuYWxfbmFtZSB7CiAJdW5zaWduZWQgY2hhciBuYW1lW10gX19hbGlnbmVkKHNpemVv
Zih1bnNpZ25lZCBsb25nKSk7CiB9OwogCitzdGF0aWMgaW5saW5lIHZvaWQgcmVsZWFzZV9leHRl
cm5hbF9uYW1lKHN0cnVjdCBleHRlcm5hbF9uYW1lICpwKQoreworCWlmICh1bmxpa2VseShhdG9t
aWNfZGVjX2FuZF90ZXN0KCZwLT5jb3VudCkpKQorCQlrZnJlZV9yY3UocCwgaGVhZCk7Cit9CisK
IHN0YXRpYyBpbmxpbmUgc3RydWN0IGV4dGVybmFsX25hbWUgKmV4dGVybmFsX25hbWUoc3RydWN0
IGRlbnRyeSAqZGVudHJ5KQogewogCXJldHVybiBjb250YWluZXJfb2YoZGVudHJ5LT5kX25hbWUu
bmFtZSwgc3RydWN0IGV4dGVybmFsX25hbWUsIG5hbWVbMF0pOwpAQCAtMzU5LDY1ICszNjUsNDgg
QEAgc3RhdGljIGlubGluZSBpbnQgZG5hbWVfZXh0ZXJuYWwoY29uc3Qgc3RydWN0IGRlbnRyeSAq
ZGVudHJ5KQogCXJldHVybiBkZW50cnktPmRfbmFtZS5uYW1lICE9IGRlbnRyeS0+ZF9zaG9ydG5h
bWUuc3RyaW5nOwogfQogCi1zdGF0aWMgYm9vbCBfX3Rha2VfZGVudHJ5X25hbWVfc25hcHNob3Qo
c3RydWN0IG5hbWVfc25hcHNob3QgKm5hbWUsCi0JCQkJCXN0cnVjdCBkZW50cnkgKmRlbnRyeSwg
Ym9vbCByZXRyeSkKK2Jvb2wgdGFrZV9kZW50cnlfbmFtZV9zbmFwc2hvdChzdHJ1Y3QgbmFtZV9z
bmFwc2hvdCAqbmFtZSwgc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogewotCXVuc2lnbmVkIHNlcTsK
LQljb25zdCB1bnNpZ25lZCBjaGFyICpzOwotCi0JcmN1X3JlYWRfbG9jaygpOwotcmV0cnk6Ci0J
c2VxID0gcmVhZF9zZXFjb3VudF9iZWdpbigmZGVudHJ5LT5kX3NlcSk7Ci0JcyA9IFJFQURfT05D
RShkZW50cnktPmRfbmFtZS5uYW1lKTsKLQluYW1lLT5uYW1lLmhhc2hfbGVuID0gZGVudHJ5LT5k
X25hbWUuaGFzaF9sZW47Ci0JbmFtZS0+bmFtZS5uYW1lID0gbmFtZS0+aW5saW5lX25hbWUuc3Ry
aW5nOwotCWlmIChsaWtlbHkocyA9PSBkZW50cnktPmRfc2hvcnRuYW1lLnN0cmluZykpIHsKLQkJ
bmFtZS0+aW5saW5lX25hbWUgPSBkZW50cnktPmRfc2hvcnRuYW1lOwotCX0gZWxzZSB7CisJZ3Vh
cmQocmN1KSgpOworCWZvciAoOzspIHsKKwkJdW5zaWduZWQgc2VxID0gcmVhZF9zZXFjb3VudF9i
ZWdpbigmZGVudHJ5LT5kX3NlcSk7CisJCWNvbnN0IHVuc2lnbmVkIGNoYXIgKnMgPSBSRUFEX09O
Q0UoZGVudHJ5LT5kX25hbWUubmFtZSk7CiAJCXN0cnVjdCBleHRlcm5hbF9uYW1lICpwOworCisJ
CW5hbWUtPm5hbWUuaGFzaF9sZW4gPSBkZW50cnktPmRfbmFtZS5oYXNoX2xlbjsKKwkJbmFtZS0+
bmFtZS5uYW1lID0gbmFtZS0+aW5saW5lX25hbWUuc3RyaW5nOworCQlpZiAobGlrZWx5KHMgPT0g
ZGVudHJ5LT5kX3Nob3J0bmFtZS5zdHJpbmcpKSB7CisJCQluYW1lLT5pbmxpbmVfbmFtZSA9IGRl
bnRyeS0+ZF9zaG9ydG5hbWU7CisJCQlpZiAocmVhZF9zZXFjb3VudF9yZXRyeSgmZGVudHJ5LT5k
X3NlcSwgc2VxKSkKKwkJCQljb250aW51ZTsKKwkJCXJldHVybiB0cnVlOworCQl9CisKKwkJLy8g
VHJ5IHRvIGdldCBhIHZhbGlkIGV4dGVybmFsIHJlZmVyZW5jZQogCQlwID0gY29udGFpbmVyX29m
KHMsIHN0cnVjdCBleHRlcm5hbF9uYW1lLCBuYW1lWzBdKTsKLQkJLy8gZ2V0IGEgdmFsaWQgcmVm
ZXJlbmNlCiAJCWlmICh1bmxpa2VseSghYXRvbWljX2luY19ub3RfemVybygmcC0+Y291bnQpKSkg
ewotCQkJaWYgKHJldHJ5KQotCQkJCWdvdG8gcmV0cnk7Ci0JCQlyY3VfcmVhZF91bmxvY2soKTsK
KwkJCWlmIChyZWFkX3NlcWNvdW50X3JldHJ5KCZkZW50cnktPmRfc2VxLCBzZXEpKQorCQkJCWNv
bnRpbnVlOwogCQkJcmV0dXJuIGZhbHNlOwogCQl9Ci0JCW5hbWUtPm5hbWUubmFtZSA9IHM7Ci0J
fQotCWlmIChyZWFkX3NlcWNvdW50X3JldHJ5KCZkZW50cnktPmRfc2VxLCBzZXEpKSB7Ci0JCXJl
bGVhc2VfZGVudHJ5X25hbWVfc25hcHNob3QobmFtZSk7Ci0JCWdvdG8gcmV0cnk7Ci0JfQotCXJj
dV9yZWFkX3VubG9jaygpOwotCXJldHVybiB0cnVlOwotfQogCi12b2lkIHRha2VfZGVudHJ5X25h
bWVfc25hcHNob3Qoc3RydWN0IG5hbWVfc25hcHNob3QgKm5hbWUsIHN0cnVjdCBkZW50cnkgKmRl
bnRyeSkKLXsKLQlfX3Rha2VfZGVudHJ5X25hbWVfc25hcHNob3QobmFtZSwgZGVudHJ5LCB0cnVl
KTsKKwkJLy8gT2ssIHdlIGhhdmUgYSBuYW1lIHJlZmVyZW5jZS4gTWFrZSBzdXJlIGl0IGlzIHN0
aWxsIHZhbGlkCisJCW5hbWUtPm5hbWUubmFtZSA9IHM7CisJCWlmICghcmVhZF9zZXFjb3VudF9y
ZXRyeSgmZGVudHJ5LT5kX3NlcSwgc2VxKSkKKwkJCXJldHVybiB0cnVlOworCisJCXJlbGVhc2Vf
ZXh0ZXJuYWxfbmFtZShwKTsKKwkJY29udGludWU7CisJfQogfQogRVhQT1JUX1NZTUJPTCh0YWtl
X2RlbnRyeV9uYW1lX3NuYXBzaG90KTsKIAotLyoKLSAqIEZvciBhIGNhbGxlciB0aGF0IGhvbGRz
IG5vIHJlZmVyZW5jZSBvbiBAZGVudHJ5LCBlLmcuIGluIFJDVSB3YWxrLgotICogVGhlIGV4dGVy
bmFsIG5hbWUgb2YgYSBkZWFkIGRlbnRyeSBoYXMgYSB6ZXJvIHJlZmNvdW50IGZvcmV2ZXIsIHNv
Ci0gKiB0YWtlX2RlbnRyeV9uYW1lX3NuYXBzaG90KCkgd291bGQgcmV0cnkgd2l0aG91dCBlbmQu
ICBGYWlsIGluc3RlYWQuCi0gKi8KLWJvb2wgdHJ5X3Rha2VfZGVudHJ5X25hbWVfc25hcHNob3Qo
c3RydWN0IG5hbWVfc25hcHNob3QgKm5hbWUsCi0JCQkJICAgc3RydWN0IGRlbnRyeSAqZGVudHJ5
KQotewotCXJldHVybiBfX3Rha2VfZGVudHJ5X25hbWVfc25hcHNob3QobmFtZSwgZGVudHJ5LCBm
YWxzZSk7Ci19Ci1FWFBPUlRfU1lNQk9MKHRyeV90YWtlX2RlbnRyeV9uYW1lX3NuYXBzaG90KTsK
LQogdm9pZCByZWxlYXNlX2RlbnRyeV9uYW1lX3NuYXBzaG90KHN0cnVjdCBuYW1lX3NuYXBzaG90
ICpuYW1lKQogewogCWlmICh1bmxpa2VseShuYW1lLT5uYW1lLm5hbWUgIT0gbmFtZS0+aW5saW5l
X25hbWUuc3RyaW5nKSkgewogCQlzdHJ1Y3QgZXh0ZXJuYWxfbmFtZSAqcDsKIAkJcCA9IGNvbnRh
aW5lcl9vZihuYW1lLT5uYW1lLm5hbWUsIHN0cnVjdCBleHRlcm5hbF9uYW1lLCBuYW1lWzBdKTsK
LQkJaWYgKHVubGlrZWx5KGF0b21pY19kZWNfYW5kX3Rlc3QoJnAtPmNvdW50KSkpCi0JCQlrZnJl
ZV9yY3UocCwgaGVhZCk7CisJCXJlbGVhc2VfZXh0ZXJuYWxfbmFtZShwKTsKIAl9CiB9CiBFWFBP
UlRfU1lNQk9MKHJlbGVhc2VfZGVudHJ5X25hbWVfc25hcHNob3QpOwpkaWZmIC0tZ2l0IGEvZnMv
b3ZlcmxheWZzL3N1cGVyLmMgYi9mcy9vdmVybGF5ZnMvc3VwZXIuYwppbmRleCAwODY5NWE5OWY0
ZjkuLmQ5MTc0ZWFjY2NlMiAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMKKysrIGIv
ZnMvb3ZlcmxheWZzL3N1cGVyLmMKQEAgLTEwMCwxNyArMTAwLDEzIEBAIHN0YXRpYyBpbnQgb3Zs
X3JldmFsaWRhdGVfcmVhbChzdHJ1Y3QgZGVudHJ5ICpkLCB1bnNpZ25lZCBpbnQgZmxhZ3MsIGJv
b2wgd2VhaykKIAkJCWRpciA9IGRfaW5vZGVfcmN1KHBhcmVudCk7CiAJCQlpZiAoIWRpcikKIAkJ
CQlyZXR1cm4gLUVDSElMRDsKLQkJCS8qCi0JCQkgKiBOb3RoaW5nIHBpbnMgZCBpbiBSQ1Ugd2Fs
azogZXZpY3Rpb24gb2YgdGhlIG92ZXJsYXkKLQkJCSAqIGlub2RlIG1heSBkcm9wIHRoZSBsYXN0
IHJlZmVyZW5jZSBhdCBhbnkgdGltZS4KLQkJCSAqLwotCQkJaWYgKCF0cnlfdGFrZV9kZW50cnlf
bmFtZV9zbmFwc2hvdCgmbiwgZCkpCi0JCQkJcmV0dXJuIC1FQ0hJTEQ7CiAJCX0gZWxzZSB7CiAJ
CQlwYXJlbnQgPSBkZ2V0X3BhcmVudChkKTsKIAkJCWRpciA9IGRfaW5vZGUocGFyZW50KTsKLQkJ
CXRha2VfZGVudHJ5X25hbWVfc25hcHNob3QoJm4sIGQpOwogCQl9CisJCS8qIEluIFJDVSB3YWxr
IHRoZSBkZW50cnkgbmFtZSBtYXkgZ28gYXdheSBhdCBhbnkgdGltZSAqLworCQlpZiAoIXRha2Vf
ZGVudHJ5X25hbWVfc25hcHNob3QoJm4sIGQpKQorCQkJcmV0dXJuIC1FQ0hJTEQ7CiAJCXJldCA9
IGQtPmRfb3AtPmRfcmV2YWxpZGF0ZShkaXIsICZuLm5hbWUsIGQsIGZsYWdzKTsKIAkJcmVsZWFz
ZV9kZW50cnlfbmFtZV9zbmFwc2hvdCgmbik7CiAJCWlmICghKGZsYWdzICYgTE9PS1VQX1JDVSkp
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2RjYWNoZS5oIGIvaW5jbHVkZS9saW51eC9kY2Fj
aGUuaAppbmRleCA4NGIwY2ZlNGVkMGUuLmFhYTRiYTdhMTI5OSAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS9saW51eC9kY2FjaGUuaAorKysgYi9pbmNsdWRlL2xpbnV4L2RjYWNoZS5oCkBAIC02NjQsOCAr
NjY0LDcgQEAgc3RydWN0IG5hbWVfc25hcHNob3QgewogCXN0cnVjdCBxc3RyIG5hbWU7CiAJdW5p
b24gc2hvcnRuYW1lX3N0b3JlIGlubGluZV9uYW1lOwogfTsKLXZvaWQgdGFrZV9kZW50cnlfbmFt
ZV9zbmFwc2hvdChzdHJ1Y3QgbmFtZV9zbmFwc2hvdCAqLCBzdHJ1Y3QgZGVudHJ5ICopOwotYm9v
bCB0cnlfdGFrZV9kZW50cnlfbmFtZV9zbmFwc2hvdChzdHJ1Y3QgbmFtZV9zbmFwc2hvdCAqLCBz
dHJ1Y3QgZGVudHJ5ICopOworYm9vbCB0YWtlX2RlbnRyeV9uYW1lX3NuYXBzaG90KHN0cnVjdCBu
YW1lX3NuYXBzaG90ICosIHN0cnVjdCBkZW50cnkgKik7CiB2b2lkIHJlbGVhc2VfZGVudHJ5X25h
bWVfc25hcHNob3Qoc3RydWN0IG5hbWVfc25hcHNob3QgKik7CiAKIHN0YXRpYyBpbmxpbmUgc3Ry
dWN0IGRlbnRyeSAqZF9maXJzdF9jaGlsZChjb25zdCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCg==
--00000000000012e61c065f5087fd--
