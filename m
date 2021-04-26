Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA7AC433ED
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 15:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38EF36135D
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 15:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhDZPXV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhDZPXV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Apr 2021 11:23:21 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD349C06175F;
        Mon, 26 Apr 2021 08:22:39 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q25so12904895iog.5;
        Mon, 26 Apr 2021 08:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPwfWKHjH4x3NkBR+ex1uWoWIs5XLShUeKm78X5BNN8=;
        b=Hs/msCcDNluWmXHYPQ9k3L6YCo90ZufmiDSkMnvHdBfnHx8PoNTHwqaeaT7q5Alg5h
         E2D/heZ3HL4Ai8CoqDBlkHm+qsjxEBiScJXkExqGda/xa3o+fdTm6Jrw9McKPFbm3x9F
         pk20ML7IvG0Zsw4bVhphOFp/yvtbmDnPgX+wHqiNc7KHhDugzHxAGgrfQuufKI5oDIdD
         1pZGLJGW4NSaP1veVPYEtEGIpykbNBh8dTKB2PDg0b7EYoo+oK/gMMSBPwFta9cMflQq
         FtyvStk7RdtQ6e7BXbiZZkVgCOWX3lk3isQmL2RTUgrVSBKRKZ3Xg4DjsTdaeBbAX9NG
         LE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPwfWKHjH4x3NkBR+ex1uWoWIs5XLShUeKm78X5BNN8=;
        b=kt6JVOhVOeVdrWx9cIBMm0gs0x21wxejKpC2yI3+iYJJD0bQ+cJYBwaTD3wvAQq4oI
         AShazjwc5wrvAXF2cpmxrDT7g3QZbz6rb5NmtC4BUV9HRjAxqzqsJWWrKkQnGJWDj3rA
         L+yJJsIhHtNUuPS6bxAvkpuwDykqj/Azpc8FQrb9ONA+dym4aLD8Yq+lI7BqRUHzJ4C4
         JwQeYdNU52nNautpl5sS+w+ESwqKM10hROuRsurlhnHbO+RUtQW2qsR8SM21AvNDOtwL
         dqV6FaW+wQ7Va3lbEsDNl2YZkOXf+el/dG9Rt4j/0zqlQa6NnMN5AtYlg5Hw/qVBnZA0
         qjdw==
X-Gm-Message-State: AOAM533Y9zydOGIKnGGyjS+WuNAReslA76fYU1TFIiOm914QS1pdVKzx
        u6P1Ipw/XwtVPUERquZA0kjQZAyxWzJlkMPqTxYTFcCI
X-Google-Smtp-Source: ABdhPJzcDlwvINu2LntRBhW9LTyMd/6Cn/RHvQAeFBQYFIaXz7Ouh0/flVGzU4DdmQSDUHNGPrQKP38/8lvC4JMJ7o8=
X-Received: by 2002:a05:6602:58d:: with SMTP id v13mr14325423iox.64.1619450559244;
 Mon, 26 Apr 2021 08:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210425071445.29547-1-amir73il@gmail.com> <CAJfpeguHn32-BJV=986963SCGs8RwBN+fMEfRdwc1d_LFecFxw@mail.gmail.com>
 <CAOQ4uxiEx-KcMYdfM9yLygvD5eYgs_58kOvr0NabKqgpB0ybug@mail.gmail.com> <CAJfpegvf=6FPgSBfz73Lu+7DV2T8A+E4CzzsNjfqSbmJccY4VA@mail.gmail.com>
In-Reply-To: <CAJfpegvf=6FPgSBfz73Lu+7DV2T8A+E4CzzsNjfqSbmJccY4VA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 26 Apr 2021 18:22:28 +0300
Message-ID: <CAOQ4uxgR_cLnC_vdU5=seP3fwqVkuZM_-WfD6maFTMbMYq=a9w@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Test overlayfs readdir cache
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000050d16f05c0e1b79e"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--00000000000050d16f05c0e1b79e
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 26, 2021 at 4:13 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Apr 26, 2021 at 12:15 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Apr 26, 2021 at 1:07 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > > The other case you found it that in case of a stale direntry the i_ino
> > > update will be skipped and so it will return an inconsistent result,
> > > right?
> >
> > Right. It returns a stale entry with the old real ino.
> > Not sure if that is an "inconsistent" result.
> > inconsistent w.r.t what?
>
> It's inconsistent with previous (before the entry got deleted)
> st_ino/i_ino.  This should actually be testable.

Right. it is testable:

     QA output created by 077
    +entry m100 has inconsistent d_ino (266 != 264)
    +entry f100 has inconsistent d_ino (367 != 16777542)
     Silence is golden

These prints are from the iteration on the first fd.
The first fd lists the stale entry with inconsistent d_ino.
The second fd does not list the stale entry (with bugfix in linux-next).
Will add it to the test in V3.

Attached patch fixes this problem.

Thanks,
Amir.

--00000000000050d16f05c0e1b79e
Content-Type: text/plain; charset="US-ASCII"; 
	name="0001-ovl-skip-stale-entries-in-merge-dir-cache-iteration.patch.txt"
Content-Disposition: attachment; 
	filename="0001-ovl-skip-stale-entries-in-merge-dir-cache-iteration.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_knyr0h6y0>
X-Attachment-Id: f_knyr0h6y0

RnJvbSAzMDRlMTU5OWNjMTEyZmFlMzg4ZDBjMGIyYWFhYmRmMzg1MDMyMjI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBNb24sIDI2IEFwciAyMDIxIDE4OjA3OjA5ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBza2lwIHN0YWxlIGVudHJpZXMgaW4gbWVyZ2UgZGlyIGNhY2hlIGl0ZXJhdGlvbgoKT24gdGhl
IGZpcnN0IGdldGRlbnRzIGNhbGwsIG92bF9pdGVyYXRlKCkgcG9wdWxhdGVzIHRoZSByZWFkZGly
IGNhY2hlCndpdGggYSBsaXN0IG9mIGVudHJpZXMsIGJ1dCBmb3IgdXBwZXIgZW50cmllcyB3aXRo
IG9yaWdpbiBsb3dlciBpbm9kZSwKcC0+aW5vIHJlbWFpbnMgemVyby4KCkZvbGxvd2luZyBnZXRk
ZW50cyBjYWxscyB0cmF2ZXJzZSB0aGUgcmVhZGRpciBjYWNoZSBsaXN0IGFuZCBjYWxsCm92bF9j
YWNoZV91cGRhdGVfaW5vKCkgZm9yIGVudHJpZXMgd2l0aCB6ZXJvIHAtPmlubyB0byBsb29rdXAg
dGhlIGVudHJ5CmluIHRoZSBvdmVybGF5IGFuZCByZXR1cm4gZF9pbm8gdGhhdCBpcyBjb25zaXN0
ZW50IHdpdGggc3RfaW5vLgoKSWYgdGhlIHVwcGVyIGZpbGUgd2FzIHVubGlua2VkIGJldHdlZW4g
dGhlIGZpcnN0IGdldGRlbnRzIGNhbGwgYW5kIHRoZQpnZXRkZW50cyBjYWxsIHRoYXQgbGlzdHMg
dGhlIGZpbGUgZW50cnksIG92bF9jYWNoZV91cGRhdGVfaW5vKCkgd2lsbCBub3QKZmluZCB0aGUg
ZW50cnkgYW5kIGZhbGwgYmFjayB0byBzZXR0aW5nIGRfaW5vIHRvIHRoZSB1cHBlciByZWFsIHN0
X2lubywKd2hpY2ggaXMgaW5jb25zaXN0ZW50IHdpdGggaG93IHRoaXMgb2JqZWN0IHdhcyBwcmVz
ZW50ZWQgdG8gdXNlcnMuCgpJbnN0ZWFkIG9mIGxpc3RpbmcgYSBzdGFsZSBlbnRyeSB3aXRoIGlu
Y29uc2lzdGVudCBkX2lubywgc2ltcGx5IHNraXAKdGhlIHN0YWxlIGVudHJ5LCB3aGljaCBpcyBi
ZXR0ZXIgZm9yIHVzZXJzLgoKU2lnbmVkLW9mZi1ieTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2ls
QGdtYWlsLmNvbT4KLS0tCiBmcy9vdmVybGF5ZnMvcmVhZGRpci5jIHwgNSArKysrKwogMSBmaWxl
IGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9yZWFk
ZGlyLmMgYi9mcy9vdmVybGF5ZnMvcmVhZGRpci5jCmluZGV4IGNjMWU4MDI1NzA2NC4uMTBiNzc4
MGU0YmRjIDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMvcmVhZGRpci5jCisrKyBiL2ZzL292ZXJs
YXlmcy9yZWFkZGlyLmMKQEAgLTQ4MSw2ICs0ODEsOCBAQCBzdGF0aWMgaW50IG92bF9jYWNoZV91
cGRhdGVfaW5vKHN0cnVjdCBwYXRoICpwYXRoLCBzdHJ1Y3Qgb3ZsX2NhY2hlX2VudHJ5ICpwKQog
CX0KIAl0aGlzID0gbG9va3VwX29uZV9sZW4ocC0+bmFtZSwgZGlyLCBwLT5sZW4pOwogCWlmIChJ
U19FUlJfT1JfTlVMTCh0aGlzKSB8fCAhdGhpcy0+ZF9pbm9kZSkgeworCQkvKiBNYXJrIGEgc3Rh
bGUgZW50cnkgKi8KKwkJcC0+aXNfd2hpdGVvdXQgPSB0cnVlOwogCQlpZiAoSVNfRVJSKHRoaXMp
KSB7CiAJCQllcnIgPSBQVFJfRVJSKHRoaXMpOwogCQkJdGhpcyA9IE5VTEw7CkBAIC03NzYsNiAr
Nzc4LDkgQEAgc3RhdGljIGludCBvdmxfaXRlcmF0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0
IGRpcl9jb250ZXh0ICpjdHgpCiAJCQkJaWYgKGVycikKIAkJCQkJZ290byBvdXQ7CiAJCQl9CisJ
CX0KKwkJLyogb3ZsX2NhY2hlX3VwZGF0ZV9pbm8oKSBzZXRzIGlzX3doaXRlb3V0IG9uIHN0YWxl
IGVudHJ5ICovCisJCWlmICghcC0+aXNfd2hpdGVvdXQpIHsKIAkJCWlmICghZGlyX2VtaXQoY3R4
LCBwLT5uYW1lLCBwLT5sZW4sIHAtPmlubywgcC0+dHlwZSkpCiAJCQkJYnJlYWs7CiAJCX0KLS0g
CjIuMjUuMQoK
--00000000000050d16f05c0e1b79e--
