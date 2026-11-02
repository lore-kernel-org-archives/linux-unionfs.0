Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653437;
	b=Ld+flj5ugPBpNuMRszV9BSZadexGOzkkfawNpukC88TDI0T7F/DqjH5HsPC6Sw3mDV6A
	 UoySCNsRVvMpQJLxnTw/V8fjAiQWhpYqVKxSIzXod+qRdpffQ+By1E86ywf/LvAyIXr6n
	 HZDwizfOmSLuSuxbr849os1T9dXdtmGLzUkJs8fyt42e7DHhKMfsajEI0BQnPfJznkDUi
	 1B2wLZuD8+Ad89XJPAMzlrQI+vqn9xE16iI0BIM9ZQHyvrN2JRcKUakBIFi7NCdKrie4f
	 khlPuhzR4VQ2es3CAgteXDDAwtByMwDhHSIVKk8H93byYi7VUAhhxri468z47k4QcjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653437;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=YebZSF/Kl+cRxyBBQxMvp4KclRsEN0c74j2FIV9Omn0=;
	b=vEUctssLGCF9C5uEeKPa79evtI2YgktWcxdAHegIeTjsIvO4K4TG2TPNMLc+nXcFsxuU
	 /x/tX6UvWRPb7tpo7odpT5ZEyGbdfDrkOljwuKfX9wzFwE3m8ImmDD0AHHSx4fVa6r8nd
	 sc5gtHiZwoj3aa42+W2VN8mHgb5OEEd+D7WjrM+arVPMVqlPjvO0RTBeVivyeIeNMmboP
	 QiDVwdNyWwhRsxdNLFvHcVHb+0inYdwPjNEPMii6NorAKbyVuJgf8r6XsD8rH7K0c8PaW
	 l7veUsKVxrdNnDcieB4ENHs/ljCkfc8q0TPCHLxhStW9e1Js9QbYL6thrDL2RqMAGKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=UaWd7jiX;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CB9606A327
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Nov 2026 21:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61CB9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=UaWd7jiX
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so5672245a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Nov 2026 13:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793653435; x=1794258235; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YebZSF/Kl+cRxyBBQxMvp4KclRsEN0c74j2FIV9Omn0=;
        b=UaWd7jiX7aPrX0onnmdziF8xKaUMUe1DXJi/22kegt+mlA41nUSRy2eZn99zlM+ur1
         NKcNPvuJ8oTNfULGMlPYz17Ir1i7V/Q7mWi96JvN3r/R2W5dv1+g7Js9cDUXkrTjhAev
         7jMvVHHy+IP3/Cc8tTT+ZVbDz8YmdDra2MFcE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793653435; x=1794258235;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YebZSF/Kl+cRxyBBQxMvp4KclRsEN0c74j2FIV9Omn0=;
        b=qcB5t0mqd/Sy0+yrsYjt3sAwbX/skqFPe0KXFtPv45DTK5rXoUfgTSzygfauadtQRw
         tuUFjL1wV3JGBhTh9TiS5OKzbMy7PsOPDotX990yuV9zvTu9u05VsnN3kTLKRgrF54WI
         5GrTy/1PG/iCK50Kv09gJrh7TH25KMA7jMZfH83O2cSmtwhYeQWdatx7B61jyS1kTde8
         IhQQlu8YW+Xlxx/xeaQqpM7SuvPu7Uhowe49Fx49LHiXJWnMMjGv42hNv1ZY/9ISf4ix
         gezYMm5rE2M7o/fcrHmwZ9Fsqlq71rxJwwoJuGOAle+aPeXDN7KmrIrw1BiXBKWAMzaf
         fctA==
X-Forwarded-Encrypted: i=1; AKwUvBxd/J/Tbm3zsS6gk+PSIkq31iSJDJ0qIzc/dP/IT5ez/1XuXqZ3PE3GY+5LJTw5DMdXPOvIuJI6xj3fMr0y@vger.kernel.org
X-Gm-Message-State: APuU4Z/XSkf0CFmudQMK9ycxG1CRfNO13Uc9Ij6pPzyA6y1l3P3tuKH0
	OEq334CYJEqLMsTfYbT/mWjZLdad/kwylKe9A1HcuVmoflu/vadxIQsOp8WOZySyyimpl+LfPA7
	KJQr/5k2ucw==
X-Gm-Gg: AYBFou0x2hr/QfP3p26enApjG8V61ZD8KZG7E4DUAHX0oYr8XIFdcrNpNHVqyN3STyv
	RFrwDneJDzkYtyhU0XCyqgwWT0Y7cYsjDerh0HMTzRhPtXpeys/leBrCBHnyL+eR7Rty99gmCVr
	OUT9q0lujSnX9JQMBTFk627732D/LjtkLQj3yH1dEqckxW/X0Oehop9Vs0yLut67MXf+eBhWekv
	rwbPAsKHHsB4Udry0CViTj+LlSXyalJxDaJZqegCB/ptjwLnNdJkbLfUZDAbaa6CdERuQfNq+iJ
	lYBB9Cl1lf53ifMNV6uBkvMEm8Wk3K/wWHXNGuDLOH/dfnnbG8MklUdePEfFvDxpRWal2VyIuwh
	fMPMqUvdfWzt85Rg9nEesrbVgJ7v86cjsKqxoPi6Ea7WxgojrJ8fZSixZqRdQDncXlf5c4eV69M
	r4Sc5AlSyuceBx4IWf521htKTWyb040SB4vyePt1oABTFgAh8YAkee+TDKUr4zqy4m3Los6GRfY
	dmhZOxOAHqJ+TCG1A4BtUjT21/2pcBDdWrAPVcH++jZxeG7RUXD9WA1t5J4Fvw5s0sFdAu22I1r
	QFwfNH6ZDlk9p3FhUtPrk9mGncVgj6V/WHPkOyjM96L+JlJcCFQKEvzxIulUDKKoWriXqHGT/EN
	VfQ==
X-Received: by 2002:a05:6402:2344:b0:6b3:e575:f4da with SMTP id 4fb4d7f45d1cf-6b4d33ab55bmr8019718a12.4.1793653434733;
        Mon, 02 Nov 2026 13:03:54 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4eca1a522sm3491903a12.29.2026.11.02.13.03.52
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 13:03:54 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c247f6687dcso607642666b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Nov 2026 13:03:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzxlVck+gnGyleOulaQJSIyX3qrIcO0yGjimeG+sOX/ZsRs0FCEwXwtBobzZjuSSzU+g/MMC6/xdG95NeEe@vger.kernel.org
X-Received: by 2002:a17:907:3e22:b0:c40:9839:c892 with SMTP id
 a640c23a62f3a-c4ca7a407b5mr929069066b.19.1793653432126; Mon, 02 Nov 2026
 13:03:52 -0800 (PST)
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
 <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com> <CAHk-=wikNxjCHDOSqEDanyNqfbVRRKXetGcLzFn2zUsbhUUexw@mail.gmail.com>
In-Reply-To: <CAHk-=wikNxjCHDOSqEDanyNqfbVRRKXetGcLzFn2zUsbhUUexw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 13:03:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi0qNR+ZLqAk49fW-dJcGKLxgEXQveZPKHoA88VnchpGQ@mail.gmail.com>
X-Gm-Features: AclHuK-VR3TscPvD0CVCydv-TmYZyiiJ3WqZgGmQCuzmzg-qkiRCQeVPGw89q6Q
Message-ID: <CAHk-=wi0qNR+ZLqAk49fW-dJcGKLxgEXQveZPKHoA88VnchpGQ@mail.gmail.com>
Subject: Re: Return failure from take_dentry_name_snapshot() (Was: [GIT PULL]
 overlayfs fixes for 7.3)
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary="000000000000ac7e34065f517bf5"

--000000000000ac7e34065f517bf5
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 11:55, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think this attached patch is correct.

Bah. I think it *was* correct, but I hated the deep indentations and
wanted to add a few comments about the failure case.

So I rewrote it with a helper function, with he outer function doing
both the RCU read-side protection and the sequence number test:

  bool take_dentry_name_snapshot(struct name_snapshot *name, struct
dentry *dentry)
  {
        guard(rcu)();
        for (;;) {
                unsigned seq = read_seqcount_begin(&dentry->d_seq);
                bool retval = try_name_snapshot(name, dentry);
                if (!read_seqcount_retry(&dentry->d_seq, seq))
                        return retval;
                release_dentry_name_snapshot(name);
        }
  }

which makes it fairly straightforward (with the main subtlety just
being that try_name_snapshot() needs to set things up so that
release_dentry_name_snapshot() is ok to call even on failure, but that
was effectively true before too).

I have now looked at this code so much that I have semantic satiation
and it has lost all meaning.

Time to stop.

                   Linus

--000000000000ac7e34065f517bf5
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mvzqxbg00>
X-Attachment-Id: f_mvzqxbg00

IGZzL2RjYWNoZS5jICAgICAgICAgICAgfCA2NiArKysrKysrKysrKysrKysrKysrKystLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZnMvb3ZlcmxheWZzL3N1cGVyLmMgICB8IDEwICsrKy0t
LS0tCiBpbmNsdWRlL2xpbnV4L2RjYWNoZS5oIHwgIDMgKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDMy
IGluc2VydGlvbnMoKyksIDQ3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2RjYWNoZS5j
IGIvZnMvZGNhY2hlLmMKaW5kZXggNDA5Zjg0MWUwNThlLi5iMmZhNWYwYTY4YzQgMTAwNjQ0Ci0t
LSBhL2ZzL2RjYWNoZS5jCisrKyBiL2ZzL2RjYWNoZS5jCkBAIC0zNTksNTggKzM1OSw0OCBAQCBz
dGF0aWMgaW5saW5lIGludCBkbmFtZV9leHRlcm5hbChjb25zdCBzdHJ1Y3QgZGVudHJ5ICpkZW50
cnkpCiAJcmV0dXJuIGRlbnRyeS0+ZF9uYW1lLm5hbWUgIT0gZGVudHJ5LT5kX3Nob3J0bmFtZS5z
dHJpbmc7CiB9CiAKLXN0YXRpYyBib29sIF9fdGFrZV9kZW50cnlfbmFtZV9zbmFwc2hvdChzdHJ1
Y3QgbmFtZV9zbmFwc2hvdCAqbmFtZSwKLQkJCQkJc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBib29s
IHJldHJ5KQorc3RhdGljIGJvb2wgdHJ5X25hbWVfc25hcHNob3Qoc3RydWN0IG5hbWVfc25hcHNo
b3QgKm5hbWUsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIHsKLQl1bnNpZ25lZCBzZXE7Ci0JY29u
c3QgdW5zaWduZWQgY2hhciAqczsKKwljb25zdCB1bnNpZ25lZCBjaGFyICpzID0gUkVBRF9PTkNF
KGRlbnRyeS0+ZF9uYW1lLm5hbWUpOworCXN0cnVjdCBleHRlcm5hbF9uYW1lICpwOwogCi0JcmN1
X3JlYWRfbG9jaygpOwotcmV0cnk6Ci0Jc2VxID0gcmVhZF9zZXFjb3VudF9iZWdpbigmZGVudHJ5
LT5kX3NlcSk7Ci0JcyA9IFJFQURfT05DRShkZW50cnktPmRfbmFtZS5uYW1lKTsKIAluYW1lLT5u
YW1lLmhhc2hfbGVuID0gZGVudHJ5LT5kX25hbWUuaGFzaF9sZW47CiAJbmFtZS0+bmFtZS5uYW1l
ID0gbmFtZS0+aW5saW5lX25hbWUuc3RyaW5nOwogCWlmIChsaWtlbHkocyA9PSBkZW50cnktPmRf
c2hvcnRuYW1lLnN0cmluZykpIHsKIAkJbmFtZS0+aW5saW5lX25hbWUgPSBkZW50cnktPmRfc2hv
cnRuYW1lOwotCX0gZWxzZSB7Ci0JCXN0cnVjdCBleHRlcm5hbF9uYW1lICpwOwotCQlwID0gY29u
dGFpbmVyX29mKHMsIHN0cnVjdCBleHRlcm5hbF9uYW1lLCBuYW1lWzBdKTsKLQkJLy8gZ2V0IGEg
dmFsaWQgcmVmZXJlbmNlCi0JCWlmICh1bmxpa2VseSghYXRvbWljX2luY19ub3RfemVybygmcC0+
Y291bnQpKSkgewotCQkJaWYgKHJldHJ5KQotCQkJCWdvdG8gcmV0cnk7Ci0JCQlyY3VfcmVhZF91
bmxvY2soKTsKLQkJCXJldHVybiBmYWxzZTsKLQkJfQotCQluYW1lLT5uYW1lLm5hbWUgPSBzOwor
CQlyZXR1cm4gdHJ1ZTsKIAl9Ci0JaWYgKHJlYWRfc2VxY291bnRfcmV0cnkoJmRlbnRyeS0+ZF9z
ZXEsIHNlcSkpIHsKLQkJcmVsZWFzZV9kZW50cnlfbmFtZV9zbmFwc2hvdChuYW1lKTsKLQkJZ290
byByZXRyeTsKLQl9Ci0JcmN1X3JlYWRfdW5sb2NrKCk7CisKKwkvLyBUcnkgdG8gZ2V0IGEgdmFs
aWQgZXh0ZXJuYWwgcmVmZXJlbmNlCisJLy8KKwkvLyBJbiBjYXNlIHdlIGZhaWwgdG8gZ2V0IGEg
cmVmLCAnbmFtZS5uYW1lJyB3aWxsCisJLy8gcG9pbnQgdG8gdGhlIGlubGluZV9uYW1lLCB3aGlj
aCBsZWF2ZXMgdGhlIG5hbWUKKwkvLyBpbnZhbGlkLiBCdXQgcmVsZWFzZV9kZW50cnlfbmFtZV9z
bmFwc2hvdCgpIGNhbgorCS8vIGJlIGNhbGxlZCByZWdhcmRsZXNzLgorCXAgPSBjb250YWluZXJf
b2Yocywgc3RydWN0IGV4dGVybmFsX25hbWUsIG5hbWVbMF0pOworCWlmICh1bmxpa2VseSghYXRv
bWljX2luY19ub3RfemVybygmcC0+Y291bnQpKSkKKwkJcmV0dXJuIGZhbHNlOworCisJLy8gV2Ug
Z290IGEgcmVmIGFuZCB0aGUgbmFtZSBpcyBub3cgbmVlZHMgdG8gYmUKKwkvLyBmcmVlJ2QgcmVn
YXJkbGVzcyBvZiB3aGV0aGVyIHRoZSBzZXF1ZW5jZSBjb3VudAorCS8vIG1hdGNoZXMgb3Igbm90
CisJbmFtZS0+bmFtZS5uYW1lID0gczsKIAlyZXR1cm4gdHJ1ZTsKIH0KIAotdm9pZCB0YWtlX2Rl
bnRyeV9uYW1lX3NuYXBzaG90KHN0cnVjdCBuYW1lX3NuYXBzaG90ICpuYW1lLCBzdHJ1Y3QgZGVu
dHJ5ICpkZW50cnkpCitib29sIHRha2VfZGVudHJ5X25hbWVfc25hcHNob3Qoc3RydWN0IG5hbWVf
c25hcHNob3QgKm5hbWUsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIHsKLQlfX3Rha2VfZGVudHJ5
X25hbWVfc25hcHNob3QobmFtZSwgZGVudHJ5LCB0cnVlKTsKKwlndWFyZChyY3UpKCk7CisJZm9y
ICg7OykgeworCQl1bnNpZ25lZCBzZXEgPSByZWFkX3NlcWNvdW50X2JlZ2luKCZkZW50cnktPmRf
c2VxKTsKKwkJYm9vbCByZXR2YWwgPSB0cnlfbmFtZV9zbmFwc2hvdChuYW1lLCBkZW50cnkpOwor
CQlpZiAoIXJlYWRfc2VxY291bnRfcmV0cnkoJmRlbnRyeS0+ZF9zZXEsIHNlcSkpCisJCQlyZXR1
cm4gcmV0dmFsOworCQlyZWxlYXNlX2RlbnRyeV9uYW1lX3NuYXBzaG90KG5hbWUpOworCX0KIH0K
IEVYUE9SVF9TWU1CT0wodGFrZV9kZW50cnlfbmFtZV9zbmFwc2hvdCk7CiAKLS8qCi0gKiBGb3Ig
YSBjYWxsZXIgdGhhdCBob2xkcyBubyByZWZlcmVuY2Ugb24gQGRlbnRyeSwgZS5nLiBpbiBSQ1Ug
d2Fsay4KLSAqIFRoZSBleHRlcm5hbCBuYW1lIG9mIGEgZGVhZCBkZW50cnkgaGFzIGEgemVybyBy
ZWZjb3VudCBmb3JldmVyLCBzbwotICogdGFrZV9kZW50cnlfbmFtZV9zbmFwc2hvdCgpIHdvdWxk
IHJldHJ5IHdpdGhvdXQgZW5kLiAgRmFpbCBpbnN0ZWFkLgotICovCi1ib29sIHRyeV90YWtlX2Rl
bnRyeV9uYW1lX3NuYXBzaG90KHN0cnVjdCBuYW1lX3NuYXBzaG90ICpuYW1lLAotCQkJCSAgIHN0
cnVjdCBkZW50cnkgKmRlbnRyeSkKLXsKLQlyZXR1cm4gX190YWtlX2RlbnRyeV9uYW1lX3NuYXBz
aG90KG5hbWUsIGRlbnRyeSwgZmFsc2UpOwotfQotRVhQT1JUX1NZTUJPTCh0cnlfdGFrZV9kZW50
cnlfbmFtZV9zbmFwc2hvdCk7Ci0KIHZvaWQgcmVsZWFzZV9kZW50cnlfbmFtZV9zbmFwc2hvdChz
dHJ1Y3QgbmFtZV9zbmFwc2hvdCAqbmFtZSkKIHsKIAlpZiAodW5saWtlbHkobmFtZS0+bmFtZS5u
YW1lICE9IG5hbWUtPmlubGluZV9uYW1lLnN0cmluZykpIHsKZGlmZiAtLWdpdCBhL2ZzL292ZXJs
YXlmcy9zdXBlci5jIGIvZnMvb3ZlcmxheWZzL3N1cGVyLmMKaW5kZXggMDg2OTVhOTlmNGY5Li5k
OTE3NGVhY2NjZTIgMTAwNjQ0Ci0tLSBhL2ZzL292ZXJsYXlmcy9zdXBlci5jCisrKyBiL2ZzL292
ZXJsYXlmcy9zdXBlci5jCkBAIC0xMDAsMTcgKzEwMCwxMyBAQCBzdGF0aWMgaW50IG92bF9yZXZh
bGlkYXRlX3JlYWwoc3RydWN0IGRlbnRyeSAqZCwgdW5zaWduZWQgaW50IGZsYWdzLCBib29sIHdl
YWspCiAJCQlkaXIgPSBkX2lub2RlX3JjdShwYXJlbnQpOwogCQkJaWYgKCFkaXIpCiAJCQkJcmV0
dXJuIC1FQ0hJTEQ7Ci0JCQkvKgotCQkJICogTm90aGluZyBwaW5zIGQgaW4gUkNVIHdhbGs6IGV2
aWN0aW9uIG9mIHRoZSBvdmVybGF5Ci0JCQkgKiBpbm9kZSBtYXkgZHJvcCB0aGUgbGFzdCByZWZl
cmVuY2UgYXQgYW55IHRpbWUuCi0JCQkgKi8KLQkJCWlmICghdHJ5X3Rha2VfZGVudHJ5X25hbWVf
c25hcHNob3QoJm4sIGQpKQotCQkJCXJldHVybiAtRUNISUxEOwogCQl9IGVsc2UgewogCQkJcGFy
ZW50ID0gZGdldF9wYXJlbnQoZCk7CiAJCQlkaXIgPSBkX2lub2RlKHBhcmVudCk7Ci0JCQl0YWtl
X2RlbnRyeV9uYW1lX3NuYXBzaG90KCZuLCBkKTsKIAkJfQorCQkvKiBJbiBSQ1Ugd2FsayB0aGUg
ZGVudHJ5IG5hbWUgbWF5IGdvIGF3YXkgYXQgYW55IHRpbWUgKi8KKwkJaWYgKCF0YWtlX2RlbnRy
eV9uYW1lX3NuYXBzaG90KCZuLCBkKSkKKwkJCXJldHVybiAtRUNISUxEOwogCQlyZXQgPSBkLT5k
X29wLT5kX3JldmFsaWRhdGUoZGlyLCAmbi5uYW1lLCBkLCBmbGFncyk7CiAJCXJlbGVhc2VfZGVu
dHJ5X25hbWVfc25hcHNob3QoJm4pOwogCQlpZiAoIShmbGFncyAmIExPT0tVUF9SQ1UpKQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kY2FjaGUuaCBiL2luY2x1ZGUvbGludXgvZGNhY2hlLmgK
aW5kZXggODRiMGNmZTRlZDBlLi5hYWE0YmE3YTEyOTkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGlu
dXgvZGNhY2hlLmgKKysrIGIvaW5jbHVkZS9saW51eC9kY2FjaGUuaApAQCAtNjY0LDggKzY2NCw3
IEBAIHN0cnVjdCBuYW1lX3NuYXBzaG90IHsKIAlzdHJ1Y3QgcXN0ciBuYW1lOwogCXVuaW9uIHNo
b3J0bmFtZV9zdG9yZSBpbmxpbmVfbmFtZTsKIH07Ci12b2lkIHRha2VfZGVudHJ5X25hbWVfc25h
cHNob3Qoc3RydWN0IG5hbWVfc25hcHNob3QgKiwgc3RydWN0IGRlbnRyeSAqKTsKLWJvb2wgdHJ5
X3Rha2VfZGVudHJ5X25hbWVfc25hcHNob3Qoc3RydWN0IG5hbWVfc25hcHNob3QgKiwgc3RydWN0
IGRlbnRyeSAqKTsKK2Jvb2wgdGFrZV9kZW50cnlfbmFtZV9zbmFwc2hvdChzdHJ1Y3QgbmFtZV9z
bmFwc2hvdCAqLCBzdHJ1Y3QgZGVudHJ5ICopOwogdm9pZCByZWxlYXNlX2RlbnRyeV9uYW1lX3Nu
YXBzaG90KHN0cnVjdCBuYW1lX3NuYXBzaG90ICopOwogCiBzdGF0aWMgaW5saW5lIHN0cnVjdCBk
ZW50cnkgKmRfZmlyc3RfY2hpbGQoY29uc3Qgc3RydWN0IGRlbnRyeSAqZGVudHJ5KQo=
--000000000000ac7e34065f517bf5--
