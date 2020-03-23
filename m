Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4ACC4332B
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 12:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEB582072E
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 12:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QVxLYELj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgCWMwm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 08:52:42 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:39596 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgCWMwm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 08:52:42 -0400
Received: by mail-il1-f194.google.com with SMTP id r5so8246633ilq.6
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 05:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IcOWTOtqmX1E/EYkmRLpi3dPVhI2hFkT9lG9qin39S0=;
        b=QVxLYELjtHNt7D5QUtzraLo0QKuL02JWs392xNhXMGstbymSD5WHCygaSR6pfrhevX
         R0omNQ/ykDjDXwxv4BH8TTFaRWFIwd90lBFJqaKqkxI/bfasvGEyUOyEEptSOXSl7IEn
         saiHR6Jbsb6ZK52QuSchqX/95kr/ujvVkQDt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IcOWTOtqmX1E/EYkmRLpi3dPVhI2hFkT9lG9qin39S0=;
        b=lNRntvh9x+Cz+locxtjiC8vobtzCXT0DpT/qgXzZe7DuZ4OZ/11j/c/f2rQJOtyE6M
         1y5/SsM0MkiAGLO/I5/npju6Q+CokfuaN0pHHBd9gv9f+ZNh5wtMpzFNbU7epBEKGMyk
         3nnd0OoJd1mZMY59uipl3CG5SImT4w6CEF6XVsqoqlqqno3BUm8F+bLSddepUbVvOGe2
         lMEVoILxJSgb20tqUIs114ypAYBkYIOHDBqnHZg/fD+E6pf0gf4ao7SWnWwQCKCRcRT5
         Gspsyz4pQTtqb8MWixp+Yg14ZxRK7Difaa1zN3fh6x4eNNn44yxuSjnpa/Y+Dg7h1+WF
         9qZg==
X-Gm-Message-State: ANhLgQ3STtBokbxha7aHuwPlA9mjAgPKHl/bFcGdpBMnumA12Ulqmu0i
        w4ZmD7V8VUVvWZYX0Y7yCjB1Xh0aQ40hzdOH/iwylg==
X-Google-Smtp-Source: ADFU+vuPuGnEwsk2AaxsNwI1rQNSgbYgs8SgjdaUagX3ASq4Kyi9XB8xoQQJCl8azyfj+/NDBNUu1XW5VKhcpFaDw3o=
X-Received: by 2002:a92:3b8c:: with SMTP id n12mr20579886ilh.186.1584967959586;
 Mon, 23 Mar 2020 05:52:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
In-Reply-To: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 23 Mar 2020 13:52:28 +0100
Message-ID: <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     Phasip <phasip@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000036842a05a1851c95"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--00000000000036842a05a1851c95
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 23, 2020 at 9:50 AM Phasip <phasip@gmail.com> wrote:
>
> Hello!
>
> I have stumbled upon two ways of producing kernel warnings when using the overlayfs, both seem to be results of the same issue.
>
> The issue seems to be related to handling of hard links that are created directly in the upperdir.
> Below is my system details and then two samples with a list of commands to reproduce and the corresponding kernel warning

Hi,

Thanks for the report.

The problem is that i_nlink is not kept in sync with changes to
underlying layers.   That would not in itself be an issue, since
modification of the underlying layers may result in
undefined/unexpected behavior.  The problem is that this manifests
itself as a kernel warning.

Since unlink/rename is synchronized on the victim inode (the one that
is getting removed) it is possible to detect this condition and
prevent drop_nlink() from being called.

Attached patch fixes both of your testcases.

We'll need an xfstests case for this as well.

Thanks,
Miklos

--00000000000036842a05a1851c95
Content-Type: text/x-patch; charset="US-ASCII"; name="ovl-prevent-negative-nlink.patch"
Content-Disposition: attachment; filename="ovl-prevent-negative-nlink.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k84gy7y30>
X-Attachment-Id: f_k84gy7y30

LS0tCiBmcy9vdmVybGF5ZnMvZGlyLmMgfCAgIDE4ICsrKysrKysrKysrKysrKystLQogMSBmaWxl
IGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgotLS0gYS9mcy9vdmVy
bGF5ZnMvZGlyLmMKKysrIGIvZnMvb3ZlcmxheWZzL2Rpci5jCkBAIC04MTksNiArODE5LDIwIEBA
IHN0YXRpYyBib29sIG92bF9wdXJlX3VwcGVyKHN0cnVjdCBkZW50cnkKIAkgICAgICAgIW92bF90
ZXN0X2ZsYWcoT1ZMX1dISVRFT1VUUywgZF9pbm9kZShkZW50cnkpKTsKIH0KIAorc3RhdGljIHZv
aWQgb3ZsX2Ryb3Bfbmxpbmsoc3RydWN0IGlub2RlICppbm9kZSkKK3sKKwlzdHJ1Y3QgZGVudHJ5
ICphbGlhcyA9IGRfZmluZF9hbGlhcyhpbm9kZSk7CisKKwlkcHV0KGFsaWFzKTsKKwkvKgorCSAq
IENoYW5nZXMgdG8gdW5kZXJseWluZyBsYXllcnMgbWF5IGNhdXNlIGlfbmxpbmsgdG8gbG9zZSBz
eW5jIHdpdGgKKwkgKiByZWFsaXR5LiAgSW4gdGhpcyBjYXNlIHByZXZlbnQgdGhlIGxpbmsgY291
bnQgZnJvbSBnb2luZyB0byB6ZXJvCisJICogcHJlbWF0dXJlbHkuCisJICovCisJaWYgKGlub2Rl
LT5pX25saW5rID4gISFhbGlhcykKKwkJZHJvcF9ubGluayhpbm9kZSk7Cit9CisKIHN0YXRpYyBp
bnQgb3ZsX2RvX3JlbW92ZShzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIGJvb2wgaXNfZGlyKQogewog
CWludCBlcnI7CkBAIC04NTYsNyArODcwLDcgQEAgc3RhdGljIGludCBvdmxfZG9fcmVtb3ZlKHN0
cnVjdCBkZW50cnkgKgogCQlpZiAoaXNfZGlyKQogCQkJY2xlYXJfbmxpbmsoZGVudHJ5LT5kX2lu
b2RlKTsKIAkJZWxzZQotCQkJZHJvcF9ubGluayhkZW50cnktPmRfaW5vZGUpOworCQkJb3ZsX2Ry
b3BfbmxpbmsoZGVudHJ5LT5kX2lub2RlKTsKIAl9CiAJb3ZsX25saW5rX2VuZChkZW50cnkpOwog
CkBAIC0xMjAxLDcgKzEyMTUsNyBAQCBzdGF0aWMgaW50IG92bF9yZW5hbWUoc3RydWN0IGlub2Rl
ICpvbGRkCiAJCWlmIChuZXdfaXNfZGlyKQogCQkJY2xlYXJfbmxpbmsoZF9pbm9kZShuZXcpKTsK
IAkJZWxzZQotCQkJZHJvcF9ubGluayhkX2lub2RlKG5ldykpOworCQkJb3ZsX2Ryb3Bfbmxpbmso
ZF9pbm9kZShuZXcpKTsKIAl9CiAKIAlvdmxfZGlyX21vZGlmaWVkKG9sZC0+ZF9wYXJlbnQsIG92
bF90eXBlX29yaWdpbihvbGQpIHx8Cg==
--00000000000036842a05a1851c95--
