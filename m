Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8DD38F9C;
	Thu, 29 Aug 2024 16:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948602; cv=none; b=SJSYBXYLpqn1Q7He7QIgiQ9l4RkhvlExAu0fayYCIq5ss9ervh57nub105GSg0tkSwwio4TLVqadXGoHgYNEYOUgcTPmi2vwAa+jLllQMsOGBnji72gKFQt/WAyNWpBFd8sEh/yA/BkTXW2z9a7Xqx7iICW3nzp5Y6hVQPzRzhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948602; c=relaxed/simple;
	bh=HSHgWwrsZJD1ptwjrnbM8g1GVjDesdARQCApeeTUp/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QBSAxukyF5tI5mmm3xFWL/CiUrewqBZKwbr+QNrhroZP5ffbjT12xRVv4+1d23Os0nY5KJKoKKqb+uiz2v2pT9vwPnuB1uVxSX41ZMOVUD4ImRfK09XTn0k6NbQtib2q7gp81xgl5dVNeUNJDR0FQj7Anb61NQSDXf9VPkzTc34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jckMpgKl; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jckMpgKl"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a7fa4cb3fdso53275085a.2;
        Thu, 29 Aug 2024 09:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724948599; x=1725553399; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wlFxL3RqJOUwOUHPGJSN6qqRIazSiOJ/SS/ZE3OVIRc=;
        b=jckMpgKlYyAbSCu5fN7mLCHlOc6lqEjP7e0bbbx1l5yN9W51sgHZdWcizClkuO+IVG
         W+bH2dS4wLDCvfTeTiNMefdSzA5p80sa3Xjnt6bQQtPrnaFV42HS+owLzJDNlI+7ivz+
         UMMe8telXe6mGBGNQxt7iAU248XIwSnrd23RaC+cS/WbZyiYiKqlZYEhggT/jkoIPlca
         vfMtQPwzKPnXnXNIxhcWsNC/F4mZgzEd0o3A8RXJt3FRAnMs002K6ExFFNgihsG/C69p
         2gcnMkRpy7g6XqA9Q+L1uCmNbcqGI1QPF1l1cLMlKUtrP332qYf2Edy98lEcv5q7KMCD
         VmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724948599; x=1725553399;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wlFxL3RqJOUwOUHPGJSN6qqRIazSiOJ/SS/ZE3OVIRc=;
        b=QMnoHBzxtJZjZ0T+VnJwsP+JmdEBjT8vamsEo4diJOvV8DCmBYuSMSYh+CwKF1BYA8
         1fxlAxOtnvv2az2cxlWGh20LZwcx2POEI6b0DeSi6mNWKD/VHPMOwLmKqRA5W9dBpoV5
         dzuFcs9Mt9En5fYmBWpn8KJErP3NPxlELlm4DErDe5iABU//D8LaTa0cF0WQWh0RQ6se
         vQBLgGZ9dI1kuc733Sl0gs4VJhX+qFzk92O5z/P6LtnKGCicpRyTv9m2wAPVKO2w85l/
         NPIdGoRk+EKzDYyXLssIA1QIo8JUsUmJnZLudr7lCyA1Pbv/XDB4NUsCxdxZKTaQg7On
         qrIA==
X-Forwarded-Encrypted: i=1; AJvYcCX3UAV817PyVT636ONm9kPLJni68Mg8ax4bEaA5FN5j7wupjOq/DlEuw9FtTvuKjoJbztYH/2yEAOhY1ZD6WQ==@vger.kernel.org, AJvYcCXYfL9qvso5Fos5UygU4wSBpsMrTa/dtEw2WnFKRmSK74ObTrNwBEFFLoY7b5Rmma0AKzSvC8Hm9hQykOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL5V94Y3L1YNAcsXxx9BwpmbzMEw/YcDFwuCTo1HkJ2t8M3XWK
	gmLP5kySjhID3S2cnHyClCqy+THrB9yR7OkKg1p8bnLOo8IBmaDqiKWXsCfw+jezPU2jwfztdxp
	6mPQbEbqmsrkFWV4f1OWAwo2wcnE=
X-Google-Smtp-Source: AGHT+IGjQnEvgwM29EjBZVK9jAL9B/+sF3jonFcd8BTwGL2A6ohRwkMbDlKxxU8O98pgtiaDYF7ZrWIXsFO/9H/zwao=
X-Received: by 2002:a05:620a:3901:b0:7a7:e050:d7e7 with SMTP id
 af79cd13be357-7a80427c280mr384618685a.63.1724948599516; Thu, 29 Aug 2024
 09:23:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
 <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com>
 <CAOQ4uxi-BuKU-AbyydVB2c8z0DiPP-Ednu+bN3JB2Cqf7rZamA@mail.gmail.com> <CAJfpegt=BLfdb5GRbsOHheStve8S57V9XRDN_cNKcxst2dKZzw@mail.gmail.com>
In-Reply-To: <CAJfpegt=BLfdb5GRbsOHheStve8S57V9XRDN_cNKcxst2dKZzw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Aug 2024 18:23:07 +0200
Message-ID: <CAOQ4uxhtoAL43d5HcVEsAH2EtgiT8h6RkjymNhTcP5nnG1h09g@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Fei Lv <feilv@asrmicro.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: multipart/mixed; boundary="00000000000087f02e0620d4e402"

--00000000000087f02e0620d4e402
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 2:51=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 29 Aug 2024 at 12:29, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > But maybe we can ignore crash safety of metacopy on ubifs, because
> > 1. the ubifs users may not be using this feature
> > 2. ubifs may be nice and takes care of ordering O_TMPFILE
> >     metadata updates before exposing the link
> >
> > Then we can do the following:
> > IF (metacopy_enabled)
> >     fsync only in ovl_copy_up_file()
> > ELSE
> >     fsync only in ovl_copy_up_metadata()
> >
> > Let me know what you think.
>
> Sounds like a good compromise.
>

Fei,

Could you please test the attached patch and confirm that your
use case does not depend on metacopy enabled?

In any case, I am holding on to your patch in case someone reports
a performance regression with this unconditional fsync approach.

Thanks,
Amir.

--00000000000087f02e0620d4e402
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ovl-fsync-after-metadata-copy-up.patch"
Content-Disposition: attachment; 
	filename="0001-ovl-fsync-after-metadata-copy-up.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m0fhum110>
X-Attachment-Id: f_m0fhum110

RnJvbSA2ZGRjNWJiZGQyMDEwZDkwZDdlY2EwYWJiMzQwZWFlZWFmYWZjMzhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDI5IEF1ZyAyMDI0IDE3OjUxOjA4ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBmc3luYyBhZnRlciBtZXRhZGF0YSBjb3B5LXVwCgpGb3IgdXBwZXIgZmlsZXN5c3RlbXMgd2hp
Y2ggZG8gbm90IHVzZSBzdHJpY3Qgb3JkZXJpbmcgb2YgcGVyc2lzdGluZwptZXRhZGF0YSBjaGFu
Z2VzIChlLmcuIHViaWZzKSwgd2hlbiBvdmVybGF5ZnMgZmlsZSBpcyBtb2RpZmllZCBmb3IKdGhl
IGZpcnN0IHRpbWUsIGNvcHkgdXAgd2lsbCBjcmVhdGUgYSBjb3B5IG9mIHRoZSBsb3dlciBmaWxl
IGFuZAppdHMgcGFyZW50IGRpcmVjdG9yaWVzIGluIHRoZSB1cHBlciBsYXllci4gUGVybWlzc2lv
biBsb3N0IG9mIHRoZQpuZXcgdXBwZXIgcGFyZW50IGRpcmVjdG9yeSB3YXMgb2JzZXJ2ZWQgZHVy
aW5nIHBvd2VyLWN1dCBzdHJlc3MgdGVzdC4KCkZpeCBieSBtb3ZpbmcgdGhlIGZzeW5jIGNhbGwg
YWZ0ZXIgbWV0YWRhdGEgY29weSB0byBtYWtlIHN1cmUgdGhhdCB0aGUKbWV0YWRhdGEgY29waWVk
IHVwIGRpcmVjdG9yeSBhbmQgZmlsZXMgcGVyc2lzdHMgdG8gZGlzayBiZWZvcmUgcmVuYW1pbmcK
ZnJvbSB0bXAgdG8gZmluYWwgZGVzdGluYXRpb24uCgpXaXRoIG1ldGFjb3B5IGVuYWJsZWQsIHRo
aXMgY2hhbmdlIHdpbGwgaHVydCBwZXJmb3JtYW5jZSBvZiB3b3JrbG9hZHMKc3VjaCBhcyBjaG93
biAtUiwgc28gd2Uga2VlcCB0aGUgbGVnYWN5IGJlaGF2aW9yIG9mIGZzeW5jIG9uIGRhdGEgY29w
eXVwCmFuZCBuZXZlciBmc3luYyBvbiBjb3B5dXAgb2YgbWV0YWRhdGEgb2YgZmlsZXMgYW5kIGRp
cmVjdG9yaWVzLgoKTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtdW5pb25mcy9D
QU9RNHV4ai1wT3ZtdzEtdVhSM3FWZHF0TGpTa3djUjluVktjTlVfdkMxMFp5ZjJtaVFAbWFpbC5n
bWFpbC5jb20vClJlcG9ydGVkLWJ5OiBGZWkgTHYgPGZlaWx2QGFzcm1pY3JvLmNvbT4KU2lnbmVk
LW9mZi1ieTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KLS0tCiBmcy9vdmVy
bGF5ZnMvY29weV91cC5jIHwgNDMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tCiAxIGZpbGUgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvY29weV91cC5jIGIvZnMvb3ZlcmxheWZzL2NvcHlf
dXAuYwppbmRleCBhNWVmMjAwNWEyY2MuLmU5MzQ4YWMxNTQ4YSAxMDA2NDQKLS0tIGEvZnMvb3Zl
cmxheWZzL2NvcHlfdXAuYworKysgYi9mcy9vdmVybGF5ZnMvY29weV91cC5jCkBAIC0yNDMsOCAr
MjQzLDI0IEBAIHN0YXRpYyBpbnQgb3ZsX3ZlcmlmeV9hcmVhKGxvZmZfdCBwb3MsIGxvZmZfdCBw
b3MyLCBsb2ZmX3QgbGVuLCBsb2ZmX3QgdG90bGVuKQogCXJldHVybiAwOwogfQogCitzdGF0aWMg
aW50IG92bF9zeW5jX2ZpbGUoc3RydWN0IHBhdGggKnBhdGgpCit7CisJc3RydWN0IGZpbGUgKm5l
d19maWxlOworCWludCBlcnI7CisKKwluZXdfZmlsZSA9IG92bF9wYXRoX29wZW4ocGF0aCwgT19S
RE9OTFkpOworCWlmIChJU19FUlIobmV3X2ZpbGUpKQorCQlyZXR1cm4gUFRSX0VSUihuZXdfZmls
ZSk7CisKKwllcnIgPSB2ZnNfZnN5bmMobmV3X2ZpbGUsIDApOworCWZwdXQobmV3X2ZpbGUpOwor
CisJcmV0dXJuIGVycjsKK30KKwogc3RhdGljIGludCBvdmxfY29weV91cF9maWxlKHN0cnVjdCBv
dmxfZnMgKm9mcywgc3RydWN0IGRlbnRyeSAqZGVudHJ5LAotCQkJICAgIHN0cnVjdCBmaWxlICpu
ZXdfZmlsZSwgbG9mZl90IGxlbikKKwkJCSAgICBzdHJ1Y3QgZmlsZSAqbmV3X2ZpbGUsIGxvZmZf
dCBsZW4sCisJCQkgICAgYm9vbCBkYXRhc3luYykKIHsKIAlzdHJ1Y3QgcGF0aCBkYXRhcGF0aDsK
IAlzdHJ1Y3QgZmlsZSAqb2xkX2ZpbGU7CkBAIC0zNDIsNyArMzU4LDggQEAgc3RhdGljIGludCBv
dmxfY29weV91cF9maWxlKHN0cnVjdCBvdmxfZnMgKm9mcywgc3RydWN0IGRlbnRyeSAqZGVudHJ5
LAogCiAJCWxlbiAtPSBieXRlczsKIAl9Ci0JaWYgKCFlcnJvciAmJiBvdmxfc2hvdWxkX3N5bmMo
b2ZzKSkKKwkvKiBjYWxsIGZzeW5jIG9uY2UsIGVpdGhlciBub3cgb3IgbGF0ZXIgYWxvbmcgd2l0
aCBtZXRhZGF0YSAqLworCWlmICghZXJyb3IgJiYgb3ZsX3Nob3VsZF9zeW5jKG9mcykgJiYgZGF0
YXN5bmMpCiAJCWVycm9yID0gdmZzX2ZzeW5jKG5ld19maWxlLCAwKTsKIG91dF9mcHV0OgogCWZw
dXQob2xkX2ZpbGUpOwpAQCAtNTc0LDYgKzU5MSw3IEBAIHN0cnVjdCBvdmxfY29weV91cF9jdHgg
ewogCWJvb2wgaW5kZXhlZDsKIAlib29sIG1ldGFjb3B5OwogCWJvb2wgbWV0YWNvcHlfZGlnZXN0
OworCWJvb2wgbWV0YWRhdGFfZnN5bmM7CiB9OwogCiBzdGF0aWMgaW50IG92bF9saW5rX3VwKHN0
cnVjdCBvdmxfY29weV91cF9jdHggKmMpCkBAIC02MzQsNyArNjUyLDggQEAgc3RhdGljIGludCBv
dmxfY29weV91cF9kYXRhKHN0cnVjdCBvdmxfY29weV91cF9jdHggKmMsIGNvbnN0IHN0cnVjdCBw
YXRoICp0ZW1wKQogCWlmIChJU19FUlIobmV3X2ZpbGUpKQogCQlyZXR1cm4gUFRSX0VSUihuZXdf
ZmlsZSk7CiAKLQllcnIgPSBvdmxfY29weV91cF9maWxlKG9mcywgYy0+ZGVudHJ5LCBuZXdfZmls
ZSwgYy0+c3RhdC5zaXplKTsKKwllcnIgPSBvdmxfY29weV91cF9maWxlKG9mcywgYy0+ZGVudHJ5
LCBuZXdfZmlsZSwgYy0+c3RhdC5zaXplLAorCQkJICAgICAgICFjLT5tZXRhZGF0YV9mc3luYyk7
CiAJZnB1dChuZXdfZmlsZSk7CiAKIAlyZXR1cm4gZXJyOwpAQCAtNzAxLDYgKzcyMCwxMCBAQCBz
dGF0aWMgaW50IG92bF9jb3B5X3VwX21ldGFkYXRhKHN0cnVjdCBvdmxfY29weV91cF9jdHggKmMs
IHN0cnVjdCBkZW50cnkgKnRlbXApCiAJCWVyciA9IG92bF9zZXRfYXR0cihvZnMsIHRlbXAsICZj
LT5zdGF0KTsKIAlpbm9kZV91bmxvY2sodGVtcC0+ZF9pbm9kZSk7CiAKKwkvKiBmc3luYyBtZXRh
ZGF0YSBiZWZvcmUgbW92ZSBpbnRvIHVwcGVyIGRpciAqLworCWlmICghZXJyICYmIG92bF9zaG91
bGRfc3luYyhvZnMpICYmIGMtPm1ldGFkYXRhX2ZzeW5jKQorCQllcnIgPSBvdmxfc3luY19maWxl
KCZ1cHBlcnBhdGgpOworCiAJcmV0dXJuIGVycjsKIH0KIApAQCAtODYwLDcgKzg4Myw4IEBAIHN0
YXRpYyBpbnQgb3ZsX2NvcHlfdXBfdG1wZmlsZShzdHJ1Y3Qgb3ZsX2NvcHlfdXBfY3R4ICpjKQog
CiAJdGVtcCA9IHRtcGZpbGUtPmZfcGF0aC5kZW50cnk7CiAJaWYgKCFjLT5tZXRhY29weSAmJiBj
LT5zdGF0LnNpemUpIHsKLQkJZXJyID0gb3ZsX2NvcHlfdXBfZmlsZShvZnMsIGMtPmRlbnRyeSwg
dG1wZmlsZSwgYy0+c3RhdC5zaXplKTsKKwkJZXJyID0gb3ZsX2NvcHlfdXBfZmlsZShvZnMsIGMt
PmRlbnRyeSwgdG1wZmlsZSwgYy0+c3RhdC5zaXplLAorCQkJCSAgICAgICAhYy0+bWV0YWRhdGFf
ZnN5bmMpOwogCQlpZiAoZXJyKQogCQkJZ290byBvdXRfZnB1dDsKIAl9CkBAIC0xMTM1LDYgKzEx
NTksMTcgQEAgc3RhdGljIGludCBvdmxfY29weV91cF9vbmUoc3RydWN0IGRlbnRyeSAqcGFyZW50
LCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnksCiAJICAgICFrZ2lkX2hhc19tYXBwaW5nKGN1cnJlbnRf
dXNlcl9ucygpLCBjdHguc3RhdC5naWQpKQogCQlyZXR1cm4gLUVPVkVSRkxPVzsKIAorCS8qCisJ
ICogV2l0aCBtZXRhY29weSBkaXNhYmxlZCwgd2UgZnN5bmMgYWZ0ZXIgZmluYWwgbWV0YWRhdGEg
Y29weXVwLCBmb3IKKwkgKiBib3RoIHJlZ3VsYXIgYW5kIG5vbi1yZWd1bGFyIGZpbGVzIHRvIGdl
dCBhdG9taWMgY29weXVwIHNlbWFudGljcworCSAqIG9uIGZpbGVzeXN0ZW1zIHRoYXQgZG8gbm90
IHVzZSBzdHJpY3QgbWV0YWRhdGEgb3JkZXJpbmcgKGUuZy4gdWJpZnMpLgorCSAqCisJICogV2l0
aCBtZXRhY29weSBlbmFibGVkIHdlIHdhbnQgdG8gYXZvaWQgZnN5bmMgb24gYWxsIG1ldGEgY29w
eXVwCisJICogdGhhdCB3aWxsIGh1cnQgcGVyZm9ybWFuY2Ugb2Ygd29ya2xvYWRzIHN1Y2ggYXMg
Y2hvd24gLVIsIHNvIHdlCisJICogb25seSBmc3luYyBvbiBkYXRhIGNvcHl1cCBhbmQgbmV2ZXIg
ZnN5bmMgb24gY29weXVwIG9mIG5vbi1yZWd1bGFyCisJICogZmlsZXMgYW5kIGRpcmVjdG9yaWVz
LgorCSAqLworCWN0eC5tZXRhZGF0YV9mc3luYyA9ICFPVkxfRlMoZGVudHJ5LT5kX3NiKS0+Y29u
ZmlnLm1ldGFjb3B5OwogCWN0eC5tZXRhY29weSA9IG92bF9uZWVkX21ldGFfY29weV91cChkZW50
cnksIGN0eC5zdGF0Lm1vZGUsIGZsYWdzKTsKIAogCWlmIChwYXJlbnQpIHsKLS0gCjIuMzQuMQoK
--00000000000087f02e0620d4e402--
