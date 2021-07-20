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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6423C07E95
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A4760C41
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhGTPiF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbhGTPgk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 11:36:40 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DB2C061768
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 09:17:17 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p186so24573309iod.13
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 09:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tu3p/272LY4foMpu4Vika11vnUAcq3QlRANgd5HbnEA=;
        b=ZxsCkPdRMKAe8RIQzaQ50Jw8ezph4WcI80gQ7J+JT2+/rLd2n5MGirSxgU5BClwU1D
         ydlr6kmiJZdQcwEG0vdOXv5xvzLcp8m6RTeenQPVArqaW1zqm1+jIvjUsrxA210uWtqf
         7JiwrICbQQcaJxLeHFQKeQOfymXS2nywqHbllpAmrr0Zpy+ux/7/HXnkbodNSP74Ge8+
         Ix39WK4mPyi3Ti0ra3zYETYWJk140K8HTvoxChTZSwjw06H4bPuloy/ThpB5FXK/CEvS
         yV/OEJZomsnrBG2+EjDTFCvjwtfIwTojENHO234Q7qmJ8vEFNgiCu8x70HYbIFuL8AFp
         uMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tu3p/272LY4foMpu4Vika11vnUAcq3QlRANgd5HbnEA=;
        b=CYbGJ6lev8KAxBlPdmCLKa5e99+iAcLX1s9aVZUVKTZ3nTQfEoZQe1O8nJ58bHOl7t
         vBIReGsCR2spBwlAjmHtBJikXTn2SNRMiosW8RquFenkzTHXxDXbjUNFcU0w8NhlpiUA
         EPYj7QO2fMqMM4VFAizoduxr/5kcY/MoDiNfO62KuU9NWbYSDu5oinr+kET7Tfcsvhk5
         sxypptHyULO9JtWBMDaQG2dWESupL0IjSpkKyufjGbKnxX70/dxp0qOwPE0C34vQ7Msk
         5BSueIm4JndLVIev3b/9PIiuLG4xWAl1YsIIh1XBIKc7YBvEqZOPwECDfQVYvbyRad0E
         Mv+A==
X-Gm-Message-State: AOAM531f1B2bvUmlphLojSarKUI3h+VDDZqVfR2yB8Kt/YfPpmzWGDRb
        mIvUfWQAzV7lQZgvUWRp+wTaMI5N89K/+mVXe/c=
X-Google-Smtp-Source: ABdhPJzWr68aEaHNq7ltbPduNuTJPQWjOhID4nYvEgO2nXC1A/xCRFN+tr+J9skU47DkxLLWzQvn7feOOGkU3zWhYKI=
X-Received: by 2002:a05:6638:1907:: with SMTP id p7mr2762223jal.93.1626797836726;
 Tue, 20 Jul 2021 09:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com> <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
 <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com>
 <CAOQ4uxjeHfEy-NHQ3s8gX6Rge9xUkJhfGWGNBFSRj6t4mhAUMQ@mail.gmail.com>
 <CAJfpeguiqGfx150nQ3Y9mMgAreNdrg0Ha-wO-sRzMtk8eXVz7Q@mail.gmail.com>
 <CAJfpegvMV7Grpzk7A=_Bp9bupg1S22VYoG3XcqL9bstfVwkXgw@mail.gmail.com>
 <CAOQ4uxhLyBntfWZYA-Q=Xu6Zzu6VfyxWks5sCZcwZCR1FHv2TQ@mail.gmail.com> <CAOQ4uxhVy3Y7BB2uTM4jW6=w0sFf6uW824QAXVEqwepNuGtMNg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhVy3Y7BB2uTM4jW6=w0sFf6uW824QAXVEqwepNuGtMNg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jul 2021 19:17:05 +0300
Message-ID: <CAOQ4uximehHRdZMR-=n-QUjBdsdD7+GXYmnn11=9eE8UznuFVg@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000002e115305c79063c2"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--0000000000002e115305c79063c2
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 20, 2021 at 5:55 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jul 20, 2021 at 10:18 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Jul 20, 2021 at 7:22 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Tue, 20 Jul 2021 at 06:19, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Mon, 19 Jul 2021 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jul 19, 2021 at 6:24 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > >
> > > > > > On Fri, 4 Jun 2021 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On the first getdents call, ovl_iterate() populates the readdir cache
> > > > > > > > with a list of entries, but for upper entries with origin lower inode,
> > > > > > > > p->ino remains zero.
> > > > > > > >
> > > > > > > > Following getdents calls traverse the readdir cache list and call
> > > > > > > > ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> > > > > > > > in the overlay and return d_ino that is consistent with st_ino.
> > > > > > > >
> > > > > > > > If the upper file was unlinked between the first getdents call and the
> > > > > > > > getdents call that lists the file entry, ovl_cache_update_ino() will not
> > > > > > > > find the entry and fall back to setting d_ino to the upper real st_ino,
> > > > > > > > which is inconsistent with how this object was presented to users.
> > > > > > > >
> > > > > > > > Instead of listing a stale entry with inconsistent d_ino, simply skip
> > > > > > > > the stale entry, which is better for users.
> > > > > > > >
> > > > > > >
> > > > > > > Miklos,
> > > > > > >
> > > > > > > I forgot to follow up on this patch.
> > > > > > > Upstream xfstest overlay/077 is failing without this patch.
> > > > > >
> > > > > > Can't reproduce (on ext4/xfs and "-oxino=on").
> > > > > >
> > > > > > Is there some trick?
> > > > >
> > > > > Not sure. overlay/077 fails for me on v5.14.0-rc2 on ext4/xfs.
> > > > >
> > > > >      QA output created by 077
> > > > >     +entry m100 has inconsistent d_ino (234 != 232)
> > > > >     +entry f100 has inconsistent d_ino (335 != 16777542)
> > > > >      Silence is golden
> > > > >
> > > > > Maybe you need to build src/t_dir_offset2?
> > > >
> > > > root@kvm:/opt/xfstests-dev# git log -1 --pretty=%h
> > > > 10f6b231
> > > > root@kvm:/opt/xfstests-dev# cat local.config
> > > > export TEST_DEV=/dev/vdb1
> > > > export TEST_DIR=/test
> > > > export SCRATCH_DEV=/dev/vdb2
> > > > export SCRATCH_MNT=/scratch
> > > > export FSTYP=ext4
> > > > export OVERLAY_MOUNT_OPTIONS="-o xino=on"
> > > > root@kvm:/opt/xfstests-dev# make src/t_dir_offset2
> > > > make: 'src/t_dir_offset2' is up to date.
> > > > root@kvm:/opt/xfstests-dev# ./check -overlay overlay/077
> > > > FSTYP         -- overlay
> > > > PLATFORM      -- Linux/x86_64 kvm 5.14.0-rc2 #276 SMP Tue Jul 20
> > > > 05:54:44 CEST 2021
> > > > MKFS_OPTIONS  -- /scratch
> > > > MOUNT_OPTIONS -- -o xino=on /scratch /scratch/ovl-mnt
> > > >
> > > > overlay/077 1s ...  1s
> > > > Ran: overlay/077
> > > > Passed all 1 tests
> > > >
> > > > root@kvm:/opt/xfstests-dev# cat results/overlay/077.full
> > > >
> > > > Create file in pure upper dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > created entry p0
> > > > entry p0 found as expected
> > > >
> > > > Remove file in pure upper dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > unlinked entry p100
> > > > entry p100 not found as expected
> > > >
> > > > Create file in impure upper dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > created entry o0
> > > > entry o0 found as expected
> > > >
> > > > Remove file in impure upper dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > unlinked entry o100
> > > > entry o100 not found as expected
> > > >
> > > > Create file in merge dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > created entry m0
> > > > entry m0 found as expected
> > > >
> > > > Remove file in merge dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > unlinked entry m100
> > > > entry m100 not found as expected
> > > >
> > > > Create file in former merge dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > created entry f0
> > > > entry f0 found as expected
> > > >
> > > > Remove file in former merge dir:
> > > > getdents at offset 0 returned 192 bytes
> > > > unlinked entry f100
> > > > entry f100 not found as expected
> > > >
> > > > Ideas for further debugging why this test isn't failing for v4.12-rc2?
> > >
> >
> > It's not you, it's me ;-)
> >
> > The failure was lost during cleanup of t_dir_offset2 patches
> > for submission and it is I who was running an older version
> > of t_dir_offset2. Let me figure this out and get back to you
> > with a working test.
> >
>
> How about you try again with a version of the test that actually has
> the check and the error print that I reported.... ;-)
>

P.S.1:
xino=on is futile for this test as it uses all layers on same fs

P.S.2:
The attached patch to t_dir_offset2 only reproduces the first
inconsistency I reported:
entry m100 has inconsistent d_ino (234 != 232)

The second inconsistency requires another small patch to overlay/077
(attached). I will post both those patches once the kernel fix is in
overlayfs-next.

Thanks,
Amir.

--0000000000002e115305c79063c2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="overlay-077-test-inconsistent-d_ino-in-former-merge-dir.patch"
Content-Disposition: attachment; 
	filename="overlay-077-test-inconsistent-d_ino-in-former-merge-dir.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krc9e1em0>
X-Attachment-Id: f_krc9e1em0

RnJvbSBlNjRhN2IwYzFjZTY5Nzc0NWMwYmRiM2VmOGY0M2YwNzY0NTEwZWY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIwIEp1bCAyMDIxIDE5OjExOjAzICswMzAwClN1YmplY3Q6IFtQQVRDSF0gb3Zl
cmxheS8wNzc6IHRlc3QgaW5jb25zaXN0ZW50IGRfaW5vIGluIGZvcm1lciBtZXJnZSBkaXIKCkZv
ciB0ZXN0aW5nIG9mIGluY29uc2lzdGVudCBkX2luby9zdF9pbm8gd2UgbmVlZCB0byB1bmxpbmsg
YW4gZW50cnkKd2hvc2Ugc3RfaW5vIGlzIG5vdCB0aGF0IG9mIHRoZSB1cHBlciBpbm9kZS4KCklu
IHRoZSBmb3JtZXIgbWVyZ2UgZGlyIHNldHVwIHdlIHVubGluayBhbGwgdGhlIGZpbGVzIGluIHRo
ZSBsb3dlcgpkaXIgYWZ0ZXIgY29weXVwLCBzbyB0aGV5IGFsbCB1c2Ugc3RfaW5vIG9mIHRoZSB1
cHBlciBpbm9kZS4KCkxldCB0aGUgdW5saW5rZWQgZmlsZSBmMTAwIHJlc2lkZSBpbiBhIGxvd2Vy
IHBhdGggdGhhdCBpcyBub3QgYmVpbmcKdW5saW5rZWQgc28gaXQgd2lsbCBoYXZlIHRoZSBzdF9p
bm8gb2YgdGhlIGxvd2VyIGlub2RlLgoKU2lnbmVkLW9mZi1ieTogQW1pciBHb2xkc3RlaW4gPGFt
aXI3M2lsQGdtYWlsLmNvbT4KLS0tCiB0ZXN0cy9vdmVybGF5LzA3NyB8IDUgKysrLS0KIDEgZmls
ZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
dGVzdHMvb3ZlcmxheS8wNzcgYi90ZXN0cy9vdmVybGF5LzA3NwppbmRleCA1OGMwZjNiNS4uMDRj
YjM4ODEgMTAwNzU1Ci0tLSBhL3Rlc3RzL292ZXJsYXkvMDc3CisrKyBiL3Rlc3RzL292ZXJsYXkv
MDc3CkBAIC02MSw4ICs2MSw4IEBAIG1rZGlyIC1wICRsb3dlcmRpci9tZXJnZSAkbG93ZXJkaXIv
Zm9ybWVyICR1cHBlcmRpci9wdXJlICR1cHBlcmRpci9pbXB1cmUKIGNyZWF0ZV9maWxlcyAkbG93
ZXJkaXIvbWVyZ2UgbQogIyBGaWxlcyB0byBiZSBtb3ZlZCBpbnRvIGltcHVyZSB1cHBlciBkaXIK
IGNyZWF0ZV9maWxlcyAkbG93ZXJkaXIgbwotIyBGaWxlIHRvIGJlIGNvcGllZCB1cCB0byBtYWtl
IGZvcm1lciBtZXJnZSBkaXIgaW1wdXJlCi10b3VjaCAkbG93ZXJkaXIvZm9ybWVyL2YxMDAKKyMg
RmlsZSB0byBiZSBtb3ZlZCBpbnRvIGZvcm1lciBtZXJnZSBkaXIgdG8gbWFrZSBpdCBpbXB1cmUK
K3RvdWNoICRsb3dlcmRpci9mMTAwCiAKIF9zY3JhdGNoX21vdW50CiAKQEAgLTcyLDYgKzcyLDcg
QEAgY3JlYXRlX2ZpbGVzICRTQ1JBVENIX01OVC9mb3JtZXIgZgogdG91Y2ggJFNDUkFUQ0hfTU5U
L21lcmdlL20xMDAKICMgTW92ZSBjb3BpZWQgdXAgZmlsZXMgc28gcmVhZGRpciB3aWxsIG5lZWQg
dG8gbG9va3VwIG9yaWdpbiBkX2lubwogbXYgJFNDUkFUQ0hfTU5UL28qICRTQ1JBVENIX01OVC9p
bXB1cmUvCittdiAkU0NSQVRDSF9NTlQvZjEwMCAkU0NSQVRDSF9NTlQvZm9ybWVyLwogCiAjIFJl
bW92ZSB0aGUgbG93ZXIgZGlyZWN0b3J5IGFuZCBtb3VudCBvdmVybGF5IGFnYWluIHRvIGNyZWF0
ZQogIyBhICJmb3JtZXIgbWVyZ2UgZGlyIgotLSAKMi4zMi4wCgo=
--0000000000002e115305c79063c2--
