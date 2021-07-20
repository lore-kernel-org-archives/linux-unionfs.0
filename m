Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1E7C07E9B
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 15:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1602161165
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 15:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbhGTPE5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239729AbhGTOU3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 10:20:29 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAC3C06178A
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 07:55:17 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a7so19372089iln.6
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 07:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gVOrP6GPtlKwJFKcs6LpVUG3y8az7qDVreIDQn6m7HA=;
        b=om1Ym2XOMFH4bLN3LQuGbbzVhgUVStx0XjyYtCeTmFiFbv6AUYV1ZRrJdhtw/mYppx
         AtMUooCNiIf7mlgZdc2Q2euQmHSa+ZGKkjW4EYtnK8Lw+GBcg+hGQ8MhvRwiBh0wCkfT
         pDtw9G+U11dSVaMWac54C+XVEMHE22AkXXdnayef+kx7l8cpgxRV/yo1RdancrbK0Z2V
         03HTdoQF93H0f23jW6+QHBaeiFXD7lj5l32oPbs2K7YT5/cVX2PZs4xQckJbFewqp06G
         hdo0X9CsZ0fA592dPM1rGcLE5mBlKeRHL/zvW0SHoVyWKK5eJk4R3P0nmc5mkvu27l95
         x3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gVOrP6GPtlKwJFKcs6LpVUG3y8az7qDVreIDQn6m7HA=;
        b=fexjZmfGO7/NRS5UzCNddu86LhB+zAeCxfbFhFTTM10xKedTfi71WCbrIlkp95csKR
         dBXBHAcgDJRlXHwnsvIVTSPLFqqK+yg3usuTNoWtiMcr9IOb9UgaQxqU+H8rDMa3hWSI
         eCnE2rLGnVeCMNBLodQ/GFMufPQA6HMkexZZ8XZTopnZ2TFsDLli4z9CuXRtBPxMa0cl
         +6dYea8CnGi6zaprb1ebJr+h/LeBlsddF8p8GU/Qy/soBo6Nw0x2WVa/s3RXQbYHjMAl
         NhFjOzB9INFRTU0dHFBmcZASAxK6Kr+lmNCidAkHAMjb0rc2xmOco5eJlKKHcFcNcjmj
         EfLw==
X-Gm-Message-State: AOAM533L7XDlvShWDYsGwpzWUnnG5Zxo4YJYA9+6Ar6A9XPU01sVmx5M
        H18lM/lK6BH3LP01kuQ+Vk/itz5OTli/ZUeCQ1g=
X-Google-Smtp-Source: ABdhPJzSDLzGXeiIc+Q0JC/Vg8y8UHiUGC7fkFfwgv6uYaQYye/udCLzSWN9F2GO2BDckiCcAIYOkWAvx43R+XCcilk=
X-Received: by 2002:a92:d28b:: with SMTP id p11mr21678405ilp.250.1626792917274;
 Tue, 20 Jul 2021 07:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com> <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
 <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com>
 <CAOQ4uxjeHfEy-NHQ3s8gX6Rge9xUkJhfGWGNBFSRj6t4mhAUMQ@mail.gmail.com>
 <CAJfpeguiqGfx150nQ3Y9mMgAreNdrg0Ha-wO-sRzMtk8eXVz7Q@mail.gmail.com>
 <CAJfpegvMV7Grpzk7A=_Bp9bupg1S22VYoG3XcqL9bstfVwkXgw@mail.gmail.com> <CAOQ4uxhLyBntfWZYA-Q=Xu6Zzu6VfyxWks5sCZcwZCR1FHv2TQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhLyBntfWZYA-Q=Xu6Zzu6VfyxWks5sCZcwZCR1FHv2TQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jul 2021 17:55:05 +0300
Message-ID: <CAOQ4uxhVy3Y7BB2uTM4jW6=w0sFf6uW824QAXVEqwepNuGtMNg@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000f56b4d05c78f3ddc"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000f56b4d05c78f3ddc
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 20, 2021 at 10:18 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jul 20, 2021 at 7:22 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, 20 Jul 2021 at 06:19, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Mon, 19 Jul 2021 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Mon, Jul 19, 2021 at 6:24 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > >
> > > > > On Fri, 4 Jun 2021 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > >
> > > > > > > On the first getdents call, ovl_iterate() populates the readdir cache
> > > > > > > with a list of entries, but for upper entries with origin lower inode,
> > > > > > > p->ino remains zero.
> > > > > > >
> > > > > > > Following getdents calls traverse the readdir cache list and call
> > > > > > > ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> > > > > > > in the overlay and return d_ino that is consistent with st_ino.
> > > > > > >
> > > > > > > If the upper file was unlinked between the first getdents call and the
> > > > > > > getdents call that lists the file entry, ovl_cache_update_ino() will not
> > > > > > > find the entry and fall back to setting d_ino to the upper real st_ino,
> > > > > > > which is inconsistent with how this object was presented to users.
> > > > > > >
> > > > > > > Instead of listing a stale entry with inconsistent d_ino, simply skip
> > > > > > > the stale entry, which is better for users.
> > > > > > >
> > > > > >
> > > > > > Miklos,
> > > > > >
> > > > > > I forgot to follow up on this patch.
> > > > > > Upstream xfstest overlay/077 is failing without this patch.
> > > > >
> > > > > Can't reproduce (on ext4/xfs and "-oxino=on").
> > > > >
> > > > > Is there some trick?
> > > >
> > > > Not sure. overlay/077 fails for me on v5.14.0-rc2 on ext4/xfs.
> > > >
> > > >      QA output created by 077
> > > >     +entry m100 has inconsistent d_ino (234 != 232)
> > > >     +entry f100 has inconsistent d_ino (335 != 16777542)
> > > >      Silence is golden
> > > >
> > > > Maybe you need to build src/t_dir_offset2?
> > >
> > > root@kvm:/opt/xfstests-dev# git log -1 --pretty=%h
> > > 10f6b231
> > > root@kvm:/opt/xfstests-dev# cat local.config
> > > export TEST_DEV=/dev/vdb1
> > > export TEST_DIR=/test
> > > export SCRATCH_DEV=/dev/vdb2
> > > export SCRATCH_MNT=/scratch
> > > export FSTYP=ext4
> > > export OVERLAY_MOUNT_OPTIONS="-o xino=on"
> > > root@kvm:/opt/xfstests-dev# make src/t_dir_offset2
> > > make: 'src/t_dir_offset2' is up to date.
> > > root@kvm:/opt/xfstests-dev# ./check -overlay overlay/077
> > > FSTYP         -- overlay
> > > PLATFORM      -- Linux/x86_64 kvm 5.14.0-rc2 #276 SMP Tue Jul 20
> > > 05:54:44 CEST 2021
> > > MKFS_OPTIONS  -- /scratch
> > > MOUNT_OPTIONS -- -o xino=on /scratch /scratch/ovl-mnt
> > >
> > > overlay/077 1s ...  1s
> > > Ran: overlay/077
> > > Passed all 1 tests
> > >
> > > root@kvm:/opt/xfstests-dev# cat results/overlay/077.full
> > >
> > > Create file in pure upper dir:
> > > getdents at offset 0 returned 192 bytes
> > > created entry p0
> > > entry p0 found as expected
> > >
> > > Remove file in pure upper dir:
> > > getdents at offset 0 returned 192 bytes
> > > unlinked entry p100
> > > entry p100 not found as expected
> > >
> > > Create file in impure upper dir:
> > > getdents at offset 0 returned 192 bytes
> > > created entry o0
> > > entry o0 found as expected
> > >
> > > Remove file in impure upper dir:
> > > getdents at offset 0 returned 192 bytes
> > > unlinked entry o100
> > > entry o100 not found as expected
> > >
> > > Create file in merge dir:
> > > getdents at offset 0 returned 192 bytes
> > > created entry m0
> > > entry m0 found as expected
> > >
> > > Remove file in merge dir:
> > > getdents at offset 0 returned 192 bytes
> > > unlinked entry m100
> > > entry m100 not found as expected
> > >
> > > Create file in former merge dir:
> > > getdents at offset 0 returned 192 bytes
> > > created entry f0
> > > entry f0 found as expected
> > >
> > > Remove file in former merge dir:
> > > getdents at offset 0 returned 192 bytes
> > > unlinked entry f100
> > > entry f100 not found as expected
> > >
> > > Ideas for further debugging why this test isn't failing for v4.12-rc2?
> >
>
> It's not you, it's me ;-)
>
> The failure was lost during cleanup of t_dir_offset2 patches
> for submission and it is I who was running an older version
> of t_dir_offset2. Let me figure this out and get back to you
> with a working test.
>

How about you try again with a version of the test that actually has
the check and the error print that I reported.... ;-)

Thanks,
Amir.

--000000000000f56b4d05c78f3ddc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="fstests-Check-for-inconsistent-d_ino-st_ino.patch"
Content-Disposition: attachment; 
	filename="fstests-Check-for-inconsistent-d_ino-st_ino.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krc6f7360>
X-Attachment-Id: f_krc6f7360

RnJvbSAyNTA2MTVkYTZmMDFlOTljMDU1YjdmYzNiZDlhMmMxZGVhYzY0NGUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIwIEp1bCAyMDIxIDE3OjQ1OjQzICswMzAwClN1YmplY3Q6IFtQQVRDSF0gc3Jj
L3RfZGlyX29mZnNldDI6IENoZWNrIGZvciBpbmNvbnNpc3RlbnQgZF9pbm8vc3RfaW5vCgpBZnRl
ciB1bmxpbmsgb2YgYSBkaXJlY3RvcnkgZW50cnksIHRoYXQgZW50cnkgbWF5IHN0aWxsIGFwZWFy
IGluIGdldGRlbnRzCnJlc3VsdHMgb2YgYW4gYWxyZWFkeSBvcGVuIGRpcmVjdG9yeSBmZCwgYnV0
IGl0IHNob3VsZCByZXR1cm4gYSBkX2lubwp2YWx1ZSB0aGF0IGlzIGNvbnNpc3RlbnQgd2l0aCB0
aGUgYWxyZWFkeSBvYnNlcnZlZCBzdF9pbm8gb2YgdGhhdCBlbnRyeS4KClRoaXMgaXMgYSByZWdy
ZXNzaW9uIHRlc3QgZm9yIGtlcm5lbCBjb21taXQgLi4uLgooIm92bDogc2tpcCBzdGFsZSBlbnRy
aWVzIGluIG1lcmdlIGRpciBjYWNoZSBpdGVyYXRpb24iKQoKU2lnbmVkLW9mZi1ieTogQW1pciBH
b2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KLS0tCiBzcmMvdF9kaXJfb2Zmc2V0Mi5jIHwg
MTggKysrKysrKysrKysrLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwg
NiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9zcmMvdF9kaXJfb2Zmc2V0Mi5jIGIvc3JjL3Rf
ZGlyX29mZnNldDIuYwppbmRleCA3NWI0MWMxYS4uMDI2YmM4ZjMgMTAwNjQ0Ci0tLSBhL3NyYy90
X2Rpcl9vZmZzZXQyLmMKKysrIGIvc3JjL3RfZGlyX29mZnNldDIuYwpAQCAtNDQsNiArNDQsNyBA
QCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQogCWNoYXIgYnVmW0JVRl9TSVpFXTsK
IAlpbnQgbnJlYWQsIGJ1ZnNpemUgPSBCVUZfU0laRTsKIAlzdHJ1Y3QgbGludXhfZGlyZW50NjQg
KmQ7CisJc3RydWN0IHN0YXQgc3QgPSB7fTsKIAlpbnQgYnBvcywgdG90YWwsIGk7CiAJb2ZmX3Qg
bHJldDsKIAlpbnQgcmV0dmFsID0gRVhJVF9TVUNDRVNTOwpAQCAtODEsOSArODIsOSBAQCBpbnQg
bWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQogCX0KIAogCWlmIChmaWxlbmFtZSkgewotCQll
eGlzdHMgPSAhZmFjY2Vzc2F0KGZkLCBmaWxlbmFtZSwgRl9PSywgQVRfU1lNTElOS19OT0ZPTExP
Vyk7CisJCWV4aXN0cyA9ICFmc3RhdGF0KGZkLCBmaWxlbmFtZSwgJnN0LCBBVF9TWU1MSU5LX05P
Rk9MTE9XKTsKIAkJaWYgKCFleGlzdHMgJiYgZXJybm8gIT0gRU5PRU5UKSB7Ci0JCQlwZXJyb3Io
ImZhY2Nlc3NhdCIpOworCQkJcGVycm9yKCJmc3RhdGF0Iik7CiAJCQlleGl0KEVYSVRfRkFJTFVS
RSk7CiAJCX0KIAl9CkBAIC0xMzksOSArMTQwLDYgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIg
KmFyZ3ZbXSkKIAkJCWNvbnRpbnVlOwogCQl9CiAKLQkJaWYgKG5yZWFkID09IDApCi0JCQlicmVh
azsKLQogCQlmb3IgKGJwb3MgPSAwOyBicG9zIDwgbnJlYWQ7IHRvdGFsKyspIHsKIAkJCWQgPSAo
c3RydWN0IGxpbnV4X2RpcmVudDY0ICopIChidWYgKyBicG9zKTsKIApAQCAtMTY1LDggKzE2Mywx
NiBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQogCQkJCQlwcmludGYoImVudHJ5
ICMlZDogJXMgKGRfaW5vPSVsbGQsIGRfb2ZmPSVsbGQpXG4iLAogCQkJCQkgICAgICAgaSwgZC0+
ZF9uYW1lLCAobG9uZyBsb25nIGludClkLT5kX2lubywKIAkJCQkJICAgICAgIChsb25nIGxvbmcg
aW50KWQtPmRfb2ZmKTsKLQkJCQlpZiAoIXN0cmNtcChmaWxlbmFtZSwgZC0+ZF9uYW1lKSkKKwkJ
CQlpZiAoIXN0cmNtcChmaWxlbmFtZSwgZC0+ZF9uYW1lKSkgewogCQkJCQlmb3VuZCA9IDE7CisJ
CQkJCWlmIChzdC5zdF9pbm8gJiYgZC0+ZF9pbm8gIT0gc3Quc3RfaW5vKSB7CisJCQkJCQlmcHJp
bnRmKHN0ZGVyciwgImVudHJ5ICVzIGhhcyBpbmNvbnNpc3RlbnQgZF9pbm8gKCVsbGQgIT0gJWxs
ZClcbiIsCisJCQkJCQkJCWZpbGVuYW1lLAorCQkJCQkJCQkobG9uZyBsb25nIGludClkLT5kX2lu
bywKKwkJCQkJCQkJKGxvbmcgbG9uZyBpbnQpc3Quc3RfaW5vKTsKKwkJCQkJfQorCQkJCX0KKwog
CQkJfQogCQkJYnBvcyArPSBkLT5kX3JlY2xlbjsKIAkJfQotLSAKMi4zMi4wCgo=
--000000000000f56b4d05c78f3ddc--
