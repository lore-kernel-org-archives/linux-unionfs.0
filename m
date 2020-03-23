Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31325C3F2CD
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 14:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0591F20753
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 14:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Dl2eQUaY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgCWOxh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 10:53:37 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:37026 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgCWOxh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 10:53:37 -0400
Received: by mail-io1-f45.google.com with SMTP id q9so14420995iod.4
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 07:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ElAsFwiTrsYFv4ELJbPBJ+9jv94sX5hsmLBXBByBPA=;
        b=Dl2eQUaYSaXON1ZVom+AFHxg5xxqkhPC+DFRa87H9ii6PiRZldQOuSwRldgU/bP2bx
         LTL3AOnGXWgqrHN4rVBPt00H6Mes60sCI4fVNg4dxAiQsqPDFrd+fpPHhtqJmog+DpX8
         XZ7v60T+AK83nwZUXKaMd8HxLeRt2Pq/VlwU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ElAsFwiTrsYFv4ELJbPBJ+9jv94sX5hsmLBXBByBPA=;
        b=NRCzmpwhMOd0HvRb/PtfIk/0bxzlVynHNnEqzZKfx21LyoXZ0j9JLeV2ACI6qfwvbj
         sgtpkC0xw62l24qlGTJUfwjCYlpWPXmLXSFzdYRoJoLBB9piZbgYFkg3+SO/0OkVfMRE
         LvOW1B2cQUJdE/D+awYzc4/mpLXD5PsxBcptb/5AJXPZu/SyIX/ckzJFODcvT6J/6+lT
         anETqfS0TX1a3jY4EB2FozFEs5dL3B9GqQCXHuROYRuj1ysTO+2V3/D7sQ8sOQTgUA4h
         vN7xRwikKo+nq7Bl8ApIoAX/EW6nOUKpng6eBe9WHVxIW5/V+UqHg9keOjqnljSSafvu
         MVew==
X-Gm-Message-State: ANhLgQ0Jz7nQQRga3gq6rHezhEuoeYO9TKEXE/xHhlF0PLJsJe9hfr+W
        jbwij0/4ZI4jNWqPJq6EMXcpFQMGM73Vj9Jh5q32mw==
X-Google-Smtp-Source: ADFU+vssLiMCrScS2iV06WicxJtvV50gBbBYgCc7p4eWIxMYR2Xl5FTuZX83zOJj+aVyjYyhMkmbLjATHccn1o/KJCI=
X-Received: by 2002:a05:6638:951:: with SMTP id f17mr98306jad.35.1584975215893;
 Mon, 23 Mar 2020 07:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
 <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com>
 <CAOQ4uxiW2-Hh_sfuYXeuQy=a6FYBm7DyWkysgEe1GnC-qWWivg@mail.gmail.com> <CAJfpegtCn-HLhuDB98G4dO8L-t2PMcqcwDw+0TiknU5LGvBacQ@mail.gmail.com>
In-Reply-To: <CAJfpegtCn-HLhuDB98G4dO8L-t2PMcqcwDw+0TiknU5LGvBacQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 23 Mar 2020 15:53:24 +0100
Message-ID: <CAJfpeguKujUqW-z75F+6mCh0uwHF6rz2cK4OWUCFe83QNmaSrQ@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Phasip <phasip@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b8ebd305a186ccb0"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000b8ebd305a186ccb0
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 23, 2020 at 3:21 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Mar 23, 2020 at 2:24 PM Amir Goldstein <amir73il@gmail.com> wrote:

> > IDGI. coming from vfs_unlink() and vfs_rename() it doesn't look like
> > it is possible for victim inode not to have a hashed alias, so the
> > alias test seems futile.
>
> Yeah, needs a comment: both ovl_remove_upper() and
> ovl_remove_and_whiteout() unhash the dentry before returning, so
> d_find_alias() will find another hashed dentry or none.

Except that doesn't seem to be true for the overwriting rename case...

Attached patch should work for both.

Thanks,
Miklos

--000000000000b8ebd305a186ccb0
Content-Type: text/x-patch; charset="US-ASCII"; name="ovl-prevent-negative-nlink-v2.patch"
Content-Disposition: attachment; 
	filename="ovl-prevent-negative-nlink-v2.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k84lauj80>
X-Attachment-Id: f_k84lauj80

LS0tCiBmcy9vdmVybGF5ZnMvZGlyLmMgfCAgIDI1ICsrKysrKysrKysrKysrKysrKysrKysrLS0K
IDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKLS0tIGEv
ZnMvb3ZlcmxheWZzL2Rpci5jCisrKyBiL2ZzL292ZXJsYXlmcy9kaXIuYwpAQCAtODE5LDYgKzgx
OSwyNyBAQCBzdGF0aWMgYm9vbCBvdmxfcHVyZV91cHBlcihzdHJ1Y3QgZGVudHJ5CiAJICAgICAg
ICFvdmxfdGVzdF9mbGFnKE9WTF9XSElURU9VVFMsIGRfaW5vZGUoZGVudHJ5KSk7CiB9CiAKK3N0
YXRpYyB2b2lkIG92bF9kcm9wX25saW5rKHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKK3sKKwlzdHJ1
Y3QgaW5vZGUgKmlub2RlID0gZF9pbm9kZShkZW50cnkpOworCXN0cnVjdCBkZW50cnkgKmFsaWFz
OworCisJc3Bpbl9sb2NrKCZpbm9kZS0+aV9sb2NrKTsKKwlobGlzdF9mb3JfZWFjaF9lbnRyeShh
bGlhcywgJmlub2RlLT5pX2RlbnRyeSwgZF91LmRfYWxpYXMpIHsKKyAJCWlmIChhbGlhcyAhPSBk
ZW50cnkgJiYgIWRfdW5oYXNoZWQoYWxpYXMpKQorCQkJYnJlYWs7CisJfQorCXNwaW5fdW5sb2Nr
KCZpbm9kZS0+aV9sb2NrKTsKKworCS8qCisJICogQ2hhbmdlcyB0byB1bmRlcmx5aW5nIGxheWVy
cyBtYXkgY2F1c2UgaV9ubGluayB0byBsb3NlIHN5bmMgd2l0aAorCSAqIHJlYWxpdHkuICBJbiB0
aGlzIGNhc2UgcHJldmVudCB0aGUgbGluayBjb3VudCBmcm9tIGdvaW5nIHRvIHplcm8KKwkgKiBw
cmVtYXR1cmVseS4KKwkgKi8KKwlpZiAoaW5vZGUtPmlfbmxpbmsgPiAhIWFsaWFzKQorCQlkcm9w
X25saW5rKGlub2RlKTsKK30KKwogc3RhdGljIGludCBvdmxfZG9fcmVtb3ZlKHN0cnVjdCBkZW50
cnkgKmRlbnRyeSwgYm9vbCBpc19kaXIpCiB7CiAJaW50IGVycjsKQEAgLTg1Niw3ICs4NzcsNyBA
QCBzdGF0aWMgaW50IG92bF9kb19yZW1vdmUoc3RydWN0IGRlbnRyeSAqCiAJCWlmIChpc19kaXIp
CiAJCQljbGVhcl9ubGluayhkZW50cnktPmRfaW5vZGUpOwogCQllbHNlCi0JCQlkcm9wX25saW5r
KGRlbnRyeS0+ZF9pbm9kZSk7CisJCQlvdmxfZHJvcF9ubGluayhkZW50cnkpOwogCX0KIAlvdmxf
bmxpbmtfZW5kKGRlbnRyeSk7CiAKQEAgLTEyMDEsNyArMTIyMiw3IEBAIHN0YXRpYyBpbnQgb3Zs
X3JlbmFtZShzdHJ1Y3QgaW5vZGUgKm9sZGQKIAkJaWYgKG5ld19pc19kaXIpCiAJCQljbGVhcl9u
bGluayhkX2lub2RlKG5ldykpOwogCQllbHNlCi0JCQlkcm9wX25saW5rKGRfaW5vZGUobmV3KSk7
CisJCQlvdmxfZHJvcF9ubGluayhuZXcpOwogCX0KIAogCW92bF9kaXJfbW9kaWZpZWQob2xkLT5k
X3BhcmVudCwgb3ZsX3R5cGVfb3JpZ2luKG9sZCkgfHwK
--000000000000b8ebd305a186ccb0--
