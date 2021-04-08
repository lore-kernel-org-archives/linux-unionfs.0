Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6786C433B4
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 15:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95BB610F9
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 15:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhDHPED (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 11:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhDHPEC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 11:04:02 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70945C061760
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Apr 2021 08:03:51 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id h34so807643uah.5
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Apr 2021 08:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3YMZd+91OlMv1mNoboEz/1Joy/QbyJpjYt+dWQ+XYwg=;
        b=TleuUpUevKviZLmi+0YttoKGp2d5yZ6aSeEpaJK2qzmpcywwapTWQNi45irZVCg1vJ
         hXp2mSfFH3DqG1B10hkas1KAp9ikplecL7IcRcokHVI9Bh4fJjQ0hb2oHON8qbzgV2Vj
         txK/SSbyH4TLLG7kKSwCsPLuOcaT7/IsfLdOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3YMZd+91OlMv1mNoboEz/1Joy/QbyJpjYt+dWQ+XYwg=;
        b=Rm63JcnM3/wt6Nk6FI7kHqJmUq93Qycw5NqelwDLhTEfYwqY9EJ4r/YOXBIRwIpFGB
         nXXoySoxyc2BBp0/tKpiNktQKpVMB7NmfWssT3ihMIydXu0kaWvmzU3S/p1GvXsgPxwr
         50dQVnquVTht7qR9eD+UuCjSxfB8w24crzCnGRcnWFJDJZhK2ss45LT3dBS5o+BYKgZu
         p4+7II4KsOPDuhEk5S/0lhonFzy//SL3P6mXfqx5EyMAKnQAMLb5BlbpwEZSY/Bcxiot
         8dG7JhnDszWGl6pmtHFZrWyXIEuttjjY0yjN4pqSVCqfJGxSWN9asxL8/LQGHax52U6X
         PGPg==
X-Gm-Message-State: AOAM531rBpLRbdBU975e6Tg7npQbAAYcRJTsC9jKqNicZdOrhh15vywH
        QIiLXkbjUb1PZWr2x7gEsPtWDJAXK51/euYxJgNMpYRA13lf3Q==
X-Google-Smtp-Source: ABdhPJxZvgnSzBaoNpbuGDFymfpBa2eEOYfC/xLkC9JttJveD6CsUzseU3RVGARzSSaiSsya6NAhJUIt94uV0bKdPoE=
X-Received: by 2002:ab0:596f:: with SMTP id o44mr6274877uad.8.1617894230680;
 Thu, 08 Apr 2021 08:03:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210408112042.2586996-1-cgxu519@mykernel.net>
 <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net>
 <CAJfpegt5vVAtik=SXL26G0Tjh8yzZ6DvD6wLtfbXTinqpkxVeg@mail.gmail.com> <178b1482b24.108404c2418483.4334767487912126386@mykernel.net>
In-Reply-To: <178b1482b24.108404c2418483.4334767487912126386@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 8 Apr 2021 17:03:39 +0200
Message-ID: <CAJfpegvbrz3=nL2ETb+nY9G2cBTu4sC_sAhdxnVdHCN7Y1JFfg@mail.gmail.com>
Subject: Re: [PATCH] ovl: check VM_DENYWRITE mappings in copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e7964c05bf775aa1"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000e7964c05bf775aa1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 8, 2021 at 1:40 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:29:55 Miklos S=
zeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
>  > On Thu, Apr 8, 2021 at 1:28 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:20:42 Che=
ngguang Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
>  > >  > In overlayfs copy-up, if open flag has O_TRUNC then upper
>  > >  > file will truncate to zero size, in this case we should check
>  > >  > VM_DENYWRITE mappings to keep compatibility with other filesystem=
s.
>  >
>  > Can you provide a test case for the bug that this is fixing?
>  >
>
> Execute binary file(keep running until open) in overlayfs which only has =
lower && open the binary file with flag O_RDWR|O_TRUNC
>
> Expected result: open fail with -ETXTBSY
>
> Actual result: open success

Worse,  it's possible to get a "Bus error" with just execute and write
on an overlayfs file, which i_writecount is supposed to protect.

The reason is that the put_write_access() call in __vma_link_file()
assumes an already negative writecount, but because of the vm_file
shuffle in ovl_mmap() that's not guaranteed.   There's even a comment
about exactly this situation in mmap():

/* ->mmap() can change vma->vm_file, but must guarantee that
* vma_link() below can deny write-access if VM_DENYWRITE is set
* and map writably if VM_SHARED is set. This usually means the
* new file must not have been exposed to user-space, yet.
*/

The attached patch fixes this, but not your original bug.

That could be addressed by checking the writecount on *both* lower and
upper for open for write/truncate.  Note: this could be checked before
copy-up, but that's not reliable alone, because the copy up could
happen due to meta-data update, for example, and then the
open/truncate wouldn't trigger the writecount check.

Something like the second attached patch?

Thanks,
Miklos

--000000000000e7964c05bf775aa1
Content-Type: text/x-patch; charset="US-ASCII"; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kn90exy80>
X-Attachment-Id: f_kn90exy80

ZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9maWxlLmMgYi9mcy9vdmVybGF5ZnMvZmlsZS5jCmlu
ZGV4IGRiZmIzNWZiMGZmNy4uNWI1YjQ0MTBjMGY0IDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMv
ZmlsZS5jCisrKyBiL2ZzL292ZXJsYXlmcy9maWxlLmMKQEAgLTQyMiw2ICs0MjIsNyBAQCBzdGF0
aWMgaW50IG92bF9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3Qg
KnZtYSkKIHsKIAlzdHJ1Y3QgZmlsZSAqcmVhbGZpbGUgPSBmaWxlLT5wcml2YXRlX2RhdGE7CiAJ
Y29uc3Qgc3RydWN0IGNyZWQgKm9sZF9jcmVkOworCXZtX2ZsYWdzX3Qgdm1fZmxhZ3MgPSB2bWEt
PnZtX2ZsYWdzOwogCWludCByZXQ7CiAKIAlpZiAoIXJlYWxmaWxlLT5mX29wLT5tbWFwKQpAQCAt
NDMwLDYgKzQzMSwxNSBAQCBzdGF0aWMgaW50IG92bF9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBz
dHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkKIAlpZiAoV0FSTl9PTihmaWxlICE9IHZtYS0+dm1f
ZmlsZSkpCiAJCXJldHVybiAtRUlPOwogCisJLyogR2V0IHRlbXBvcmFyeSBkZW5pYWwgY291bnRz
IG9uIHJlYWxmaWxlICovCisJaWYgKHZtX2ZsYWdzICYgVk1fREVOWVdSSVRFICYmCisJICAgIChy
ZXQgPSBkZW55X3dyaXRlX2FjY2VzcyhyZWFsZmlsZSkpKQorCQlnb3RvIG91dDsKKworCWlmICh2
bV9mbGFncyAmIFZNX1NIQVJFRCAmJgorCSAgICAocmV0ID0gbWFwcGluZ19tYXBfd3JpdGFibGUo
ZmlsZS0+Zl9tYXBwaW5nKSkpCisJCWdvdG8gYWxsb3dfd3JpdGU7CisKIAl2bWEtPnZtX2ZpbGUg
PSBnZXRfZmlsZShyZWFsZmlsZSk7CiAKIAlvbGRfY3JlZCA9IG92bF9vdmVycmlkZV9jcmVkcyhm
aWxlX2lub2RlKGZpbGUpLT5pX3NiKTsKQEAgLTQ0Niw2ICs0NTYsMTMgQEAgc3RhdGljIGludCBv
dmxfbW1hcChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCiAK
IAlvdmxfZmlsZV9hY2Nlc3NlZChmaWxlKTsKIAorCS8qIFVuZG8gdGVtcG9yYXJ5IGRlbmlhbCBj
b3VudHMgKi8KKwlpZiAodm1fZmxhZ3MgJiBWTV9TSEFSRUQpCisJCW1hcHBpbmdfdW5tYXBfd3Jp
dGFibGUocmVhbGZpbGUtPmZfbWFwcGluZyk7CithbGxvd193cml0ZToKKwlpZiAodm1fZmxhZ3Mg
JiBWTV9ERU5ZV1JJVEUpCisJCWFsbG93X3dyaXRlX2FjY2VzcyhyZWFsZmlsZSk7CitvdXQ6CiAJ
cmV0dXJuIHJldDsKIH0KIApkaWZmIC0tZ2l0IGEvbW0vbW1hcC5jIGIvbW0vbW1hcC5jCmluZGV4
IDNmMjg3NTk5YTdhMy4uMTViMDgyYzcwMWM3IDEwMDY0NAotLS0gYS9tbS9tbWFwLmMKKysrIGIv
bW0vbW1hcC5jCkBAIC02NTksMTEgKzY1OSwxOCBAQCBzdGF0aWMgdm9pZCBfX3ZtYV9saW5rX2Zp
bGUoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCiAJZmlsZSA9IHZtYS0+dm1fZmlsZTsKIAlp
ZiAoZmlsZSkgewogCQlzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZyA9IGZpbGUtPmZfbWFw
cGluZzsKKwkJc3RydWN0IGlub2RlICppbm9kZSA9IGZpbGVfaW5vZGUoZmlsZSk7CiAKLQkJaWYg
KHZtYS0+dm1fZmxhZ3MgJiBWTV9ERU5ZV1JJVEUpCi0JCQlwdXRfd3JpdGVfYWNjZXNzKGZpbGVf
aW5vZGUoZmlsZSkpOwotCQlpZiAodm1hLT52bV9mbGFncyAmIFZNX1NIQVJFRCkKKwkJaWYgKHZt
YS0+dm1fZmxhZ3MgJiBWTV9ERU5ZV1JJVEUpIHsKKwkJCS8qIFRoaXMgaXMgYW4gdW5jb25kaXRp
b25hbCBkZW55X3dyaXRlX2FjY2VzcygpICovCisJCQlXQVJOX09OKGF0b21pY19yZWFkKCZpbm9k
ZS0+aV93cml0ZWNvdW50KSA+IDApOworCQkJcHV0X3dyaXRlX2FjY2Vzcyhpbm9kZSk7CisJCX0K
KwkJaWYgKHZtYS0+dm1fZmxhZ3MgJiBWTV9TSEFSRUQpIHsKKwkJCS8qIFRoaXMgaXMgYW4gdW5j
b25kaXRpb25hbCBtYXBwaW5nX21hcF93cml0YWJsZSgpICovCisJCQlXQVJOX09OKGF0b21pY19y
ZWFkKCZtYXBwaW5nLT5pX21tYXBfd3JpdGFibGUpIDwgMCk7CiAJCQltYXBwaW5nX2FsbG93X3dy
aXRhYmxlKG1hcHBpbmcpOworCQl9CiAKIAkJZmx1c2hfZGNhY2hlX21tYXBfbG9jayhtYXBwaW5n
KTsKIAkJdm1hX2ludGVydmFsX3RyZWVfaW5zZXJ0KHZtYSwgJm1hcHBpbmctPmlfbW1hcCk7Cg==
--000000000000e7964c05bf775aa1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="ovl-check-writecount-on-underlying-inodes.patch"
Content-Disposition: attachment; 
	filename="ovl-check-writecount-on-underlying-inodes.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kn90fp7y1>
X-Attachment-Id: f_kn90fp7y1

ZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9maWxlLmMgYi9mcy9vdmVybGF5ZnMvZmlsZS5jCmlu
ZGV4IGRiZmIzNWZiMGZmNy4uNTA0MTA3ZGQ2YmFiIDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMv
ZmlsZS5jCisrKyBiL2ZzL292ZXJsYXlmcy9maWxlLmMKQEAgLTE0NCw4ICsxNDQsMTcgQEAgc3Rh
dGljIGludCBvdmxfcmVhbF9mZGdldChjb25zdCBzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGZk
ICpyZWFsKQogc3RhdGljIGludCBvdmxfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3Qg
ZmlsZSAqZmlsZSkKIHsKIAlzdHJ1Y3QgZmlsZSAqcmVhbGZpbGU7CisJc3RydWN0IGlub2RlICps
b3dlcmlub2RlLCAqdXBwZXJpbm9kZTsKIAlpbnQgZXJyOwogCisJbG93ZXJpbm9kZSA9IG92bF9p
bm9kZV9sb3dlcihpbm9kZSk7CisJdXBwZXJpbm9kZSA9IG92bF9pbm9kZV91cHBlcihpbm9kZSk7
CisKKwlpZiAoKChmaWxlLT5mX21vZGUgJiBGTU9ERV9XUklURSkgfHwgZmlsZS0+Zl9mbGFncyAm
IE9fVFJVTkMpICYmIAorCSAgICAoKGxvd2VyaW5vZGUgJiYgYXRvbWljX3JlYWQoJmxvd2VyaW5v
ZGUtPmlfd3JpdGVjb3VudCkgPCAwKSB8fAorCSAgICAgKHVwcGVyaW5vZGUgJiYgYXRvbWljX3Jl
YWQoJnVwcGVyaW5vZGUtPmlfd3JpdGVjb3VudCkgPCAwKSkpCisJCXJldHVybiAtRVRYVEJTWTsK
KwogCWVyciA9IG92bF9tYXliZV9jb3B5X3VwKGZpbGVfZGVudHJ5KGZpbGUpLCBmaWxlLT5mX2Zs
YWdzKTsKIAlpZiAoZXJyKQogCQlyZXR1cm4gZXJyOwo=
--000000000000e7964c05bf775aa1--
