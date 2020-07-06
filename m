Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3197FC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 14:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4152070B
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 14:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvZ101A8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgGFOaD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 10:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729201AbgGFOaD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 10:30:03 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CD2C061755
        for <linux-unionfs@vger.kernel.org>; Mon,  6 Jul 2020 07:30:03 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q74so15960999iod.1
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2020 07:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V06sBhcuWwBW8U0AFI803i8EXHxA7P1DZmcewOB4PHk=;
        b=IvZ101A8iSuKSHpxsqyR0z9KrJx5tvfRcJ4P0m5nf1i4i/jnrB9oeeb8dEHnvEm6n5
         Ke7ysC10MWoFWXWhwd7PCm2AzUvJUE5+CVKa/hE/+55hKmlRk1l80uRjG347YgBUUsAE
         KPLqW/Z6/n3XGRH25XIg4VU3FTez6JOp+K5nSi1xVlmVHmg/WZC8IBwStMFZJtDZkPDw
         Z7YSHdZWk1tyOrs6ZsL5xdDefYhZlaMfBqaHVJQk/KfjDG5FNrTSe4iCxqhM4LzGMYhi
         xRZbpYDLmZVmsoOzHOwfEZKyFBULSSjlKmXB2zzv2k1A1Pi9YP/9ixyAuUWA7Rv05/na
         X/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V06sBhcuWwBW8U0AFI803i8EXHxA7P1DZmcewOB4PHk=;
        b=lvEIu5b8pxb9aam0JfdyiB1QZ8krxYehZGSklURaPf26+9K+i7DAbUAjYIxu9NpM+5
         QL3zakRmMXLktQjrnpSb6PvXtq2qCOKaOLaa/BdZahPorOwPKpCuknqqI6O9YTcOPvwj
         CiCGcCkxZD3E2APtan3trO6tWF8zH4P3fElRuPc9a8o0x39vmdzSlABM88alaq4j3pZ/
         4WQf712gp8M4DBPauaAi2ur6J3ZeggIHh4X0IedWoOSAH0WOzxmgSbtfDbxZezgCvHJT
         wRNPNmzUmhGJkPTYKR2kp7qgajb4X/h2LcDc35v1SVvobb8jTT9fW+Y4FEFUYfRjAPhX
         tOcg==
X-Gm-Message-State: AOAM533SauHPdbql/Sm2Rwj1gu3bKUwDbmAGTVjZF5fjJmwifpgFox4q
        FLmz06eNfe2DYRUvnclISoGqefdQPjHSPa5zYzeWo5yO
X-Google-Smtp-Source: ABdhPJxYTBX1X4KGbH0OoDFHmk1m2CH0jQjB9hoEHw4T/nMuTtVdDQK1RiLWxUK1B2xvp0lE7MWY2CZMWSR3rU/5Ys8=
X-Received: by 2002:a05:6602:491:: with SMTP id y17mr25403065iov.72.1594045802616;
 Mon, 06 Jul 2020 07:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop>
In-Reply-To: <32532923.JtPX5UtSzP@fgdesktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 6 Jul 2020 17:29:51 +0300
Message-ID: <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Fabian <godi.beat@gmx.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d2d63a05a9c6b582"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000d2d63a05a9c6b582
Content-Type: text/plain; charset="UTF-8"

Hi Fabian,

On Mon, Jul 6, 2020 at 4:28 PM Fabian <godi.beat@gmx.net> wrote:
>
> Hope this is the right list for asking overlayfs <-> squashfs related issues.

Yes.

> Else please let me know where to ask.
>
> We are seeing problems using an read-writeable overlayfs (upper) on a readonly
> squashfs (lower). The squashfs gets an update from time to time while we keep
> the upper overlayfs.
>

It gets updated while the overlay is offline (not mounted) correct?

> On replaced files we then see -ESTALE ("overlayfs: failed to get inode (-116)")
> messages if the lower squashfs was created _without_ using the "-no-exports"
> switch.
> The -ESTALE comes from ovl_get_inode() which in turn calls ovl_verify_inode()
> and returns on the line where the upperdentry inode gets compared
> ( if (upperdentry && ovl_inode_upper(inode) != d_inode(upperdentry)) ).
>
> A little debugging shows, that the upper files dentry name does not fit to the
> dentry name of the new lower dentry as it seems to look for the inode on the
> squashfs "export"-lookup-table which has changed as we replaced the lower fs.
>
> Building the lower squashfs with the "-no-exports"-mksquashfs option, so
> without the export-lookup-table, seems to work, but it might be no longer
> exportable using nfs (which is ok and we can keep with it).
>
> As we didn't find any other information regarding this behaviour or anyone who
> also had this problem before we just want to know if this is the right way to
> use the rw overlayfs on a (replaceable) ro squashfs filesystem.
>
> Is this a known issue? Is it really needed to disable the export feature when
> using overlayfs on a squashfs if we later need to replace squashfs during an
> update? Any hints we can have a look on if this should work and we might have
> done wrong during squashfs or overlayfs creation?
>

This sounds like an unintentional outcome of:
9df085f3c9a2 ovl: relax requirement for non null uuid of lower fs

Which enabled nfs_export for overlay with lower squashfs.

If you do not need to export overlayfs to NFS, then you can check if the
attached patch solves your problem.

If you do need to export overlayfs to NFS or to export squashfs to NFS
for that matter, you will have a problem, because when re-creating
squashfs (I suppose) all file handles are re-assigned randomly to new
files, so they have no meaning in the context of NFS file handles exported
in the old squashfs.

Thanks,
Amir.

--000000000000d2d63a05a9c6b582
Content-Type: text/plain; charset="US-ASCII"; 
	name="ovl-fix-regression-with-re-formatted-lower-squashfs.patch.txt"
Content-Disposition: attachment; 
	filename="ovl-fix-regression-with-re-formatted-lower-squashfs.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kcalkbmh0>
X-Attachment-Id: f_kcalkbmh0

RnJvbSA4ZTlmNTMyY2U0MTlhZTcyYmE0N2I0OTU4MjM0MjM3Nzc4MGEzMmRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBNb24sIDYgSnVsIDIwMjAgMTc6MjE6MjEgKzAzMDAKU3ViamVjdDogW1BBVENIXSBvdmw6
IGZpeCByZWdyZXNzaW9uIHdpdGggcmUtZm9ybWF0dGVkIGxvd2VyIHNxdWFzaGZzCgpSZWxheCB0
aGUgcmVxdWlyZW1lbnQgZm9yIG5vbiBudWxsIHV1aWQgb25seSBpZiB1c2VyIG9wdHMtaW4gdG8K
aW5kZXg9b24gb3IgbmZzX2V4cG9ydD1vbiB0byBhdm9pZCByZWdyZXNzaW9ucyB3aXRoIG92ZXJs
YXkgdGhhdAppcyBtaWdyYXRlZCB0byBhIG5ld2x5IGZvcm1hdHRlZCBsb3dlciBzcXVhc2hmcy4K
ClJlcG9ydGVkLWJ5OiBGYWJpYW4gPGdvZGkuYmVhdEBnbXgubmV0PgpGaXhlczogOWRmMDg1ZjNj
OWEyICgib3ZsOiByZWxheCByZXF1aXJlbWVudCBmb3Igbm9uIG51bGwgdXVpZC4uLiIpClNpZ25l
ZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+Ci0tLQogZnMvb3Zl
cmxheWZzL3N1cGVyLmMgfCAxMCArKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0
aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9zdXBlci5jIGIvZnMvb3ZlcmxheWZz
L3N1cGVyLmMKaW5kZXggMTU5MzlhYjM5YzFjLi5hZjk1ZjgzZTNhNzAgMTAwNjQ0Ci0tLSBhL2Zz
L292ZXJsYXlmcy9zdXBlci5jCisrKyBiL2ZzL292ZXJsYXlmcy9zdXBlci5jCkBAIC0xNDAyLDYg
KzE0MDIsMTYgQEAgc3RhdGljIGJvb2wgb3ZsX2xvd2VyX3V1aWRfb2soc3RydWN0IG92bF9mcyAq
b2ZzLCBjb25zdCB1dWlkX3QgKnV1aWQpCiAJaWYgKCFvZnMtPmNvbmZpZy5uZnNfZXhwb3J0ICYm
ICFvdmxfdXBwZXJfbW50KG9mcykpCiAJCXJldHVybiB0cnVlOwogCisJLyoKKwkgKiBXZSBhbGxv
dyB1c2luZyBzaW5nbGUgbG93ZXIgd2l0aCBudWxsIHV1aWQgZm9yIGluZGV4IGFuZCBuZnNfZXhw
b3J0CisJICogZm9yIGV4YW1wbGUgdG8gc3VwcG9ydCB0aG9zZSBmZWF0dXJlcyB3aXRoIHNpbmds
ZSBsb3dlciBzcXVhc2hmcy4KKwkgKiBUbyBhdm9pZCByZWdyZXNzaW9ucyBzZXR1cHMgb2Ygb3Zl
cmxheSB3aXRoIHJlLWZvcm1hdHRlZCBsb3dlcgorCSAqIHNxdWFzaGZzIGRvIG5vdCBhbGxvdyBk
ZWNvZGluZyBvcmlnaW4gd2l0aCBsb3dlciBudWxsIHV1aWQgdW5sZXNzCisJICogaW5kZXggb3Ig
bmZzX2V4cG9ydCBhcmUgZXhwbGljaXRseSBlbmFibGVkLgorCSAqLworCWlmICghb2ZzLT5jb25m
aWcuaW5kZXggJiYgdXVpZF9pc19udWxsKHV1aWQpKQorCQlyZXR1cm4gZmFsc2U7CisKIAlmb3Ig
KGkgPSAwOyBpIDwgb2ZzLT5udW1mczsgaSsrKSB7CiAJCS8qCiAJCSAqIFdlIHVzZSB1dWlkIHRv
IGFzc29jaWF0ZSBhbiBvdmVybGF5IGxvd2VyIGZpbGUgaGFuZGxlIHdpdGggYQotLSAKMi4xNy4x
Cgo=
--000000000000d2d63a05a9c6b582--
